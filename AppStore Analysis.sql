Select * from AppleStore
Select * from appleStore_description

--***********************************************EDA***********************************************************
--No of Apps Presents in App Store
Select Count(DISTINCT id) As UniqueApps
From AppleStore

Select Count(DISTINCT id) As UniqueApps
From appleStore_description

--Checking For NULL Values
Select count(*) as MissingValues
from AppleStore
WHERE track_name Is Null OR prime_genre Is Null OR user_rating IS Null 

Select count(*) as MissingValues
from appleStore_description
WHERE track_name Is Null OR size_bytes Is Null OR app_desc IS Null 

--Number of genre Present in the App Store
Select COUNT(DISTINCT prime_genre) As NoOfGenre
From AppleStore


--Number of Apps present in each genre  
Select prime_genre,COUNT(*) As NumOfApps
from AppleStore
Group By prime_genre
Order By NumOfApps desc


--SELECTING USER RATING 
Select  AVG(user_rating)AS AvgRating,
		MAX(user_rating) AS MaxRating,
		MIN(user_rating) As MinRating
From AppleStore

--***********************************************DATA ANALYSIS***********************************************************

--Determining whether paid app have higher rating or Free app has highest rating

SELECT 
		Case
			When price > 0 Then 'Paid App'
			Else 'Free App'
		End as App_Type,
		AVG(user_rating) AS Avg_Rating
FROM AppleStore
Group BY Case
			When price > 0 Then 'Paid App'
			Else 'Free App'
		End

--App Supported with more language has highest rating or not 
SELECT CASE 
		WHEN lang_num < 10 THEN '<10 Languages'
		WHEN lang_num BETWEEN 10 AND 30 THEN '10-30 Language'
		Else '>30 Language'
		End As LanguageCount,
	AVG(user_rating) AS Avg_Rating
FROM AppleStore
GROUP BY CASE 
		WHEN lang_num < 10 THEN '<10 Languages'
		WHEN lang_num BETWEEN 10 AND 30 THEN '10-30 Language'
		Else '>30 Language'
		End
ORDER BY Avg_Rating desc

--Genre With lowest Rating

Select prime_genre,
		Avg(user_rating) As AvgRating
From AppleStore
GROUP BY prime_genre
Order By AvgRating 

--Check For correlation between length of the app and user rating
--Apps Having Higher Description Has Highest Rating
Select  
		CASE 
		WHEN  len(Table2.app_desc) < 500 THEN 'Short'
		WHEN len(Table2.app_desc) BETWEEN 500 AND 1000 THEN 'Medium'
		ELSE 'Long'
		End As Description_length,
		AVG(Table1.user_rating) AS AvgRating
From AppleStore AS Table1
Join appleStore_description As Table2
On Table1.id= Table2.id
Group By CASE 
		WHEN  len(Table2.app_desc) < 500 THEN 'Short'
		WHEN len(Table2.app_desc) BETWEEN 500 AND 1000 THEN 'Medium'
		ELSE 'Long'
		End 
Order BY AvgRating Desc

--Top Rated App For Each Genre
SELECT prime_genre,track_name,user_rating
FROM (
SELECT prime_genre,track_name,user_rating,RANK() OVER (PARTITION BY prime_genre ORDER BY user_rating Desc, rating_count_tot DESC) AS Ranking
From AppleStore
) As Table1
Where Table1.Ranking=1



