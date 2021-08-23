/*

Data Exploration on the covid-19 dataset from https://ourworldindata.org/coronavirus (Jan 28,2020 to Aug 15,2021)

Table name
1.covid_death 
2.covid_vaccination 

Frequently used columns
covid_death        -  date, location, population, total_cases, total_deaths 
covid_vaccination  -  total_tests, total_vaccinations

*/

--------------------------------------------------------------------------------------------------------------------------------

-- Filter a seperate table for on "covid_death" for country with Sinovac Approval using view
 
DROP VIEW IF  EXISTS sinovac; 
USE covid ;
GO
CREATE VIEW sinovac
AS
SELECT *
FROM covid_vaccination
WHERE
   location LIKE '%Albania%'
OR location LIKE '%Armenia%'
OR location LIKE '%Azerbaijan%'
OR location LIKE '%Bangladesh%'
OR location LIKE '%Benin%'
OR location LIKE '%Brazil%'
OR location LIKE '%Cambodia%'
OR location LIKE '%Chile%'
OR location LIKE '%China%'
OR location LIKE '%Colombia%'
OR location LIKE '%Dominican Republic%'
OR location LIKE '%Ecuador%'
OR location LIKE '%Egypt%'
OR location LIKE '%El Salvador%'
OR location LIKE '%Georgia%'
OR location LIKE '%Hong Kong%'
OR location LIKE '%Indonesia%'
OR location LIKE '%Kazakhstan%'
OR location LIKE '%Lao%'
OR location LIKE '%Malaysia%'
OR location LIKE '%Mexico%'
OR location LIKE '%Nepal%'
OR location LIKE '%Oman%'
OR location LIKE '%Pakistan%'
OR location LIKE '%Panama%'
OR location LIKE '%Paraguay%'
OR location LIKE '%Philippines%'
OR location LIKE '%South Africa%'
OR location LIKE '%Sri Lanka%'
OR location LIKE '%Tajikistan%'
OR location LIKE '%Thailand%'
OR location LIKE '%Timor%' 
OR location LIKE '%Togo%'
OR location LIKE '%Tunisia%'
OR location LIKE '%Turkey%'
OR location LIKE '%Ukraine%'
OR location LIKE '%Tanzania%'
OR location LIKE '%Uruguay%'
OR location LIKE '%Zimbabwe%'
;
GO

-- Delete Romania

DELETE FROM sinovac WHERE location = 'Romania';

-- Test new view

 SELECT location, convert(bigint,max(population)) from sinovac
GROUP BY location;

 -- Choose wanted column for export

SELECT  date, location, gdp_per_capita, population, people_fully_vaccinated, 
        SUM(CONVERT(BIGINT,new_vaccinations)) OVER (PARTITION BY location ORDER BY location,date ) AS Total_vaccinated
FROM  sinovac
ORDER BY location, date;

 
 