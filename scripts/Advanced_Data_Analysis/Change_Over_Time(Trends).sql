USE DataWarehouse;

/*
==================================
Change-Over-Time (Trends)
==================================
Analyze how a measure evolves over time.
Helps track trends and identify seasonality in our data
*/

-- Analyze sales performance over time to discover seasonality in our data
-- 1. over month
SELECT
	MONTHNAME(order_date) as order_month,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) as total_customers,
    SUM(quantity) AS total_quantity
FROM fact_sales
WHERE order_date IS NOT NULL
GROUP BY MONTHNAME(order_date)
ORDER BY MONTHNAME(order_date);

-- over the month (starting from the first day)
SELECT
	DATE_FORMAT(order_date, '%Y-%m-01') AS month_start,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) as total_customers,
    SUM(quantity) AS total_quantity
FROM fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATE_FORMAT(order_date, '%Y-%m-01')
ORDER BY month_start;

-- 2. over year
SELECT
	YEAR(order_date) as order_year,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) as total_customers,
    SUM(quantity) AS total_quantity
FROM fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date)
ORDER BY YEAR(order_date);

-- over the year (starting from the first day)
SELECT
	DATE_FORMAT(order_date, '%Y-01-01') AS year_start,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) as total_customers,
    SUM(quantity) AS total_quantity
FROM fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATE_FORMAT(order_date, '%Y-01-01')
ORDER BY month_start;