----prikaz prva 4 reda u tabeli
--SELECT TOP 4 *
--FROM CovidDeaths

--SELECT TOP 4 *
--FROM CovidVaccinations

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM CovidDeaths 
ORDER BY 1,2
	
-- Looking at total cases vs total deaths for all countries 

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS Death_Case_percent
FROM CovidDeaths 
ORDER BY 1,2

-- Looking at total cases vs total deaths for Serbia 

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS Death_Case_percent
FROM CovidDeaths 
WHERE location = 'Serbia'
ORDER BY 1,2

-- Looking at total cases vs population for Serbia 

SELECT location, date, population,  total_cases, (total_cases/population)*100 AS Population_Case_percent
FROM CovidDeaths 
WHERE location = 'Serbia'
ORDER BY 1,2

--looking at countries with highest total cases compared to population

SELECT location, population,  MAX(total_cases) AS HighestTotalCases, MAX((total_cases/population)*100) AS Population_Case_percent
FROM CovidDeaths 
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY Population_Case_percent DESC

--looking at countries with highest death cases compared to population

SELECT location, population,  MAX(CAST(total_deaths as int)) AS MaxDeathCount
FROM CovidDeaths 
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY MaxDeathCount DESC

--looking at continents with highest death cases compared to population

SELECT location, MAX(CAST(total_deaths as int)) AS MaxDeathCount
FROM CovidDeaths 
WHERE continent IS NULL
GROUP BY location
ORDER BY MaxDeathCount DESC

--Global numbers per day
SELECT date, SUM(new_cases) AS TotalCases, SUM(CAST(new_deaths AS int)) AS TotalDeaths, SUM(CAST(new_deaths AS int))/SUM(new_cases)*100 AS DeathPercantage
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1,2

--Global numbers total
SELECT SUM(new_cases) AS TotalCases, SUM(CAST(new_deaths AS int)) AS TotalDeaths, SUM(CAST(new_deaths AS int))/SUM(new_cases)*100 AS DeathPercantage
FROM CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1,2

-- Total Population vs vaccination

WITH PopvsVac (Continent, Date, Location, Population, New_Vaccinations, MaxVaccToDate)
AS
(
SELECT deaths.continent, deaths.date, deaths.location, deaths.population, vaccin.new_vaccinations,
SUM(CAST(vaccin.new_vaccinations AS int)) OVER (PARTITION BY deaths.location ORDER BY deaths.location, deaths.date) AS MaxVaccToDate
FROM CovidDeaths deaths
JOIN CovidVaccinations vaccin
ON deaths.location = vaccin.location
AND deaths.date = vaccin.date
WHERE deaths.continent IS NOT NULL
)
SELECT *, (MaxVaccToDate/Population)*100 AS PercentOfVacPopToDate
FROM PopvsVac

