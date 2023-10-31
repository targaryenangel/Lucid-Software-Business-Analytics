

WITH ChannelRevenue AS (
    SELECT
        dbo.Visits_Analytics.channel,
        COUNT(DISTINCT dbo.Visits_Analytics.visit_id) AS visitors,
        SUM(dbo.Subscription_Analytics.revenue) AS total_revenue
    FROM
        Visits_Analytics
    LEFT JOIN
        Subscription_Analytics ON Visits_Analytics.account_id = Subscription_Analytics.account_id
    WHERE
        Subscription_Analytics.subscription_start_date IS NOT NULL
    GROUP BY
        Visits_Analytics.channel
)

	--Above, I created a query that utilizes a CTE that calculates the total revenue 
	--as well as each channel's quantity of distinct visitors.

SELECT
    channel,
    (total_revenue / visitors) AS revenue_per_visitor
FROM
    ChannelRevenue
ORDER BY
    revenue_per_visitor DESC;


	--I then wrote the query above to calculate the revenue per visitor for each channel and
	--ordered the results in descending order to identify the channel with the highest revenue per visitor.
