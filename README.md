## Project Description

This project implements a complete **SQL-based Data Warehouse** with a modular **three-layer architecture** (Bronze, Silver, and Gold). Its purpose is to consolidate, clean, and model raw CRM and ERP data into a reliable and analytics-ready structure.

---

<img width="1160" height="773" alt="High Level Architecture" src="https://github.com/user-attachments/assets/fd0e843f-f54f-4f3e-8c53-41045bccd036" />


### 🟫 Bronze Layer – Raw Data

The Bronze layer ingests data from **two different sources** in CSV format: `CRM` and `ERP`. These files are loaded exactly as they are found, without any modification. This ensures **data traceability** — if any issue arises, we can always refer back to the original untouched source.

- **Data Source:** CSV files (flat files)
- **Storage:** SQL Server tables
- **Processing:** `TRUNCATE + INSERT`
- **Transformations:** None (raw ingestion only)

<img width="1068" height="712" alt="Integration Model" src="https://github.com/user-attachments/assets/3c76f751-3122-46b4-9dee-139af7e998b3" />

---

### 🟦 Silver Layer – Cleaned & Standardized Data

In the Silver layer, raw data is **cleaned, standardized, and normalized** using a variety of techniques, while still preserving the structure of the original tables (same schema as Bronze and source files).

#### Techniques used:
- **Data Cleansing:** Removing nulls, correcting invalid formats, eliminating duplicate keys
- **Data Standardization:** Converting gender and marital status codes to human-readable values
- **Data Normalization:** Enforcing consistent structure and formats (dates, prices, etc.)
- **Data Enrichment:** Merging CRM records with ERP data using shared business keys

This layer ensures that all data is **valid and business-ready** before further modeling.

---

### 🟡 Gold Layer – Analytical Model

The Gold layer transforms the standardized data into **a Star Schema**, ready for business intelligence, reporting, or machine learning consumption.

<img width="958" height="525" alt="Star Schema" src="https://github.com/user-attachments/assets/a15b4a6e-29ae-4559-82ab-e91df18cd71d" />


Only **three key entities** are modeled as views:
- `gold.dim_customers` — Customer dimension (consolidates CRM and ERP)
- `gold.dim_products` — Product dimension (with categories and pricing)
- `gold.fact_sales` — Sales fact table (linked to customer and product dimensions)

#### Highlights:
- **Data Integration**: Joining and enriching data from CRM and ERP systems
- **Aggregations**: Derived calculations such as total sales, price corrections, etc.
- **Data Model**: Clean Star Schema for fast and intuitive analysis

  
<img width="988" height="659" alt="Data Flow" src="https://github.com/user-attachments/assets/b3d7afcf-3c5b-4e39-88f2-59520f482da1" />

---

### 📊 Use Cases

The Gold layer data is now **organized, reliable, and ready to use** for various business applications, including:

-  **Power BI dashboards** (sales by customer segment, product performance)
-  **Ad hoc SQL analysis** (monthly trends, customer behavior)
-  **Machine Learning** (churn prediction, product recommendation systems)

---

### 🛠 Technologies Used

- **SQL Server** – Main database engine
- **T-SQL** – For data processing, views, and logic
- **CSV Files** – Source data inputs
- **Power BI / ML Tools** – For consuming the output data

---

###  Key Concepts Applied

Throughout the development of this project, I gained hands-on experience with foundational concepts in **data engineering**, including:

- ETL Process
- Data Cleansing & Standardization
- Data Normalization & Enrichment
- Views & SQL Window Functions
- Schema Design (Star Schema)
- Facts and Dimensions
- Layered Architecture (Bronze → Silver → Gold)
- Separation of Concerns in Data Modeling

---

###  Final Note

This project helped me solidify the core principles of modern data architecture using SQL Server. The layered design not only enables traceability and data quality, but also makes it scalable and future-ready.

Whether the goal is reporting, data science, or business analytics — this warehouse is ready to deliver.

---
