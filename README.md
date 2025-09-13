# Data Warehouse Project
This project is an exciting, hands-on journey into **building a modern SQL data warehouse from scratch**. It goes beyond theoretical knowledge, demonstrating how such complex data engineering projects are implemented in real-world companies.

The primary objective is to **develop a modern data warehouse using MySQL to consolidate sales data, enabling analytical reporting and informed decision-making**. This is a foundational data analytics project designed to address the challenges faced by companies without a proper data management system, such as lengthy manual reporting processes, inconsistent data, human errors, difficulties with big data, and the inability to generate integrated reports from multiple sources.

Through this project, participants will gain practical skills and experience different roles:

- As a **data architect**, you will learn to design a modern data architecture following best practices.
- As a **data engineer**, you will write code to clean, transform, load, and prepare data for analysis.
- As a **data modeler**, you will learn the basics of data modeling and create a new data model for analytics from scratch.

While the project utilizes MySQL, the concepts and skills taught are broadly applicable, allowing you to follow along with other databases like PostgreSQL. By the end, you will have a **professional portfolio project** to showcase your newly acquired skills, for example, on LinkedIn.

### Learning Objectives:

1. ETL/ELT Processing (Extract - Transform - Load)
2. Data Architecture
3. Data Integration
4. Data Cleansing
5. Data Load
6. Data Modeling

### What is Data Warehouse?

A data warehouse is a **foundational component for any data analytics project**, designed to organize, structure, and prepare data for analysis. It serves as a **single point of truth for analysis and reporting**, bringing together data from various sources into one integrated place.

Bill Inmon, often referred to as the father of the data warehouse, defines it as a **"subject oriented, integrated, time variance, and nonvolatile collection of data designed to support the Management's decision-making process"**.

- **Subject-oriented:** It focuses on specific business areas, such as sales, customers, or finance.
- **Integrated:** It combines data from multiple source systems, not just a single one.
- **Time-variant:** It retains historical data, allowing for analysis of trends over time.
- **Nonvolatile:** Once data enters the data warehouse, it is neither deleted nor modified.

You can think of a data warehouse like the **kitchen of a busy restaurant**, where raw ingredients (your data) are cleaned, sorted, and stored. When an order (a report or analysis) comes in, the prepared ingredients are quickly grabbed to create and serve the perfect dish.

### Why do we need Data Warehouse?

Companies need a data warehouse for several critical reasons, primarily to overcome the significant challenges posed by managing data without a proper system and to enable informed decision-making:

**Challenges Without a Data Warehouse:**

- **Slow and Manual Processes:** Without a data warehouse, data analysts often spend weeks or even months manually collecting, extracting, and transforming raw data from various systems into meaningful reports. This process is slow, stressful, and inefficient.
- **Inconsistent Data for Decision-Making:** Different reports might show data from different time periods (e.g., one report 40 days old, another 10 days old), making it **difficult to make reliable decisions** based on inconsistent information.
- **High Risk of Human Error:** Manual processes are prone to human errors, and inaccuracies in reports can lead to bad business decisions.
- **Difficulty Handling Big Data:** As data sources generate massive amounts of data, manual collection can become impossible, leading to a breakdown in the reporting process and an inability to generate fresh data.
- **Chaotic Integrated Reporting:** Merging data from multiple disparate sources manually for integrated reports is chaotic, time-consuming, and full of risks.
- **Disorganized Data Teams:** Data teams waste time "fighting with the data" rather than focusing on analysis and insights.

**Benefits and Reasons for Needing a Data Warehouse:**

- **Automation and Speed:** A data warehouse automates the entire data preparation process (Extract, Transform, Load - ETL), allowing data to be loaded from sources to reports in **hours or even minutes**, rather than weeks or months.
- **Reduced Human Error:** By automating data processes, the risk of human error is significantly reduced.
- **Consistent and Reliable Data:** It provides a **single, integrated source of truth**, ensuring that all reports and analyses are based on consistent and current data, which is crucial for making good and fast decisions.
- **Integrated Data for Comprehensive Reporting:** It brings together data from various sources into one place, making it significantly **easier to create integrated reports** that offer a holistic view of the business.
- **Historical Analysis:** Data warehouses can store historical data, enabling businesses to track trends over time, compare performance, and segment data.
- **Scalability for Big Data:** Modern data warehouses, especially those built on cloud platforms, are designed to easily handle massive amounts of data from various sources.
- **Solid Foundation for Analytics:** It provides the **solid foundations for reporting and business intelligence**, making it suitable for businesses that primarily deal with structured data.
- **Organized Data Management:** It helps data teams become more organized and focused, delivering professional and fresh reports that the company can rely on.

