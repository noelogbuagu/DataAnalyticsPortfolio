-- Creating necessary temp tables

-- Drop the temp table if it already exists
IF OBJECT_ID('tempDB..#stepRanking', 'U') IS NOT NULL
DROP TABLE #stepRanking
GO
--  creat temp table
SELECT 
    Id,
    AVG(StepTotal) as avg_steps,
    (CASE
        WHEN AVG(StepTotal) BETWEEN 0 AND 5999
            THEN 'Low'
        WHEN AVG(StepTotal) BETWEEN 6000 AND 10999
            THEN 'Medium'
        WHEN AVG(StepTotal) BETWEEN 11000 AND 16999
            THEN 'High'
    END) as step_groups
INTO
    #stepRanking --temp table
FROM 
    [dbo].steps
GROUP BY
    Id
GO
-- Select rows from a Table or View '[#stepRanking]' in schema '[dbo]'
SELECT * FROM [dbo].[#stepRanking]
GO



-- Creating a temp table for all hourly data

-- Drop the temp table if it already exists
IF OBJECT_ID('tempDB..#hourlyData', 'U') IS NOT NULL
DROP TABLE #hourlyData
GO
-- Create the temporary table from a physical table called 'TableName' in schema 'dbo' in database 'DatabaseName'
SELECT 
    hCal.Id,
    hCal.new_Date,
    hCal.[hour],
    hCal.weekday,
    hCal.Calories,
    hInt.TotalIntensity,
    hInt.AverageIntensity,
    hSteps.StepTotal
INTO 
    #hourlyData
FROM 
    [dbo].hourlyCalories as hCal
INNER JOIN
    dbo.hourlyIntensities as hInt
    ON
        hCal.Id = hInt.Id
        AND
        hCal.new_Date = hInt.new_Date
        AND
        hCal.[hour] = hInt.[hour]
INNER JOIN
    dbo.hourlySteps as hSteps
    ON
        hSteps.Id = hCal.Id
        AND
        hSteps.new_Date = hCal.new_Date
        AND
        hSteps.[hour] = hCal.[hour]
WHERE
    hCal.Id IS NOT NULL
ORDER BY
    1,2
GO
-- show hourlyData temp table 
SELECT * FROM [dbo].[#hourlyData]
GO

-- Repeat process for daily data

-- Drop a temporary table called '#dailyData'
-- Drop the table if it already exists
IF OBJECT_ID('tempDB..#dailyData', 'U') IS NOT NULL
DROP TABLE #dailyData
GO
-- Create the temporary table from a physical table called 'TableName' in schema 'dbo' in database 'DatabaseName'
SELECT 
    dSleep.Id,
    dSleep.new_Date,
    dSleep.weekday,
    dSleep.TotalMinutesAsleep,
    dSleep.TotalTimeInBed,
    dActivity.TotalSteps,
    dActivity.TotalDistance,
    dActivity.VeryActiveDistance,
    dActivity.ModeratelyActiveDistance,
    dActivity.LightActiveDistance,
    dActivity.total_mins,
    dActivity.VeryActiveMinutes,
    dActivity.FairlyActiveMinutes,
    dActivity.LightlyActiveMinutes,
    dActivity.SedentaryMinutes,
    dActivity.Calories
INTO 
    #dailyData
FROM 
    dbo.activity as dActivity
INNER JOIN
    dbo.sleep as dSleep
    ON
        dActivity.Id = dSleep.Id
        AND
        dActivity.new_Date = dSleep.new_Date
        AND
        dActivity.weekday = dSleep.weekday
WHERE 
    dSleep.Id IS NOT NULL
ORDER BY
    1,2,3
GO
-- show dailyData temp table 
SELECT * FROM [dbo].#dailyData
GO

-- DATA EXPLORATION

-- what can we get from weight dataset
SELECT * FROM [dbo].[weight]
GO
-- DESCRIPTIVE STAT
SELECT 
    COUNT(DISTINCT Id) as number_of_users,
    MIN(WeightKg) as lightest_user_Kg,
    MAX(WeightKg) as heaviest_user_Kg,
    AVG(BMI) as avg_BMI
FROM
    [dbo].[weight]
GO
-- On average, the users are overweight.


-- what can we get from steps dataset
SELECT 
    *
FROM 
    [dbo].[steps]
GO
-- questions
-- What day of the week are participants the most active?
-- VIZ 1
SELECT 
    weekday,
    MAX(StepTotal) AS max_steps_per_day
FROM 
    [dbo].[steps]
GROUP BY
    weekday
ORDER BY
    max_steps_per_day DESC
GO
-- most steps are taken on the weekends and least are taken mid-week
-- how does step count vary from beigining date to end date?
-- VIZ 2
SELECT 
    ActivityDay,
    SUM(StepTotal) AS total_steps_per_date
FROM 
    [dbo].[steps]
GROUP BY
    ActivityDay
ORDER BY
    ActivityDay
GO
-- generally, activity reduced towards the end.
-- What step group is the most predominant?
-- DESCRIPTIVE STAT
SELECT 
    step_groups,
    COUNT(Id) as group_count
FROM 
    [dbo].#stepRanking
GROUP BY
    step_groups
ORDER BY
    group_count DESC
GO
-- turns out majority are in the medium step group
-- Now to visualize it(Id vs avg_steps grouped by step_groups)
-- VIZ 3
SELECT 
    *
FROM 
    [dbo].#stepRanking
GO



-- lets take a look at the heartrate dataset
SELECT 
    *
FROM 
    [dbo].heartrate
GO
-- questions
-- what is the distribution of the heart rate 
-- VIZ 4 (histogram)
-- VIZ 5 (scatter plot of count, heartRate and classification)
SELECT 
    [Value] as heartRate,
    COUNT(Id) as count,
    (CASE
        WHEN [Value] BETWEEN 0 AND 59
            THEN 'Slow'
        WHEN [Value] BETWEEN 60 AND 100
            THEN 'Normal'
        WHEN [Value] > 100 
            THEN 'Fast'
    END) as classification
FROM 
    [dbo].heartrate
GROUP BY
    [Value]
ORDER BY
    [Value]
GO
-- how does hearRate change as time of day progresses or day of the week?
-- VIZ 6
SELECT 
    [Value] as heartRate,
    DATEPART(hour,new_time) AS time_of_day,
    weekday
FROM 
    [dbo].heartrate
GROUP BY
    DATEPART(hour,new_time),
    [Value],
    weekday
ORDER BY
    [time_of_day],
    [Value]
GO


-- -- let's look at MET_data dataset
-- SELECT * FROM [dbo].[MET_data]
-- GO
-- -- VIZ 7
-- -- looking at how METs varies across time of day
-- SELECT 
--     Id,
--     DATEPART(hour,new_time) AS time_of_day,
--     METs,
--     (CASE
--         WHEN METs >= 0 AND METs <= 1.5
--             THEN 'Sedentary'
--         WHEN METs > 1.5 AND METs <= 3
--             THEN 'Light'
--         WHEN METs > 3 AND METs <= 6 
--             THEN 'Moderate'
--         WHEN METs > 6
--             THEN 'Vigorous'
--     END) as Intensities
-- FROM 
--     dbo.MET_data
-- GO
-- -- VIZ 8
-- -- looking at hw METs varies across weekday
-- SELECT 
--     Id,
--     weekday,
--     METs,
--     (CASE
--         WHEN METs >= 0 AND METs <= 1.5
--             THEN 'Sedentary'
--         WHEN METs > 1.5 AND METs <= 3
--             THEN 'Light'
--         WHEN METs > 3 AND METs <= 6 
--             THEN 'Moderate'
--         WHEN METs > 6
--             THEN 'Vigorous'
--     END) as Intensities
-- FROM 
--     dbo.MET_data
-- -- VIZ 9
-- -- looking at how METs varies across the time of data collection
-- SELECT 
--     Id,
--     new_Date,
--     METs,
--     (CASE
--         WHEN METs >= 0 AND METs <= 1.5
--             THEN 'Sedentary'
--         WHEN METs > 1.5 AND METs <= 3
--             THEN 'Light'
--         WHEN METs > 3 AND METs <= 6 
--             THEN 'Moderate'
--         WHEN METs > 6
--             THEN 'Vigorous'
--     END) as Intensities
-- FROM 
--     dbo.MET_data
-- WHERE
--     METs BETWEEN 3 and 5
-- GO


-- looking at hourly data
SELECT * FROM dbo.#hourlyData
ORDER BY [hour] DESC
GO
-- ideas
-- look at relationship between steptotal and intensity/callories across every hour
-- VIZ 10 (plot both intensity and calories over time of day to identify trends)
SELECT
    [hour] as time_of_day,
    SUM(Calories) as Calories,
    SUM(TotalIntensity) as Intensity
FROM 
    dbo.#hourlyData
GROUP BY
    [hour]
ORDER BY
    [hour]
GO
-- (another idea would be to see how weekday affects the relationship)
SELECT
    [hour] as time_of_day,
    weekday,
    SUM(Calories) as Calories,
    SUM(TotalIntensity) as Intensity
FROM 
    dbo.#hourlyData
GROUP BY
    [hour],
    weekday
ORDER BY
    [hour],
    weekday
GO
-- another idea would be to look through the dates as well to see if the participants were consistent from start to finish
SELECT
    new_Date,
    SUM(Calories) as Calories,
    SUM(TotalIntensity) as Intensity
FROM 
    dbo.#hourlyData
GROUP BY
    new_Date
ORDER BY
    new_Date
GO



-- looking at daily data
SELECT * FROM dbo.#dailyData
GO
-- how does daily step counts relate to calories weekday?
SELECT 
    weekday,
    SUM(TotalSteps) as total_steps,
    SUM(Calories) as calories_burned
FROM 
    dbo.#dailyData
GROUP BY
    weekday
GO
-- how does the time spent asleep affect time being active
SELECT 
    TotalMinutesAsleep,
    VeryActiveMinutes,
    FairlyActiveMinutes,
    LightlyActiveMinutes,
    (SedentaryMinutes + TotalTimeInBed) AS SedentaryTime
FROM 
    dbo.#dailyData
GO
-- as the days went by how did time spent being active change
SELECT 
    new_Date,
    VeryActiveMinutes,
    FairlyActiveMinutes,
    LightlyActiveMinutes,
    (SedentaryMinutes + TotalTimeInBed) AS SedentaryTime
FROM 
    dbo.#dailyData
GO
-- how does distance travelled affect calories
SELECT 
    Calories,
    VeryActiveDistance,
    ModeratelyActiveDistance,
    LightActiveDistance
FROM 
    dbo.#dailyData
GO
-- how active are the users?
SELECT 
    Id,
    AVG(SedentaryMinutes) AS Avg_SedentaryTime,
    (CASE
        WHEN AVG(SedentaryMinutes) BETWEEN 0 AND 900
            THEN 'Passive'
        WHEN AVG(SedentaryMinutes) > 900
            THEN 'Active'
    END) as sedentary_groups
FROM 
    dbo.#dailyData
GROUP BY
    Id
GO