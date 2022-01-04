-- TOTAL ROLLING COUNT OF PEOPLE VACCINATED
CREATE VIEW PercentPeopleVaccinated AS
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
;

GO

