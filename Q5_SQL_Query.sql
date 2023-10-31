

WITH DirectSubscriptionRates AS (
    SELECT
        Visits_Analytics.region,
         CAST(COUNT(DISTINCT CASE WHEN Subscription_Analytics.trial_start_date IS NULL THEN Visits_Analytics.account_id ELSE NULL END) 
		 AS decimal) AS direct_subscriptions,
        COUNT(DISTINCT Visits_Analytics.account_id) AS total_visitors
    FROM
        Visits_Analytics
    LEFT JOIN
        Subscription_Analytics ON Visits_Analytics.account_id = Subscription_Analytics.account_id
    WHERE
        Subscription_Analytics.subscription_start_date IS NOT NULL
    GROUP BY
        Visits_Analytics.region
)

--To calculate the total amount of visiters as well as amount of paying subscribers for each landing page I created a CTE, 
--then calculated the conversion rate by dividing the number of paying subscribers 
--by the total number of visitors and multiplying by 100 


SELECT
    region,
    (direct_subscriptions / total_visitors * 100) AS direct_subscription_rate
FROM
    DirectSubscriptionRates
ORDER BY
    direct_subscription_rate DESC;

--Then I used the 'DESC' statement to find the region with the highest conversion rate