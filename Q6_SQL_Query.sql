
WITH TrialStartRates AS (
    SELECT
        Visits_Analytics.region,
        CAST(COUNT(DISTINCT CASE WHEN Subscription_Analytics.trial_start_date IS NOT NULL THEN Visits_Analytics.account_id ELSE NULL END) 
		AS decimal) AS trial_starts,
        COUNT(DISTINCT Visits_Analytics.account_id) AS total_visitors
    FROM
        Visits_Analytics
    LEFT JOIN
        Subscription_Analytics ON Visits_Analytics.account_id = Subscription_Analytics.account_id
    WHERE
        day >= '1/1/2021'  -- Used Excel to sort trial start dates and find the earliest one
        AND day <= '1/7/2023'  -- Used Excel to sort trial end dates and find the latest one
    GROUP BY
        Visits_Analytics.region
)

	--To calculate the amount of trial starts (amount of visitors who started a trial) as well as 
	--the total amount of visitors per region within the trial start and end, I created a CTE


SELECT
    region,
    (trial_starts / total_visitors * 100) AS trial_start_rate
FROM
    TrialStartRates
ORDER BY
    trial_start_rate DESC;

	--I then calculated the trial start rate by dividing the number of paying subscribers by 
	--the total number of visitors and multiplying by 100 
	--Then I used the 'DESC' statement to find the region with the highest trial start rate