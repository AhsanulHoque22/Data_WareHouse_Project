/*
WARNING: CSV File Access and LOAD DATA INFILE Restrictions

1. MySQL Secure File Privilege:
   - MySQL server may restrict file access using the `--secure-file-priv` option.
   - Any LOAD DATA INFILE statement attempting to read CSVs from paths outside the designated directory will fail.
   - Errors encountered:
       - "Error Code: 1290. The MySQL server is running with the --secure-file-priv option"
       - "Error Code: 2068. LOAD DATA LOCAL INFILE file request rejected due to restrictions on access"

2. File Permissions:
   - Even if files are in the secure directory, incorrect ownership or permissions can prevent MySQL from reading them.
   - Errors encountered:
       - "Permission denied" when trying to access `/var/lib/mysql-files/` (run "SHOW VARIABLES LIKE 'secure_file_priv';" to get the path)

3. Solution Implemented:
   - Copy all CSV files into MySQL's secure `mysql-files` directory (usually `/var/lib/mysql-files/`).
       Example:
           sudo cp /home/user/project/data_sets/*.csv /var/lib/mysql-files/
   - Change ownership to `mysql:mysql`:
           sudo chown mysql:mysql /var/lib/mysql-files/*.csv
   - Set proper read permissions:
           sudo chmod 644 /var/lib/mysql-files/*.csv
   - Use absolute paths in LOAD DATA INFILE pointing to `/var/lib/mysql-files/`.
   - Use `LOCAL` only if the server allows, but prefer server-side files in the secure directory.

4. General Recommendation:
   - Do NOT attempt to bypass secure-file-priv by changing server settings unless necessary.
   - Always ensure CSV files are placed in the secure directory with correct permissions.
   - This approach ensures safe, direct loading of CSVs using LOAD DATA INFILE without modifying MySQL server security configurations.

*/

USE DataWarehouse;

/*
SELECT * FROM crm_cust_info;
SELECT * FROM crm_prd_info;
SELECT * FROM crm_sales_details;
SELECT * FROM erp_CUST_AZ12;
SELECT * FROM erp_LOC_A101;
SELECT * FROM erp_px_cat_g1v2;
*/

DELIMITER $$

-- Procedure only handles truncation and logging
CREATE PROCEDURE bronze_truncate()
BEGIN
    DECLARE start_time DATETIME;
    DECLARE end_time DATETIME;

    -- Error handler
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SELECT 'ERROR: Truncation failed for bronze layer';
    END;

    SET start_time = NOW();
    SELECT 'Starting Bronze Layer Truncation';

    -- Truncate all tables
    TRUNCATE TABLE crm_cust_info;
    SELECT 'Truncated crm_cust_info';

    TRUNCATE TABLE crm_prd_info;
    SELECT 'Truncated crm_prd_info';

    TRUNCATE TABLE crm_sales_details;
    SELECT 'Truncated crm_sales_details';

    TRUNCATE TABLE erp_CUST_AZ12;
    SELECT 'Truncated erp_CUST_AZ12';

    TRUNCATE TABLE erp_LOC_A101;
    SELECT 'Truncated erp_LOC_A101';

    TRUNCATE TABLE erp_px_cat_g1v2;
    SELECT 'Truncated erp_px_cat_g1v2';

    SET end_time = NOW();
    SELECT CONCAT('Total truncation duration: ', TIMESTAMPDIFF(SECOND, start_time, end_time), ' seconds');
END$$

DELIMITER ;

-- ==================================
-- Step 1: Call truncation procedure
-- ==================================
CALL bronze_truncate();

-- ===============================================
-- Step 2: Run LOAD DATA INFILE outside procedure
-- ===============================================