In essence, a data warehouse transforms raw, unorganized, and potentially inconsistent data into a structured, clean, and reliable resource, empowering companies to perform advanced analytics and make timely, informed business decisions.

### All about ETL

The **ETL process** (Extract, Transform, Load) is a crucial component in data analytics projects, especially for building data warehouses. It is the **core element of a data warehouse** and is essential for organizing, structuring, and preparing data for analysis. In real-world projects, data engineers often spend approximately 90% of their time building this component.

The ETL process addresses significant challenges faced by companies without a proper data management system:

- **Slow and Manual Processes** Without ETL, data collection and report generation can take weeks or even months of manual effort, making the process slow, stressful, and inefficient.
- **Inconsistent Data** Reports derived manually from various sources often present inconsistent data states (e.g., one report 40 days old, another 10 days old), making reliable decision-making difficult.
- **High Risk of Human Error** Manual data handling is prone to human errors, which can lead to inaccurate reports and poor business decisions.
- **Difficulty with Big Data** Without automation, handling massive amounts of data from various sources can become impossible, leading to a breakdown in reporting and an inability to generate fresh data.
- **Chaotic Integrated Reporting** Manually merging data from multiple disparate sources for integrated reports is chaotic, time-consuming, and risky.

By implementing ETL, companies can achieve **automation, speed, and reduce human errors**, enabling data to be loaded from sources to reports in **hours or even minutes**. It provides a **single, integrated source of truth**, ensuring all reports are based on consistent and reliable data, crucial for making quick and informed decisions.

The ETL process consists of three main stages:

### 1. Extract (E)

The **extract** stage is the first step, where data is pulled out from various source systems. The primary task of extraction is to **identify the data that needs to be pulled out from the source, without changing or manipulating it**. The data is kept "one to one" with the source system during this stage.

There are different methods and types of extraction:

- **Methods of Extraction**:
    - **Pull Extraction:** The data warehouse system actively pulls data from the source system.
    - **Push Extraction:** The source system pushes data to the data warehouse.
- **Types of Extraction**:
    - **Full Extraction:** All records from tables are loaded to the data warehouse every day.
    - **Incremental Extraction:** Only new or changed data is identified and extracted daily, making the process more efficient by not loading the entire dataset.
- **Techniques of Extraction**:
    - Manually accessing and extracting data.
    - Connecting to a database and using a query.
    - Parsing files (e.g., CSV files).
    - Connecting to APIs and writing code.
    - Event-based streaming (e.g., from Kafka).
    - Change Data Capture (CDC).
    - Web scraping.

### 2. Transform (T)

The **transform** stage takes the extracted raw data and applies various manipulations and reshaping to convert it into a meaningful and desired format for analysis and reporting. This is typically a "heavy working" process.

Common types of transformations include:

- **Data Cleansing:** This is a broad category aimed at improving data quality.
    - **Removing Duplicates:** Ensuring only one unique record for primary keys.
    - **Data Filtering:** Removing unwanted data.
    - **Handling Missing Data:** Filling blanks by replacing nulls or empty strings with default values (e.g., 'not available' or zero).
    - **Handling Invalid Values:** Correcting or removing data that is out of range or incorrect (e.g., future birth-dates, negative costs, strange numbers that cannot be converted to dates).
    - **Removing Unwanted Spaces:** Trimming leading or trailing spaces from string values.
    - **Casting Data Types:** Converting data from one type to another (e.g., integer to date).
    - **Detecting Outliers:** Identifying values that significantly deviate from other observations.
