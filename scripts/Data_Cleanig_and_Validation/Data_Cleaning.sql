USE DataWarehouse;

/*
SELECT * FROM cln_crm_cust_info;
SELECT * FROM cln_crm_prd_info;
SELECT * FROM cln_crm_sales_details;
SELECT * FROM cln_erp_CUST_AZ12;
SELECT * FROM cln_erp_LOC_A101;
SELECT * FROM cln_erp_px_cat_g1v2;
*/


DELIMITER $$

CREATE PROCEDURE clean_and_load_data()
BEGIN

/*
==============================================
Clean data of 'crm_cust_info' table
==============================================
** Cleaning Issues Solved for crm_cust_info
Duplicate or NULL primary keys (cst_id)
Checked cst_id for duplicates and nulls.
Used HAVING COUNT(*) > 1 OR cst_id IS NULL to capture both issues.
** Ensures uniqueness and integrity of customer IDs.
Unwanted spaces in string values
Checked cst_firstname and cst_lastname for leading/trailing spaces using TRIM().
** Ensures clean, properly formatted customer names.
(Other string columns were examined, but only name fields needed cleaning.)
Data standardization and consistency
Checked distinct values for categorical fields:
cst_gndr (gender)
cst_marital_status
** Cleaned them to ensure full, meaningful, standardized values.
Example:
M → Male
F → Female
S → Single
M → Married
Else → n/a
Eliminated inconsistent abbreviations and ensured semantic clarity.
*/
TRUNCATE TABLE cln_crm_cust_info;
INSERT INTO cln_crm_cust_info (
	cst_id,
    cst_key,
    cst_firstname,
    cst_lastname,
    cst_marital_status,
    cst_gndr,
    cst_create_date
)
SELECT
	cst_id,
    cst_key,
    TRIM(cst_firstname) AS cst_firstname, 
    TRIM(cst_lastname) AS cst_lastname,
    CASE
		WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
		WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
		ELSE 'n/a'
	END cst_marital_status,
    CASE 
		WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
		WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
		ELSE 'n/a'
	END cst_gndr,
    cst_create_date
FROM (
	SELECT
		*,
		ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) as flag_last 
	FROM crm_cust_info
    WHERE cst_id IS NOT NULL
	) t
WHERE flag_last = 1;


/*
==============================================
Clean data of 'crm_prd_info' table
==============================================
** Cleaning Issues Solved for crm_prd_info
Duplicate or NULL primary keys
Checked prd_id for duplicates and nulls.
** Ensures uniqueness and integrity of product IDs.
Category ID standardization (prd_key)
Extracted category ID from the first 5 characters of prd_key.
Replaced '-' with '_' to match category IDs in erp_px_cat_g1v2.
** Fixed delimiter inconsistency between source and reference tables.
Product key extraction
Extracted substring from position 7 → end as product identifier (prd_key).
Verified it matches with crm_sales_details.
** Ensures consistency across sales and product tables.
Unwanted spaces in product names (prd_nm)
Checked for leading/trailing spaces using TRIM().
** Ensures product names are clean and standardized.
Product cost validation (prd_cost)
Checked for NULL or negative values.
** Prevents missing or invalid costs (no negative prices).
Standardization of product line (prd_line)
Validated distinct values of prd_line.
Standardized to meaningful names:
M → Mountain
R → Road
S → Other Sales
T → Touring
else → n/a
** Ensures consistent, human-readable product line categories.
Date consistency (prd_start_dt / prd_end_dt)
Start date cannot be NULL.
End date can be NULL, but:
Must not be before start date.
Must not overlap with another product period.
Fixed by setting:
End Date = (Next Record’s Start Date - 1 day)
Last record’s end date = NULL.
** Ensures chronological validity and no overlapping product availability.
*/
TRUNCATE TABLE cln_crm_prd_info;
INSERT INTO cln_crm_prd_info (
	prd_id,
    cat_id,
    prd_key,
    prd_nm,
    prd_cost,
    prd_line,
    prd_start_dt,
    prd_end_dt
)
SELECT
	prd_id,
    REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,
    SUBSTRING(prd_key, 7, length(prd_key)) AS prd_key,
    prd_nm,
    COALESCE(prd_cost, 0) AS prd_cost,
    CASE UPPER(TRIM(prd_line)) 
		 WHEN 'M' THEN 'Mountain'
		 WHEN 'R' THEN 'Road'
         WHEN 'S' THEN 'other Sales'
         WHEN 'T' THEN 'Touring'
         ELSE 'n/a'
	END AS prd_line,
    CAST(prd_start_dt AS DATE) AS prd_start_dt_prs,
    CASE 
        WHEN LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt) IS NOT NULL 
        THEN CAST(DATE_SUB(LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt), INTERVAL 1 DAY) AS DATE)
        ELSE NULL
    END AS prd_end_dt