-- CRM Source Tables
/*
WARNING: Data Loading Considerations for Bronze Layer CSVs

1. Empty Numeric Fields:
   - Some CSV columns representing integers or decimals may contain empty strings ('') or spaces (' ').
   - Direct insertion into INT, BIGINT, or DECIMAL columns will cause "Incorrect integer value" errors.
   - Solution: Use user variables and conditional logic (IF(TRIM(@var) = '', NULL, @var)) to safely convert empty or space-only values to NULL.

2. Empty or Malformed Dates:
   - Date columns may contain empty strings, spaces, or invalid date formats.
   - Direct insertion or applying STR_TO_DATE() on such values causes "Incorrect date/datetime value" errors.
   - Solution: Store the CSV value in a user variable, trim spaces, check for empty or invalid format (using REGEXP), and convert to NULL if invalid. Only apply STR_TO_DATE() on valid values.

3. Missing Columns / Incomplete Rows:
   - Some CSV rows may not contain data for all table columns.
   - Solution: Explicitly list the columns present in the CSV to prevent mismatch errors during LOAD DATA INFILE.

4. Permissions and Server Settings:
   - MySQL secure-file-priv or LOCAL INFILE restrictions may prevent loading files from arbitrary paths.
   - Solution: Use the designated mysql-files directory with correct file ownership (mysql:mysql) and permissions (644).

5. General Recommendation:
   - Do NOT attempt to modify the CSVs directly if they are source files.
   - Always handle invalid, missing, or malformed data in the LOAD DATA INFILE statement using user variables, TRIM, IF, and STR_TO_DATE as demonstrated.

Failure to follow these precautions can result in load failures, data inconsistencies, or runtime errors.

*/
LOAD DATA INFILE '/var/lib/mysql-files/cust_info.csv'
INTO TABLE crm_cust_info
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@cst_id, @cst_key, @cst_firstname, @cst_lastname, @cst_marital_status, @cst_gndr, @cst_create_date)
SET
    cst_id = IF(TRIM(@cst_id) = '' OR @cst_id REGEXP '^[^0-9]+$', NULL, @cst_id),
    cst_key = IF(TRIM(@cst_key) = '', NULL, @cst_key),
    cst_firstname = IF(TRIM(@cst_firstname) = '', NULL, @cst_firstname),
    cst_lastname = IF(TRIM(@cst_lastname) = '', NULL, @cst_lastname),
    cst_marital_status = IF(TRIM(@cst_marital_status) = '', NULL, @cst_marital_status),
    cst_gndr = IF(TRIM(@cst_gndr) = '', NULL, @cst_gndr),
    cst_create_date = IF(
        TRIM(@cst_create_date) = '' 
        OR @cst_create_date NOT REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$', 
        NULL, 
        STR_TO_DATE(@cst_create_date, '%Y-%m-%d')
    );


LOAD DATA INFILE '/var/lib/mysql-files/prd_info.csv'
INTO TABLE crm_prd_info
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@prd_id, @prd_key, @prd_nm, @prd_cost, @prd_line, @prd_start_dt, @prd_end_dt)
SET
    prd_id = IF(TRIM(@prd_id) = '', NULL, @prd_id),
    prd_key = IF(TRIM(@prd_key) = '', NULL, @prd_key),
    prd_nm = IF(TRIM(@prd_nm) = '', NULL, @prd_nm),
    prd_cost = IF(TRIM(@prd_cost) = '', NULL, @prd_cost),
    prd_line = IF(TRIM(@prd_line) = '', NULL, @prd_line),
    prd_start_dt = IF(TRIM(@prd_start_dt) = '' 
                      OR @prd_start_dt NOT REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}([ ]+[0-9]{2}:[0-9]{2}:[0-9]{2})?$', 
                      NULL, 
                      STR_TO_DATE(@prd_start_dt, '%Y-%m-%d %H:%i:%s')),
    prd_end_dt = IF(TRIM(@prd_end_dt) = '' 
                    OR @prd_end_dt NOT REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}([ ]+[0-9]{2}:[0-9]{2}:[0-9]{2})?$', 
                    NULL, 
                    STR_TO_DATE(@prd_end_dt, '%Y-%m-%d %H:%i:%s'));



/*
WARNING: Data Loading Issues and Solutions for Numeric Columns in CSVs

1. Empty or Space-Only Numeric Fields:
   - Some CSV columns representing integers (e.g., sls_price, sls_quantity, sls_cust_id) may contain empty strings ('') or spaces (' ').
   - Direct insertion into INT columns will cause errors:
       - 1366 Incorrect integer value
       - 1292 Truncated incorrect INTEGER value
   - Cause: MySQL cannot convert empty or non-numeric strings to INT.

2. Hidden or Non-Printable Characters:
   - CSVs may contain hidden characters (tabs, non-breaking spaces) that prevent direct conversion to numeric types.
   - These will also cause truncation or conversion errors.

3. Solution:
   - Use user variables to temporarily store CSV values during LOAD DATA INFILE.
   - Apply TRIM() to remove spaces.
   - Validate the variable using REGEXP to ensure it contains only digits.
   - Convert invalid, empty, or non-numeric values to NULL before inserting into table columns.
   - Example pattern for integers:
         sls_price = IF(TRIM(@sls_price) REGEXP '^[0-9]+$', @sls_price, NULL);

4. General Recommendation:
   - Do NOT modify original CSV files.
   - Always handle invalid, empty, or malformed numeric values in the LOAD DATA INFILE statement using user variables, TRIM, REGEXP, and conditional NULL assignment.
   - This approach prevents load failures and ensures data integrity in the target table.

*/

