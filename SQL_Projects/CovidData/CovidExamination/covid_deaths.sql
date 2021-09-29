-- GLOBAL NUMBERS

-- GLOBAL CASES, DEATHS & DEATH PERCENTAGE
-- VIZ 1
SELECT
    SUM(new_cases) AS TotalGlobalCases,
    SUM(new_deaths) AS TotalGlobalDeaths,
    SUM(new_deaths)/SUM(new_cases)*100 AS OverallGlobalDeathPercentage
FROM
    dbo.CovidDeaths
WHERE
    continent IS NOT NULL
ORDER BY
    1,2
;

-- DEATHCOUNT PER CONTINENT
-- VIZ 2
SELECT
    [location],
    MAX(total_deaths) AS TotalDeathCount
FROM
    DBO.CovidDeaths
WHERE
    continent IS NULL
    AND
    [location] NOT IN ('World', 'International', 'European Union')
GROUP BY
    [location]
ORDER BY
    TotalDeathCount DESC
;

-- COUNTRIES WITH HIGHEST INFECTION RATE
-- VIZ 3
SELECT
    [location],
    population,
    MAX(total_cases) AS HighestInfectionCount,
    MAX((total_cases/population))*100 AS InffectedPercentage
FROM
    dbo.CovidDeaths
WHERE
    continent IS NOT NULL
GROUP BY
    [location],
    population
ORDER BY
    InffectedPercentage DESC
;

-- COUNTRIES WITH HIGHEST INFECTION RATE
-- VIZ 4
SELECT
    [location],
    population,
    date,
    MAX(total_cases) AS HighestInfectionCount,
    MAX((total_cases/population))*100 AS InffectedPercentage
FROM
    dbo.CovidDeaths
WHERE
    continent IS NOT NULL
GROUP BY
    [location],
    population,
    [date]
ORDER BY
    InffectedPercentage DESC
;

-- GLOBAL DEATH PERCENTAGE PER DAY
SELECT
    [date],
    SUM(new_cases) AS GlobalCasesPerDay,
    SUM(new_deaths) AS GlobalDeathsPerDay,
    SUM(new_deaths)/SUM(new_cases)*100 AS GlobalDeathPercentagePerDay
FROM
    dbo.CovidDeaths
WHERE
    continent IS NOT NULL
GROUP BY
    [date]
ORDER BY
    1,2
;

-- GLOBAL CASES & DEATHS
SELECT
    [location],
    [date],
    population,
    new_cases,
    total_cases,
    new_deaths,
    total_deaths,
    ([total_deaths]/total_cases)*100 AS DeathPercentage
FROM
    dbo.CovidDeaths
WHERE
    continent IS NOT NULL
ORDER BY
    [location],
    [date]
;

-- EXAMINING RELATIONSHIP BETWEEN TOTAL CASES, HOSPITAL ADMISSIONS
-- ICU ADMISSIONS, TOTAL DEATHS AND DEATH PERCENTAGE
SELECT
    [location],
    population,
    -- [date],
    MAX(total_cases) AS Total_Cases,
    ROUND(AVG(weekly_hosp_admissions),0) AS Average_Weekly_Hospital_Admissions,
    ROUND(MAX(weekly_hosp_admissions), 0) AS Highest_Weekly_Hospital_Admission,
    ROUND(AVG(weekly_icu_admissions), 0) AS Average_Weekly_ICU_Admissions,
    ROUND(MAX(weekly_icu_admissions), 0) AS Highest_Weekly_ICU_Admission,
    MAX(total_deaths) AS Total_Deaths,
    (MAX(total_deaths)/MAX(total_cases))*100 AS DeathPercentage
FROM
    dbo.CovidDeaths
WHERE
    -- [location] LIKE '%Nigeria%' 
    -- AND
    continent IS NOT NULL
    AND
    weekly_hosp_admissions IS NOT NULL
    AND
    weekly_icu_admissions IS NOT NULL
GROUP BY
    [location],
    population
;


-- EXAMINING TOTAL CASES VS POPULATION
-- Percentage of population affected
SELECT
    [location],
    [date],
    population,
    total_cases,
    (total_cases/population)*100 AS InffectedPercentage
FROM
    dbo.CovidDeaths
WHERE
    -- [location] LIKE '%America%'
    -- AND 
    continent IS NOT NULL
ORDER BY
    [location],
    [date]
;

-- COUNTRIES WITH HIGHEST MORTALITY RATE OF INFECTED PERSON
SELECT
    [location],
    population,
    MAX(total_deaths) AS HighestDeathCount,
    MAX(total_cases) AS HighestInfectionCount,
    (MAX([total_deaths])/MAX(total_cases))*100 AS DeathPercentage
FROM
    dbo.CovidDeaths
WHERE
    continent IS NOT NULL
GROUP BY
    [location],
    population
ORDER BY
    [DeathPercentage] DESC
;

-- HIGHEST DEATHCOUNT PER POPULATION
SELECT
    [location],
    population,
    MAX(total_deaths) AS TotalDeathCount
FROM
    DBO.CovidDeaths
WHERE
    continent IS NOT NULL
GROUP BY
    [location],
    population
ORDER BY
    TotalDeathCount DESC
;


-- COMPLETE TABLE USING JOINS
SELECT
    *
FROM
    dbo.CovidVaccinations vac
JOIN
    dbo.CovidDeaths dea
