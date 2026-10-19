-- Overall Sales
-- What is the total sales?
SELECT SUM(sales) AS total_sales FROM fact_sales;
-- What is the total profit?
SELECT SUM(profit) AS total_profit FROM fact_sales;
-- Total Orders
SELECT COUNT(DISTINCT order_id) AS total_orders FROM fact_sales;
-- Total Quantity
SELECT SUM(quantity) AS total_quantity FROM fact_sales;

-- Time Analysis
SELECT
    YEAR(order_date) AS year,
    SUM(sales) AS total_sales
FROM fact_sales
GROUP BY YEAR(order_date)
ORDER BY total_sales DESC;

-- Profit by Year
-- Which year had the highest profit?
SELECT
    YEAR(order_date) AS year,
    SUM(profit) AS total_profit
FROM fact_sales
GROUP BY YEAR(order_date)
ORDER BY total_profit DESC;

-- Sales by Month
SELECT
    MONTH(order_date) AS month,
    SUM(sales) AS total_sales
FROM fact_sales
GROUP BY MONTH(order_date)
ORDER BY total_sales DESC;

-- State Analysis
-- Which state has the highest sales?
SELECT
    l.state,
    SUM(f.sales) AS total_sales
FROM fact_sales f
JOIN dim_location l
    ON f.postal_code = l.postal_code
GROUP BY l.state
ORDER BY total_sales DESC;

-- Which state has the highest profit?
SELECT
    l.state,
    SUM(f.profit) AS total_profit
FROM fact_sales f
JOIN dim_location l
    ON f.postal_code = l.postal_code
GROUP BY l.state
ORDER BY total_profit DESC;

-- Product Analysis
-- Which category generates the highest sales?
SELECT
    p.category_of_goods,
    SUM(f.sales) AS total_sales
FROM fact_sales f
JOIN dim_product p
    ON f.product_id = p.product_id
GROUP BY p.category_of_goods
ORDER BY total_sales DESC;

-- Which category generates the highest profit?
SELECT
    p.category_of_goods,
    SUM(f.profit) AS total_profit
FROM fact_sales f
JOIN dim_product p
    ON f.product_id = p.product_id
GROUP BY p.category_of_goods
ORDER BY total_profit DESC;

-- Top 10 Products
SELECT
    p.product_name,
    SUM(f.sales) AS total_sales
FROM fact_sales f
JOIN dim_product p
    ON f.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_sales DESC
LIMIT 10;


-- Customer Analysis
-- Which customer segment generates the highest sales?
SELECT
    c.segment,
    SUM(f.sales) AS total_sales
FROM fact_sales f
JOIN dim_customer c
    ON f.customer_id = c.customer_id
GROUP BY c.segment
ORDER BY total_sales DESC;

-- Sales by Age Group
SELECT
    c.age_group,
    SUM(f.sales) AS total_sales
FROM fact_sales f
JOIN dim_customer c
    ON f.customer_id = c.customer_id
GROUP BY c.age_group
ORDER BY total_sales DESC;

-- Shipping Analysis
-- Which shipping mode is most frequently used?
SELECT
    ship_mode,
    COUNT(*) AS order_count
FROM fact_sales
GROUP BY ship_mode
ORDER BY order_count DESC;

-- Average Shipping Time
SELECT
    ship_mode,
    AVG(shipping_days) AS avg_shipping_days
FROM fact_sales
GROUP BY ship_mode
ORDER BY avg_shipping_days;

-- SELECT
--     ship_mode,
--     MIN(shipping_days) AS min_days,
--     MAX(shipping_days) AS max_days,
--     AVG(shipping_days) AS avg_days,
--     COUNT(*) AS orders
-- FROM fact_sales
-- GROUP BY ship_mode;


-- Discount vs Profit
-- How does discount affect profit?
SELECT
    discount,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit
FROM fact_sales
GROUP BY discount
ORDER BY discount;
-- profit margin by discount
SELECT
    discount,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    ROUND(SUM(profit) / SUM(sales) * 100, 2) AS profit_margin_percent
FROM fact_sales
GROUP BY discount
ORDER BY discount;

 -- which category has highest profit margin
 SELECT
    p.category_of_goods,
    SUM(f.profit) / SUM(f.sales) AS profit_margin
FROM fact_sales f
JOIN dim_product p
    ON f.product_id = p.product_id
GROUP BY p.category_of_goods
ORDER BY profit_margin DESC;

SELECT VERSION();
SELECT USER(), CURRENT_USER();
SHOW VARIABLES LIKE 'port';


SELECT
    f.postal_code,
    l.location_id
FROM fact_sales f
LEFT JOIN dim_location l
    ON f.postal_code = l.postal_code
LIMIT 20;

SELECT
    postal_code,
    COUNT(*) AS location_count
FROM dim_location
GROUP BY postal_code
HAVING COUNT(*) > 1
ORDER BY location_count DESC;
SELECT
    postal_code,
    state,
    city_type,
    region,
    country,
    outlet_type,
    COUNT(*) AS location_count
FROM dim_location
GROUP BY
    postal_code,
    state,
    city_type,
    region,
    country,
    outlet_type
HAVING COUNT(*) > 1;

SELECT COUNT(*) AS matching_rows
FROM fact_sales f
JOIN splitting_table s
    ON f.order_id = s.order_id
JOIN dim_location l
    ON l.postal_code = s.postal_code
   AND l.state = s.state
   AND l.city_type = s.city_type
   AND l.region = s.region
   AND l.country = s.country
   AND l.outlet_type = s.outlet_type
WHERE f.location_id IS NULL;

SHOW INDEX FROM fact_sales
WHERE Key_name = 'PRIMARY';
ALTER TABLE fact_sales
ADD PRIMARY KEY (order_id);

SHOW INDEX FROM fact_sales;

UPDATE fact_sales f
JOIN splitting_table s
    ON f.order_id = s.order_id
JOIN dim_location l
    ON l.postal_code = s.postal_code
   AND l.state = s.state
   AND l.city_type = s.city_type
   AND l.region = s.region
   AND l.country = s.country
   AND l.outlet_type = s.outlet_type
SET f.location_id = l.location_id
WHERE f.location_id IS NULL;

SELECT COUNT(*) AS remaining_nulls
FROM fact_sales
WHERE location_id IS NULL;

SELECT
    COUNT(*) AS total_rows,
    SUM(location_id IS NULL) AS null_location_ids
FROM fact_sales;

DESCRIBE dim_date;


SELECT
    MIN(order_date) AS min_date,
    MAX(order_date) AS max_date,
    COUNT(*) AS total_dates
FROM dim_date;






