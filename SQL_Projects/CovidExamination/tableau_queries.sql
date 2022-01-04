
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