- **Data Enrichment:** Adding new relevant data or values to existing datasets.
- **Data Integration:** Combining data from multiple sources into a single, unified data model, often involving complex logic to resolve conflicting information.
- **Deriving New Columns:** Creating new columns based on calculations or transformations of existing ones (e.g., extracting category ID from a product key).
- **Data Normalization/Standardization:** Mapping coded values (e.g., 'F' to 'Female', 'M' to 'Male') to more meaningful, user-friendly descriptions or ensuring consistent formats.
- **Business Rules and Logic:** Applying specific business criteria to build new columns or transform data according to business requirements (e.g., recalculating sales based on quantity and price if original sales figures are incorrect).
- **Data Aggregation:** Summarizing data to a different granularity.

### 3. Load (L)

The **load** stage is the final step where the transformed and prepared data is inserted into its final destination, typically the data warehouse.

Different processing types and load methods exist:

- **Processing Types**:
    - **Batch Processing:** Loading the data warehouse in one large batch, often scheduled to run once or twice a day.
    - **Stream Processing:** Processing changes in the source system as soon as they occur, aiming for a real-time data warehouse, which is more challenging to implement.
- **Load Methods**:
    - **Full Load:** The entire dataset is loaded.
        - **Truncate and Insert:** The target table is made completely empty (truncated), and then all data is inserted from scratch. This is a common approach for full loads in the bronze layer.
        - **Update-Insert (Upsert):** Existing records are updated, and new records are inserted.
        - **Drop, Create, and Insert:** The entire table is dropped, recreated from scratch, and then data is inserted.
    - **Incremental Load:** Only the new or changed data is loaded.
        - **Upsert:** Update existing records and insert new ones.
        - **Append-Only:** New data is simply inserted without updating existing records, often used for log-like data.
        - **Merge (Update, Insert, Delete):** Records are updated, new ones inserted, and old ones potentially deleted based on specific logic.

A related concept during loading, especially in data warehousing, is **Slowly Changing Dimensions (SCDs)**, which deals with how to handle the history of changes in dimension tables. Common types include:

- **SCD0 (No Historization):** No changes are allowed; data is not updated.
- **SCD1 (Overwrite):** Records are updated with new information, overwriting old values and losing historical data. This is similar to an upsert.
- **SCD2 (Add Historization):** New records are inserted for each change, marking old records as inactive and new ones as active, thus retaining full history.

### ETL in Data Architecture Layers

In a multi-layered data architecture, such as the Medallion Architecture (Bronze, Silver, Gold layers), ETL plays a distinct role in moving and transforming data between layers:

- **Source to Bronze:** Often, data is loaded from the source directly to the first layer (e.g., Bronze) without transformations, aiming to keep the raw, untouched data for traceability and debugging. This might be an "Extract and Load" (EL) process.
- **Bronze to Silver:** Data is extracted from the Bronze layer, undergoes significant transformations (cleansing, standardization, normalization, deriving new columns, enrichment), and then loaded into the Silver layer. This is typically a full ETL process.
- **Silver to Gold:** Data from the Silver layer is further transformed to apply business rules, perform data aggregations, and integrate data from various sources into a business-ready data model (e.g., star schema), often for reporting and machine learning. In modern data warehouses, the Gold layer might be composed of views, meaning there is no "load" process to a physical table, only transformations applied to the data in the Silver layer. This could be a "Transform and Load" (TL) or just "Transform" (T) if using views.

It is important to note that you don't always use a complete ETL process (E, T, L) for every transition between layers; it depends on the design of your data architecture. The principle of **"separation of concerns"** is vital, ensuring each layer and component has a unique set of tasks, preventing duplication of effort and avoiding mixing responsibilities.

### Real-World ETL Implementation

Building ETL processes in real-world projects also involves:

