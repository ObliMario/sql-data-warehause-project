/* 
==================================================================================================================================================================================================================================================================================================
🇩🇪 Deutsch:
Diese gespeicherte Prozedur bronze.load_bronze lädt Daten aus mehreren CSV-Dateien in die Tabellen der Bronze-Schicht eines Data-Warehouse. Vor dem Laden werden die Tabellen geleert. Der Vorgang wird zeitlich gemessen, und Fehler werden abgefangen und protokolliert.
==================================================================================================================================================================================================================================================================================================
🇬🇧 English:
This stored procedure bronze.load_bronze loads data from multiple CSV files into the Bronze layer tables of a data warehouse. Before loading, it truncates the tables. The process is timed, and any errors are caught and logged.
==================================================================================================================================================================================================================================================================================================
*/
CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME;
	BEGIN TRY
		PRINT '============================';
		PRINT 'Loading Bronze Layer';
		PRINT '============================';

		PRINT '--------------------------';
		PRINT 'Loading CRM Tables';
		PRINT '--------------------------';
		SET @start_time = GETDATE();
		TRUNCATE TABLE bronze.crm_cust_info;
		BULK INSERT bronze.crm_cust_info
		FROM 'C:\Users\mario\Desktop\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		TRUNCATE TABLE bronze.crm_prd_info;
		BULK INSERT bronze.crm_prd_info
		FROM 'C:\Users\mario\Desktop\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		TRUNCATE TABLE bronze.crm_sales_details;
		BULK INSERT bronze.crm_sales_details
		FROM 'C:\Users\mario\Desktop\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		PRINT '--------------------------';
		PRINT 'Loading ERP Tables';
		PRINT '--------------------------';

		TRUNCATE TABLE bronze.erp_cust_az12;
		BULK INSERT bronze.erp_cust_az12
		FROM 'C:\Users\mario\Desktop\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\cust_az12.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		TRUNCATE TABLE bronze.erp_loc_a101;
		BULK INSERT bronze.erp_loc_a101
		FROM 'C:\Users\mario\Desktop\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\loc_a101.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		TRUNCATE TABLE bronze.erp_px_cat_g1v2;
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'C:\Users\mario\Desktop\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\px_cat_g1v2.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT 'END LOADING TABLES IN BRONZE LAYER'
		PRINT '>> Load Duration: '+ CAST( DATEDIFF(second,@start_time, @end_time) AS NVARCHAR) + ' seconds';
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
GO

EXEC bronze.load_bronze

--SELECT COUNT(*) FROM bronze.crm_cust_info;
--SELECT COUNT(*) FROM bronze.crm_prd_info;
--SELECT COUNT(*) FROM bronze.crm_sales_details;
--SELECT COUNT(*) FROM bronze.erp_cust_az12;
--SELECT COUNT(*) FROM bronze.erp_loc_a101;
--SELECT COUNT(*) FROM bronze.erp_px_cat_g1v2;
