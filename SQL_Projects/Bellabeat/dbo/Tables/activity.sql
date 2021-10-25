CREATE TABLE [dbo].[activity] (
    [Id]                       FLOAT (53)   NULL,
    [ActivityDate]             DATE         NULL,
    [TotalSteps]               INT          NULL,
    [TotalDistance]            FLOAT (53)   NULL,
    [TrackerDistance]          FLOAT (53)   NULL,
    [LoggedActivitiesDistance] VARCHAR (50) NULL,
    [VeryActiveDistance]       FLOAT (53)   NULL,
    [ModeratelyActiveDistance] FLOAT (53)   NULL,
    [LightActiveDistance]      FLOAT (53)   NULL,
    [SedentaryActiveDistance]  FLOAT (53)   NULL,
    [VeryActiveMinutes]        TINYINT      NULL,
    [FairlyActiveMinutes]      TINYINT      NULL,
    [LightlyActiveMinutes]     SMALLINT     NULL,
    [SedentaryMinutes]         SMALLINT     NULL,
    [Calories]                 SMALLINT     NULL
);


GO

