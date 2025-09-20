USE DataWarehouse;

/*
==================================
Cumulative Analysis
==================================
Aggrigating the data progressively over time
Help to understand Whether our business is growing or declining
*/

-- Calculate the running total of sales over time
-- over month
SELECT
	order_date,
    total_sales,
    SUM(total_sales) OVER (PARTITION BY order_date ORDER BY order_date) AS running_total_sales,
    AVG(avg_price) OVER (PARTITION BY order_date ORDER BY order_date) AS running_average_price
FROM (
	SELECT
		DATE_FORMAT(order_date, '%Y-%m-01') AS order_date,
		SUM(sales_amount) AS total_sales,
        AVG(price) AS avg_price
	FROM fact_sales
	WHERE order_date IS NOT NULL
	GROUP BY DATE_FORMAT(order_date, '%Y-%m-01')
)t;

-- Calculate the running total of sales over time
-- over year
SELECT
	order_date,
    total_sales,
    SUM(total_sales) OVER (ORDER BY order_date) AS running_total_sales,
    AVG(avg_price) OVER (ORDER BY order_date) AS running_average_price
FROM (
	SELECT
		DATE_FORMAT(order_date, '%Y-01-01') AS order_date,
		SUM(sales_amount) AS total_sales,
        AVG(price) AS avg_price
	FROM fact_sales
	WHERE order_date IS NOT NULL
	GROUP BY DATE_FORMAT(order_date, '%Y-01-01')
)t;