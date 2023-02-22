/* SQL Data Exploration Portfolio Project 
Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types
*/

SELECT*
FROM project-1-366402.Covid.Deaths
WHERE continent IS NOT NULL
ORDER BY 3,4;

SELECT*
FROM project-1-366402.Covid.Vaccinations
WHERE continent IS NOT NULL
ORDER BY 3,4;

----------------------------------------------------------------------

/* Select Data that we are starting with */

SELECT
  location,
  date, 
  total_cases,
  new_cases, 
  total_deaths, 
  population
FROM project-1-366402.Covid.Deaths
WHERE continent IS NOT NULL
ORDER BY 1,2;

----------------------------------------------------------------------

/* Total cases Vs. Total deaths */
--Shows the likelihood of dying if you contracted Covid in your country

SELECT 
  location, 
  date, 
  total_cases, 
  total_deaths, 
  (total_deaths/total_cases)*100 AS Death_Percentage

FROM project-1-366402.Covid.Deaths
WHERE 
  location = 'United States'
  AND continent IS NOT NULL
ORDER BY 1,2;

----------------------------------------------------------------------

/* Total_cases Vs. Population */
--Shows the percentage of population that contracted Covid

SELECT 
  location, 
  date, 
  total_cases, 
  population, 
  (total_cases/population)*100 AS Infected_Population_Percentage

FROM project-1-366402.Covid.Deaths
WHERE continent IS NOT NULL
ORDER BY 1,2;

----------------------------------------------------------------------

/* Countries with Highest Infection Rate compared to Population */

SELECT
  location,
  population,
  MAX(total_cases) AS Highest_Infection_Count,  
  MAX((total_cases/population)*100) AS Infected_Population_Percentage
FROM project-1-366402.Covid.Deaths
WHERE continent IS NOT NULL
GROUP BY Location, Population
ORDER BY Infected_Population_Percentage DESC;

----------------------------------------------------------------------

/* Countries with the Highest Death Count */

SELECT
  location,
  MAX(total_deaths) AS Total_Death_Count
FROM project-1-366402.Covid.Deaths
WHERE continent IS NOT NULL
GROUP BY Location
ORDER BY Total_Death_Count DESC;

----------------------------------------------------------------------

/* Continents with Highest Death Count */

SELECT
  continent,
  MAX(total_deaths) AS Total_Death_Count
FROM project-1-366402.Covid.Deaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY Total_Death_Count DESC;

----------------------------------------------------------------------

/* Global Numbers */

SELECT
  SUM(new_deaths) AS total_deaths,
  SUM(new_cases) AS total_cases,
  SUM(new_deaths)/SUM(new_cases) *100 AS Death_Percentage
FROM project-1-366402.Covid.Deaths
WHERE continent IS NOT NULL
ORDER BY Death_Percentage;

----------------------------------------------------------------------

/* Total Population Vs.Vaccinations */
--Shows percentage of Population that has received atleast one Covid Vaccine

SELECT
  CD.continent,
  CD.location,
  CD.date,
  CD.population,
  CV.new_vaccinations,
  SUM(CV.new_vaccinations) OVER (PARTITION BY CD.location ORDER BY CD.location, CD.date) AS RollingPeopleVaccinated
FROM project-1-366402.Covid.Deaths AS CD
JOIN project-1-366402.Covid.Vaccinations AS CV
  ON CD.location = CV.location
  AND CD.date = CV.date
WHERE CD.continent IS NOT NULL
ORDER BY 2,3;

----------------------------------------------------------------------

/* Total Population Vs.Vaccinations */
--Using CTE to perform Calculation on Partition By in previous query

WITH PopVsVac AS
(
SELECT
  CD.continent,
  CD.location,
  CD.date,
  CD.population,
  CV.new_vaccinations,
  SUM(CV.new_vaccinations) OVER (PARTITION BY CD.location ORDER BY CD.location, CD.date) AS RollingPeopleVaccinated
FROM project-1-366402.Covid.Deaths AS CD
JOIN project-1-366402.Covid.Vaccinations AS CV
  ON CD.location = CV.location
  AND CD.date = CV.date
WHERE CD.continent IS NOT NULL
ORDER BY 2,3
)
SELECT
  *,
  (RollingPeopleVaccinated/population)*100
FROM PopVsVac;

----------------------------------------------------------------------

/* Total Population Vs.Vaccinations */
--Using Temp Table to perform Calculation on Partition By in previous query

CREATE OR REPLACE TABLE project-1-366402.Covid.PercentPopVac AS 
(
SELECT
  CD.continent,
  CD.location,
  CD.date,
  CD.population,
  CV.new_vaccinations,
  SUM(CV.new_vaccinations) OVER (PARTITION BY CD.location ORDER BY CD.location, CD.date) AS RollingPeopleVaccinated
FROM project-1-366402.Covid.Deaths AS CD
JOIN project-1-366402.Covid.Vaccinations AS CV
  ON CD.location = CV.location
  AND CD.date = CV.date
WHERE CD.continent IS NOT NULL
ORDER BY 2,3
);

SELECT
  *,
  (RollingPeopleVaccinated/population)*100 AS PercentPopVac
FROM project-1-366402.Covid.PercentPopVac;

DROP TABLE project-1-366402.Covid.PercentPopVac;

----------------------------------------------------------------------

--Create View to store data for later visualizations

CREATE OR REPLACE VIEW project-1-366402.Covid.PopVsVac AS
(
SELECT
  CD.continent,
  CD.location,
  CD.date,
  CD.population,
  CV.new_vaccinations,
  SUM(CV.new_vaccinations) OVER (PARTITION BY CD.location ORDER BY CD.location, CD.date) AS RollingPeopleVaccinated
FROM project-1-366402.Covid.Deaths AS CD
JOIN project-1-366402.Covid.Vaccinations AS CV
  ON CD.location = CV.location
  AND CD.date = CV.date
WHERE CD.continent IS NOT NULL
ORDER BY 2,3
);

SELECT
  *,
  (RollingPeopleVaccinated/population)*100 AS PercentPopVac
FROM project-1-366402.Covid.PopVsVac;

DROP VIEW Covid.PopVsVac;

