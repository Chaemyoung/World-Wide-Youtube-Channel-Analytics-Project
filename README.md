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

