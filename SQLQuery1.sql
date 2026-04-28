SELECT * FROM swiggy_data

--Data Validation and Cleaning
--Null Check
SELECT
    SUM(CASE WHEN State IS NULL THEN 1 ELSE 0 END) AS NULL_STATE,
    SUM(CASE WHEN City IS NULL THEN 1 ELSE 0 END) AS NULL_CITY,
    SUM(CASE WHEN Order_Date IS NULL THEN 1 ELSE 0 END) AS NULL_ORDER_DATE,
    SUM(CASE WHEN  Restaurant_Name is null THEN 1 ELSE 0 END) AS NULL_RESTAURANT ,
    SUM(CASE WHEN Location  IS NULL THEN 1 ELSE 0 END) AS NULL_LOCATION,
    SUM(CASE WHEN Category IS NULL THEN 1 ELSE 0 END) AS NULL_CATEGORY,
    SUM(CASE WHEN Dish_Name IS NULL THEN 1 ELSE 0 END) AS DISH_NAME,
    SUM(CASE WHEN Price_INR IS NULL THEN 1 ELSE 0 END) AS NULL_PRICE ,
    SUM(CASE WHEN Rating IS NULL THEN 1 ELSE 0 END) AS NULL_RATING ,
    SUM(CASE WHEN Rating_Count IS NULL THEN 1 ELSE 0 END) AS NULL_RATING_COUNT
from swiggy_data;


--blank or empty strings
select * 
from swiggy_data
where
state = '' or Restaurant_Name = '' or location = '' or Category = '' or Dish_Name= '';

--Duplicate Detection
select
state, city , order_date  ,  restaurant_name ,  location , 
Category ,  dish_name , Price_inr , Rating , Rating_count,
count(*) as CNT
from swiggy_data
GROUP BY
state, city , order_date  , restaurant_name, location, 
Category, dish_name,Price_inr,Rating, Rating_count
Having count(*)>1

--Delete Duplication 
with CTE AS (
SELECT *, ROW_NUMBER() OVER(
     PARTITION BY state, city , order_date  ,  restaurant_name ,  location , 
Category ,  dish_name , Price_inr , Rating , Rating_count
ORDER BY (SELECT NULL)
) AS RN 
FROM swiggy_data
)
DELETE FROM CTE WHERE RN>1




--KPI's
--Total Orders
Select Count(*) As Total_Orders
From swiggy_data

--Total Revenue (INR Million)
Select
Format (Sum(Convert(FLoat,Price_INR))/1000000,'N2')+'INR Million'
As Total_Revenue 
from swiggy_data

--Average Dish Price
Select
Format (Avg(Convert(FLoat,Price_INR)),'N2')+'INR'
As Average_Dish_Price 
from swiggy_data

--Average Rating
Select 
AVG(Rating) As Average_Rating
from swiggy_data



--Deep-Dive Buisness Analytics



--Top Cities By Orders
SELECT City, COUNT(*) AS Total_Orders
FROM swiggy_data
GROUP BY City
ORDER BY Total_Orders DESC;

--Top Restaurants By Revenue
SELECT Restaurant_Name, SUM(Price_INR) AS Revenue
FROM swiggy_data
GROUP BY Restaurant_Name
ORDER BY Revenue DESC;

--Highest Rated Restaurants
SELECT Restaurant_Name, AVG(Rating) AS Avg_Rating
FROM swiggy_data
GROUP BY Restaurant_Name
ORDER BY Avg_Rating DESC;



--Most Ordered Dishes
SELECT Dish_Name, COUNT(*) AS Orders
FROM swiggy_data
GROUP BY Dish_Name
ORDER BY Orders DESC;


--Monthly Order Trend
SELECT 
    MONTH(Order_Date) AS Month,
    COUNT(*) AS Orders
FROM swiggy_data
GROUP BY MONTH(Order_Date)
ORDER BY Month;


