/*
=====================================================
🇩🇪 Beschreibung (Deutsch)
=====================================================

Dieses Skript führt verschiedene Datenqualitätsprüfungen im Bronze- und Silver-Schema eines Data Warehouses durch.
Es überprüft die Eindeutigkeit und Gültigkeit von Primärschlüsseln, ungewollte Leerzeichen, die Konsistenz
von Kategorienamen, sowie fehlende oder negative Werte in Kosten- und Verkaufsdaten.
Darüber hinaus wird geprüft, ob Berechnungen wie Umsatz = Menge × Preis korrekt sind.
Es wird erwartet, dass keine Ergebnisse zurückgegeben werden, wenn die Daten korrekt sind.

=====================================================
🇬🇧 Description (English)
=====================================================

This script performs various data quality checks in the Bronze and Silver schemas of a data warehouse.
It verifies the uniqueness and validity of primary keys, checks for unwanted spaces, consistency of category values,
and the presence of null or negative values in cost and sales fields.
Additionally, it validates whether calculations like sales = quantity × price are accurate.
No results are expected if the data is clean and correct.
*/

-- Check Nulls or Duplicates in Primery Key
-- Expected No Results

SELECT cst_id, COUNT(*)
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*)>1 OR cst_id IS NULL

-- Check for unwanted Spaces
-- Expected No Results

SELECT * from bronze.crm_cust_info
where cst_firstname != TRIM(cst_firstname)

-- Data Standarization and Consistency
SELECT DISTINCT prd_line
FROM bronze.crm_prd_info

-- Check for NULLS or Negative Numbers
-- Expected No Results

 SELECT * FROM bronze.crm_prd_info
where prd_cost <0 or prd_cost IS NULL
;

--Check if calculation are ok
SELECT * from silver.crm_sales_details
where sls_sales <=0 or sls_sales IS NULL
OR sls_sales != sls_quantity * sls_price
