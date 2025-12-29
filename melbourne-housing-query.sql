-- Cleaning data
-- Find duplicate addresses and suburbs in the dataset
SELECT 
    Address, Suburb, COUNT(*)
FROM 
    melbourne_house_prices
GROUP BY 
    Address, Suburb
HAVING 
    COUNT(*) > 1;

-- Delete properties that have a price or rooms value of 0
DELETE FROM
    melbourne_house_prices
WHERE 
    Price = 0 or Rooms = 0;

-- Test data by checking agents with short names (3 characters or less) and deleted
SELECT
    SellerG, COUNT(*) AS jumlah
FROM
    melbourne_house_prices
WHERE
    LENGTH(SellerG) <= 3
GROUP BY
    SellerG
ORDER BY
    jumlah ASC;

DELETE FROM
    melbourne_house_prices
WHERE
    LENGTH(SellerG) <= 3;

-- Clean agent name data by replacing inconsistent values
UPDATE 
    melbourne_house_prices
SET
    SellerG = 'Agen lain-lain'
WHERE
    SellerG = '@Realty' 
    OR SellerG = 'TRUE' 
    OR LENGTH(SellerG) <= 3;
    
-----------------------------------------------------------
--Analyzing Data
-- Calculate the average property price per suburb 
SELECT
    Region_Name, Suburb, ROUND(AVG(Price), 2) AS average_price
FROM
    melbourne_house_prices
GROUP BY
    Region_Name, Suburb
ORDER BY
    average_price DESC;

-- Calculate the average property price per region
SELECT
    Region_Name, ROUND(AVG(Price), 2) AS average_price
FROM 
    melbourne_house_prices
GROUP BY
    Region_Name
ORDER BY
    average_price DESC;

-- Find the most common property sales methods
SELECT
    Methode, COUNT(*) AS total_methode
FROM
    melbourne_house_prices
GROUP BY
    Methode
ORDER BY
    total_methode DESC;

-- Calculate the average price per room for each suburb
SELECT
    Suburb, ROUND(AVG(Price / Rooms), 2) AS average_price
FROM 
    melbourne_house_prices
GROUP BY
    Suburb
ORDER BY
    average_price DESC;

-- Calculate the average price per room for each council area
SELECT
    Council_Area, ROUND(AVG(Price / Rooms), 2) AS average_price
FROM 
    melbourne_house_prices
GROUP BY
    Council_Area
ORDER BY
    average_price;

-- Calculate the Average price per room by suburb
SELECT
    Suburb, ROUND(AVG(Price / Rooms), 2) AS average_price
FROM 
    melbourne_house_prices
GROUP BY
    Suburb
ORDER BY
	average_price;

-- Identify the top 10 most successful property agents
SELECT
    SellerG, COUNT(*) AS total_agentsales
FROM
    melbourne_house_prices
GROUP BY
    SellerG
ORDER BY
    total_agentsales DESC
LIMIT 10;

-- Market Demand Condition in each month
select 
 	case when month(Date) = 1 then "Jan"
		when month(Date) = 2 then "Feb"
		when month(Date) = 3 then "March"
		when month(Date) = 4 then "Apr"
		when month(Date) = 5 then "May"
		when month(Date) = 6 then "June"
		when month(Date) = 7 then "July"
		when month(Date) = 8 then "Augt"
		when month(Date) = 9 then "Sep"
		when month(Date) = 10 then "Oct"
		when month(Date) = 11 then "Nov"
		else "Dec"
	end as monthname, Round(AVG(Price), 0) as average_price, count(*) as total_transaction 
from melbourne_house_prices
group by month(Date);

-- How the Distance Influece the price property?
select 
	case
		when distance <=5 then "0-5 km"
		when distance <=10 then "6-10 km"
		else ">10 km"
	end as distance_group, Round(AVG(Price), 0) as average_price, count(*) total_transaction
from melbourne_house_prices
group by distance_group;

-----------------------------------------------------------------------------------------
-- Descriptive Analytics (Median, Mode)
-- Median for property price per suburb within each region
with ranked as (
	select Suburb, Price,
			ROW_NUMBER() OVER(partition by Suburb order by Price) as row_num,
			Count(*) OVER(partition by Suburb) as total_count
	from melbourne_house_prices
)
select Suburb, AVG(Price) as median
from ranked
where row_num IN (FLOOR((total_count + 1) / 2), CEIL((total_count + 1) / 2))
GROUP BY Suburb
order by median;

-- Median for average property price per region
with ranked as (
	select Region_Name, Price,
			ROW_NUMBER() OVER(partition by Region_Name order by Price) as row_num,
			Count(*) OVER(partition by Region_Name) as total_count
	from melbourne_house_prices
)
select Region_Name, Round(AVG(Price), 0) as median, total_count
from ranked
where row_num IN (FLOOR((total_count + 1) / 2), CEIL((total_count + 1) / 2))
GROUP BY Region_Name
order by median;

-- How the Distance Influece the median price property?
with ranked as (
	select 
		case
			when distance <=5 then "0-5 km"
			when distance <=10 then "6-10 km"
			else ">10 km"
		end as distance_group, Price,
		ROW_NUMBER() OVER(partition by distance_group order by Price) as row_num,
		Count(*) OVER(partition by distance_group) as total_count
	from melbourne_house_prices
)
select distance_group, AVG(Price) as median
from ranked
where row_num IN (FLOOR((total_count + 1) / 2), CEIL((total_count + 1) / 2))
GROUP BY distance_group;

-- Median for Market Demand Condition in each month
with ranked as (
	select 
		Case
		 	when month(Date) = 1 then "Jan"
			when month(Date) = 2 then "Feb"
			when month(Date) = 3 then "March"
			when month(Date) = 4 then "Apr"
			when month(Date) = 5 then "May"
			when month(Date) = 6 then "June"
			when month(Date) = 7 then "July"
			when month(Date) = 8 then "Augt"
			when month(Date) = 9 then "Sep"
			when month(Date) = 10 then "Oct"
			when month(Date) = 11 then "Nov"
			else "Dec"
		end as month_name, Price,
		ROW_NUMBER() OVER(partition by month_name order by Price) as row_num,
		Count(*) OVER(partition by month_name) as total_count
	from melbourne_house_prices
)
select month_name, AVG(Price) as median
from ranked
where row_num IN (FLOOR((total_count + 1) / 2), CEIL((total_count + 1) / 2))
GROUP BY month_name;

# Mode (most total_transaction by Suburb)
select Suburb, Count(*) as median
from melbourne_house_prices
group by Suburb
order by median desc
limit 1;

# Mode (most total_transaction by Region_Name)
select Region_Name, Count(*) as median
from melbourne_house_prices
group by Region_Name
order by median desc
limit 1;

# Mode (most total_transaction by SellerG)
select SellerG, Count(*) as Mode
from melbourne_house_prices
where SellerG <> "Agen lain-lain"
group by SellerG
order by Mode desc
limit 1;



