SHOW VARIABLES LIKE 'secure_file_priv';

-- 'secure_file_priv','C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\'


CREATE DATABASE IF NOT EXISTS pizza_db;
USE pizza_db;

DROP TABLE IF EXISTS pizza_sales;

CREATE TABLE pizza_sales (
pizza_id INT PRIMARY KEY,
order_id INT,
pizza_name_id VARCHAR(255),
quantity INT,
order_date VARCHAR(50),
order_time VARCHAR(50),
unit_price DECIMAL(10,2),
total_price DECIMAL(10,2),
pizza_size VARCHAR(10),
pizza_category VARCHAR(50),
pizza_ingredients VARCHAR(1000),
pizza_name VARCHAR(255)
);

select * from pizza_sales;



LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/pizza_sales.csv"
INTO TABLE pizza_sales
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"' -- <--- Add 'OPTIONALLY' here
LINES TERMINATED BY '\r\n' -- <--- Ensure this matches your file (use \r\n for Windows)
IGNORE 1 ROWS;

-- Check if data is there
SELECT * FROM pizza_sales LIMIT 10;
set sql_safe_updates= 0;
set sql_safe_updates= 1;

-- Data Cleaning 
select * from pizza_sales;
update pizza_sales set order_date = str_to_date(order_date,'%d-%m-%Y');
alter table pizza_sales modify column order_date date;
update pizza_sales set order_time = replace(order_time,'.',':');
alter table pizza_sales modify column order_time time;
-- KPI
-- Total sales
select round(sum(total_price)/1000,0 )from pizza_sales;
select round(sum(total_price)/0)/ count(distinct order_id)from pizza_sales; --- 
-- Q3
select sum(quantity) from pizza_sales;
-- Q4
select count(distinct order_id) from pizza_sales;
-- Q5
select sum(quantity) /count(distinct order_id) from pizza_sales;
-- Phase 2 
-- Q6
select hour(order_time) as order_hour,
sum(total_price) as hourly_revenue,
count(distinct order_id) as hourly_orders,
sum(total_price) /count(distinct order_id)  as avg_hourly_revenue,
sum(quantity) /count(distinct order_id) as avg_hourly_pizza_order
from pizza_sales
group by order_hour
order by hourly_revenue Desc
limit 8;
-- Q7
select dayname(order_date) as day_of_order,
sum(total_price) as day_wise_revenue,
count(distinct order_id) as day_wise_orders,
sum(total_price) /count(distinct order_id)  as avg_day_wise_revenue,
sum(quantity) /count(distinct order_id) as avg_day_wise_pizza_order
from pizza_sales
group by day_of_order
order by day_wise_revenue Desc;
-- Q8
select monthname(order_date) as order_month,
sum(total_price) as month_revenue,
count(distinct order_id) as month_orders,
sum(total_price) /count(distinct order_id)  as avg_month_revenue,
sum(quantity) /count(distinct order_id) as avg_month_pizza_order
from pizza_sales
group by order_month
order by month_revenue Desc;
-- Q9
select
case
   when day(order_date) in (1,7) then 'weekend' else 'weekday'
   end as day_type,
   sum(total_price) as revenue,
count(distinct order_id) as orders,
sum(total_price) /count(distinct order_id)  as avg_revenue,
sum(quantity) /count(distinct order_id) as avg_pizza_order
from pizza_sales
group by day_type
order by revenue Desc;


select * from pizza_sales;

-- Q 10
select pizza_category,
 sum(total_price) as revenue,
 count(distinct order_id) as orders,
 sum(total_price)/count(distinct order_id) as avg_revenue,
 sum(quantity)/count(distinct order_id) as avg_pizza_order,
  sum(total_price) * 100 / (select  sum(total_price) as grand_total from pizza_sales) as sales_percent
 from pizza_sales
 group by pizza_category
 order by revenue desc;
 -- Q 11
 select pizza_size,
 sum(total_price) as revenue,
 count(distinct order_id) as orders,
 sum(total_price)/count(distinct order_id) as avg_revenue,
 sum(quantity)/count(distinct order_id) as avg_pizza_order,
  sum(total_price) * 100 / (select  sum(total_price) as grand_total from pizza_sales) as sales_percent
 from pizza_sales
 group by pizza_size
 order by revenue desc;
 -- my example
 select pizza_size,
 sum(total_price) as revenue,
 count(distinct order_id) as orders
 from pizza_sales
 group by pizza_size
 order by revenue desc;
 -- Q12
  select pizza_name,
 sum(total_price) as revenue,
 count(distinct order_id) as orders,
 sum(total_price)/count(distinct order_id) as avg_revenue,
 sum(quantity)/count(distinct order_id) as avg_pizza_order,
  sum(total_price) * 100 / (select  sum(total_price) as grand_total from pizza_sales) as sales_percent
 from pizza_sales
 group by pizza_name
 order by revenue desc
 limit 5;
 -- Q 14
 select pizza_size,
  sum(case when dayofweek(order_date) in (1,7) then  quantity  else 0 end) as  weekend,
  sum(case when dayofweek(order_date) between  2 and  6  then  quantity  else 0 end) as weekday
 from pizza_sales
 group by pizza_size
 having pizza_size = 'L';
 -- Q15
  select pizza_category,
  hour(order_time) as order_hour,
 sum(total_price) as revenue,
 count(distinct order_id) as orders,
 sum(total_price)/count(distinct order_id) as avg_revenue,
 sum(quantity)/count(distinct order_id) as avg_pizza_order
 from pizza_sales
 group by order_hour,pizza_category
 order by revenue
 limit 5;
 -- Q16
WITH category_leaders AS
(
    SELECT 
        pizza_category,
        pizza_name,
        SUM(total_price) AS revenue,
        RANK() OVER(
            PARTITION BY pizza_category
            ORDER BY SUM(total_price) DESC
        ) AS rnk
    FROM pizza_sales
    GROUP BY pizza_category, pizza_name
)

SELECT 
    pizza_category,
    pizza_name,
    revenue
FROM category_leaders
WHERE rnk = 1;
