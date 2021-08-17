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

-- Case Fatality Rate, CFR (Confirmed death per case) sequential.

SELECT date, location, total_deaths, total_cases, (total_deaths/total_cases)*100  as CFR
FROM covid_death
--WHERE location = 'Thailand'
ORDER BY location,date;

-- Ranking the avg CFR (Confirmed death per case) at the latest date. (Aug 15,2021)

SELECT MAX(date), location , AVG(case_fatality_rate) AS CFR
FROM(
    SELECT date , location, (total_deaths/total_cases)*100 AS case_fatality_rate
    FROM covid_death
    WHERE continent is not NULL --REMOVED CONTINENT
    ) case_fatality_rate
GROUP BY  location
ORDER BY  CFR DESC;

--------------------------------------------------------------------------------------------------------------------------------

--  Death Rate, DR (Confirmed death per Population) sequential.

SELECT date, location, total_deaths, total_cases, (total_deaths/population)*100  as DR
FROM covid_death
--WHERE location = 'Thailand'
ORDER BY location,date;

-- Ranking the Death Rate, DR (Confirmed death per Population) at the latest date. (Aug 15,2021)

SELECT MAX(date), location, population ,AVG(death_rate) AS DR
FROM(
    SELECT date , location, population, (total_deaths/population)*100 AS death_rate
    FROM covid_death
    WHERE continent is not NULL
    ) death_rate
GROUP BY  location, population
ORDER BY  DR DESC;

--------------------------------------------------------------------------------------------------------------------------------

--  Infection Rate, IR (Confirmed case per Population) sequential.

SELECT date, location, total_deaths, total_cases, (total_cases/population)*100  as IR
FROM covid_death
--WHERE location = 'Thailand
ORDER BY location,date;

-- Ranking the Infection Rate, IR (Confirmed case per Population) at the latest date. (Aug 15,2021)

SELECT MAX(date), location, population ,AVG(infection_rate) AS IR
FROM(
    SELECT date , location, population, (total_cases/population)*100 AS infection_rate
    FROM covid_death
    WHERE continent is not NULL
    ) infection_rate
GROUP BY  location, population
ORDER BY  IR DESC;

--------------------------------------------------------------------------------------------------------------------------------

-- Total death by Country

SELECT location, SUM(cast(new_deaths as int)) AS total_deaths
FROM covid_death
WHERE continent is not NULL
GROUP BY location
ORDER BY total_deaths DESC;

-- Total death by Continent

SELECT continent, MAX(cast(total_deaths as int)) AS total_deaths
FROM covid_death
WHERE continent is not NULL 
GROUP BY continent
ORDER BY total_deaths DESC;

-- Total death globally

SELECT location, 
       MAX(total_cases) AS Total_cases, 
       MAX(CAST(total_deaths AS int)) AS Total_deaths, 
       MAX(CAST(total_deaths AS int))/MAX(total_cases)*100 AS case_fatality_rate
FROM covid_death
WHERE location = 'World'
GROUP BY location;

--------------------------------------------------------------------------------------------------------------------------------

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

-- Case Fatality Rate, CFR (Confirmed death per case) sequential.

SELECT date, location, total_deaths, total_cases, (total_deaths/total_cases)*100  as CFR
FROM covid_death
--WHERE location = 'Thailand'
ORDER BY location,date;

-- Ranking the avg CFR (Confirmed death per case) at the latest date. (Aug 15,2021)

SELECT MAX(date), location , AVG(case_fatality_rate) AS CFR
FROM(
    SELECT date , location, (total_deaths/total_cases)*100 AS case_fatality_rate
    FROM covid_death
    WHERE continent is not NULL --REMOVED CONTINENT
    ) case_fatality_rate
GROUP BY  location
ORDER BY  CFR DESC;

--------------------------------------------------------------------------------------------------------------------------------

--  Death Rate, DR (Confirmed death per Population) sequential.

SELECT date, location, total_deaths, total_cases, (total_deaths/population)*100  as DR
FROM covid_death
--WHERE location = 'Thailand'
ORDER BY location,date;

-- Ranking the Death Rate, DR (Confirmed death per Population) at the latest date. (Aug 15,2021)

SELECT MAX(date), location, population ,AVG(death_rate) AS DR
FROM(
    SELECT date , location, population, (total_deaths/population)*100 AS death_rate
    FROM covid_death
    WHERE continent is not NULL
    ) death_rate
GROUP BY  location, population
ORDER BY  DR DESC;

