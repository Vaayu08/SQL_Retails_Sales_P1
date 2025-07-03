--Sql Project Salaes Analysis- P1 -

create database SQL_Project_P2;

--DATA ADDED FROM EXCEL PROCESS
--create table
DROP TABLE IF EXISTS reatil_sales;
CREATE Table reatil_sales
(
    transactions_id	 INT PRIMARY KEY,
	sale_date  DATE,
	sale_time  TIME,
	customer_id INT,
	gender VARCHAR(15),
	age INT,
	category VARCHAR(15),
	quantiy INT,
	price_per_unit FLOAT,
	cogs FLOAT,
	total_sale FLOAT
);

-- DATA CHECKING AND CLEANNING PROCESS
--find top 10 rows or filled in table
SELECT * FROM reatil_sales
LIMIT 10;

-- find count
SELECT
COUNT(*) FROM
reatil_sales

-- how to find null values in table
SELECT * FROM reatil_sales
where
     transactions_id IS NULL
	 OR
	 sale_date IS NULL
	 OR
	 sale_time IS NULL
	 OR
	 gender IS NULL
	 OR
	 category IS NULL
	 OR
	 quantiy IS NULL
	 OR 
	 cogs IS NULL
	 OR
	 total_sale IS NULL;

-- DELETE NULL ROWS FROM TABLE
DELETE FROM reatil_sales
	 where
     transactions_id IS NULL
	 OR
	 sale_date IS NULL
	 OR
	 sale_time IS NULL
	 OR
	 gender IS NULL
	 OR
	 category IS NULL
	 OR
	 quantiy IS NULL
	 OR 
	 cogs IS NULL
	 OR
	 total_sale IS NULL;

-- DATA EXPLORATION PROCESS
-- HOW MANY SALES WE HAVE
SELECT COUNT(*) AS totale_sale from reatil_sales;

-- how many unique customer we have
select count(distinct customer_id) as totale_sale from reatil_sales;

-- how many unique category we have
select count(distinct category) as totale_sale from reatil_sales;

--show different category name
select distinct category from reatil_sales;

-- DATA ANALYSIS AND BUSINESS KEY PROBLEM
--### 3. Data Analysis & Findings
--The following SQL queries were developed to answer specific business questions:
--1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05**:
SELECT *
FROM reatil_sales
WHERE sale_date = '2022-11-05';

--**2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022**:
select 
 *
from reatil_sales 
where category = 'Clothing'
AND
TO_CHAR(sale_date ,'YYYY-MM') ='2022-11'
and
quantiy >=4
group by 1

--3. **Write a SQL query to calculate the total sales (total_sale) for each category.**:
select 
category,
sum(total_sale) as net_sale ,
count(*) as total_orders
from reatil_sales
group by 1

--4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**:
select
round(avg(age),2) as avg_age
from reatil_sales
where category = 'Beauty'

--5. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**:
select * from reatil_sales
where total_sale >1000

--6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**:
select
category,
gender,
count (*) as total_sales
from reatil_sales
group by 
category,
gender
order by 1

--7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**:

select
			year, 
			month,
			avg_sale
	from
(
			SELECT
			EXTRACT(YEAR from sale_date) as year,
			EXTRACT(MONTH from sale_date) as month,
			AVG(total_sale) as avg_sale,
			RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) order by AVG(total_sale) DESC) as rank
			from reatil_sales
			group by 1,2
) as T1
where rank = 1

--8. **Write a SQL query to find the top 5 customers based on the highest total sales **:
select
customer_id,
SUM(total_sale)as total_sales
from reatil_sales
group by 1
order by 2 DESC
limit 5

--9. **Write a SQL query to find the number of unique customers who purchased items from each category.**:
select
category,
count(distinct customer_id) as cnt_unique_cs
from reatil_sales
group by category 

--10. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
with Hourly_sale
AS
(
select *,
			case 
			WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
			WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
			ELSE 'Evening'
			END as shift
from reatil_sales
)
SELECT
    shift,
	count(*) as total_orders
from Hourly_sale
group by shift