- **Project Planning and Naming Conventions:** Defining clear rules for naming databases, schemas, tables, columns, and stored procedures is crucial to avoid chaos and ensure consistency across development teams.
- **Error Handling:** Implementing `TRY...CATCH` blocks in ETL scripts (e.g., stored procedures) to define what should happen if an error occurs, such as logging error messages, numbers, and states.
- **Performance Measurement:** Tracking the duration of each ETL step and the overall batch load time is essential for identifying bottlenecks and optimizing performance.
- **Logging and Messaging:** Providing clear and organized output messages during the ETL process helps in debugging and understanding the flow of data.
- **Version Control:** Committing ETL scripts and related documentation to a Git repository helps track changes, collaborate with teams, and provides a professional portfolio.
- **Data Validation and Quality Checks:** After each ETL stage (especially for the bronze and silver layers), it's crucial to perform quality checks to ensure data completeness, schema integrity, and the absence of duplicates or invalid data.

In this project we will be using **Full Extraction** and **Pull Extraction** techniques also we will be **parsing files** to the data warehouse. All types of transformations techniques mentioned above will be covered in this project. We will do **Batch Processing** using **Full Load (Truncate & Insert)**. And about the **Historization** we will be doing **SCD1.** 

### **Requirements Analysis**

Here are the key requirements for the data engineering part of the project, specifically for building the data warehouse:

- **Main Objective**: **Develop a modern data warehouse using SQL Server to consolidate sales data, enabling analytical reporting and informed decision-making**.
- **Data Sources**: The project requires importing data from two source systems: **ERP (Enterprise Resource Planning) and CRM (Customer Relationship Management)**. These sources provide data as **CSV (Comma Separated Values)** files.
- **Data Quality**: It is mandatory to **clean and fix data quality issues** before any data analysis. The sources anticipate that raw data will not be perfect and will contain missing information that needs to be cleaned.
- **Data Integration**: The project must **combine both ERP and CRM sources into one single, user-friendly data model** that is specifically designed for analytics and reporting. This means merging the disparate sources into a cohesive model.
- **Historization**: The project is required to **focus on the latest datasets**, indicating **no need for historization** (keeping historical data) in the database.
- **Documentation**: The project must **provide clear documentation of the data model** to support business users and analytical teams, making it easier for consumers of the data to understand and use the system.

These requirements, while seemingly generic, provide significant information for the project, guiding the choice of platform (SQL Server), the need for data quality efforts, the integration of multiple CSV sources into a new analytical data model, the decision against historization, and the necessity for comprehensive documentation.

### Data Architecture

Data architecture is a fundamental aspect of the modern SQL data warehouse project, serving as the blueprint for how data flows, integrates, and is accessed within the system. It is essential for ensuring that the data warehouse is not only functional but also **scalable, maintainable, and aligned with business needs**. Skipping this design phase can lead to unstable, inefficient, or unusable data systems.

Here's everything you need to know:

### 1. Importance and Role of a Data Architect

A data architect's role is akin to a house architect, designing how data will flow, integrate, and be accessed to ensure a data warehouse is functional, scalable, and easy to maintain. This involves making crucial decisions about the approach and structure of the data management system.

### 2. Overall Data Management Approaches

The project first requires a decision on the major type of data management system to build. The options discussed include:

- **Data Warehouse**: Suitable for structured data, providing a solid foundation for reporting and business intelligence. This is the **chosen approach for this project**.
- **Data Lake**: Offers flexibility for storing structured, semi-structured, and unstructured data, suitable for advanced analytics and machine learning. However, it can become unorganized, leading to a "data swamp".
- **Data Lakehouse**: A modern approach combining the flexibility of a data lake with the structure and organization of a data warehouse. This is the speaker's personal favorite.
- **Data Mesh**: A decentralized approach where multiple departments or domains build and share data products, aiming to avoid bottlenecks of a centralized system.

### 3. Data Warehouse Specific Approaches

Once "Data Warehouse" is chosen, there are four common architectural approaches for building it:

- **Inmon Approach**: Involves a **Staging layer** for raw data, an **Enterprise Data Warehouse (EDW)** where data is modeled in the third normal form (3NF), followed by **Data Marts** designed for specific reporting topics, which are then consumed by BI tools.
- **Kimball Approach**: Jumps directly from the Staging layer to Data Marts, bypassing the EDW. It's faster but can lead to inconsistency and chaos over time due to repeated transformations.
- **Data Vault**: Similar to Inmon but introduces more standards and rules by splitting the middle layer into a **Raw Vault** (original data) and a **Business Vault** (business rules and transformations) before feeding Data Marts.
- **Medallion Architecture**: Consists of three layers: **Bronze, Silver, and Gold**. It's described as easy to understand and build. This is the **chosen architecture for this project**.

