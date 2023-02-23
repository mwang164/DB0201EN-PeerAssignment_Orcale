/*
1. Socioeconomic Indicators in Chicago

This dataset contains a selection of six socioeconomic indicators of public health significance and a “hardship index,” for each Chicago community area, for the years 2008 – 2012.

2. Chicago Public Schools

This dataset shows all school level performance data used to create CPS School Report Cards for the 2011-2012 school year. This dataset is provided by the city of Chicago's Data Portal.

3. Chicago Crime Data

This dataset reflects reported incidents of crime (with the exception of murders where data exists for each victim) that occurred in the City of Chicago from 2001 to present, minus the most recent seven days.

**CENSUS_DATA**
**CHICAGO_PUBLIC_SCHOOLS**
**CHICAGO_CRIME_DATA**
*/



--### Problem 1
--#### Find the total number of crimes recorded in the CRIME table.
SELECT COUNT(*)
FROM CHICAGO_CRIME_DATA;

--### Problem 2
--#### List community areas with per capita income less than 11000.
SELECT community_area_name, per_capita_income
FROM CENSUS_DATA
WHERE per_capita_income < 11000;

--### Problem 3
--#### List all case numbers for crimes  involving minors?
--     (children are not considered minors for the purposes of crime analysis)
SELECT case_number, description
FROM CHICAGO_CRIME_DATA
Where description LIKE '%MINOR%';

--### Problem 4
--##### List all kidnapping crimes involving a child?
SELECT *
FROM CHICAGO_CRIME_DATA
Where primary_type = 'KIDNAPPING'
AND description LIKE '%CHILD%';

--### Problem 5
--##### What kinds of crimes were recorded at schools?
SELECT DISTINCT primary_type
FROM CHICAGO_CRIME_DATA
Where location_description LIKE '%SCHOOL%';

--### Problem 6
--##### List the average safety score for each type of school.
SELECT school_type, AVG(safety_score)
FROM CHICAGO_PUBLIC_SCHOOLS
GROUP BY school_type;

--### Problem 7
--##### List 5 community areas with highest % of households below poverty line
SELECT community_area_name, percent_households_below_poverty
FROM CENSUS_DATA
ORDER BY percent_households_below_poverty DESC
FETCH FIRST 5 ROWS ONLY;

--### Problem 8
--##### Which community area is most crime prone?
SELECT census.community_area_name, COUNT(*) AS "Crime Count"
FROM CHICAGO_CRIME_DATA crime JOIN CENSUS_DATA census
    ON crime.community_area_number = census.community_area_number
GROUP BY crime.community_area_number, census.community_area_name
ORDER BY COUNT(*) DESC
FETCH FIRST 1 ROWS ONLY;

--### Problem 9
--##### Use a sub-query to find the name of the community area with highest hardship index
SELECT community_area_name, hardship_index
FROM CENSUS_DATA
WHERE hardship_index = (
 SELECT MAX(hardship_index) 
FROM CENSUS_DATA);

--### Problem 10
--##### Use a sub-query to determine the Community Area Name with most number of crimes?
SELECT d.community_area_name, c.crime_count
FROM (
SELECT community_area_number, COUNT(*) AS crime_count
FROM CHICAGO_CRIME_DATA
GROUP BY community_area_number
ORDER BY COUNT(*) DESC
) c JOIN CENSUS_DATA d
    ON c.community_area_number = d.community_area_number
FETCH FIRST 1 ROWS ONLY;