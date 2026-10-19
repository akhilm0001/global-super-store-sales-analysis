SELECT COUNT(*) AS row_count FROM splitting_table;
SELECT * FROM splitting_table LIMIT 10;
SELECT
    COUNT(*) AS total_rows,
    COUNT(customer_id) AS customer_id_count,
    COUNT(order_id) AS order_id_count,
    COUNT(product_id) AS product_id_count,
    COUNT(sales) AS sales_count,
    COUNT(profit) AS profit_count
FROM splitting_table;

SELECT customer_id, COUNT(*) AS cnt
FROM splitting_table
GROUP BY customer_id
HAVING COUNT(*) > 1;

SELECT product_id, COUNT(*) AS cnt
FROM splitting_table
GROUP BY product_id
HAVING COUNT(*) > 1;

DESCRIBE splitting_table;
ALTER TABLE splitting_table
RENAME COLUMN ` date_of_birth` TO date_of_birth;
DESCRIBE splitting_table;

CREATE TABLE dim_customer AS
SELECT DISTINCT
    customer_id,
    customer_name,
    last_name,
    date_of_birth,
    age,
    age_group,
    segment
FROM splitting_table;
SELECT COUNT(*) AS customer_rows
FROM dim_customer;
SELECT *
FROM dim_customer
LIMIT 10;

CREATE TABLE dim_product AS
SELECT DISTINCT
    product_id,
    product_name,
    category_of_goods,
    sub_category
FROM splitting_table;

CREATE TABLE dim_location AS
SELECT DISTINCT
    postal_code,
    state,
    city_type,
    region,
    country,
    outlet_type
FROM splitting_table;
SELECT COUNT(*) AS customer_rows
FROM dim_location;
SELECT *
FROM dim_location
LIMIT 20;

CREATE TABLE dim_date AS
SELECT DISTINCT
    order_date,
    order_year,
    order_quarter,
    order_month,
    month_name,
    order_week,
    order_day,
    day_name
FROM splitting_table;

CREATE TABLE fact_sales AS
SELECT
    order_id,
    customer_id,
    product_id,
    order_date,
    sales_date,
    ship_date,
    postal_code,
    ship_mode,
    quantity,
    sales,
    discount,
    profit,
    shipping_days,
    profit_margin
FROM splitting_table;


show tables;
SELECT COUNT(*) AS customers FROM dim_customer;
SELECT COUNT(*) AS products FROM dim_product;
SELECT COUNT(*) AS locations FROM dim_location;
SELECT COUNT(*) AS dates FROM dim_date;
SELECT COUNT(*) AS sales FROM fact_sales;

SELECT *
FROM fact_sales
LIMIT 10;

SELECT customer_id, COUNT(*) AS cnt
FROM dim_customer
GROUP BY customer_id
HAVING COUNT(*) > 1;

ALTER TABLE dim_customer
ADD PRIMARY KEY (customer_id);

SELECT product_id, COUNT(*) AS cnt
FROM dim_product
GROUP BY product_id
HAVING COUNT(*) > 1;

ALTER TABLE dim_product
ADD PRIMARY KEY (product_id);

SELECT order_date, COUNT(*) AS cnt
FROM dim_date
GROUP BY order_date
HAVING COUNT(*) > 1;
ALTER TABLE dim_date
ADD PRIMARY KEY (order_date);


SELECT postal_code, COUNT(*) AS cnt
FROM dim_location
GROUP BY postal_code
HAVING COUNT(*) > 1;

ALTER TABLE dim_location
ADD COLUMN location_id INT AUTO_INCREMENT PRIMARY KEY;

SELECT
    postal_code,
    state,
    city_type,
    region,
    country,
    outlet_type,
    COUNT(*) AS cnt
FROM dim_location
GROUP BY
    postal_code,
    state,
    city_type,
    region,
    country,
    outlet_type
HAVING COUNT(*) > 1;

ALTER TABLE fact_sales
ADD COLUMN location_id INT;

DESCRIBE fact_sales;

SELECT COUNT(*) 
FROM fact_sales;

SELECT COUNT(*) 
FROM fact_sales
WHERE location_id IS NULL;

SET SQL_SAFE_UPDATES = 0;
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
SET f.location_id = l.location_id;
SELECT 1;

SELECT COUNT(*) AS filled_location_id
FROM fact_sales
WHERE location_id IS NOT NULL;


SELECT COUNT(*) AS rows_count
FROM fact_sales;


SELECT COUNT(*) AS location_count
FROM dim_location;
CREATE TABLE location_mapping AS
SELECT
    location_id,
    postal_code,
    state,
    city_type,
    region,
    country,
    outlet_type
FROM dim_location;

CREATE INDEX idx_mapping_location
ON location_mapping (
    postal_code,
    state,
    city_type,
    region,
    country,
    outlet_type
);

SELECT
    f.order_id,
    f.postal_code,
    l.location_id
FROM fact_sales f
JOIN splitting_table s
    ON f.order_id = s.order_id
JOIN location_mapping l
    ON l.postal_code = s.postal_code
   AND l.state = s.state
   AND l.city_type = s.city_type
   AND l.region = s.region
   AND l.country = s.country
   AND l.outlet_type = s.outlet_type
LIMIT 10;

-- CREATE INDEX idx_fact_order
-- ON fact_sales(order_id);
SELECT 1;
SHOW TABLES;
-- SELECT COUNT(*) AS total_rows
-- FROM fact_sales;
SELECT COUNT(*) FROM fact_sales;

SELECT COUNT(*) FROM splitting_table;
SELECT COUNT(*) FROM dim_location;
DROP TABLE fact_sales;
SELECT 1;
SELECT COUNT(*) FROM splitting_table;

SHOW TABLE STATUS LIKE 'fact_sales';
SELECT *
FROM fact_sales
LIMIT 1;
SELECT *
FROM fact_sales
LIMIT 10;

SELECT customer_id, COUNT(*) AS cnt
FROM dim_customer
GROUP BY customer_id
HAVING COUNT(*) > 1;
-- ALTER TABLE dim_customer
-- ADD PRIMARY KEY (customer_id);

SHOW CREATE TABLE dim_customer;

SHOW INDEX FROM dim_customer
WHERE Key_name = 'PRIMARY';

SELECT product_id, COUNT(*) AS cnt
FROM dim_product
GROUP BY product_id
HAVING COUNT(*) > 1;

SHOW INDEX FROM dim_product
WHERE Key_name = 'PRIMARY';

SELECT order_date, COUNT(*) AS cnt
FROM dim_date
GROUP BY order_date
HAVING COUNT(*) > 1;
SHOW INDEX FROM dim_date
WHERE Key_name = 'PRIMARY';


SELECT COUNT(*) AS unmatched_customers
FROM fact_sales f
LEFT JOIN dim_customer c
    ON f.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

SELECT COUNT(*) AS unmatched_products
FROM fact_sales f
LEFT JOIN dim_product p
    ON f.product_id = p.product_id
WHERE p.product_id IS NULL;

SELECT COUNT(*) AS unmatched_dates
FROM fact_sales f
LEFT JOIN dim_date d
    ON f.order_date = d.order_date
WHERE d.order_date IS NULL;

SELECT COUNT(*) AS unmatched_locations
FROM fact_sales f
LEFT JOIN dim_location l
    ON f.postal_code = l.postal_code
WHERE l.postal_code IS NULL;

show tables;
DROP TABLE location_mapping;
show tables;
 