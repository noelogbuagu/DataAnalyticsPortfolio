CREATE TABLE [dbo].[hourlyIntensities] (
    [Id]               VARCHAR (50)  NOT NULL,
    [ActivityHour]     DATETIME2 (7) NULL,
    [TotalIntensity]   TINYINT       NULL,
    [AverageIntensity] FLOAT (53)    NULL
);


GO

