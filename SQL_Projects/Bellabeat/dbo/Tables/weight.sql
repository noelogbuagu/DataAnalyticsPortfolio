CREATE TABLE [dbo].[weight] (
    [Id]             FLOAT (53)    NOT NULL,
    [Date]           DATETIME2 (7) NULL,
    [WeightKg]       FLOAT (53)    NULL,
    [WeightPounds]   FLOAT (53)    NULL,
    [Fat]            TINYINT       NULL,
    [BMI]            FLOAT (53)    NULL,
    [IsManualReport] BIT           NULL,
    [LogId]          FLOAT (53)    NULL
);


GO

