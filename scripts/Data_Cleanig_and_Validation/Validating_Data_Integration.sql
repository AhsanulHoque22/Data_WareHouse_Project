USE DataWarehouse;

-- 1. check for duplicates in primary key
SELECT cst_id, COUNT(*) FROM (
	SELECT
		ci.cst_id,
		ci.cst_key,
		ci.cst_firstname,
		ci.cst_lastname,
		ci.cst_marital_status,
		ci.cst_gndr,
		ci.cst_create_date,
		ca.bdate,
		ca.gen,
		la.cntry
	FROM cln_crm_cust_info ci
	LEFT JOIN cln_erp_CUST_AZ12 ca
	ON		  ci.cst_KEY = ca.cid
	LEFT JOIN cln_erp_LOC_A101 la
	ON		  ci.cst_key = la.cid
) t GROUP BY cst_id
HAVING COUNT(*) > 1;
-- Result no output which means no duplicate primary key.

-- 2. cheching data consistancy
-- both cln_crm_cust_info and cln_erp_CUST_AZ12 has gender information.
-- this is redundant and let's see if they have same values for each customer
SELECT DISTINCT
		ci.cst_gndr AS CI_Gender,
		ca.gen AS CA_Gender
FROM cln_crm_cust_info ci
LEFT JOIN cln_erp_CUST_AZ12 ca
ON		  ci.cst_KEY = ca.cid
LEFT JOIN cln_erp_LOC_A101 la
ON		  ci.cst_key = la.cid
ORDER BY 1,2;

-- Result:
-- we can see that both the columns have same genders, so data is pretty much constant
-- sometimes it happens that consistancy is bad and for a customer different tables have different gender information
-- again sometimes one table can have n/a and other have malew or female
-- again it may happen that both are not available

-- Solution:
-- Consult with higher ups and know which table is the master table and which one is the slave
-- Business Logic: use the data of the master table and if data in master table is not available then use the data of slave table
-- if none are available use the n/a


-- 3. check for duplicates in primary key
SELECT prd_key, COUNT(*) FROM (
	SELECT
		pn.prd_id,
		pn.prd_key,
		pn.prd_nm,
		pn.cat_id,
		pc.cat,
		pc.subcat,
		pc.maintenance,
		pn.prd_cost,
		pn.prd_line,
		pn.prd_start_dt
	FROM cln_crm_prd_info pn
	LEFT JOIN cln_erp_px_cat_g1v2 pc
	ON		  pn.cat_id = pc.id
    WHERE prd_end_dt IS NULL
) t GROUP BY prd_key
HAVING COUNT(*) > 1;
-- Result no output which means no duplicate primary key.


-- fact view check.
-- Check if all dimensions tables can successfully join to the fact table
SELECT *
FROM fact_sales f
LEFT JOIN dim_customers c
ON 		  c.customer_key = f.customer_key
LEFT JOIN dim_products p
ON 		  p.product_key = f.product_key
WHERE c.customer_key IS NULL OR p.product_key IS NULL;
-- Result: NO output. It means joins are successful and there is no unmatched data