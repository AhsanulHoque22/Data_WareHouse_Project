USE DataWarehouse;
/*
SELECT * FROM cln_crm_cust_info;
SELECT * FROM cln_crm_prd_info;
SELECT * FROM cln_crm_sales_details;
SELECT * FROM cln_erp_CUST_AZ12;
SELECT * FROM cln_erp_LOC_A101;
SELECT * FROM cln_erp_px_cat_g1v2;
*/


/*
==============================================
Cleaning data of 'crm_cust_info' table
==============================================
*/

-- 1. Check For Null or Duplicates in Primary Key
SELECT 
    cst_id,
    COUNT(*)
FROM crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL; -- if there is only one null then it won't show in the result so we add "OR cst_id IS NULL"

-- Expectation: No Result
SELECT 
    cst_id,
    COUNT(*)
FROM cln_crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;




-- 2. Check For Unwanted Spaces in String Values
DESCRIBE crm_cust_info; -- look for string type columns
-- then check th uality of each of the string type coulumns and remove the check for the columns that already have expected result

SELECT cst_firstname
FROM crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname);

SELECT cst_lastname
FROM crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname);

-- Expectation: No Result
SELECT cst_firstname
FROM cln_crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname);

SELECT cst_lastname
FROM cln_crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname);



-- 3. Data Standardization & Consitency
SELECT DISTINCT cst_gndr
FROM crm_cust_info;

SELECT DISTINCT cst_marital_status
FROM crm_cust_info;

-- Exectation: Clean and Meaningful Value
SELECT DISTINCT cst_gndr
FROM cln_crm_cust_info;

SELECT DISTINCT cst_marital_status
FROM cln_crm_cust_info;


/*
==============================================
Cleaning data of 'crm_prd_info' table
==============================================
*/

-- 1. Checking nulls and duplicates
SELECT
	prd_id,
	COUNT(*)
FROM crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;

-- Expectation: No Results
SELECT
	prd_id,
	COUNT(*)
FROM cln_crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;

-- 2. Extracting two new columns from prd_key
-- i.
-- frist 5 characters of the string is the category_id. So we use SUBSTRING() function to extract and make a new column
-- frist check te categories from the source.
 SELECT DISTINCT id
 FROM erp_px_cat_g1v2;
-- Here we can see that the category id uses '_' as delimiter but in the prd_info table '-' is used. So we have to replace hifen with an underscore

-- ii.
-- second extracted column is product information
-- from 7th to the last character is the key to identify individual product
-- frst check the sls_prd_key from sales_details table
SELECT DISTINCT sls_prd_key
FROM crm_sales_details;
-- Here we can se '-' is used as delimiters in both the tables. so we don't need to trunsform it anymore. Just extracting would be enough
 
-- 3. Checking for unwanted spaces in the product name column
 SELECT prd_nm
 FROM crm_prd_info
 WHERE prd_nm != TRIM(prd_nm);
 
-- Expectation: No Results
 SELECT prd_nm
 FROM cln_crm_prd_info
 WHERE prd_nm != TRIM(prd_nm);
 
-- 4. Checking for Nulls or Negative numbers in the product costs column
SELECT prd_cost
FROM crm_prd_info
WHERE prd_cost IS NULL or prd_cost < 0;
 
-- Expectation: No Result
SELECT prd_cost
FROM cln_crm_prd_info
WHERE prd_cost IS NULL or prd_cost < 0 ;

-- 5. Data Standardization And Consistency
SELECT DISTINCT prd_line
FROM crm_prd_info;
-- Expectations: Full or consistant meanningful names

-- 6. Check for Invalid Date Orders
SELECT DISTINCT prd_key
FROM crm_prd_info
WHERE prd_end_dt < prd_start_dt;

-- start date cannot be null
-- end date can be null
-- product dates cannto be overlapping

-- solution: End Date of Current Record = Start date of the Next Record - 1 day
-- end date of the last record can be null

-- also we need just the date not time so we cast start date and end date to date instead of datetime

-- Expectation: No Result
SELECT DISTINCT prd_key
FROM cln_crm_prd_info
WHERE prd_end_dt < prd_start_dt;


/*
==============================================
Cleaning data of 'crm_sales_details' table
==============================================
*/

-- 1. Checking for unwanted spaces in the order number column
 SELECT sls_ord_num
 FROM crm_sales_details
 WHERE sls_ord_num != TRIM(sls_ord_num);
 