### 4. Medallion Architecture Layers (Project Specific)

This project adopts the Medallion Architecture, defining clear purposes, object types, load methods, and transformation rules for each layer:

| Category | Bronze Layer (Raw) | Silver Layer (Cleaned) | Gold Layer (Business-Ready) |
| --- | --- | --- | --- |
| **Definition** | Raw, unprocessed data as-is from sources | Clean & standardized data | Business-Ready data |
| **Objective** | Traceability & Debugging | (Intermediate Layer) Prepare Data for Analysis | Provide data to be consumed for reporting & Analytics |
| **Object Type** | Tables | Tables | Views |
| **Load Method** | Full Load (Truncate & Insert) | Full Load (Truncate & Insert) | None |
| **Data Transformation** | None (as-is) | - Data Cleaning- Data Standardization- Data Normalization- Derived Columns- Data Enrichment | - Data Integration- Data Aggregation- Business Logic & Rules |
| **Data Modeling** | None (as-is) | None (as-is) | - Star Schema- Aggregated Objects- Flat Tables |
| **Target Audience** | Data Engineers | Data Analysts, Data Engineers | Data Analysts, Business Users |

### 5. Guiding Principle: Separation of Concerns

A critical principle for data architects is the **separation of concerns**. This means breaking down complex systems into smaller, independent parts, with each part responsible for a specific, **unique task**, avoiding duplication of efforts across layers. For example, data cleansing is unique to the Silver layer, while business transformations are unique to the Gold layer.

### 6. Visual Representation of Data Architecture

The data architecture is visually represented using tools like Draw.io:

- **Overall Structure**: Divided into three main containers: **Sources**, the **Data Warehouse**, and **Consumers**.
- **Data Warehouse Components**: Inside the Data Warehouse container, the three layers (Bronze, Silver, Gold) are clearly depicted.
- **Sources**: Specifies the types of source systems (e.g., CSV files in folders for CRM and ERP for this project).
- **Data Flow**: Arrows illustrate the direction of data flow between layers (from Sources to Bronze, Bronze to Silver, Silver to Gold, and Gold to Consumers).
- **Layer Details**: Each layer includes text detailing its objective (e.g., "raw data," "clean standardized data," "business ready data") and specifications (object type, load method, transformations, data model).
- **Consumers**: Represents how the data is utilized (e.g., Business Intelligence & Reporting, Ad-hoc Analysis, Machine Learning).
- **Data Lineage**: The complete diagram provides a **full data lineage**, showing the origin and flow of data across all layers without needing to examine scripts.
- **Data Model Diagram**: For the Gold layer, a **logical data model diagram (Star Schema)** is created, showing fact and dimension tables, their columns (including primary and foreign keys/surrogate keys), and the one-to-many relationships between them. This also includes descriptions of business rules or calculations.

### 7. Roles Involved

- **Data Architect**: Designs the data architecture, defining the layers, their purposes, and the overall flow.
- **Data Engineer**: Builds the ETL (Extract, Transform, Load) components and the data warehouse itself, scripting processes for data ingestion, cleaning, transformation, and loading.

### 8. Project-Specific ETL Implementation Details

The project specifies the following ETL process characteristics based on the chosen Medallion Architecture:

- **Extraction**:
    - **Method**: **Pull extraction** (data pulled from sources).
    - **Type**: **Full extraction** (all records loaded every day).
    - **Technique**: **Parsing files** (CSV files).
- **Transformation**: All types of transformations (data enrichment, integration, derived columns, normalization, business rules, aggregation, cleansing) are expected to be covered across the Silver and Gold layers.
- **Load**:
    - **Processing Type**: **Batch processing** (loading data in one big batch, scheduled periodically).
    - **Method**: **Full load** using "truncate and insert".
- **Historization (Slowly Changing Dimensions - SCD)**: The project uses **SCD1**, meaning new information overwrites old values, and **historical data is not kept** in the database. This aligns with the requirement to focus on the latest datasets.

