/*
=====================================================
🇩🇪 Beschreibung (Deutsch)
=====================================================

Dieses Skript erstellt drei Ansichten (Views) im Schema `gold` eines Data-Warehouse-Modells:
- `dim_customers`: eine Dimensionstabelle mit bereinigten Kundendaten, inklusive generierter Schlüssel, bereinigtem Geschlecht, Geburtsdatum und Herkunftsland.
- `dim_products`: eine Dimensionstabelle für Produkte, kombiniert mit Kategorien und Unterkategorien. Es werden nur aktuelle Produkte ohne Enddatum einbezogen.
- `fact_sales`: eine Faktentabelle, die Verkaufsdaten mit den entsprechenden Kunden- und Produktdimensionen verknüpft.

Diese Ansichten strukturieren die Gold-Schicht für analytische Zwecke und ermöglichen performante und konsistente Abfragen in BI-Tools oder Reports.

=====================================================
🇬🇧 Description (English)
=====================================================

This script creates three views within the `gold` schema of a data warehouse model:
- `dim_customers`: a dimension table with cleansed customer data, including generated keys, gender enrichment, birthdate, and country information.
- `dim_products`: a product dimension table joined with category and subcategory details. It includes only current product prices (no end date).
- `fact_sales`: a fact table that joins sales transactions with their corresponding customer and product dimensions.

These views define the Gold layer for analytics and enable efficient, consistent reporting in BI tools or dashboards.
*/


CREATE VIEW gold.dim_customers AS
select
ROW_NUMBER() OVER (ORDER BY c1.cst_id ) AS customer_key,
c1.cst_id as customer_id,
c1.cst_key as customer_number,
c1.cst_firstname as first_name,
c1.cst_lastname as last_name,
l1.cntry as country,
c1.cst_marital_status as marital_status,
CASE WHEN c1.cst_gndr != 'n/a' THEN c1.cst_gndr
	ELSE COALESCE(c2.gen,'n/a')
END AS gender,
c2.bdate as birthdate,
c1.cst_create_date as create_date
from silver.crm_cust_info c1
LEFT JOIN silver.erp_cust_az12 c2 on c1.cst_key = c2.cid
LEFT JOIN silver.erp_loc_a101 l1 on c1.cst_key = l1.cid

CREATE VIEW gold.dim_products AS
select 
ROW_NUMBER() OVER ( ORDER BY p1.prd_start_dt, p1.prd_key) as product_key,
p1.prd_id as product_id,
p1.prd_key as product_number,
p1.prd_nm as product_name,
p1.cat_id as category_id,
p2.cat as category,
p2.subcat as subcategory,
p2.maintenance,
p1.prd_cost as product_cost,
p1.prd_line as product_line,
p1.prd_start_dt as start_date
from silver.crm_prd_info p1
left join silver.erp_px_cat_g1v2 p2 on p1.cat_id = p2.id
where p1.prd_end_dt is null -- Just current prices

CREATE VIEW gold.fact_sales AS
SELECT 
sls_ord_num as order_number,
c1.customer_key,
c2.product_key,
sls_order_dt as order_date,
sls_ship_dt as shipping_date,
sls_due_dt as due_date,
sls_quantity as quantity,
sls_price as price,
sls_sales as sales_amount
FROM silver.crm_sales_details s1
LEFT JOIN gold.dim_customers c1 on s1.sls_cust_id = c1.customer_id
LEFT JOIN gold.dim_products c2 on s1.sls_prd_key = c2.product_number
