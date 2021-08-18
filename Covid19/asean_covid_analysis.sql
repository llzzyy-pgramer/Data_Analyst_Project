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

-- Filter a seperate table for on "covid_death" for ASEAN countries using view
 
DROP VIEW IF  EXISTS asean_death; 
USE covid ;
GO
CREATE VIEW asean_death
AS
SELECT *
FROM covid_death
WHERE iso_code = 'BRN'
OR    iso_code = 'KHM'
OR    iso_code = 'IDN'
OR    iso_code = 'LAO'
OR    iso_code = 'MYS'
OR    iso_code = 'PHI'
OR    iso_code = 'THA'
OR    iso_code = 'SGP'
OR    iso_code = 'VNM' ;
GO

-- Test new view

SELECT location, population ,MAX(CAST(total_deaths AS INT)) AS Total_death, MAX(CAST(total_deaths AS INT))/population*100 AS death_rate
FROM asean_death 
GROUP BY location,population
ORDER BY death_rate DESC

-- Filter a seperate table for on "covid_vaccination" for ASEAN countries using view

DROP VIEW IF  EXISTS asean_vaccination;
USE covid ;
GO
CREATE VIEW asean_vaccination
AS
SELECT *
FROM covid_vaccination
WHERE iso_code = 'BRN'
OR    iso_code = 'KHM'
OR    iso_code = 'IDN'
OR    iso_code = 'LAO'
OR    iso_code = 'MYS'
OR    iso_code = 'PHI'
OR    iso_code = 'THA'
OR    iso_code = 'SGP'
OR    iso_code = 'VNM' ;
GO

-- Test new view

SELECT location, population ,MAX(CAST( people_fully_vaccinated AS INT)) AS Total_vaccinated, MAX(CAST(people_fully_vaccinated AS INT))/population*100 AS fully_vaccinated_rate
FROM asean_vaccination 
GROUP BY location,population
ORDER BY fully_vaccinated_rate DESC

select * from asean_vaccination;
select * from asean_death;

 