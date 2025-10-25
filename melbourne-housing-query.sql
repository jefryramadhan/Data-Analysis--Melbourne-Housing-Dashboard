-- Find duplicate addresses and suburbs in the dataset
SELECT 
    Address, Suburb, COUNT(*)
FROM 
    melbourne_house_prices
GROUP BY 
    Address, Suburb
HAVING 
    COUNT(*) > 1;

-- Identify properties that have a price value of 0
SELECT
    Price
FROM
    melbourne_house_prices
WHERE 
    Price = 0;

-- Calculate the average property price per suburb within each region
SELECT
    Region_Name, Suburb, ROUND(AVG(Price), 2) AS rata_rata_harga
FROM
    melbourne_house_prices
GROUP BY
    Region_Name, Suburb
ORDER BY
    rata_rata_harga DESC;

-- Calculate the average property price per region
SELECT
    Region_Name, ROUND(AVG(Price), 2) AS ratarata_harga
FROM 
    melbourne_house_prices
GROUP BY
    Region_Name
ORDER BY
    ratarata_harga DESC;

-- Find the most common property sale methods
SELECT
    Methode, COUNT(*) AS total_methode
FROM
    melbourne_house_prices
GROUP BY
    Methode
ORDER BY
    total_methode DESC;

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

-- Calculate the average price per room for each suburb
SELECT
    Suburb, ROUND(AVG(Price / Rooms), 2) AS rata_rata_harga
FROM 
    melbourne_house_prices
GROUP BY
    Suburb
ORDER BY
    rata_rata_harga DESC;

-- Calculate the average price per room for each council area
SELECT
    Council_Area, ROUND(AVG(Price / Rooms), 2) AS ratarata_harga
FROM 
    melbourne_house_prices
GROUP BY
    Council_Area
ORDER BY
    ratarata_harga ASC;

-- Recheck average price per room by suburb
SELECT
    Suburb, ROUND(AVG(Price / Rooms), 2) AS rata_rata_harga
FROM 
    melbourne_house_prices
GROUP BY
    Suburb;

-- Find properties that have 0 rooms (invalid or missing data)
SELECT
    Rooms 
FROM
    melbourne_house_prices
WHERE
    Rooms = 0;

-- Test data import by checking agents with short names (3 characters or less)
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

-- Count total transactions by each agent
SELECT
    SellerG, COUNT(*) AS jumlah_transaksi
FROM 
    melbourne_house_prices
GROUP BY 
    SellerG
ORDER BY
    jumlah_transaksi ASC;

-- Clean agent name data by replacing inconsistent values
UPDATE 
    melbourne_house_prices
SET
    SellerG = 'Agen lain-lain'
WHERE
    SellerG = '@Realty' 
    OR SellerG = 'TRUE' 
    OR LENGTH(SellerG) <= 3;
