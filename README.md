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


