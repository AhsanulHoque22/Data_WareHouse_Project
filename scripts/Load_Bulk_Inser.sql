USE DataWarehouse;

TRUNCATE TABLE crm_cust_info;
LOAD DATA INFILE '/home/ahsanul-hoque/Data_WareHouse_Project/data_sets/source_crm/cust_info.csv' 
INTO TABLE crm_cust_info 
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

TRUNCATE TABLE crm_prd_info;
LOAD DATA INFILE '/home/ahsanul-hoque/Data_WareHouse_Project/data_sets/source_crm/prd_info.csv' 
INTO TABLE crm_prd_info 
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

TRUNCATE TABLE crm_sales_details;
LOAD DATA INFILE '/home/ahsanul-hoque/Data_WareHouse_Project/data_sets/source_crm/sales_details.csv' 
INTO TABLE crm_sales_details 
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

TRUNCATE TABLE erp_CUST_AZ12;
LOAD DATA INFILE '/home/ahsanul-hoque/Data_WareHouse_Project/data_sets/source_crm/CUST_AZ12.csv' 
INTO TABLE erp_CUST_AZ12 
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

TRUNCATE TABLE erp_LOC_A101;
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/erp_LOC_A101.csv' 
INTO TABLE erp_LOC_A101 
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

TRUNCATE TABLE erp_px_cat_g1v2;
LOAD DATA INFILE '/home/ahsanul-hoque/Data_WareHouse_Project/data_sets/source_crm/erp_px_cat_g1v2.csv' 
INTO TABLE erp_px_cat_g1v2 
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;