ON
    vac.[location] = dea.[location]
    AND
    vac.[date] = vac.[date]
;

-- TOTAL POPULATION VS NEW VACCINATIONS
SELECT
    dea.continent,
    dea.[location],
    dea.[date],
    dea.population,
    vac.new_vaccinations
FROM
    dbo.CovidVaccinations vac
INNER JOIN
    dbo.CovidDeaths dea
ON
    vac.[location] = dea.[location]
    AND
    vac.[date] = dea.[date]
WHERE
    dea.continent IS NOT NULl
ORDER BY
    1,2,3
;

-- TOTAL ROLLING COUNT OF PEOPLE VACCINATED
-- POPULATION VS NEW VACCINATIONS
SELECT
    dea.continent,
    dea.[location],
    dea.[date],
    dea.population,
    vac.new_vaccinations,
    SUM(vac.new_vaccinations)
    OVER 
    (PARTITION BY 
    dea.location 
    ORDER BY 
    dea.location,
    dea.date
    )
    AS RollingPeopleVaccinated
FROM
    dbo.CovidVaccinations vac
INNER JOIN
    dbo.CovidDeaths dea
ON
    vac.[location] = dea.[location]
    AND
    vac.[date] = dea.[date]
WHERE
    dea.continent IS NOT NULl
ORDER BY
    1,2,3
;

-- 2 Methods To get Rolling Percentage of People Vaccinated
-- WITH CTE
WITH 
    PopvsVac (Continent, Location, Date, Population,New_Vaccination, RollingPeopleVaccinated)
AS
(
    SELECT
    dea.continent,
    dea.[location],
    dea.[date],
    dea.population,
    vac.new_vaccinations,
    SUM(vac.new_vaccinations)
    OVER 
    (PARTITION BY 
    dea.location 
    ORDER BY 
    dea.location,
    dea.date
    )
    AS RollingPeopleVaccinated
FROM
    dbo.CovidVaccinations vac
INNER JOIN
    dbo.CovidDeaths dea
ON
    vac.[location] = dea.[location]
    AND
    vac.[date] = dea.[date]
WHERE
    dea.continent IS NOT NULl
-- ORDER BY
--     1,2,3
)
SELECT
    *,
    (RollingPeopleVaccinated/Population)*100 AS RollingPercentageOfPopulationVaccinated
FROM
    PopvsVac
;

-- ALTERNATIVE METHOD WITH TEMP TABLE
-- Drop a temporary table called '#PercentPeopleVaccinated'
-- Drop the table if it already exists
IF OBJECT_ID('tempDB..#PercentPeopleVaccinated', 'U') IS NOT NULL
DROP TABLE #PercentPeopleVaccinated
GO
-- Create the temporary table from a physical table called 'CovidVaccinations' in schema 'dbo' in database 'PortfolioProjDB'
SELECT
    dea.continent,
    dea.[location],
    dea.[date],
    dea.population,
    vac.new_vaccinations,
    SUM(vac.new_vaccinations)
    OVER 
    (PARTITION BY 
    dea.location 
    ORDER BY 
    dea.location,
    dea.date
    )
    AS RollingPeopleVaccinated
INTO #PercentPeopleVaccinated
FROM
    dbo.CovidVaccinations vac
INNER JOIN
    dbo.CovidDeaths dea
ON
    vac.[location] = dea.[location]
    AND
    vac.[date] = dea.[date]
WHERE
    dea.continent IS NOT NULl
ORDER BY
    1,2,3
SELECT
    *,
    (RollingPeopleVaccinated/Population)*100 AS RollingPercentageOfPopulationVaccinated
FROM
    #PercentPeopleVaccinated

-- CREATING VIEW FOR VISUALIZATIONS

-- HIGHEST DEATHCOUNT PER POPULATION BY CONTINENT
-- CREATE VIEW 
--     GlobalDeathCountPerPopulation 
--     AS
-- SELECT
--     [location],
--     MAX(total_deaths) AS TotalDeathCount
-- FROM
--     DBO.CovidDeaths
-- WHERE
--     continent IS NULL
-- GROUP BY
--     [location]
-- ;

-- -- TOTAL ROLLING COUNT OF PEOPLE VACCINATED
-- CREATE VIEW PercentPeopleVaccinated AS
-- SELECT
--     dea.continent,
--     dea.[location],
--     dea.[date],
--     dea.population,
--     vac.new_vaccinations,
--     SUM(vac.new_vaccinations)
--     OVER 
--     (PARTITION BY 
--     dea.location 
--     ORDER BY 
--     dea.location,
--     dea.date
--     )
--     AS RollingPeopleVaccinated
-- FROM
--     dbo.CovidVaccinations vac
-- INNER JOIN
--     dbo.CovidDeaths dea
-- ON
--     vac.[location] = dea.[location]
--     AND
--     vac.[date] = dea.[date]
-- WHERE
--     dea.continent IS NOT NULl
-- ;

-- CREATE VIEW GlobalDeathPercentageByDay AS
-- SELECT
--     [date],
--     SUM(new_cases) AS GlobalCasesPerDay,
--     SUM(new_deaths) AS GlobalDeathsPerDay,
--     SUM(new_deaths)/SUM(new_cases)*100 AS GlobalDeathPercentagePerDay
-- FROM
--     dbo.CovidDeaths
-- WHERE
--     continent IS NOT NULL
-- GROUP BY
--     [date]
-- ;