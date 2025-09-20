USE DataWarehouse;

/*
=============================================
Add MataData Column To the tables
=============================================
These are columns added by data engineers that do not originate from the source data. Such As,
create_date: The record's load timestamp
update_date: The record's update timestamp
source_system: The origin system of the record
file_location: The file source of the record
*/

/*
SELECT * FROM crm_cust_info;
SELECT * FROM crm_prd_info;
SELECT * FROM crm_sales_details;
SELECT * FROM erp_CUST_AZ12;
SELECT * FROM erp_LOC_A101;
SELECT * FROM erp_px_cat_g1v2;
*/

ALTER TABLE crm_cust_info
ADD COLUMN cst_update_date   DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
ADD COLUMN source_system VARCHAR(50),
ADD COLUMN file_location VARCHAR(255);

ALTER TABLE crm_prd_info
ADD COLUMN prd_create_date   DATETIME DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN prd_update_date   DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
ADD COLUMN prd_source_system VARCHAR(50),
ADD COLUMN prd_file_location VARCHAR(255);

ALTER TABLE crm_sales_details
ADD COLUMN sls_create_date   DATETIME DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN sls_update_date   DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
ADD COLUMN sls_source_system VARCHAR(50),
ADD COLUMN sls_file_location VARCHAR(255);

ALTER TABLE erp_CUST_AZ12
ADD COLUMN create_date   DATETIME DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN update_date   DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
ADD COLUMN source_system VARCHAR(50),
ADD COLUMN file_location VARCHAR(255);

ALTER TABLE erp_LOC_A101
ADD COLUMN create_date   DATETIME DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN update_date   DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
ADD COLUMN source_system VARCHAR(50),
ADD COLUMN file_location VARCHAR(255);

ALTER TABLE erp_px_cat_g1v2
ADD COLUMN create_date   DATETIME DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN update_date   DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
ADD COLUMN source_system VARCHAR(50),
ADD COLUMN file_location VARCHAR(255);


/*
===================================
Populating the new columns
===================================
*/

UPDATE crm_cust_info
SET 
    source_system = 'CRM',
    file_location = '/var/lib/mysql-files/cust_info.csv'
WHERE source_system IS NULL;  -- only update rows that don’t have metadata yet

UPDATE crm_prd_info
SET 
    source_system = 'CRM',
    file_location = '/var/lib/mysql-files/prd_info.csv'
WHERE source_system IS NULL;

UPDATE crm_sales_details
SET 
    source_system = 'CRM',
    file_location = '/var/lib/mysql-files/sales_details.csv'
WHERE source_system IS NULL;

UPDATE erp_CUST_AZ12
SET 
    source_system = 'ERP',
    file_location = '/var/lib/mysql-files/CUST_AZ12.csv'
WHERE source_system IS NULL;

UPDATE erp_LOC_A101
SET 
    source_system = 'ERP',
    file_location = '/var/lib/mysql-files/LOC_A101.csv'
WHERE source_system IS NULL;

UPDATE erp_px_cat_g1v2
SET 
    source_system = 'ERP',
    file_location = '/var/lib/mysql-files/PX_CAT_G1V2.csv'
WHERE source_system IS NULL;


/*
=============================================
Saperating product key into two columns
=============================================
in the crm_prd_info table the prd_column holds two infromaton. First five characters are category id
and rest is the product key. We need to saperate the product key and category id into different columns
so we can later join the erp_pd_cat_g1v2 table (Category table) easily.
*/

ALTER TABLE cln_crm_prd_info
DROP COLUMN prd_key,
ADD COLUMN prd_key VARCHAR(50) AFTER prd_id,
ADD COLUMN cat_id VARCHAR(50) AFTER prd_id;

/*
===============================
Change the prd_start_dt and
prd_end_dt from DATETIME to
DATE type. and then insert in 
the clean table
===============================
*/
ALTER TABLE cln_crm_prd_info
MODIFY COLUMN prd_start_dt DATE,
MODIFY COLUMN prd_end_dt DATE;


/*
adding meta date to the clean tables
*/

ALTER TABLE cln_crm_cust_info 
ADD COLUMN dwh_last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

ALTER TABLE cln_crm_prd_info 
ADD COLUMN dwh_last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

ALTER TABLE cln_crm_sales_details 
ADD COLUMN dwh_last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

ALTER TABLE cln_erp_CUST_AZ12 
ADD COLUMN dwh_last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

ALTER TABLE cln_erp_LOC_A101 
ADD COLUMN dwh_last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

ALTER TABLE cln_erp_px_cat_g1v2 
ADD COLUMN dwh_last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

