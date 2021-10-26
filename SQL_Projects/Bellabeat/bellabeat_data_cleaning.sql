-- DATA CLEANING


-- preparing weight dataset
SELECT 
    *
FROM 
    [dbo].[weight]
GO
-- making changes permanent
ALTER TABLE 
    [dbo].[weight]
ADD 
    [new_Date] DATE,
    new_time TIME,
    weekday VARCHAR(50)
GO

UPDATE 
    [dbo].weight
SET
    new_Date = CONVERT(date, [Date]),
    new_time = CONVERT(time, [Date]),
    weekday = DATENAME(WEEKDAY, [Date])
GO
-- Drop redundant columns
ALTER TABLE 
    [dbo].[weight]
DROP 
    COLUMN [Date],
    COLUMN WeightPounds,
    COLUMN IsManualReport,
    COLUMN LogId
GO


-- Preparing sleep dataset
SELECT 
    * 
FROM 
    [dbo].sleep
GO
-- making changes permanent
ALTER TABLE 
    dbo.sleep
ADD 
    [new_Date] DATE, 
    weekday VARCHAR(50)
GO

UPDATE 
    [dbo].sleep
SET
    new_Date = CONVERT(date, SleepDay),
    weekday = DATENAME(WEEKDAY, SleepDay)
GO
-- Drop redundant columns
ALTER TABLE 
    [dbo].[sleep]
DROP 
    COLUMN [totalsleeprecords],
    COLUMN sleepday
GO


-- Preparing hourlySteps dataset
SELECT 
    *
FROM
    [dbo].[hourlySteps]
GO
-- making changes permanent
ALTER TABLE 
    [dbo].[hourlySteps]
ADD 
    [new_Date] DATE, 
    hour TIME,
    weekday VARCHAR(50)
GO

UPDATE 
    [dbo].hourlySteps
SET
    new_Date = CONVERT(date, [ActivityHour]),
    hour = CONVERT(time, [ActivityHour]),
    weekday = DATENAME(WEEKDAY, [ActivityHour])
GO
-- Drop redundant columns
ALTER TABLE 
    [dbo].[hourlySteps]
DROP 
    COLUMN [ActivityHour]
GO


--  Preparing hourlyIntensities dataset
SELECT 
    *
FROM 
    [dbo].[hourlyIntensities]
GO
-- making changes permanent
ALTER TABLE 
    [dbo].[hourlyIntensities]
ADD 
    [new_Date] DATE, 
    hour TIME,
    weekday VARCHAR(50)
GO

UPDATE 
    [dbo].hourlyIntensities
SET
    new_Date = CONVERT(date, [ActivityHour]),
    hour = CONVERT(time, [ActivityHour]),
    weekday = DATENAME(WEEKDAY, [ActivityHour])
GO
-- Drop redundant columns
ALTER TABLE 
    [dbo].[hourlyIntensities]
DROP 
    COLUMN [ActivityHour]
GO


--  Preparing hourlyCalories dataset
SELECT 
    *
FROM 
    [dbo].[hourlyCalories]
GO
-- making changes permanent
ALTER TABLE 
    [dbo].[hourlyCalories]
ADD 
    [new_Date] DATE, 
    hour TIME,
    weekday VARCHAR(50)
GO

UPDATE 
    [dbo].hourlyCalories
SET
    new_Date = CONVERT(date, [ActivityHour]),
    hour = CONVERT(time, [ActivityHour]),
    weekday = DATENAME(WEEKDAY, [ActivityHour])
GO
-- Drop redundant columns
ALTER TABLE 
    [dbo].[hourlyCalories]
DROP 
    COLUMN [ActivityHour]
GO


-- Preparing activity dataset
SELECT 
    *
FROM 
    [dbo].[activity]
GO
-- making changes permanent
ALTER TABLE 
    [dbo].[activity]
ADD 
    [new_Date] DATE, 
    weekday VARCHAR(50),
    total_mins INT
GO

UPDATE 
    [dbo].activity
SET
    new_Date = CONVERT(date, [ActivityDate]),
    weekday = DATENAME(WEEKDAY, [ActivityDate]),
    total_mins = VeryActiveMinutes + FairlyActiveMinutes + LightlyActiveMinutes + SedentaryMinutes
GO
-- Drop redundant columns
ALTER TABLE 
    [dbo].[activity]
DROP 
    COLUMN [ActivityDate],
    COLUMN [trackerdistance],
    COLUMN [loggedactivitiesdistance],
    COLUMN [sedentaryactivedistance]
GO


-- Preparing heartrate dataset
SELECT 
    * 
FROM 
    [dbo].[heartrate]
GO
-- making changes permanent
ALTER TABLE 
    [dbo].[heartrate]
ADD 
    [new_Date] DATE, 
    new_time TIME,
    weekday VARCHAR(50)
GO

UPDATE 
    [dbo].heartrate
SET
    new_Date = CONVERT(date, [Time]),
    new_time = CONVERT(time, [Time]),
    weekday = DATENAME(WEEKDAY, [Time])
GO
-- Drop redundant columns
ALTER TABLE 
    [dbo].[heartrate]
DROP 
    COLUMN [Time]
GO


-- Preparing steps datasets
SELECT 
    *
FROM 
    [dbo].[steps]
GO
-- making changes permanent
ALTER TABLE 
    [dbo].[steps]
ADD 
    weekday VARCHAR(50)
GO

UPDATE 
    [dbo].steps
SET
    weekday = DATENAME(WEEKDAY, [ActivityDay])
GO


-- Preparing MET_data dataset
SELECT 
    * 
FROM 
    [dbo].MET_data
GO
-- making changes permanent
ALTER TABLE 
    dbo.MET_data
ADD 
    [new_Date] DATE, 
    new_time TIME,
    weekday VARCHAR(50)
GO

UPDATE 
    [dbo].MET_data
SET
    new_Date = CONVERT(date, ActivityMinute),
    new_time = CONVERT(time, ActivityMinute),
    weekday = DATENAME(WEEKDAY, ActivityMinute)
GO
-- Drop redundant columns
ALTER TABLE 
    [dbo].MET_data
DROP 
    COLUMN ActivityMinute
GO