-- Expectation: No Results
 SELECT sls_ord_num
 FROM cln_crm_sales_details
 WHERE prd_nm != TRIM(prd_nm);
 
 
 -- 2. Cehck if the data in different tables are consistant
 
 -- i.
 -- Records in the sales table sls_prd_key has to in the prodct table prd_key. Otherwise we won't be able to join them
 SELECT sls_prd_key
 FROM crm_sales_details
 WHERE sls_prd_key NOT IN (SELECT prd_key FROM cln_crm_prd_info);
 
 -- Expectation: No Results
  SELECT sls_prd_key
 FROM cln_crm_sales_details
 WHERE sls_prd_key NOT IN (SELECT prd_key FROM cln_crm_prd_info);
 
  -- ii.
 -- Records in the sales table sls_cust_id has to in the prodct table cst_id. Otherwise we won't be able to join them
 SELECT sls_cust_id
 FROM crm_sales_details
 WHERE sls_cust_id NOT IN (SELECT cst_id FROM cln_crm_cust_info);
 
 -- Expectation: No Results
  SELECT sls_cust_id
 FROM cln_crm_sales_details
 WHERE sls_cust_id NOT IN (SELECT cst_id FROM cln_crm_cust_info);
 
 
-- Check For Invalid Date
-- Here date is in integer format. First 4 numbers of that integer represents the year, the following 2 numbers
-- represent the moth and the last 2 numbers represent the date and total it's 8 character
-- So we have to chage the type from an integer to date tupe and handle invalid date.

-- i. Check Zeroes. Zeros should be replaced with nulls.
SELECT sls_order_dt
FROM crm_sales_details
WHERE sls_order_dt <= 0;

-- Expectation: No Result
SELECT sls_order_dt
FROM cln_crm_sales_details
WHERE sls_order_dt <= 0;

-- ii. Length of the date columns must be 8. If not we cannot turn them into date format in not length = 8 exactly.
SELECT sls_order_dt
FROM crm_sales_details
WHERE LENGTH(sls_order_dt) != 8;
 
-- Expectation: No Result
SELECT sls_order_dt
FROM cln_crm_sales_details
WHERE LENGTH(sls_order_dt) != 8;

-- iii. Check for outliers by validating the bounderies of the date range
SELECT sls_order_dt
FROM crm_sales_details
WHERE sls_order_dt > 20500101 OR sls_order_dt < 19000101;

-- Expectation: No Result 
SELECT sls_order_dt
FROM cln_crm_sales_details
WHERE sls_order_dt > 20500101 OR sls_order_dt < 19000101;

-- do exactly the same for the rest of the date columns like sls_ship_dt and sls_due_dt

-- iv. Check for Invalid Date order
-- Oder date must always be earlier than the shipping date or due date
SELECT
*
FROM crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt;

-- Expectation: No Result 
SELECT
*
FROM cln_crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt;


-- 3. Business Logic and Data Consistency
-- Sum(sales) = quantity * price
-- negative, zeros or nulls not allowed in any record of sales, quantity and price
SELECT DISTINCT
	sls_sales,
    sls_quantity,
    sls_price
FROM crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price;

-- Rules to solve this issues
-- i. If sales is negative , zero or null, derive it using quantity and price
-- ii. If price is zero or null, calcualte it using Sales and Quantity
-- iii. If price is negative, convert it to positive value

-- Expectation: No Result
SELECT DISTINCT
	sls_sales,
    sls_quantity,
    sls_price
FROM cln_crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price;

/*
==============================================
Cleaning data of 'erp_CUST_AZ12' table
==============================================
*/

-- 1. Check if we can connect the table with other tables using customer id or cid
-- we can compare cust_info tables cst_key records with cust_az12 cid
SELECT * FROM crm_cust_info;

-- take one example record of cst_key 'AW00011000' from crm_cust_info. Then match with erp_cust_az12 cid
SELECT
	cid,
    bdate,
    gen
FROM erp_CUST_AZ12
WHERE cid LIKE '%AW00011000%';

-- we can see in the record NAS is unnecessary data as it has no significance so we will remove it.
-- After that validate the modified data if there is any cid erp_CUST_AZ12 in that is not in crm_cust_info cst_key
-- Expectation: No Result
SELECT
	cid
FROM cln_erp_CUST_AZ12
WHERE cid NOT IN (SELECT DISTINCT cst_key FROM crm_cust_info);

