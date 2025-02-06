
CREATE DATABASE p1_retail_db;

-- create table

drop table if exists retail_sales;
create table retail_sales
(
  transactions_id  int primary key,
  sale_date date,	
  sale_time	time,
  customer_id	int,
  gender	varchar(15),
  age int,
  category varchar(15),
  quantity	int,
  price_per_unit float,
  cogs float,
  total_sale float
);


select * from retail_sales
limit 10;


select 
      count(*)
from retail_sales;


-- data cleaning 

select * from retail_sales
where transactions_id is null;


select * from retail_sales 
where sale_date is null;


select * from retail_sales
where sale_time is null; 

select * from retail_sales
where 
     transactions_id is null
	 or
	 sale_date is null
	 or
	 sale_time is null
	 or  
	 gender is null
	 or
	 category is null
	 or
	 quantity is null
	 or 
	 cogs is null
	 or 
	 total_sale is null;


-- 
   delete from retail_sales
   where 
         transactions_id is null
	     or
	     sale_date is null
	     or
	     sale_time is null
	     or  
	     gender is null
	     or
	     category is null
	     or
	     quantity is null
	     or 
	     cogs is null
	     or 
	     total_sale is null;


-- Data Exploration

-- How many sales we have ?

select count(*) as total_sales from retail_sales;

-- How many unique customers we have ?
select count(distinct customer_id) as unique_customer_count from retail_sales;

-- retrieve the categories from the retail_sales data

select distinct category from retail_sales;



-- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings


-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05

SELECT
	*
FROM
	RETAIL_SALES
WHERE
	SALE_DATE = '2022-11-05';


-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022

SELECT
	*
FROM
	RETAIL_SALES
WHERE
	CATEGORY = 'Clothing'
	AND TO_CHAR(SALE_DATE, 'YYYY-MM') = '2022-11'
	AND QUANTITY >= 4;


-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

SELECT
	CATEGORY,
	SUM(TOTAL_SALE) AS NET_SALE,
	COUNT(*) AS TOTAL_ORDERS
FROM
	RETAIL_SALES
GROUP BY
	1;


-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT
	ROUND(AVG(AGE), 2) AS AVG_AGE
FROM
	RETAIL_SALES
WHERE
	CATEGORY = 'Beauty';


	-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

SELECT
	*
FROM
	RETAIL_SALES
WHERE
	TOTAL_SALE > 1000;


-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

SELECT
	CATEGORY,
	GENDER,
	COUNT(*) AS TOTAL_TRANSACTIOINS
FROM
	RETAIL_SALES
GROUP BY
	CATEGORY,
	GENDER
ORDER BY
	1;



-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

SELECT
	YEAR,
	MONTH,
	AVG_SALE
FROM
	(
		SELECT
			EXTRACT(
				YEAR
				FROM
					SALE_DATE
			) AS YEAR,
			EXTRACT(
				MONTH
				FROM
					SALE_DATE
			) AS MONTH,
			AVG(TOTAL_SALE) AS AVG_SALE,
			RANK() OVER (
				PARTITION BY
					EXTRACT(
						YEAR
						FROM
							SALE_DATE
					)
				ORDER BY
					AVG(TOTAL_SALE) DESC
			) AS RANK
		FROM
			RETAIL_SALES
		GROUP BY
			1,
			2
	) AS T1
WHERE
	RANK = 1;


-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

SELECT
	CUSTOMER_ID,
	SUM(TOTAL_SALE) AS TOTAL_SALES
FROM
	RETAIL_SALES
GROUP BY
	1
ORDER BY
	2 DESC
LIMIT
	5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

SELECT
	CATEGORY,
	COUNT(DISTINCT CUSTOMER_ID) AS UNIQUE_CUSTOMER_COUNT
FROM
	RETAIL_SALES
GROUP BY
	1; 


-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

WITH
	HOURLY_SALES AS (
		SELECT
			*,
			CASE
				WHEN EXTRACT(
					HOUR
					FROM
						SALE_TIME
				) < 12 THEN 'Morning'
				WHEN EXTRACT(
					HOUR
					FROM
						SALE_TIME
				) BETWEEN 12 AND 17  THEN 'Afternoon'
				ELSE 'Evening'
			END AS SHIFT
		FROM
			RETAIL_SALES
	)
SELECT
	SHIFT,
	COUNT(*) AS TOTAL_ORDERS
FROM
	HOURLY_SALES
GROUP BY
	SHIFT;

-- End of project.
