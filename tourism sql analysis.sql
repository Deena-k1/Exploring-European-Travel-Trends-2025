##top countries by season and how many tourists visit them:

SELECT 
    Season_of_Visit,
    Country_Visited,
    COUNT(Tourist_ID) AS Tourist_Count
FROM travel_data
GROUP BY Season_of_Visit, Country_Visited
ORDER BY Season_of_Visit, Tourist_Count DESC;

##popular countries for travel
SELECT 
    Country_Visited,
    COUNT(DISTINCT Tourist_ID) AS Number_of_Tourists
FROM travel_data
GROUP BY Country_Visited
ORDER BY Number_of_Tourists DESC;
  -- Limit to top 5 most popular countries

## popular modes of transport for those countries
SELECT 
    Country_Visited,
    Mode_of_Travel,
    COUNT(*) AS Travel_Count
FROM travel_data
WHERE Country_Visited IN ('Greece', 'Portugal', 'Germany', 'Switzerland', 'Austria')  -- Replace with top countries from Step 1
GROUP BY Country_Visited, Mode_of_Travel
ORDER BY Country_Visited, Travel_Count DESC;

##how does group size impacts both mode of transport and accommodation preferences

SELECT 
    Number_of_Companions,
    Mode_of_Travel,
    Accommodation_Type,
    COUNT(*) AS Preference_Count
FROM travel_data
GROUP BY Number_of_Companions, Mode_of_Travel, Accommodation_Type
ORDER BY Number_of_Companions, Preference_Count DESC;

##average travel costs by country and mode of transport.

SELECT 
    Country_Visited, 
    Mode_of_Travel,
    ROUND(AVG(Total_Travel_Cost), 2) AS Avg_Travel_Cost
FROM travel_data
GROUP BY Country_Visited, Mode_of_Travel
ORDER BY Avg_Travel_Cost DESC;
#+

SELECT 
    Country_Visited,
    AVG(Total_Travel_Cost / (Number_of_Companions + 1)) AS Avg_Travel_Cost_Per_Person
FROM travel_data
WHERE Country_Visited IN ('Greece', 'Portugal', 'Germany', 'Switzerland', 'Austria')  -- Filter for top countries if needed
GROUP BY Country_Visited
ORDER BY Country_Visited, Avg_Travel_Cost_Per_Person DESC;




##variation of costs by season
SELECT 
    Season_of_Visit, 
    AVG(Total_Travel_Cost / (Number_of_Companions +1)) AS Avg_Travel_Cost_Person
FROM travel_data
WHERE Season_of_Visit IN ('Spring', 'Summer', 'Fall', 'Winter')
GROUP BY Season_of_Visit
ORDER BY Avg_Travel_Cost_Person DESC;

##costs by both accommodation type and mode of transport.
SELECT 
    Accommodation_Type, 
    AVG(Total_Travel_Cost / (Number_of_Companions + 1 )) AS Avg_Travel_Cost
FROM travel_data
WHERE Accommodation_Type IN ('Hotel', 'Camping', 'Hostel', 'Airbnb')
GROUP BY Accommodation_Type
ORDER BY Avg_Travel_Cost DESC;

##how group size and travel costs are influenced 
##by the purpose of travel (business, leisure, etc.)

SELECT 
    Main_Purpose, 
    Number_of_Companions, 
    ROUND(AVG(Total_Travel_Cost), 2) AS Avg_Travel_Cost,
    COUNT(*) AS Group_Size_Count
FROM travel_data
GROUP BY Main_Purpose, Number_of_Companions
ORDER BY Main_Purpose, Number_of_Companions;

#avg group size by country of travel 
SELECT DISTINCT Country_Visited
FROM travel_data;

SELECT 
    Country_Visited,
    AVG(Number_of_Companions + 1) AS Avg_Group_Size
FROM travel_data
WHERE Country_Visited IN ('Uk','Spain', 'Italy', 'Netherlands', 'France','Greece', 'Portugal', 'Germany', 'Switzerland', 'Austria')  -- Filter for top countries if needed
GROUP BY Country_Visited
ORDER BY Avg_Group_Size DESC;


##does group size influence travel preferences (transport, accommodation) in specific countries
SELECT 
    Country_Visited,
    Number_of_Companions,
    Mode_of_Travel,
    Accommodation_Type,
    COUNT(*) AS Preference_Count
FROM travel_data
GROUP BY Country_Visited, Number_of_Companions, Mode_of_Travel, Accommodation_Type
ORDER BY Country_Visited, Number_of_Companions;

##destination popularity by season
WITH RankedCountries AS (
    SELECT 
        Season_of_Visit,
        Country_Visited,
        COUNT(Tourist_ID) AS Tourist_Count,
        RANK() OVER (PARTITION BY Season_of_Visit ORDER BY COUNT(Tourist_ID) DESC) AS rank_position
    FROM travel_data
    GROUP BY Season_of_Visit, Country_Visited
)
SELECT 
    Season_of_Visit,
    Country_Visited,
    Tourist_Count
FROM RankedCountries
WHERE rank_position <= 2
ORDER BY Season_of_Visit, Tourist_Count DESC;

