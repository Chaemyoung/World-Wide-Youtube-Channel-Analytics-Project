-- Youtubers with the most subscribers

/*

1. Define the variables.
2. Create a CTE to convert the Average_Views Column (NVARCHAR) into BIGINT type
3. Select the columns that are required for the analysis.
4. Filter the rsults by the YouTube channels with the highest subscriber bases.
5. Order by net_profit (from highest to lowest).

*/


-- 1.
DECLARE @conversionRate FLOAT = 0.02;			-- The conversion rate @ 2%
DECLARE @productCost MONEY = 5.0;				-- The product cost @ $5
DECLARE @campaignCost MONEY = 50000.0;			-- The campaign cost @ $50,000


-- 2.
WITH NoDuplicates AS (
	SELECT 
		Channel_Name,
		CASE
			WHEN RIGHT(Average_Views, 1) = 'M' THEN CAST(TRY_CONVERT(DECIMAL(10, 2), LEFT(Average_Views, LEN(Average_Views) - 1)) * 1000000 AS BIGINT)
			WHEN RIGHT(Average_Views, 1) = 'K' THEN CAST(TRY_CONVERT(DECIMAL(10, 2), LEFT(Average_Views, LEN(Average_Views) - 1)) * 1000 AS BIGINT)
			ELSE TRY_CONVERT(BIGINT, Average_Views)
		END as Average_Views
	FROM 
		dbo.[2024_top_worldwide_youtube_channel]
)


-- 3. 
SELECT
	Channel_Name, 
	Average_Views,
	Average_Views * @conversionRate AS potential_units_sold_per_video,
	Average_Views * @conversionRate * @productCost AS potential_revenue_per_video,
	(Average_Views * @conversionRate * @productCost) - @campaignCost AS net_profit
FROM 
	NoDuplicates


-- 4.
WHERE 
	Channel_Name IN ('T-Series', 'MrBeast', 'Cocomelon - Nursery Rhymes')


-- 5.
ORDER BY 
	net_profit DESC



-- Youtubers with the most average views

/*

1. Define the variables.
2. Create a CTE to convert the Average_Views Column (NVARCHAR) into BIGINT type
3. Select the columns that are required for the analysis.
4. Filter the rsults by the YouTube channels with the highest Average View bases.
5. Order by net_profit (from highest to lowest).

*/


-- 1.
DECLARE @conversionRate FLOAT = 0.02;			-- The conversion rate @ 2%
DECLARE @productCost MONEY = 5.0;				-- The product cost @ $5
DECLARE @campaignCost MONEY = 130000.0;			-- The campaign cost @ $50,000


-- 2.
WITH NoDuplicates AS (
	SELECT 
		Channel_Name,
		CASE
			WHEN RIGHT(Average_Views, 1) = 'M' THEN CAST(TRY_CONVERT(DECIMAL(10, 2), LEFT(Average_Views, LEN(Average_Views) - 1)) * 1000000 AS BIGINT)
			WHEN RIGHT(Average_Views, 1) = 'K' THEN CAST(TRY_CONVERT(DECIMAL(10, 2), LEFT(Average_Views, LEN(Average_Views) - 1)) * 1000 AS BIGINT)
			ELSE TRY_CONVERT(BIGINT, Average_Views)
		END as Average_Views
	FROM 
		dbo.[2024_top_worldwide_youtube_channel]
)


-- 3. 
SELECT
	Channel_Name, 
	Average_Views,
	(Average_Views * @conversionRate) AS potential_units_sold_per_video,
	(Average_Views * @conversionRate * @productCost) AS potential_revenue_per_video,
	(Average_Views * @conversionRate * @productCost) - @campaignCost AS net_profit
FROM 
	NoDuplicates


-- 4.
WHERE 
	Channel_Name IN ('MrBeast', 'Bizarrap', '_vector_')

-- 5.
ORDER BY 
	Average_Views DESC