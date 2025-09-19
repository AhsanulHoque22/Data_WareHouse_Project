USE DataWarehouse;

/*
SELECT * FROM dim_customers;
SELECT * FROM dim_products;
SELECT * FROM fact_sales;
*/

/*
Serrogate Key: System-generated unique identifier assigned to each record in a table
*/


-- Customer Dimension View
CREATE VIEW dim_customers AS
SELECT
	ROW_NUMBER() OVER (ORDER BY cst_id) AS custmer_key, -- Surrogate key
    ci.cst_id AS customer_id,
    ci.cst_key as customer_number,
    ci.cst_firstname AS first_name,
    ci.cst_lastname AS last_name,
    la.cntry AS country,
    ci.cst_marital_status AS marital_status,
    CASE WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr -- CRM is the Mater for gender information
		 ELSE COALESCE(ca.gen, 'n/a')
	END AS gender,
    ca.bdate AS birthdate,
    ci.cst_create_date AS create_date
FROM cln_crm_cust_info ci
LEFT JOIN cln_erp_CUST_AZ12 ca
ON		  ci.cst_KEY = ca.cid
LEFT JOIN cln_erp_LOC_A101 la
ON		  ci.cst_key = la.cid
ORDER BY 1,2;


-- Product Dimension View
CREATE VIEW dim_products AS
SELECT
	ROW_NUMBER() OVER (ORDER BY pn.prd_start_dt, pn.prd_key) AS product_key,
    pn.prd_id AS product_id,
    pn.prd_key AS product_number,
    pn.prd_nm AS product_name,
    pn.cat_id AS category_id,
    pc.cat AS category,
    pc.subcat AS subcategory,
    pc.maintenance,
    pn.prd_cost AS cost,
    pn.prd_line AS product_line,
    pn.prd_start_dt AS start_date
FROM cln_crm_prd_info pn
LEFT JOIN cln_erp_px_cat_g1v2 pc
ON		  pn.cat_id = pc.id
WHERE prd_end_dt IS NULL; -- End date null means current data. We don't need historical products. So filter them out,