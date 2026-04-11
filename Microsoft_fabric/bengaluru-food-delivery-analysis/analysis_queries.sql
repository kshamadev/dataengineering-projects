SELECT DB_NAME() AS current_db;

SELECT * FROM INFORMATION_SCHEMA.TABLES;

SELECT * FROM dbo.[dbo.fact_orders];

--Data Analysis (Business requirements)

-- 1st Category: Sales & Revenue

--Question 1:- Total Revenue: What is the total revenue generated across all orders?
select sum(total_amount) as Total Revenue from dbo.[dbo.fact_orders];

--Question 2:- Top Cuisines: Which are the top 5 cuisines by total revenue?
Select Top 5 cuisine as cuisine, sum(total_amount) as Total_Revenue from dbo.[dbo.fact_orders]
GROUP by cuisine
Order by sum(total_amount) DESC;

--Question 3:- Revenue by Location: Which area in Bengaluru generated the highest sales?
Select Top 1 location as location, sum(total_amount) as Total_Revenue from dbo.[dbo.fact_orders]
Group by location 
Order by sum(total_amount) desc

--Question 4:- Average Order Value (AOV): What is the average amount spent per order?
SELECT DISTINCT order_id, AVG(total_amount) as AOV  from dbo.[dbo.fact_orders]
GROUP BY order_id

--Question 5:-High-Value Orders: List the top 10 orders with the highest total_amount
SELECT Top 10 order_id, SUM(total_amount) as Total_Revenue from dbo.[dbo.fact_orders]
GROUP By order_id
ORDER By SUM(total_amount) DESC

-- 2nd Category: Operational Efficiency

--Question 6:-Average Delivery Time: What is the average delivery time (in minutes) for all online orders?
SELECT AVg(DATEDIFF(MINUTE, order_time, delivery_time)) as Avg_delivery_time from dbo.[dbo.fact_orders]
where online_order = 'Yes' AND delivery_time is not null

--Question 7:-Fastest Restaurants: Which 5 restaurants have the fastest average delivery time 
SELECT Top 5 restaurant, AVG(DATEDIFF(MINUTE, order_time, delivery_time)) as average_delivery_time from dbo.[dbo.fact_orders]
WHERE delivery_time is not NULL
GROUP BY restaurant
ORDER BY AVG(DATEDIFF(MINUTE, order_time, delivery_time)) DESC

--Question 8:-Location Delays: Which location has the highest average delivery time?
SELECT Top 1 location, AVG(DATEDIFF(MINUTE, order_time, delivery_time)) as average_delivery_time from dbo.[dbo.fact_orders]
WHERE delivery_time is not NULL
GROUP by location
ORDER BY AVG(DATEDIFF(MINUTE, order_time, delivery_time))  DESC

--Question 9:-Distance Impact: What is the average delivery time for orders traveling more than 10km?
SELECT AVG(DATEDIFF(MINUTE, order_time, delivery_time)) as average_delivery_time from dbo.[dbo.fact_orders]
WHERE distance_km > 10 and delivery_time is not null

--Question 10:-Delivery Success Rate: How many orders have a valid delivery_time compared to the total online_order = 'Yes' count?
SELECT count(CASE WHEN delivery_time is not null then 1 END) * 100/ count(*) as delivery_success_rate from dbo.[dbo.fact_orders]
where online_order = 'Yes'

--3rd Category: Customer Behavior
--Question 11:-Order Mode: What is the percentage split between "Online" vs "Offline" orders?
SELECT ROUND(count(case WHEN online_order = 'Yes' then 1 END) * 100.0 / COUNT(*),2) as Online_order_pct,
       ROUND(count(case WHEN online_order = 'No' then 1 END) * 100.0 / COUNT(*),2) as Offile_order_pct
       from dbo.[dbo.fact_orders]

--Question 12:- Booking Influence: Do customers who "Book a Table" spend more on average than those who don't?

With Avg_value as (
SELECT AVG(CASE WHEN book_table = 'Yes' then total_amount END) as Booked_avg_amount, 
       AVG(CASE WHEN book_table = 'No' then total_amount END) as Not_Booked_avg_amount
       from dbo.[dbo.fact_orders]
       )
       SELECT *, CASE WHEN Booked_avg_amount > Not_Booked_avg_amount then 'Yes' ELSE 'No' END AS Booking_Increases_Spend
       from Avg_value

--Question 13:-Peak Order Hours: During which hour of the day do most orders occur?
SELECT Top 1 DATEPART(Hour, order_time) as order_hour, count(order_id) as Total_orders from dbo.[dbo.fact_orders]
GROUP by DATEPART(Hour, order_time)
ORDER BY count(order_id)  DESC

--Question 14:-Popular Locations: Which 5 locations have the highest volume of orders?
SELECT Top 5 location,count(ordered_qty) as Total_orders from dbo.[dbo.fact_orders]
GROUP BY location
Order BY count(ordered_qty) DESC

--Question 15:-Quantity Trends: What is the average ordered_qty per order for different cuisine types?
SELECT cuisine, AVG(ordered_qty) as Avg_order_qty from dbo.[dbo.fact_orders]
GROUP BY cuisine
ORDER by AVG(ordered_qty) 

-- 4th Category: Quality & Ratings

 --Question 16:-Top Rated: Which restaurants have an average rating higher than 4.5?
SELECT restaurant from dbo.[dbo.fact_orders]
WHERE (rating_clean) > 4.5

--Question 17:-Cuisine Satisfaction: Which cuisine has the highest average customer rating?
SELECT Top 1 cuisine from dbo.[dbo.fact_orders]
ORDER BY rating_clean DESC

--Question 18:- Rating vs. Spend: Is there a correlation between high spending and high ratings?
SELECT 
CASE WHEN total_amount > 100 then 'High Spend' ELSE 'Low Spend' end as Spent_category,
Avg(rating_clean) as Avg_rating
from dbo.[dbo.fact_orders]
Group by CASE WHEN total_amount > 100 then 'High Spend' ELSE 'Low Spend' END

--Question 19:-Low Rating Audit: List the restaurants with more than 10 orders that have an average rating below 3.0.
SELECT restaurant, sum(ordered_qty) as Total_orders, Avg(rating_clean) as rating from  dbo.[dbo.fact_orders]
Group by restaurant
HAVING sum(ordered_qty) > 10 AND Avg(rating_clean)  < 3.0 

--Question 20:-City-Wide Quality: What is the average rating of food delivery across the entire city of Bengaluru?
Select city, AVG(rating_clean) as Avg_rating from  dbo.[dbo.fact_orders]
GROUP BY city


