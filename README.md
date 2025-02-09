# SSMS-World-Wide-Youtube-Channel-Analytics-Project-Walkthrough
[Watch the Video!](https://www.youtube.com/watch?v=mm_sN-Elplg&amp;t=650s)



# Table of Contents
- [Objective](#objective)
- [Data Source](#data-source)
- [Stages](#stages)
- [Design](#design)
    - [Mockup](#mockup)
    - [Tools](#tools)
- [Development](#development)
    - [Pseudocode](#pseudocode)
    - [Data Exploration](#data-exploration)
    - [Data Cleaning](#data-cleaning)
    - [Transform the Data](#transform-the-data)
    - [Create the SQL View](#create-the-sql-view)
- [Testing](#testing)
    - [Data Quality Tests](#data-quality-tests)
- [Visualization](#visualization)
    - [Results](#results)
    - [Dax Measures](#dax-measures)
- [Recommendations](#recommendations)
    - [Potential ROI](#potential-roi)
    - [Potential Courses of Actions](#potential-courses-of-actions)
- [Conclusion](#conclusion)



# Objective

- To discover the top performing Worldwide Youtubers to form marketing collaborations throughout the year 2025.

## User story

As the Head of Marketing, I want to a dashboard to identify the top Youtubers in the world based on subscriber count videos uploaded and views accumulated, so that I can decide on which channels would be best to run marketing campaigns with to generate a good ROI.

This dashboard should allow me to identify the top performing channels.

The dashboard should include:
- List the top Youtube channels by subscribers, videos and views.
- Display key metrics (channel name, subscribers, videos, views, engagement ratios).
- Be user-friendly and easy to filter/sort.
- Use the most recent data possible.

# Data source

Manager needs the top Youtubers in the world, and the key metrics needed include:
- Subscriber count
- Videos uploaded
- Views
- Average views
- Subscriber engagement ratio
- Views per subscriber

- Where is the data coming from?
The data is sourced from Kaggle (an CSV extract), [Click here to find it!](https://www.kaggle.com/datasets/shiivvvaam/top-youtuber-worldwide)

# Stages

- Design
- Development
- Testing
- Analysis


# Design 

## Dashboard components required
To understand what it should contain, we need to figure out what questions we need the dashboard to answer:

1. Who are the top 10 Youtubers with the most subscribers?
2. Which category of the channels have the most subscribers?
3. Which 10 channel have the hightest average views?
4. What is the engagement rate of a channel?
5. Which category of the channels have the most subscribers?
6. In which countries is each channel active?

For now, these are some of the questions we need to answer, this may change as we progress down our analysis.

## Dashboard

| Tool | Purpose |
| Excel | Exploring the data |
| MS SQL Sever | Cleaning, testing, and analyzing the data |
| Power BI | Visualizing the data via interactive dashboards |
| GitHub | Hosting the project documentation and version control |

# Development

## Pseudocode

This is the general approach to creating a solution from start to finish.

1. Get the data
2. Explore the data in Excel
3. Load the data into MS SQL Server
4. Clean the data with SQL
5. Test the data with SQL
6. Visualize the data using Power BI
7. Generate the findings based on the insights
8. Write the documentation + commentary
9. Publish the data to GitHub

## Data exploration notes

This is the stage where you scan through the data, errors, inconsistencies, bugs, weird, corrupted characters and etc.

- The initial observations with the dataset.

1. There are at least 7 columns that contain the data we need for this analysis, which tells we have everything we need from the file without needing to contact the client for any more data.
2. Last 45 rows were the duplicated rows that are already appeared. Which we need to remove duplicate rows.
3. The columns for average_views, average_likes and average_comments are stored in NVARCHAR with metric prefixes. e.g. 10K, 25M. Which we need to convert them into the numeric value. 
4. In the Category column, there were some NULL values. We need to replace NULL into 'Unkown' to indicate the missing category fields for this analysis.

## Data cleaning
The aim is to refine our dataset to ensure it is structured and ready for analysis.

The cleaned data should meet the following criteria and constraints:
- Only relevant columns should be retained.
- All data types should be appropriate for the contents of each column.
- No column should contain NULL values, indicating complete data for all records.

Below is a table outlining constraints on our cleaned dataset:

| Property          | Description |
| ----------------- | ----------- |
| Number of Rows    | 1000        |
| Number of Columns | 8           |

And here is a tabular representation of the expected schema for the clean data:

| Column Name      | Data Type | Nullable |
| ---------------- | --------- | -------- |
| Rank             | INTEGER   | NO       |
| Channel_Name     | NVARCHAR  | NO       |
| Category         | NVARCHAR  | NO       |
| Subscribers_Num  | BIGINT    | NO       |
| Country          | NVARCHAR  | NO       |
| Average_Views    | BIGINT    | NO       |
| Average_Likes    | BIGINT    | NO       |
| Average_Comments | BIGINT    | NO       |

- The steps are needed to clean and shape the data into the desired format

1. Exclude any duplicate rows.
2. Remove unnecessary columns by only selecting the ones we need.
3. Replace NULL values with a default value.
4. Convert the data type into a appropriate one.

### Transform the data

```sql
/*
# 1. Create a CTE to exclude duplicate rows.
# 2. Select rows needed.
# 3. Replace NULL value with 'Unkown'.
# 4. Convert the data type into a appropriate one for analysis.
*/

-- 1.
WITH NoDuplicates AS (
	SELECT DISTINCT *
	FROM view_2024_top_worldwide_youtube_channel
)

-- 2.
SELECT 
    Rank,
	Channel_Name,

    -- 3.
	ISNULL(Category, 'Unknown') AS Category,
	ISNULL(Country, 'Unknown') AS Country,


    -- 4.
	CAST(TRY_CONVERT(DECIMAL(10, 2), LEFT(Subscribers_Num, LEN(Subscribers_Num) - 1)) * 1000000 AS BIGINT)  AS Subscribers,
	CASE
		WHEN RIGHT(Average_Views, 1) = 'M' THEN CAST(TRY_CONVERT(DECIMAL(10, 2), LEFT(Average_Views, LEN(Average_Views) - 1)) * 1000000 AS BIGINT)
		WHEN RIGHT(Average_Views, 1) = 'K' THEN CAST(TRY_CONVERT(DECIMAL(10, 2), LEFT(Average_Views, LEN(Average_Views) - 1)) * 1000 AS BIGINT)
		ELSE TRY_CONVERT(BIGINT, Average_Views)
	END as Average_Views,
	CASE
		WHEN RIGHT(Average_Likes, 1) = 'M' THEN CAST(TRY_CONVERT(DECIMAL(10, 2), LEFT(Average_Likes, LEN(Average_Likes) - 1)) * 1000000 AS BIGINT)
		WHEN RIGHT(Average_Likes, 1) = 'K' THEN CAST(TRY_CONVERT(DECIMAL(10, 2), LEFT(Average_Likes, LEN(Average_Likes) - 1)) * 1000 AS BIGINT)
		ELSE TRY_CONVERT(BIGINT, Average_Likes)
	END as Average_Likes,
	CAST(Average_Comments AS BIGINT) AS Average_Comments
FROM 
    NoDuplicates

```

# Testing

- Testing data quality and validation checks.

Here are the data quality tests conducted:

## Row count check
### SQL query
```sql
/*
# Count the total number of records (or rows) are in the SQL view.
*/

SELECT COUNT(*) AS num_of_row 
FROM view_2024_top_worldwide_youtube_channel
```
### Output
![Row count check](assets/images/1_row_count_check.png)


## Column count check
### SQL query
```sql
/*
# Count the total number of columns (or fields) are in the SQL view.
*/

SELECT COUNT(*) as num_of_column
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'view_2024_top_worldwide_youtube_channel'
```

### Output
![Column count check](assets/images/2_column_count_check.png)


## Data type check
### SQL query
```sql 
/*
# Check the data types of each column from the view by checking the INFORMATION SCHEMA view.
*/

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'view_2024_top_worldwide_youtube_channel'
```


## Duplicate count check
### SQL query
```sql 
/*
# 1. Check for duplicate rows in the view.
# 2. Group by the channel name.
# 3. Filter for groups with more than one row.
# 4. Order the data by Rank in ascending order.
*/

-- 1.
SELECT Rank, Channel_Name, Count(*) as duplicate_count
FROM view_2024_top_worldwide_youtube_channel

-- 2.
GROUP BY Channel_Name, Rank

-- 3.
HAVING COUNT(*) > 1

-- 4. 
ORDER BY Rank ASC
```


# Visualization

## Results

- The dashboard

![Power BI Dashboard](images/top_worldwide_youtubers_2024.png)

This shows the Top Worldwide Youtuvers in 2024.

## DAX Measures

### EngagementRatio
```sql
EngagementRatio = 
DIVIDE(
    SUM('Cleaned_2024_top_worldwide_youtube_channel'[Average_Likes]) + SUM('Cleaned_2024_top_worldwide_youtube_channel'[Average_Comments]),
    SUM('Cleaned_2024_top_worldwide_youtube_channel'[Subscribers])
)
```


# Analysis

## Findings

- What we found.

For this analysis, we're going to focus on the questions below to get the information we need for our marketing client -

Here are the key questions we need to answer for our marketing client:
1. Who are the top 10 Youtubers with the most subscribers?
2. Which category of the channels have the most subscribers?
3. Which 10 channel have the hightest average views?
4. What is the engagement rate of a channel?
5. Which category of the channels have the most subscribers?
6. In which countries is each channel active?


### 1. Who are the top 10 Youtubers with the most subscribers?
| Rank | Channel_Name                | Subscribers |
|------|----------------------------|--------------|
| 1    | T-Series                   | 258,400,000  |
| 2    | MrBeast                    | 236,100,000  |
| 3    | Cocomelon - Nursery Rhymes | 171,400,000  |
| 4    | SET India                  | 167,100,000  |
| 5    | ✿ Kids Diana Show          | 118,500,000 |
| 6    | Like Nastya                | 112,600,000  |
| 7    | PewDiePie                  | 111,600,000  |
| 8    | Vlad and Niki              | 109,600,000  |
| 9    | Zee Music Company          | 104,500,000  |
| 10   | WWE                        | 99,000,000   |


### 2. Which category of the channels have the most subscribers?
| Rank | Channel_Name                | Category      |
|------|-----------------------------|---------------|
| 1    | T-Series                    | Music & Dance |
| 2    | MrBeast                     | Video games   |
| 3    | Cocomelon - Nursery Rhymes  | Education     |
| 4    | SET India                   | Unknown       |
| 5    | ✿ Kids Diana Show          | Animation     |
| 6    | Like Nastya                 | Toys          |
| 7    | PewDiePie                   | Movies        |
| 8    | Vlad and Niki               | Animation     |
| 9    | Zee Music Company           | Music & Dance |
| 10   | WWE                         | Video games   | 


### 3. Which 10 channel have the highest average views?
| Rank  | Channel_Name                | Average_Views |
|-------|-----------------------------|---------------|
| 1     | MrBeast                     | 104,000,000   |
| 2     | Vlad and Niki               | 5,800,000     |
| 3     | Cocomelon - Nursery Rhymes  | 5,100,000     |
| 4     | ✿ Kids Diana Show          | 5,100,000     |
| 5     | Like Nastya                 | 3,400,000     |
| 6     | PewDiePie                   | 1,700,000     |
| 7     | WWE                         | 182,900       | 
| 8     | T-Series                    | 135,200       |
| 9     | Zee Music Company           | 38,000        |
| 10    | SET India                   | 27,900        |


### 4. Which 10 Category have the most number of total subscribers group by category?
| Rank | Category         | Total_Subscribers_By_Category |
|------|------------------|-------------------------------|
| 1    | Animation        | 2,833,900,000                 |
| 2    | Education        | 625,600,000                   |
| 3    | Daily vlogs      | 612,200,000                   |
| 4    | DIY & Life Hacks | 48,700,000                    |
| 5    | Design/art       | 36,500,000                    |
| 6    | Autos & Vehicles | 29,800,000                    |
| 7    | ASMR             | 29,100,000                    |
| 8    | Beauty           | 23,900,000                    |
| 9    | Animals & Pets   | 15,400,000                    |
| 10   | Fashion          | 14,100,000                    |

### 5. Which 10 Country have the most number of total subscribers?
| Rank | Country       | Total_Subscribers_By_Country |
|------|---------------|------------------------------|
| 1    | India         | 6,349,600,000                |
| 2    | United States | 6,033,200,000                |
| 3    | Unknown       | 4,491,300,000                |
| 4    | Brazil        | 1,252,400,000                |
| 5    | Mexico        | 1,236,700,000                |
| 6    | Indonesia     | 814,800,000                  |
| 7    | Russia        | 449,000,000                  |
| 8    | Thailand      | 370,200,000                  |
| 9    | Colombia      | 293,800,000                  |
| 10   | Philippines   | 284,200,000                  |
| 11   | Pakistan      | 195,100,000                  |

### Notes

For this analysis, we'll prioritize analysing the metrics that are important in generating the expected ROI for our marketing client, which are the YouTube channels with the most:

- Number of subscribers
- Average views per video


## Validation

### 1. Youtubers with the most subscribers

#### Calculation breakdown

Campaign idea = product placement

a. T-Series

- Average views per video =  135,200 
- Product cost = $5
- Potential units sold per video = 135,200 x 2% conversion rate =  2,704 units sold
- Potential revenue per video = 2,704 x $5 = $13,520
- Campaign cost (one-time fee) = $50,000
- **Net Profit = $13,520 - $50,000 = -36,480**


b. MrBeast

- Average views per video = 104,000,000 
- Product cost = $5
- Potential units sold per video =  104,000,000 x 2% conversion rate =   2,080,000 units sold
- Potential revenue per video = 2,080,000 x $5 = $10,400,000 
- Campaign cost (one-time fee) = $50,000
- **Net Profit = $10,400,000 - $50,000 = $10,350,000**


c. Cocomelon - Nursery Rhymes

- Average views per video =  5,100,000 
- Product cost = $5
- Potential units sold per video =  5,100,000 x 2% conversion rate =    102,000 units sold
- Potential revenue per video = 102,000 x $5 = $510,000 
- Campaign cost (one-time fee) = $50,000
- **Net Profit = $510,000 - $50,000 = $460,000**


**Best option from category: MrBeast**


Campaign idea = product placement

#### SQL query

```sql
/*

1. Define the variables.
2. Create a CTE to convert the Average_Views Column (NVARCHAR) into BIGINT type
3. Select the columns that are required for the analysis.
4. Filter the rsults by the YouTube channelswith the highest subscriber bases.
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
FROM NoDuplicates


-- 4.
WHERE Channel_Name IN ('T-Series', 'MrBeast', 'Cocomelon - Nursery Rhymes')


-- 5.
ORDER BY net_profit DESC
```