-- 2. Check for very old customers and check for future birthdays (these should be removed). We cannot do anything much about the old customers
SELECT DISTINCT
	bdate
FROM erp_CUST_AZ12
WHERE bdate < '1925-01-01' OR bdate > CURDATE();

-- Expectation: No Result
SELECT DISTINCT
	bdate
FROM cln_erp_CUST_AZ12
WHERE bdate > CURDATE();


-- 3. Data Standardization and Consistency
-- It's all over the place. Set all to Male, Female or n/a
/*
The initial problem was that your code was setting all values to 'n/a' because of hidden, 
non-standard characters in your data. The TRIM and REPLACE functions in MySQL only remove standard space characters ( ) 
and other common whitespace. The data you were working with likely had different types of non-printable or zero-width characters that those functions couldn't
identify or remove, causing the CASE statement to fail.

The final query worked because it used a regular expression (REGEXP) to perform a more flexible and powerful pattern match.
Instead of looking for an exact string, it looked for a pattern that allowed for a wide variety of "noise" or hidden 
characters around the desired 'F' or 'M'.

WHEN gen REGEXP '^[[:space:]]*[Ff](emale)*[[:space:]]*$' THEN 'Female'
WHEN gen REGEXP '^[[:space:]]*[Mm](ale)*[[:space:]]*$' THEN 'Male'
*/

SELECT DISTINCT
    gen
FROM erp_CUST_AZ12;

-- Expectation: only Male, Female or n/a
SELECT DISTINCT
    gen
FROM cln_erp_CUST_AZ12;

/*
==============================================
Cleaning data of 'erp_LOC_A101' table
==============================================
*/

-- 1. Just like before cst_key in crm_cust_info has to match erp_LOC_A101
SELECT cst_key FROM cln_crm_cust_info;
-- here the records have no '-' in them. But erp_LOC_A101 has '-' so we have to remove it
SELECT cid
FROM erp_LOC_A101;
-- checking if the data matches
SELECT cid
FROM erp_LOC_A101
WHERE cid NOT IN (SELECT cst_key FROM cln_crm_cust_info);

-- should match the id/key in both table
-- Expectation: No Result
SELECT cid
FROM cln_erp_LOC_A101
WHERE cid NOT IN (SELECT cst_key FROM cln_crm_cust_info);

-- 2. Data stnadardization and consistency
-- we have a lot of empty space. different versions of the same country
-- clean this up

SELECT DISTINCT
	cntry
FROM erp_LOC_A101;

