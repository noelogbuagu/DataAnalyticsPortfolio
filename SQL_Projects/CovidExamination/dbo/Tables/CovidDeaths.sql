CREATE TABLE [dbo].[CovidDeaths] (
    [iso_code]                           NVARCHAR (50) NULL,
    [continent]                          NVARCHAR (50) NULL,
    [location]                           NVARCHAR (50) NULL,
    [date]                               DATE          NULL,
    [population]                         FLOAT (53)    NULL,
    [total_cases]                        FLOAT (53)    NULL,
    [new_cases]                          FLOAT (53)    NULL,
    [new_cases_smoothed]                 FLOAT (53)    NULL,
    [total_deaths]                       FLOAT (53)    NULL,
    [new_deaths]                         FLOAT (53)    NULL,
    [new_deaths_smoothed]                FLOAT (53)    NULL,
    [total_cases_per_million]            FLOAT (53)    NULL,
    [new_cases_per_million]              FLOAT (53)    NULL,
    [new_cases_smoothed_per_million]     FLOAT (53)    NULL,
    [total_deaths_per_million]           FLOAT (53)    NULL,
    [new_deaths_per_million]             FLOAT (53)    NULL,
    [new_deaths_smoothed_per_million]    FLOAT (53)    NULL,
    [reproduction_rate]                  FLOAT (53)    NULL,
    [icu_patients]                       FLOAT (53)    NULL,
    [icu_patients_per_million]           FLOAT (53)    NULL,
    [hosp_patients]                      FLOAT (53)    NULL,
    [hosp_patients_per_million]          FLOAT (53)    NULL,
    [weekly_icu_admissions]              FLOAT (53)    NULL,
    [weekly_icu_admissions_per_million]  FLOAT (53)    NULL,
    [weekly_hosp_admissions]             FLOAT (53)    NULL,
    [weekly_hosp_admissions_per_million] FLOAT (53)    NULL
);


GO