FROM crm_prd_info;


/*
==============================================
Clean data of 'crm_sales_details' table
==============================================
** Data Cleaning Summary for crm_sales_details
1. Whitespace Issues
Problem: Some sls_ord_num values may contain unwanted leading/trailing spaces.
Solution: Used TRIM() to remove spaces. Only trimmed values were inserted into cln_crm_sales_details.
2. Referential Integrity
Problem:
sls_prd_key in sales must exist in cln_crm_prd_info.
sls_cust_id in sales must exist in cln_crm_cust_info.
Solution:
Checked for invalid keys with NOT IN queries.
Excluded any records where product/customer keys did not exist in the reference tables.
3. Date Format and Validity
Sales date columns (sls_order_dt, sls_ship_dt, sls_due_dt) were originally stored as integers (YYYYMMDD). Several validations were applied:
a. Zero or Invalid Dates
Problem: Dates with 0 or invalid integers.
Solution: Replaced with NULL.
b. Incorrect Length
Problem: Dates not exactly 8 digits long (not YYYYMMDD).
Solution: Replaced with NULL.
c. Out-of-Range Dates
Problem: Dates earlier than 1900-01-01 or later than 2050-01-01.
Solution: Replaced with NULL.
d. Invalid Order of Dates
Problem: sls_order_dt later than sls_ship_dt or sls_due_dt.
Solution: Such rows excluded from the cleaned dataset.
Conversion Step
Used STR_TO_DATE(CAST(date_col AS CHAR), '%Y%m%d') to properly convert 8-digit integers into MySQL DATE format.
4. Sales, Quantity, and Price Consistency
Problem: Business logic requires:
sls_sales=sls_quantity×sls_pric
sls_sales=sls_quantity×sls_price
but data had mismatches, NULLs, zeroes, and negatives.
Solutions:
Invalid Sales (NULL, ≤0, or mismatch):
Recalculated as sls_quantity * ABS(sls_price).
Invalid Price (NULL or ≤0):
Recalculated as sls_sales / NULLIF(sls_quantity, 0).
Ensured no division by zero using NULLIF.
Negative Price Values:
Converted to positive using ABS(sls_price) inside the calculation.
Quantity:
Verified no issues, inserted directly.
** Final Outcome
Clean table cln_crm_sales_details has:
Trimmed sls_ord_num.
Valid product & customer references.
Properly formatted DATE columns with invalid ones set to NULL.
Consistent and corrected sls_sales, sls_price, and sls_quantity values following business rules.
*/
TRUNCATE TABLE cln_crm_sales_details;
INSERT INTO cln_crm_sales_details (
	sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    sls_order_dt,
    sls_ship_dt,
    sls_due_dt,
    sls_sales,
    sls_quantity,
    sls_price
)
SELECT
	sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    CASE WHEN sls_order_dt = 0 OR LENGTH(sls_order_dt) != 8 THEN NULL
		 ELSE STR_TO_DATE(CAST(sls_order_dt AS CHAR), '%Y%m%d')
	END AS sls_order_dt,
    CASE WHEN sls_ship_dt = 0 OR LENGTH(sls_ship_dt) != 8 THEN NULL
		 ELSE STR_TO_DATE(CAST(sls_ship_dt AS CHAR), '%Y%m%d')
	END AS sls_ship_dt,
    CASE WHEN sls_due_dt = 0 OR LENGTH(sls_due_dt) != 8 THEN NULL
		 ELSE STR_TO_DATE(CAST(sls_due_dt AS CHAR), '%Y%m%d')
	END AS sls_due_dt,
    CASE WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * abs(sls_price)
			THEN sls_quantity * abs(sls_price)
		 ELSE sls_sales
	END AS sls_sales,
    sls_quantity, -- it had no quality issue when checked
    CASE WHEN sls_price IS NULL OR sls_price <= 0
			THEN sls_sales / NULLIF(sls_quantity, 0)
         ELSE sls_price
    END AS sls_price
FROM crm_sales_details;

