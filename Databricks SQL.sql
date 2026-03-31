-----------1. I want to see and limit the first 1000 rows
Select * 
from `workspace`.`default`.`assignment-coffee_analysis` limit 1000;


-----------2. I want to see how long this data is. From which date to which date
SELECT MIN(Transaction_date) AS Min_date
FROM `workspace`.`default`.`assignment-coffee_analysis`;


SELECT MAX(Transaction_date) AS Max_date, MIN(Transaction_date) AS Min_date 
FROM `workspace`.`default`.`assignment-coffee_analysis`;

--Comment: The data is span is 6 months. Starting 01 January to 30 June 2023

----------3. Checking out the different store
SELECT DISTINCT store_location
FROM `workspace`.`default`.`assignment-coffee_analysis`;


SELECT COUNT( DISTINCT store_id) AS number_of_stores
FROM `workspace`.`default`.`assignment-coffee_analysis`;
--Comment: There are 3 different stores named: Lower Manhattan, Hell's Kitchen, Astoria

------------4. Checking out different products sold at the shop
SELECT DISTINCT product_category
FROM `workspace`.`default`.`assignment-coffee_analysis`;

----Comment: 8 product category
SELECT DISTINCT product_detail
FROM `workspace`.`default`.`assignment-coffee_analysis`;

----Comment: 80 product details
SELECT DISTINCT product_type
FROM `workspace`.`default`.`assignment-coffee_analysis`;

----Comment: 29 product type
SELECT DISTINCT product_category AS category,
product_detail AS product_name
FROM `workspace`.`default`.`assignment-coffee_analysis`;


----5. Check product price
SELECT MIN(unit_price) As Lowest_price
FROM `workspace`.`default`.`assignment-coffee_analysis`;


SELECT MAX(unit_price) As Highest_price
FROM `workspace`.`default`.`assignment-coffee_analysis`;


----Count Functions
SELECT
COUNT(*) AS number_of_rows,
COUNT(DISTINCT transaction_id) AS number_of_sales,
COUNT(DISTINCT product_id) AS number_of_products,
COUNT(DISTINCT store_id) AS number_of_stores
FROM `workspace`.`default`.`assignment-coffee_analysis`;


-----Combining all SQLs resulting in CLEANED data
SELECT   -- DATES
    transaction_date,
    DAYNAME(transaction_date) AS day_name,
    MONTHNAME(transaction_date) AS month_name,
    Date_format(transaction_time,'HH:mm:ss') AS Purchase_time,
    
    CASE
        WHEN DAYNAME(transaction_date) IN ('Sun' ,'Sat') THEN 'Weekend'
        ELSE 'Weekday'
    END AS day_classification,   

    CASE
          WHEN Date_format(transaction_time, 'HH:mm:ss') BETWEEN '00:00:00' AND '06:59:59' THEN 'Early Bird'
          WHEN Date_format(transaction_time, 'HH:mm:ss') BETWEEN '07:00:00' AND '09:59:59' THEN 'Morning Rush'
          WHEN Date_format(transaction_time, 'HH:mm:ss') BETWEEN '10:00:00' AND '11:59:59' THEN 'Normal Morning'
          WHEN Date_format(transaction_time, 'HH:mm:ss') BETWEEN '12:00:00' AND '14:59:59' THEN 'Day time'
          WHEN Date_format(transaction_time, 'HH:mm:ss') BETWEEN '15:00:00' AND '16:59:59' THEN 'Afternoon'
          WHEN Date_format(transaction_time, 'HH:mm:ss') >= '17:00:00' THEN 'Evening'

    END AS timebucket_intervals,      

    -- Categorical
    store_location,
    product_category,
    product_detail,

    -- Revenue
    SUM(transaction_qty * unit_price) AS total_revenue,
    CASE 
        WHEN total_revenue <=4.0 THEN 'Low Spend'
        WHEN total_revenue BETWEEN 4.01 AND 15.00 THEN 'Normal Spend'
        ELSE 'High Spend'
    END AS spend_bucket,    


    -- Counts
    COUNT(DISTINCT transaction_id) AS number_of_sales,
    COUNT(DISTINCT product_id) AS number_of_products,
    COUNT(DISTINCT store_id) AS number_of_stores

FROM `workspace`.`default`.`assignment-coffee_analysis`

GROUP BY 
    transaction_date,
    DAYNAME(transaction_date),
    MONTHNAME(transaction_date),
    store_location,
    product_category,
    Date_format(transaction_time, 'HH:mm:ss'),
    CASE
          WHEN Date_format(transaction_time, 'HH:mm:ss') BETWEEN '07:00:00' AND '09:59:59' THEN 'Morning Rush'
          WHEN Date_format(transaction_time, 'HH:mm:ss') BETWEEN '00:00:00' AND '06:59:59' THEN 'Early Bird'
          WHEN Date_format(transaction_time, 'HH:mm:ss') BETWEEN '10:00:00' AND '11:59:59' THEN 'Normal Morning'
          WHEN Date_format(transaction_time, 'HH:mm:ss') BETWEEN '12:00:00' AND '14:59:59' THEN 'Day time'
          WHEN Date_format(transaction_time, 'HH:mm:ss') BETWEEN '15:00:00' AND '16:59:59' THEN 'Afternoon'
          WHEN Date_format(transaction_time, 'HH:mm:ss') >= '17:00:00' THEN 'Evening'
    END,
    CASE
        WHEN DAYNAME(transaction_date) IN ('Sun' ,'Sat') THEN 'Weekend'
        ELSE 'Weekday'
    END ,
    product_detail;
