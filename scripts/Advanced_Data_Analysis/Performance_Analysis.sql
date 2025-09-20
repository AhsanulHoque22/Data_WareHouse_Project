USE DataWarehouse;

/*
==================================
Performance Analysis
==================================
Comparing the current value to a target value
Help measure success and compare performance
*/

-- Analyze yearly performance of prducts by comparing each product's sales to both it's average sales peformance and the previous year's sales

WITH yearly_product_sales AS (
SELECT
	YEAR(f.order_date) AS order_year,
    p.product_name,
    SUM(f.sales_amount) AS current_sales
FROM fact_sales f
LEFT JOIN dim_products p
ON f.product_key = p.product_key
WHERE f.order_date IS NOT NULL
GROUP BY YEAR(f.order_date),
		 p.product_name
)

SELECT
	order_year,
    product_name,
    current_sales,
    AVG(current_sales) OVER (PARTITION BY product_name) AS avg_sales,
    current_sales - AVG(current_sales) OVER (PARTITION BY product_name) AS diff_in_avg,
    CASE WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) < 0 THEN 'Below Average'
		 WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) >  0 THEN 'Above Average'
         ELSE 'Average'
	END avg_change,
    LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) prev_year_sales,
    current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) AS diffence_from_prev_year,
    CASE WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) < 0 THEN 'Decrease'
		 WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) >  0 THEN 'Increase'
         ELSE 'No Change'
	END prev_year_change
FROM yearly_product_sales
ORDER BY product_name, order_year;