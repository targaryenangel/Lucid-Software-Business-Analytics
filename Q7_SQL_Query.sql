

WITH TrialConversionRates AS (
    SELECT
        Visits_Analytics.region,
        CAST(COUNT(DISTINCT CASE WHEN Subscription_Analytics.subscription_start_date IS NOT NULL 
		THEN Subscription_Analytics.account_id ELSE NULL END) AS decimal) AS trial_conversions,
        CAST(COUNT(DISTINCT CASE WHEN Subscription_Analytics.trial_start_date IS NOT NULL 
		THEN Visits_Analytics.account_id ELSE NULL END) AS decimal) AS trials_started
    FROM
        Visits_Analytics
    LEFT JOIN
        Subscription_Analytics ON Visits_Analytics.account_id = Subscription_Analytics.account_id
    WHERE
        Subscription_Analytics.trial_start_date IS NOT NULL
    GROUP BY
        Visits_Analytics.region
)

	--To calculate the amount of trial conversions (visitors who started a subscription after a trial) 
	--and the total amount of trials started per region within the subscription start and end, I created a CTE.


SELECT
    region,
    (trial_conversions / trials_started * 100) AS trial_conversion_rate
FROM
    TrialConversionRates
ORDER BY
    trial_conversion_rate DESC;

	--I then calculated the trial conversion rate by dividing the number of trial conversions by 
	--the total number of trials started and multiplying by 100.
	--Then I used the 'DESC' statement to find the region with the highest trial conversion rate.