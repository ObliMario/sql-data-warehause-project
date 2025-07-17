# Data Warehouse Project: CRM + ERP Integration

## 📌 Overview

This project implements a full **data warehouse architecture** that integrates data from **CRM** and **ERP** systems. The architecture follows a **Bronze → Silver → Gold** layered model, providing raw storage, data cleansing, and business-ready views for analytics, reporting, and machine learning.

---

## 📐 Data Architecture

<img width="1160" height="773" alt="High Level Architecture" src="https://github.com/user-attachments/assets/d9464894-d133-462a-a338-bfa6ee0c4a78" />


### 🔶 Bronze Layer
- **Purpose:** Store raw data from source systems.
- **Object Type:** Tables
- **Load Strategy:** `TRUNCATE + INSERT`
- **Transformations:** ❌ None  
- **Sources:** CSV files from CRM and ERP systems.

### 🔷 Silver Layer
- **Purpose:** Store cleaned, standardized data.
- **Object Type:** Tables
- **Transformations:**
  - Data Cleansing
  - Standardization
  - Normalization
  - Enrichment
- **Load Strategy:** `TRUNCATE + INSERT`

### 🟡 Gold Layer
- **Purpose:** Present data in a ready-to-use format.
- **Object Type:** Views (no physical load)
- **Transformations:**
  - Data Integration (e.g., CRM + ERP joins)
  - Business Aggregations
- **Data Models:** Star Schema, Flat Tables, Aggregated Views

---

## 🔄 Integration Model

<img width="1068" height="712" alt="Integration Model" src="https://github.com/user-attachments/assets/b4e034e4-e835-4f39-b873-3755205344d0" />

The **CRM and ERP** systems provide different but related datasets:
- `crm_sales_details` links to both `crm_prod_info` and `crm_cust_info`
- Keys from CRM (`prd_key`, `cst_key`) are used to join with ERP tables like:
  - `erp_px_cat_g1v2`
  - `erp_cust_az12`
  - `erp_loc_a101`

This design allows the warehouse to **enrich CRM data with ERP context**.

---

## 🌟 Star Schema

<img width="958" height="525" alt="Star Schema" src="https://github.com/user-attachments/assets/e83bc713-ae2f-4ce0-8bba-a4dd4cc80971" />

The final **Gold layer** is modeled as a **Star Schema**, ideal for reporting and BI tools like Power BI:

- **Fact Table:** `gold.fact_sales`
- **Dimensions:**
  - `gold.dim_customers` — enriched customer info
  - `gold.dim_products` — current products with category details

This design enables:
- Fast slicing/dicing
- Simple joins
- Semantic clarity for analysts

---

## 📤 Data Flow

<img width="988" height="659" alt="Data Flow" src="https://github.com/user-attachments/assets/3db03c32-0a05-4082-942c-2155d4bef0df" />

This diagram shows how data flows from raw CSVs to final analytical views:

1. **Bronze Layer** ingests raw CRM & ERP data
2. **Silver Layer** applies standardization, formatting, cleansing
3. **Gold Layer** creates business-facing views using joins and calculations

---

## 🛠️ Technologies Used

- **SQL Server** (Database Engine)
- **T-SQL** (for ETL logic, procedures, and views)
- **Power BI / Queries / ML** (for consumption layer)

---

## ✅ Benefits of This Architecture

- Clear separation of responsibilities per layer
- Reusable, modular transformations
- BI-friendly schema (Star)
- Scalable and auditable data flow
- Supports both batch ingestion and downstream ML or reporting