LOAD DATA INFILE '/var/lib/mysql-files/sales_details.csv'
INTO TABLE crm_sales_details
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@sls_ord_num, @sls_prd_key, @sls_cust_id, @sls_order_dt, @sls_ship_dt, @sls_due_dt, @sls_sales, @sls_quantity, @sls_price)
SET
    sls_ord_num = NULLIF(TRIM(@sls_ord_num), ''),
    sls_prd_key = NULLIF(TRIM(@sls_prd_key), ''),
    sls_cust_id = IF(TRIM(@sls_cust_id) REGEXP '^[0-9]+$', @sls_cust_id, NULL),
    sls_order_dt = IF(TRIM(@sls_order_dt) REGEXP '^[0-9]+$', @sls_order_dt, NULL),
    sls_ship_dt = IF(TRIM(@sls_ship_dt) REGEXP '^[0-9]+$', @sls_ship_dt, NULL),
    sls_due_dt = IF(TRIM(@sls_due_dt) REGEXP '^[0-9]+$', @sls_due_dt, NULL),
    sls_sales = IF(TRIM(@sls_sales) REGEXP '^[0-9]+$', @sls_sales, NULL),
    sls_quantity = IF(TRIM(@sls_quantity) REGEXP '^[0-9]+$', @sls_quantity, NULL),
    sls_price = IF(TRIM(@sls_price) REGEXP '^[0-9]+$', @sls_price, NULL);


-- ERP Tables
/*
WARNING: Data Loading Issues and Solutions for Missing or Incomplete Columns in CSVs

1. Missing Columns / Incomplete Rows:
   - Some CSV rows may not contain values for all columns defined in the table (e.g., cid, bdate, gen).
   - Direct insertion using LOAD DATA INFILE without handling this will result in:
       - Error 1261: Row ... doesn't contain data for all columns
   - Cause: MySQL expects each row in the CSV to provide a value for every column you are loading.

2. Empty or Space-Only Fields:
   - Even if a column exists, it may contain empty strings ('') or spaces (' '), which may cause errors for numeric or date columns.

3. Solution:
   - Use user variables to temporarily hold CSV values during LOAD DATA INFILE.
   - Apply TRIM() to remove spaces and NULLIF() to convert empty strings to NULL.
   - For date columns, validate format using REGEXP before applying STR_TO_DATE().
   - Example for date column:
         bdate = IF(TRIM(@bdate) = '' OR @bdate NOT REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$', NULL, STR_TO_DATE(TRIM(@bdate), '%Y-%m-%d'))

4. General Recommendation:
   - Do NOT modify original CSV files.
   - Always handle missing columns, empty, or malformed values using user variables, TRIM, REGEXP, NULLIF, and conditional assignment.
   - This ensures safe loading and prevents runtime errors while maintaining data integrity.

*/

LOAD DATA INFILE '/var/lib/mysql-files/CUST_AZ12.csv'
INTO TABLE erp_CUST_AZ12
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@cid, @bdate, @gen)
SET
    cid = NULLIF(TRIM(@cid), ''),
    gen = NULLIF(TRIM(@gen), ''),
    bdate = IF(
        TRIM(@bdate) = '' OR @bdate NOT REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$',
        NULL,
        STR_TO_DATE(TRIM(@bdate), '%Y-%m-%d')
    );


LOAD DATA INFILE '/var/lib/mysql-files/LOC_A101.csv' 
INTO TABLE erp_LOC_A101 
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE '/var/lib/mysql-files/PX_CAT_G1V2.csv' 
INTO TABLE erp_px_cat_g1v2 
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Optional: Print completion message
SELECT 'Bronze layer loading completed successfully';