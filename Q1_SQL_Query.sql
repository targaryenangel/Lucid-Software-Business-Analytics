

WITH RevenuePerAccountPerRegion
	AS
	(
	SELECT DBO.Subscription_Analytics.REVENUE, DBO.Visits_Analytics.REGION,
SUM(DBO.Subscription_Analytics.REVENUE) OVER (PARTITION BY DBO.Visits_Analytics.REGION) AS TOTAL_REVENUE_PER_REGION
FROM Subscription_Analytics
JOIN Visits_Analytics
	ON Subscription_Analytics.ACCOUNT_ID = Visits_Analytics.ACCOUNT_ID
	WHERE Subscription_Analytics.REVENUE is not null
	)


	--In the query above, the results reflected the sum of each region's revenue along with the accompanying account ID

	
	--It occurred to me that I needed to filter out the duplicates of the total revenue per region,
	--hence I used a CTE to query from the one above using the 'SELECT DISTINCT' statement, 
	--so that the results ommitted duplicates and only each distinct region's total revenue.


	SELECT DISTINCT REGION,	TOTAL_REVENUE_PER_REGION
	FROM RevenuePerAccountPerRegion
	ORDER BY REGION;


	--I was confident that using 'WHERE revenue is not null' in the first query
	--would by default produce an accurate total of revenues because as mentioned in the Lucid assignment document,
	--the 'revenue' column only includes revenue produced by subscriptions, therefore there would be
	--no need to query the subscription start and end dates since subscription revenue does not account for trials and visits.
	--To confirm this, I made another query below, in which I used 'WHERE... is not null' 
	--on the timeframe covered by the subscription dataset

	
	SELECT
    region,
    SUM(revenue) AS total_revenue
FROM
    dbo.Subscription_Analytics
JOIN
    dbo.Visits_Analytics ON Subscription_Analytics.account_id = Visits_Analytics.account_id
WHERE
    subscription_start_date IS NOT NULL
    AND day >= '1/1/2021'  -- Did a custom sort in EXCEL to find earliest 'start_date'
    AND day <= '1/7/2024'  -- Did a custom sort in EXCEL to find latest 'end_date' 
GROUP BY
    region

	--In the process of creating this query, I figured out a way to make it shorter than the previous
	--since using "GROUP BY" would group together the revenues by region, 
	--negating the need for a CTE and "SELECT DISTINCT" as used previously

	--Ultimately, this new query yielded the same values as the query before, 
	--so I was able to confirm that I have the correct total revenue per region