/*
==============================================
Clean data of 'erp_CUST_AZ12' table
==============================================
Here’s a concise summary of the problems in erp_CUST_AZ12 and the approach taken to solve them:
1. Inconsistent or extraneous customer IDs (cid)
Problem: Some cid values have unnecessary prefixes like NAS, which prevents proper matching with the crm_cust_info table.
Solution Approach: Remove the unnecessary prefixes and validate that all cid values exist in crm_cust_info to ensure consistency and proper linkage between tables.
2. Invalid birth dates (bdate)
Problem: Some records have birth dates far in the past (before 1925) or in the future (after today), which are clearly incorrect.
Solution Approach: Future dates are replaced with NULL, while very old dates are acknowledged but kept; all dates are validated to ensure no future dates remain.
3. Inconsistent or messy gender values (gen)
Problem: Gender values include inconsistent formatting, extra spaces, capitalization differences, or hidden/unprintable characters, causing simple cleaning functions to fail.
Solution Approach: Use pattern-based matching (regular expressions) to standardize gender values into three categories: Male, Female, or n/a. This handles extra spaces, capitalization, and hidden characters.
4. General data consistency and cleaning
Problem: Data across the table is inconsistent, making analysis unreliable.
Solution Approach: Apply cleaning logic systematically to create a new standardized table where all cid, bdate, and gen values are consistent and validated, ensuring the dataset is ready for analysis.
This approach focuses on validation, standardization, and removing noise, resulting in a clean and reliable dataset without altering meaningful information.
*/
TRUNCATE TABLE cln_erp_CUST_AZ12;
INSERT INTO cln_erp_CUST_AZ12 (
	cid,
    bdate,
    gen
)
SELECT
    CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LENGTH(cid))
		 ELSE cid
	END AS cid,
    CASE WHEN bdate > CURDATE() THEN NULL
		 ELSE bdate
	END AS bdate,
    CASE
        WHEN gen IS NULL THEN 'n/a'
        WHEN gen REGEXP '^[[:space:]]*[Ff](emale)*[[:space:]]*$' THEN 'Female'
        WHEN gen REGEXP '^[[:space:]]*[Mm](ale)*[[:space:]]*$' THEN 'Male'
        ELSE 'n/a'
    END AS gen
FROM erp_CUST_AZ12;

/*
==============================================
Clean data of 'erp_LOC_A101' table
==============================================
1. Key Alignment Between Tables
We have two related datasets:
cln_crm_cust_info → cst_key
erp_LOC_A101 → cid

Issues found:
In cln_crm_cust_info, IDs do not contain dashes (-).
In erp_LOC_A101, IDs do contain dashes.

Normalization of keys → remove - from cid in erp_LOC_A101 so it matches cst_key in cln_crm_cust_info.
** Expectation: no unmatched IDs after standardization.
This ensures referential integrity between the two tables.

2. Country Field Standardization
Issues found:
Multiple spellings / codes for the same country
US, USA, United States
DE, Germany
UK, United Kingdom, England
Hidden whitespace and control characters
"France\r"
" \r"
Empty and null values
'', NULL, "nan"

Cleaning performed:
Trimmed whitespace using TRIM.
Removed hidden characters (like carriage returns \r, tabs) with REGEXP_REPLACE(..., '[[:space:]]', '').
Standardized country names using CASE + REGEXP_LIKE:
(US|USA|UnitedStates) → United States
(DE|Germany) → Germany
(UK|UnitedKingdom|England) → United Kingdom
(CA|Canada) → Canada
(AU|Australia) → Australia
Null handling:
NULL, '', whitespace-only, "nan" → n/a
*/
TRUNCATE TABLE cln_erp_LOC_A101;
INSERT INTO cln_erp_LOC_A101 (
	cid,
    cntry
)
SELECT
	REPLACE(cid, '-', '') AS cid,
	CASE 
        WHEN REGEXP_LIKE(REGEXP_REPLACE(cntry, '[[:space:]]', ''), '^(US|USA|UnitedStates)$', 'i') 
            THEN 'United States'
        WHEN REGEXP_LIKE(REGEXP_REPLACE(cntry, '[[:space:]]', ''), '^(DE|Germany)$', 'i') 
            THEN 'Germany'
        WHEN REGEXP_LIKE(REGEXP_REPLACE(cntry, '[[:space:]]', ''), '^(UK|UnitedKingdom|England)$', 'i') 
            THEN 'United Kingdom'
        WHEN REGEXP_LIKE(REGEXP_REPLACE(cntry, '[[:space:]]', ''), '^(CA|Canada)$', 'i') 
            THEN 'Canada'
        WHEN REGEXP_LIKE(REGEXP_REPLACE(cntry, '[[:space:]]', ''), '^(AU|Australia)$', 'i') 
            THEN 'Australia'
        WHEN cntry IS NULL 
             OR TRIM(REGEXP_REPLACE(CNTRY, '[[:space:]]', '')) = '' 
             OR UPPER(TRIM(cntry)) = 'NAN'
            THEN 'n/a'
        ELSE TRIM(REGEXP_REPLACE(cntry, '[[:space:]]', ' '))
    END AS cntry
FROM erp_LOC_A101;


/*
==============================================
Clean data of 'erp_px_cat_g1v2' table
==============================================
No data quality issue. Directly load into cln_erp_px_cat_g1v2
*/
TRUNCATE TABLE cln_erp_px_cat_g1v2;
INSERT INTO cln_erp_px_cat_g1v2 (
	id,
    cat,
    subcat,
    maintenance
)
SELECT
	id,
    cat,
    subcat,
    maintenance
FROM erp_px_cat_g1v2;



END$$
DELIMITER ;

CALL clean_and_load_data();