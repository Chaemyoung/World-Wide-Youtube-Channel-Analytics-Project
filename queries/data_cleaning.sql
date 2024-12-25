/*

# Data cleaning steps

1. Remove unnecessary columns by only selecting the ones we need
2. Extract the YouiTube channel names from the first columns
3. Rename the column names

*/

-- Create a view for powerBI
 create view view_2024_top_worldwide_youtube_channel as

select 
	Rank,
	Channel_Name,
	Category,
	Subscribers as Subscribers_Num,
	Country,
	Average_Views,
	Average_Likes,
	Average_Comments
from dbo.[2024_top_worldwide_youtube_channel]