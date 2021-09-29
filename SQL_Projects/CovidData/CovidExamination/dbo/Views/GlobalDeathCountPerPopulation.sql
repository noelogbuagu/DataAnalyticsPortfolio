CREATE VIEW GlobalDeathCountPerPopulation AS
SELECT
    [location],
    MAX(total_deaths) AS TotalDeathCount
FROM
    DBO.CovidDeaths
WHERE
    continent IS NULL
GROUP BY
    [location]
-- ORDER BY
--     TotalDeathCount DESC
;

GO

