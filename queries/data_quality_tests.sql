/*

# Data quality tests

1. The data needs to be 100 records of Youtube channels (row count tests)
2. THe data needs 8 fields (column count tests)
3. The channel name column must be string format, and the other columns must be numerical data types (data type checks)
4. Each record must be unique in the dataset (duplicate count check)


# The goals for this Tests 

Row count - 1000
Column count - 8

Data types

Rank : Integer
Channel_Name : VARCHAR
Category : VARCHAR
Subscribers_Num : VARCHAR
Country : VARCHAR
Average_Views : VARCHAR
Average_Likes : VARCHAR
Average_Comments : FLOAT

Duplicate count = 0

*/


/*

Test Results:

1. Failed (Exp: 1000, Act: 1045)
2. Passed (Exp: 8, Act: 8)
3. Failed (Exp: Average_Comments-FLOAT, Act: Average_Comments-money)
4. Failed (Exp: 0 duplicate, 45 duplicate data)


*/


select TOP 1000 * 
from view_2024_top_worldwide_youtube_channel


-- 1. Row count check test
select count(*) as num_of_row 
from view_2024_top_worldwide_youtube_channel

-- 2. Column count check test
SELECT COUNT(*) as num_of_column
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'view_2024_top_worldwide_youtube_channel'

-- 3. Data type check test
SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'view_2024_top_worldwide_youtube_channel'


-- 4. Duplicate records check test
SELECT Rank, Channel_Name, Count(*) as duplicate_count
FROM view_2024_top_worldwide_youtube_channel
GROUP BY Channel_Name, Rank
HAVING COUNT(*) > 1
ORDER BY Rank ASC