/*
=====================================================
🇩🇪 Beschreibung (Deutsch)
=====================================================

Diese gespeicherte Prozedur `silver.load_silver` lädt bereinigte und transformierte Daten aus der Bronze-Schicht
in die Silver-Schicht eines Data-Warehouse-Systems. Sie bereinigt Felder, ersetzt Codes mit Klartextwerten,
führt Datentransformationen wie Datumskonvertierungen und Textkürzungen durch und stellt sicher, dass die Datenqualität verbessert wird.
Alle Zieltabellen in der Silver-Schicht werden vor dem Laden geleert. Der gesamte Vorgang wird zeitlich erfasst,
und bei einem Fehler werden entsprechende Informationen protokolliert.

=====================================================
🇬🇧 Description (English)
=====================================================

This stored procedure `silver.load_silver` loads cleansed and transformed data from the Bronze layer
into the Silver layer of a data warehouse system. It sanitizes fields, replaces codes with human-readable values,
performs data transformations such as date conversions and text normalization, and ensures improved data quality.
All target tables in the Silver layer are truncated before loading. The entire process is timed,
and errors are caught and logged with relevant details.
*/

CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
	BEGIN TRY
		PRINT '============================';
		PRINT 'Loading SILVER Layer';
		PRINT '============================';
		DECLARE @start_load_time DATETIME, @end_load_time DATETIME;
		SET @start_load_time = GETDATE();
		PRINT '>> TRUNCATING AND LOADING DATA INTO silver.crm_cust_info'
		TRUNCATE TABLE silver.crm_cust_info
		INSERT INTO silver.crm_cust_info(
			cst_id,cst_key,cst_firstname,cst_lastname,cst_marital_status,cst_gndr,cst_create_date)
		SELECT cst_id,
		cst_key,
		TRIM(cst_firstname) as cst_firstname,
		TRIM(cst_lastname) as cst_lastname,
		CASE WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
			WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
			ELSE 'n/a'
		END as cst_marital_status,
		CASE WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
			WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
			ELSE 'n/a'
		END as cst_gndr,
		cst_create_date
		FROM (
			SELECT *, ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) as flag_last
			FROM bronze.crm_cust_info
			--order by flag_last DESC
			where cst_id IS NOT NULL
			)t WHERE t.flag_last = 1

		-- INSERT INTO silver.crm_prd_info
		PRINT '>> TRUNCATING AND LOADING DATA INTO silver.crm_prd_info'
		TRUNCATE TABLE silver.crm_prd_info
		INSERT INTO silver.crm_prd_info (
		prd_id,cat_id,prd_key,prd_nm,prd_cost,prd_line,prd_start_dt,prd_end_dt
		)
		SELECT prd_id,
		REPLACE( SUBSTRING(prd_key,1,5),'-','_' )as cat_id,
		SUBSTRING( prd_key, 7, LEN(prd_key)) as prd_key,
		prd_nm,
		ISNULL(prd_cost,0) as prd_cost,
		CASE UPPER(TRIM(prd_line)) 
			WHEN 'M' THEN 'Mountain' 
			WHEN 'R' THEN 'Road' 
			WHEN 'S' THEN 'Other Sales' 
			WHEN 'T' THEN 'Touring' 
			ELSE 'n/a'
		END as prd_line,
		CAST(prd_start_dt AS DATE) AS prd_start_dt ,
		CAST(LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt) -1 AS DATE) as prd_end_dt
		FROM bronze.crm_prd_info

		-- INSERT INTO silver.crm_sales_details
		PRINT '>> TRUNCATING AND LOADING DATA INTO silver.crm_sales_details'
		TRUNCATE TABLE silver.crm_sales_details
		INSERT INTO silver.crm_sales_details(sls_ord_num,sls_prd_key,sls_cust_id,sls_order_dt,sls_ship_dt,sls_due_dt,sls_sales,sls_quantity,sls_price)
		SELECT sls_ord_num,sls_prd_key,sls_cust_id,
		CASE WHEN sls_order_dt <= 0 OR (LEN(sls_order_dt) != 8) then NULL
			ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE)
		END as sls_order_dt,
		CASE WHEN sls_ship_dt <= 0 OR (LEN(sls_ship_dt) != 8) then NULL
			ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)
		END as sls_ship_dt,
		CASE WHEN sls_due_dt <= 0 OR (LEN(sls_due_dt) != 8) then NULL
			ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)
		END as sls_due_dt,
		CASE WHEN sls_sales <= 0  or sls_sales IS NULL or sls_sales != sls_quantity * ABS(sls_price)
			THEN sls_quantity * ABS(sls_price)
			ELSE sls_sales 
		END as sls_sales,
		sls_quantity,
		CASE WHEN sls_price IS NULL OR sls_price <=0
			THEn sls_sales / NULLIF(sls_quantity,0)
			ELSE sls_price
		END AS sls_price
		FROM bronze.crm_sales_details

		-- INSERT INTO silver.erp_cust_az12
		PRINT '>> TRUNCATING AND LOADING DATA INTO silver.erp_cust_az12'
		TRUNCATE TABLE silver.erp_cust_az12
		INSERT INTO silver.erp_cust_az12 (cid,bdate,gen)
		SELECT 
		CASE WHEN cid like 'NAS%' THEN SUBSTRING (cid,4,LEN(cid))
			ELSE cid
		ENd as cid,
		CASE WHEN bdate > GETDATE() THEN NULL
		else bdate
		end as bdate,
		CASE WHEN UPPER(TRIM(gen)) IN ('F','FEMALE') THEN 'Female'
			WHEN UPPER(TRIM(gen)) IN ('M','MALE') THEN 'Male'
			ELSE 'n/a'
		END as gen
		--Select distinct gen
		FROM bronze.erp_cust_az12

		-- INSERT INTO silver.erp_loc_a101
		PRINT '>> TRUNCATING AND LOADING DATA INTO silver.erp_loc_a101'
		TRUNCATE TABLE silver.erp_loc_a101
		INSERT INTO silver.erp_loc_a101 (cid,cntry)
		SELECT 
		REPLACE(cid,'-','') as cid,
		CASE WHEN cntry IS NULL OR UPPER(TRIM(cntry)) = '' THEN 'n/a'
			WHEN TRIM(cntry) IN ('DE') THEN 'Germany'
			WHEN TRIM(cntry) IN ('USA','US') THEN 'United States'
		ELSE Trim(cntry)
		END as cntry
		FROM bronze.erp_loc_a101 

		-- INSERT INTO silver.erp_px_cat_g1v2
		PRINT '>> TRUNCATING AND LOADING DATA INTO silver.erp_px_cat_g1v2'
		TRUNCATE TABLE silver.erp_px_cat_g1v2
		INSERT INTO silver.erp_px_cat_g1v2 (id,cat,subcat,maintenance)
		SELECT id,cat,subcat,maintenance
		FROM bronze.erp_px_cat_g1v2
		SET @end_load_time = GETDATE();
		PRINT 'END LOADING TABLES IN SILVER LAYER'
		PRINT '>> Load Duration: '+ CAST( DATEDIFF(second,@start_load_time, @end_load_time) AS NVARCHAR) + ' seconds';
	END TRY
	BEGIN CATCH
		PRINT '================================';
		PRINT 'ERROR DURING LOADING BRONZE LAYER'
		PRINT 'Error Message:' + ERROR_MESSAGE();
		PRINT 'Error Message:' + CAST( ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message:' + CAST( ERROR_STATE() AS NVARCHAR);
		PRINT '================================';
	END CATCH
END
