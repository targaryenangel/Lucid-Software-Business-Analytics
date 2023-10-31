

WITH LandingPageConversion AS (
    SELECT
        Visits_Analytics.region,
        Visits_Analytics.landing_page,
        CAST(COUNT(DISTINCT CASE WHEN Subscription_Analytics.subscription_start_date IS NOT NULL 
		THEN Visits_Analytics.account_id ELSE NULL END) AS decimal) AS paying_subscribers,
        CAST(COUNT(DISTINCT Visits_Analytics.account_id) AS decimal) AS total_visitors
    FROM
        Visits_Analytics
    LEFT JOIN
        Subscription_Analytics ON Visits_Analytics.account_id = Subscription_Analytics.account_id
    GROUP BY
        Visits_Analytics.region, Visits_Analytics.landing_page
),

	--To calculate the amount of paying subscribers  the total number of visitors per region and 
	--landing page combination, I created a CTE.

RankedLandingPages AS (
    SELECT
        region,
        landing_page,
        (paying_subscribers / total_visitors * 100) AS conversion_rate,
        ROW_NUMBER() OVER (PARTITION BY region ORDER BY (paying_subscribers / total_visitors) DESC) AS ranking
    FROM
        LandingPageConversion
)
	
	--I then ranked the landing pages within each region by conversion rate, by creating another CTE.

SELECT DISTINCT
    region,
    landing_page AS top_converting_landing_page
FROM
    RankedLandingPages
WHERE
    ranking = 1

	--To find the top converting landing page per region, I selected the regions and their respective 
	--top converting landing pages where the ranking is equal to 1.
	--By using the results of the query, I identified which regions did not have 
	--landing page H (the landing page with the overall highest conversion rate)
	--as their own top converting landing page.
