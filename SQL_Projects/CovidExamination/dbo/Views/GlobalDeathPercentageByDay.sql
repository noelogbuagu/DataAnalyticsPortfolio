CREATE VIEW GlobalDeathPercentageByDay AS
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
;

GO

