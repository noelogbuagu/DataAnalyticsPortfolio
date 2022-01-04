SELECT 
    *
FROM 
    [dbo].[New_years_resolutions]
GO

-- add new columns for date and time
ALTER TABLE
    [dbo].[New_years_resolutions]
ADD 
    [tweet_date] DATE,
    tweet_time INT,
    day_of_week VARCHAR(50)
GO

-- populate columns
UPDATE 
    [dbo].New_years_resolutions
SET
    tweet_date = CONVERT(date, tweet_created),
    tweet_time = DATEPART(hour, tweet_created),
    day_of_week = DATENAME(WEEKDAY, [tweet_created])
GO

-- remove tweet_created column
ALTER TABLE 
    [dbo].[New_years_resolutions]
DROP 
    COLUMN [tweet_created]  
GO

-- Don't think timezone is required
SELECT 
    *
FROM 
    [dbo].[New_years_resolutions]
-- WHERE
--     retweet_count IS NOT NULL
GO

-- drop user_timezone
ALTER TABLE 
    [dbo].[New_years_resolutions]
DROP 
    COLUMN user_timezone  
GO



-- ------ANALYSIS-----------------

-- most popular tweet category
SELECT 
    tweet_category,
    COUNT(tweet_category) as frequency
FROM 
    [dbo].[New_years_resolutions]
GROUP BY
    tweet_category
ORDER BY
    frequency DESC
GO

-- most retweeted resoultion category
SELECT 
    tweet_category,
    COUNT(retweet_count) as retweets
FROM 
    [dbo].[New_years_resolutions]
WHERE
    retweet_count IS NOT NULL
GROUP BY
    tweet_category
ORDER BY
    retweets DESC
GO

-- most popular time of day to tweet
SELECT 
    tweet_time,
    COUNT(tweet_time) as number_of_tweets
FROM 
    [dbo].[New_years_resolutions]
-- WHERE
--     retweet_count IS NOT NULL
GROUP BY
    tweet_time
ORDER BY
    number_of_tweets DESC
GO

-- what day of the week is the most popular 
SELECT 
    day_of_week,
    COUNT(day_of_week) as frequency
FROM 
    [dbo].[New_years_resolutions]
GROUP BY
    day_of_week
ORDER BY
    frequency DESC
GO

-- state that produced the most tweets
SELECT 
    tweet_state,
    COUNT(tweet_state) as frequency
FROM 
    [dbo].[New_years_resolutions]
GROUP BY
    tweet_state
ORDER BY
    frequency DESC
GO

-- most active gender
SELECT 
    user_gender,
    COUNT(user_gender) as frequency
FROM 
    [dbo].[New_years_resolutions]
GROUP BY
    user_gender
ORDER BY
    frequency DESC
GO