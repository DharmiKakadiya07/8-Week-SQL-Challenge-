# :avocado: Case Study #3: Foodie-Fi - Data Analysis Questions

## Case Study Questions
1. How many customers has Foodie-Fi ever had?
2. What is the monthly distribution of trial plan start_date values for our dataset - use the start of the month as the group by value
3. What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events for each plan_name
4. What is the customer count and percentage of customers who have churned rounded to 1 decimal place?
5. How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?
6. What is the number and percentage of customer plans after their initial free trial?
7. What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31?
8. How many customers have upgraded to an annual plan in 2020?
9. How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi?
10. Can you further breakdown this average value into 30 day periods (i.e. 0-30 days, 31-60 days etc)
11. How many customers downgraded from a pro monthly to a basic monthly plan in 2020?

***

###  1. How many customers has Foodie-Fi ever had?
```sql
SELECT COUNT(DISTINCT customer_id) AS 'number_of_customers'
FROM subscriptions;
``` 

#### Result set:


***

###  2. What is the monthly distribution of trial plan start_date values for our dataset - use the start of the month as the group by value
-- Every customer starts with a trial so plan_id = 0
```sql
SELECT 
    MONTH(start_date) AS month_number,
    MONTHNAME(start_date) AS month_name,
    COUNT(customer_id) AS total_customers
FROM subscriptions
WHERE plan_id = 0
GROUP BY MONTH(start_date), MONTHNAME(start_date)
ORDER BY month_number;
``` 
	
#### Result set:


***

###  3. What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events for each plan_name

```sql
SELECT 
    p.plan_name,
    COUNT(*) AS number_of_events
FROM subscriptions s
JOIN plans p ON s.plan_id = p.plan_id
WHERE YEAR(s.start_date) > 2020
GROUP BY p.plan_name, p.plan_id
ORDER BY p.plan_id;
``` 
	
#### Result set:


***

###  4. What is the customer count and percentage of customers who have churned rounded to 1 decimal place?

```sql
SELECT 
    COUNT(DISTINCT customer_id) AS churned_customers,
    ROUND(COUNT(DISTINCT customer_id) * 100 / 
        (SELECT COUNT(DISTINCT customer_id) 
         FROM subscriptions), 1) AS churn_percentage
FROM subscriptions
WHERE plan_id = 4;
``` 
	
#### Result set:


***

###  5. How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?

```sql
WITH trial_then_churn AS (
    SELECT 
        s1.customer_id
    FROM subscriptions s1
    JOIN subscriptions s2 ON s1.customer_id = s2.customer_id
    WHERE s1.plan_id = 0        -- trial plan
    AND s2.plan_id = 4          -- churn plan
    AND s2.start_date = DATE_ADD(s1.start_date, INTERVAL 7 DAY)
)
SELECT 
    COUNT(*) AS churned_after_trial,
    ROUND(COUNT(*) * 100 / 
        (SELECT COUNT(DISTINCT customer_id) 
         FROM subscriptions)) AS percentage
FROM trial_then_churn;
``` 
	
#### Result set:


***

###  6. What is the number and percentage of customer plans after their initial free trial?

```sql
WITH next_plans AS (
    SELECT 
        s1.customer_id,
        s2.plan_id
    FROM subscriptions s1
    JOIN subscriptions s2 ON s1.customer_id = s2.customer_id
    WHERE s1.plan_id = 0
    AND s2.start_date = DATE_ADD(s1.start_date, INTERVAL 7 DAY)
)
SELECT 
    p.plan_name,
    COUNT(*) AS customer_count,
    ROUND(COUNT(*) * 100 / 
        (SELECT COUNT(DISTINCT customer_id) 
         FROM subscriptions), 1) AS percentage
FROM next_plans np
JOIN plans p ON np.plan_id = p.plan_id
GROUP BY p.plan_name, np.plan_id
ORDER BY np.plan_id;
``` 
	
#### Result set:


***

###  7. What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31?

```sql
WITH latest_plans AS (
    SELECT 
        customer_id,
        plan_id,
        start_date,
        ROW_NUMBER() OVER (
            PARTITION BY customer_id 
            ORDER BY start_date DESC
        ) AS plan_rank
    FROM subscriptions
    WHERE start_date <= '2020-12-31'
)
SELECT 
    p.plan_name,
    COUNT(*) AS customer_count,
    ROUND(COUNT(*) * 100 / 
        (SELECT COUNT(DISTINCT customer_id) 
         FROM subscriptions), 1) AS percentage
FROM latest_plans lp
JOIN plans p ON lp.plan_id = p.plan_id
WHERE plan_rank = 1
GROUP BY p.plan_name, lp.plan_id
ORDER BY lp.plan_id;

``` 
	
#### Result set:


***

###  8. How many customers have upgraded to an annual plan in 2020?

```sql
SELECT 
    COUNT(DISTINCT customer_id) AS annual_upgrades
FROM subscriptions
WHERE plan_id = 3
AND YEAR(start_date) = 2020;
``` 
	
#### Result set:

  
***

###  9. How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi?

```sql
WITH trial_start AS (
    SELECT 
        customer_id,
        start_date AS trial_date
    FROM subscriptions
    WHERE plan_id = 0
),
annual_start AS (
    SELECT 
        customer_id,
        start_date AS annual_date
    FROM subscriptions
    WHERE plan_id = 3
)
SELECT 
    ROUND(AVG(DATEDIFF(annual_date, trial_date))) AS avg_days_to_annual
FROM trial_start t
JOIN annual_start a ON t.customer_id = a.customer_id;
``` 

#### Result set:


***

###  10. Can you further breakdown this average value into 30 day periods (i.e. 0-30 days, 31-60 days etc)
skip
```sql

``` 
	
#### Result set:


***

###  11. How many customers downgraded from a pro monthly to a basic monthly plan in 2020?

```sql
WITH plan_changes AS (
    SELECT 
        s1.customer_id,
        s1.plan_id AS current_plan,
        s2.plan_id AS next_plan,
        s2.start_date
    FROM subscriptions s1
    JOIN subscriptions s2 ON s1.customer_id = s2.customer_id
    WHERE s1.plan_id = 2        -- pro monthly
    AND s2.plan_id = 1          -- basic monthly
    AND s2.start_date > s1.start_date  -- basic came AFTER pro
    AND YEAR(s2.start_date) = 2020
)
SELECT 
    COUNT(*) AS downgrades
FROM plan_changes;
``` 
	
#### Result set:


***