/*

## 1. Initial Data Quality Issues

When you first queried distinct values from `erp_LOC_A101`, the `CNTRY` column had messy entries.

We found issues such as:

Multiple representations of the same country

  * `US`, `USA`, `United States`
  * `DE`, `Germany`
  * `UK`, `United Kingdom`, `England`

Trailing/leading hidden spaces or control characters

  * `"France\r"` → contains carriage return `\r`
  * `" \r"` → looks like empty, but is not really empty

Empty strings and nulls

  * `''` (blank string)
  * `NULL` values
  * `"nan"` (text literal, not actual NULL)

Inconsistent casing

  * `us`, `USA`, `United States` → different capitalization

---

## 2. First Attempt

```sql
CASE 
  WHEN TRIM(CNTRY) = 'DE' THEN 'Germany'
  WHEN TRIM(CNTRY) IN ('US','USA') THEN 'United States'
  WHEN TRIM(CNTRY) = '' OR CNTRY IS NULL THEN 'n/a'
  ELSE TRIM(CNTRY)
END
```

This solved **simple spacing** and **null vs. blank string**, but did **not** handle:

* `"France\r"` (hidden carriage return)
* `" \r"` (looks empty but not detected)
* `"nan"` (string literal)
* Multiple variations of the same name systematically

---

## 3. Enhanced Cleaning

We added **regular expressions** and **whitespace removal**:

```sql
REGEXP_REPLACE(CNTRY, '[[:space:]]', '')
```

This:

Removes hidden characters (`\r`, `\n`, tabs, extra spaces).
Ensures `"France\r"` becomes `France`, `" \r"` becomes `''`.

We also expanded mappings using `REGEXP_LIKE`:

* `(US|USA|UnitedStates)` → **United States**
* `(DE|Germany)` → **Germany**
* `(UK|UnitedKingdom|England)` → **United Kingdom**
* `(CA|Canada)` → **Canada**
* `(AU|Australia)` → **Australia**

Finally, we unified null handling:

* If value is `NULL`, `''`, `"nan"`, or only whitespace → **n/a**

---

## 4. Final Query

```sql
SELECT DISTINCT
    CASE 
        WHEN REGEXP_LIKE(REGEXP_REPLACE(CNTRY, '[[:space:]]', ''), '^(US|USA|UnitedStates)$', 'i') 
            THEN 'United States'
        WHEN REGEXP_LIKE(REGEXP_REPLACE(CNTRY, '[[:space:]]', ''), '^(DE|Germany)$', 'i') 
            THEN 'Germany'
        WHEN REGEXP_LIKE(REGEXP_REPLACE(CNTRY, '[[:space:]]', ''), '^(UK|UnitedKingdom|England)$', 'i') 
            THEN 'United Kingdom'
        WHEN REGEXP_LIKE(REGEXP_REPLACE(CNTRY, '[[:space:]]', ''), '^(CA|Canada)$', 'i') 
            THEN 'Canada'
        WHEN REGEXP_LIKE(REGEXP_REPLACE(CNTRY, '[[:space:]]', ''), '^(AU|Australia)$', 'i') 
            THEN 'Australia'
        WHEN CNTRY IS NULL 
             OR TRIM(REGEXP_REPLACE(CNTRY, '[[:space:]]', '')) = '' 
             OR UPPER(TRIM(CNTRY)) = 'NAN'
            THEN 'n/a'
        ELSE TRIM(REGEXP_REPLACE(CNTRY, '[[:space:]]', ' '))
    END AS CNTRY
FROM erp_LOC_A101;
```

---

## 5. Result After Cleaning

Now you get a clean and consistent country list:

```
Australia
Canada
France
Germany
United Kingdom
United States
n/a
```

---

✅ All data quality issues solved:

* **Duplicates merged** → different codes/names unified.
* **Whitespace & hidden characters removed**.
* **Nulls, blanks, “nan” standardized** to `n/a`.
* **Consistent capitalization** applied.

*/

-- Expectation: 
/*
Australia
Canada
France
Germany
United Kingdom
United States
n/a
*/

SELECT DISTINCT
	cntry
FROM cln_erp_LOC_A101;



/*
==============================================
Cleaning data of 'erp_px_cat_g1v2' table
==============================================
*/

-- 1. checking if the data matches
SELECT id
FROM erp_px_cat_g1v2
WHERE id NOT IN (SELECT cat_id FROM cln_crm_prd_info);
/*
🔎 Result
Exactly one category is returned. -> 'CO_PD'
Meaning: this category exists in your category master (erp_px_cat_g1v2), but no product is assigned to it in cln_crm_prd_info.

🧐 Is this a Data Quality Issue?
It depends on the business rules:
If every category must be used by at least one product →
✅ Yes, this is a data quality issue (or a sign of an orphan record).
If unused categories are allowed (e.g., new categories created for future use, or old categories no longer in use) →
⚠️ Then it is not strictly a data error, but it is still a data consistency concern worth flagging.

We will go witgh the second logic.
*/
-- Expectation: No Result
SELECT id
FROM cln_erp_px_cat_g1v2
WHERE id NOT IN (SELECT cant_id FROM cln_crm_prd_info) OR 'CO_PD';

-- 2. Check for unwanted spaces
SELECT * FROM erp_px_cat_g1v2
WHERE cat != TRIM(cat) OR subcat != TRIM(subcat) OR maintenance != TRIM(maintenance);

-- Expectation: No Result
SELECT * FROM cln_erp_px_cat_g1v2
WHERE cat != TRIM(cat) OR subcat != TRIM(subcat) OR maintenance != TRIM(maintenance); 

-- Data standardization & consistency
SELECT DISTINCT
	cat
FROM erp_px_cat_g1v2;

SELECT DISTINCT
	subcat
FROM erp_px_cat_g1v2;

SELECT DISTINCT
	maintenance
FROM erp_px_cat_g1v2;

-- Expectation: No inconsistant or repeatition in different form
SELECT DISTINCT
	cat
FROM cln_erp_px_cat_g1v2;

SELECT DISTINCT
	subcat
FROM cln_erp_px_cat_g1v2;

SELECT DISTINCT
	maintenance
FROM cln_erp_px_cat_g1v2;