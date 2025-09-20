# Data Warehouse Project

This repository showcases a complete data warehousing project, from raw data ingestion and ETL (Extract, Transform, Load) to advanced analytics and business intelligence reporting. The project integrates data from disparate sources, builds a robust data warehouse, and provides valuable insights through SQL-based analysis and Python-powered visualizations.

This portfolio project highlights my proficiency in:

- **Database Management:** Designing and implementing data schemas, DDL, and DML for a relational data warehouse.  
- **ETL Processes:** Performing data cleaning, validation, and integration to ensure data quality and integrity.  
- **SQL Mastery:** Writing complex SQL queries for advanced data analysis, including trend analysis, segmentation, and performance tracking.  
- **Data Visualization:** Creating insightful and interactive dashboards using Python libraries like Matplotlib, Seaborn, and Pandas for business reporting.  
- **Project Management & Documentation:** Maintaining a structured repository with clear documentation on data sources, folder structure, and naming conventions.  

---

## Project Structure

The project is organized in a logical and scalable manner:

```
.
├── data_catalog.md
├── data_sets
│   ├── source_crm
│   │   ├── cust_info.csv
│   │   ├── prd_info.csv
│   │   └── sales_details.csv
│   └── source_erp
│       ├── CUST_AZ12.csv
│       ├── LOC_A101.csv
│       └── PX_CAT_G1V2.csv
├── Data_visualization
│   ├── Python_Scripts
│   │   ├── Category_Sales_Visualization.ipynb
│   │   ├── Comprehensive_Business_Report.ipynb
│   │   ├── Cumulative_Analysis_Visualization.ipynb
│   │   ├── Customer_Report_Visualization.ipynb
│   │   ├── Data_Segmentation_Visualization.ipynb
│   │   ├── Product_Performance_Visualization.ipynb
│   │   ├── Product_Report_Visualization.ipynb
│   │   └── Sales_Trends_Visualization.ipynb
│   └── Visualization_PDF
│       ├── Category_Sales_Visualization.pdf
│       ├── Comprehensive_Business_Report.pdf
│       ├── Cumulative_Analysis_Visualization.pdf
│       ├── Customer_Report_Visualization.pdf
│       ├── Data_Segmentation_Visualization.pdf
│       ├── Product_Performance_Visualization.pdf
│       ├── Product_Report_Visualization.pdf
│       └── Sales_Trends_Visualization.pdf
├── docs
│   ├── Data_Flow.png
│   ├── Data_Integration.png
│   ├── Data_Model.png
│   ├── ETL.png
│   ├── HighLevelArchitecture.png
│   ├── interviews
│   ├── Layer_Work_FLow
│   └── naming_conventions.md
├── folder_structure.md
├── README.md
└── scripts
    ├── Advanced_Data_Analysis
    │   ├── Change_Over_Time(Trends).sql
    │   ├── Cumulative_Analysis.sql
    │   ├── Customer_Report.sql
    │   ├── Data_Segmentation.sql
    │   ├── EDA(Exploratory_Data_Analysis).sql
    │   ├── Part_To_Whole_Analysis.sql
    │   ├── Performance_Analysis.sql
    │   └── Product_Report.sql
    ├── Database_Creation
    │   ├── Database_Init.sql
    │   ├── DDL.sql
    │   ├── Load_Bulk_Inser.sql
    │   └── Table_modifications.sql
    └── Data_Cleanig_and_Validation
        ├── Data_Cleaning.sql
        ├── Data_Integration.sql
        ├── Data_Quialuity_Checking.sql
        └── Validating_Data_Integration.sql

12 directories, 49 files
```
---

## Detailed Breakdown of Components

### 1. Data Sources (`data_sets/`)

The project begins with raw data from two primary business sources:

- **CRM (Customer Relationship Management):** Provides customer, product, and sales transaction information.
  - `cust_info.csv`: Contains customer-specific data.
  - `prd_info.csv`: Includes product details.
  - `sales_details.csv`: Records sales transactions.
- **ERP (Enterprise Resource Planning):** Offers additional customer and product category information.
  - `CUST_AZ12.csv`: Provides supplementary customer data.
  - `LOC_A101.csv`: Contains location information.
  - `PX_CAT_G1V2.csv`: Lists product categories, which is crucial for product analysis.

---

### 2. ETL Scripts (`scripts/`)

This is the core of the data engineering pipeline. The SQL scripts perform a series of critical tasks to transform raw data into a clean, integrated, and analysis-ready format.

**Database_Creation/:**
- `Database_Init.sql`: Initializes the database and schema.  
- `DDL.sql`: Defines the Data Definition Language, creating tables and setting up the schema.  
- `Load_Bulk_Inser.sql`: Handles the efficient bulk loading of data from the source CSV files into the newly created database tables.  

**Data_Cleanig_and_Validation/:**
- `Data_Cleaning.sql`: Handles various data quality issues, such as:
  - Extracting meaningful information from combined fields (e.g., separating `prd_key` and `cat_id` from a single `prd` column in `crm_prd_info`).  
  - Casting data types to the correct format (e.g., converting `DATETIME` to `DATE`).  
  - Adding metadata columns (`dwh_last_update`) for tracking data freshness.  
- `Data_Integration.sql` & `Validating_Data_Integration.sql`: Join and integrate data from multiple sources (CRM and ERP) into a unified view, followed by validation to ensure integration success.  

---

### 3. Advanced Analysis (`scripts/Advanced_Data_Analysis/`)

This folder contains SQL queries that extract meaningful business insights:

- `Change_Over_Time(Trends).sql`: Uses window functions and date-based queries to analyze trends.  
- `Cumulative_Analysis.sql`: Tracks total sales and customer growth using cumulative sums.  
- `Customer_Report.sql`: Generates a comprehensive report on customer behavior.  
- `Data_Segmentation.sql`: Segments customers or products based on metrics like sales volume or frequency.  
- `EDA(Exploratory_Data_Analysis).sql`: Ad-hoc queries for initial data exploration.  
- `Part_To_Whole_Analysis.sql`: Understands contribution of individual products/categories to overall sales.  
- `Performance_Analysis.sql`: Measures and compares product or region performance.  

---

### 4. Data Visualization (`Data_visualization/Python_Scripts/`)

The Jupyter Notebooks in this directory connect directly to the data warehouse to generate visualizations for stakeholders:

- `Category_Sales_Visualization.ipynb`: Compares sales performance across product categories.  
- `Comprehensive_Business_Report.ipynb`: Combines multiple visualizations for a 360-degree view of the business.  
- `Sales_Trends_Visualization.ipynb`: Visualizes trends identified in SQL scripts to spot seasonal changes or growth patterns.  

---

## How to Get Started

1. Clone this repository.
2. Set up a relational database (e.g., MySQL).  
3. Load the data from `data_sets/` using the `Load_Bulk_Inser.sql` script.  
4. Execute the SQL scripts in the `scripts` directory to build the data warehouse.  
5. Open the Jupyter Notebooks in `Data_visualization/Python_Scripts` to reproduce reports and visualizations.