### **Separation of Concerns (SoC)**

The **Separation of Concerns (SoC)** is a fundamental design principle that every data architect must understand and implement. It is a "secret principle" for building robust data architectures.

Here's an explanation of Separation of Concerns based on the sources:

1. **Core Definition and Purpose**:
Separation of Concerns means to **break down a complex system into smaller, independent parts**, where **each part is responsible for a specific, unique task**. The primary "magic" of this principle is that **components of the architecture must not have duplicated tasks**. The goal is to avoid mixing everything together, which is often a significant mistake in large projects.
2. **Application in Data Architecture (Medallion Architecture)**:
In the context of building a modern SQL data warehouse using the Medallion Architecture (Bronze, Silver, Gold layers), SoC is applied by defining a **unique set of tasks for each layer**. This ensures that responsibilities are clearly delineated and that no single task is performed in multiple layers, preventing overlap and inconsistency.
    - **Bronze Layer**: This layer is designated as the **first landing layer** for raw data directly from source systems. Its unique task is to store unprocessed data for traceability and debugging, with **no transformations allowed**. Crucially, data is *not* permitted to bypass the Bronze layer and load directly into the Silver layer, as this would create overlapping data ingestion in two different layers.
    - **Silver Layer**: This layer's unique task is to perform **data cleansing, standardization, and normalization**. It focuses on transforming data to be clean and consistent, preparing it for the final layer. **Business transformations are explicitly pushed to the Gold layer** and are not allowed in the Silver layer.
    - **Gold Layer**: This layer is dedicated to **business transformations**, including data integration, aggregation, and the application of business logic and rules to build analytical data models (like the Star Schema). It **does not perform data cleansing**, as that is the unique task of the Silver layer.
3. **Benefits and Importance**:
By adhering to the Separation of Concerns, the data warehouse becomes more **organized, scalable, and easier to maintain**. It prevents chaos and inconsistencies that can arise when transformations and data handling responsibilities are mixed or duplicated across different parts of the system. A data architect who embraces this mindset is considered effective in their role.

### High Level Architecture

![Untitled design(1).png](attachment:1c59f44e-222d-48f0-9c6d-98efa4dc448f:Untitled_design(1).png)

### **Naming Conventions**

This document outlines the naming conventions used for schemas, tables, views, columns, and other objects in the data warehouse.

### **General Principles**

- Use `snake_case`, with lowercase letters and underscores (`_`) to separate words.
- Use English for all names.
- Do not use SQL reserved words as object names.

### **Table Naming Conventions**

### **Bronze Rules**

- Names must start with the source system name, table names must match original names.
- Format: **`<sourcesystem>_<entity>`**
    - `<sourcesystem>` → e.g., `crm`, `erp`
    - `<entity>` → exact source table name
    - Example: `crm_customer_info`

### **Silver Rules**

- Same as Bronze: keep source-aligned names.
- Format: **`<sourcesystem>_<entity>`**
    - Example: `erp_order_items`

### **Gold Rules**

- Use **business-aligned, meaningful names** with category prefixes.
- Format: **`<category>_<entity>`**
    - `<category>`: `dim`, `fact`, `report`
    - `<entity>`: Business term (customers, sales, products, etc.)
- Examples:
    - `dim_customers`
    - `fact_sales`

### **Glossary of Category Patterns**

| Pattern | Meaning | Example(s) |
| --- | --- | --- |
| `dim_` | Dimension table | `dim_customer`, `dim_product` |
| `fact_` | Fact table | `fact_sales` |
| `report_` | Report table | `report_customers`, `report_sales_monthly` |

## **Column Naming Conventions**

### **Surrogate Keys**

- Primary keys in dimension tables use suffix `_key`.
- Format: **`<table_name>_key`**
- Example: `customer_key` in `dim_customers`.

### **Technical Columns**

- Start with prefix `dwh_`.
- Format: **`dwh_<column_name>`**
- Example: `dwh_load_date` → record load date.

## **Stored Procedure Naming Conventions**

- Format: **`load_<layer>`**
    - `<layer>`: bronze, silver, gold.
- Examples:
    - `load_bronze`
    - `load_silver`