--------------------------------------------------------------------------------------------------------------------------------

--  Infection Rate, IR (Confirmed case per Population) sequential.

SELECT date, location, total_deaths, total_cases, (total_cases/population)*100  as IR
FROM covid_death
--WHERE location = 'Thailand
ORDER BY location,date;

-- Ranking the Infection Rate, IR (Confirmed case per Population) at the latest date. (Aug 15,2021)

SELECT MAX(date), location, population ,AVG(infection_rate) AS IR
FROM(
    SELECT date , location, population, (total_cases/population)*100 AS infection_rate
    FROM covid_death
    WHERE continent is not NULL
    ) infection_rate
GROUP BY  location, population
ORDER BY  IR DESC;

--------------------------------------------------------------------------------------------------------------------------------

-- Total death by Country

SELECT location, SUM(cast(new_deaths as int)) AS total_deaths
FROM covid_death
WHERE continent is not NULL
GROUP BY location
ORDER BY total_deaths DESC;

-- Total death by Continent

SELECT continent, MAX(cast(total_deaths as int)) AS total_deaths
FROM covid_death
WHERE continent is not NULL 
GROUP BY continent
ORDER BY total_deaths DESC;

-- Total death globally

SELECT location, 
       MAX(total_cases) AS Total_cases, 
       MAX(CAST(total_deaths AS int)) AS Total_deaths, 
       MAX(CAST(total_deaths AS int))/MAX(total_cases)*100 AS case_fatality_rate
FROM covid_death
WHERE location = 'World'
GROUP BY location;

--------------------------------------------------------------------------------------------------------------------------------

-- Total Population vs Vaccinations
/* Using sub-queries */

SELECT continent, location, date, population, total_cases, total_deaths, RollingPeopleVaccinated,
       (RollingPeopleVaccinated/population)*100 AS Vaccinated_Rate
FROM
    (
    SELECT dea.continent, dea.location, dea.date, dea.population, dea.total_cases, dea.total_deaths, 
        SUM(CONVERT(INT,vac.new_vaccinations)) OVER (PARTITION By dea.location ORDER BY vac.location, dea.Date) AS RollingPeopleVaccinated
    FROM covid_death dea INNER JOIN covid_vaccination vac 
    ON (dea.location = vac.location AND dea.date = vac.date)
    WHERE dea.continent IS NOT NULL
    AND dea.location = 'Thailand'
    ) pop_vac
ORDER BY date DESC

/* CTE */

With pop_vac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
AS
    (
    SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
    , SUM(CONVERT(INT,vac.new_vaccinations)) OVER (PARTITION BY dea.Location ORDER BY dea.location, dea.Date) AS RollingPeopleVaccinated
    --, (RollingPeopleVaccinated/population)*100
    FROM covid_death dea
    JOIN covid_vaccination vac
    ON ( dea.location = vac.location AND dea.date = vac.date )
    WHERE dea.continent IS NOT NULL
    )
SELECT *, (RollingPeopleVaccinated/Population)*100
FROM pop_vac
WHERE location =  'Thailand'
ORDER BY date DESC;

--------------------------------------------------------------------------------------------------------------------------------

-- Generate a temporary table to store previous query

DROP TABLE IF EXISTS vaccinated_rate;
CREATE TABLE vaccinated_rate
    (
    Continent nvarchar(255),
    Location nvarchar(255),
    Date datetime,
    Population numeric,
    Total_Cases numeric,
    Total_deaths numeric,
    RollingPeopleVaccinated numeric,
    Vaccinated_rate numeric
    )

INSERT INTO vaccinated_rate
    SELECT continent, location, date, population, total_cases, total_deaths, RollingPeopleVaccinated,
        (RollingPeopleVaccinated/population)*100 AS Vaccinated_Rate
    FROM
        (
        SELECT dea.continent, dea.location, dea.date, dea.population, dea.total_cases, dea.total_deaths, 
            SUM(CONVERT(INT,vac.new_vaccinations)) OVER (PARTITION By dea.location ORDER BY vac.location, dea.Date) AS RollingPeopleVaccinated
        FROM covid_death dea INNER JOIN covid_vaccination vac 
        ON (dea.location = vac.location AND dea.date = vac.date)
        WHERE dea.continent IS NOT NULL
        ) pop_vac
    ORDER BY date DESC;

-- Test new table
SELECT *
FROM vaccinated_rate
WHERE location = 'Thailand';

--------------------------------------------------------------------------------------------------------------------------------

 