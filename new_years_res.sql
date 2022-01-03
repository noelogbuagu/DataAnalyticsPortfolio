SELECT 
    *
FROM 
    [dbo].[New_years_resolutions]
-- WHERE
--     retweet_count IS NOT NULL
GO


-- add new columns for date and time
ALTER TABLE
    [dbo].[New_years_resolutions]
ADD 
    [tweet_date] /*new_column_name*/ DATE /*new_column_datatype*/ NULL /*new_column_nullability*/,
    tweet_time TIME,
    day_of_week VARCHAR
GO

-- populate columns
UPDATE 
    [dbo].New_years_resolutions
SET
    tweet_date = CONVERT(date, tweet_created),
    tweet_time = CONVERT(time, tweet_created),
    day_of_week = DATENAME(WEEKDAY, [tweet_created])
GO

-- remove tweet_created column
ALTER TABLE 
    [dbo].[New_years_resolutions]
DROP 
    COLUMN [tweet_created]
GO