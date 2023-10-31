

WITH LandingPageConversion AS (
    SELECT
        Visits_Analytics.landing_page,
        CAST(COUNT(DISTINCT CASE WHEN Subscription_Analytics.subscription_start_date IS NOT NULL THEN 
		Visits_Analytics.account_id ELSE NULL END) AS decimal) AS paying_subscribers,
        CAST(COUNT(DISTINCT Visits_Analytics.account_id) AS decimal) AS total_visitors
    FROM
        Visits_Analytics
    LEFT JOIN
        Subscription_Analytics ON Visits_Analytics.account_id = Subscription_Analytics.account_id
    GROUP BY
        Visits_Analytics.landing_page
)

	--To calculate the amount of paying subscribers (visitors who started a subscription)
	--and the total number of visitors per landing page, I created a CTE.

SELECT
    landing_page,
    (paying_subscribers / total_visitors * 100) AS conversion_rate
FROM
    LandingPageConversion
ORDER BY
    conversion_rate DESC;

	--I then calculated the landing page conversion rate by dividing the number of of paying subscribers 
	--by the total number of visitors and multiplying by 100.
	--Then I used the 'DESC' statement to find the landing page with the highest conversion rate.

