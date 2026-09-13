# Part B: Foodie-Fi - Data Analysis Questions

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
<img width="157" height="55" alt="Screenshot 2026-09-13 153611" src="https://github.com/user-attachments/assets/1cf6d261-603c-4b0b-a158-0e7756e3acc3" />


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
<img width="390" height="293" alt="Screenshot 2026-09-13 154526" src="https://github.com/user-attachments/assets/a070fd48-d62a-4a3c-84c7-86d420a3741b" />


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
<img width="287" height="131" alt="Screenshot 2026-09-13 154541" src="https://github.com/user-attachments/assets/6a14b0bf-c27e-42b1-a615-a0d6948a1b9a" />



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
<img width="317" height="55" alt="Screenshot 2026-09-13 154601" src="https://github.com/user-attachments/assets/131b2c12-8780-4af6-bd41-fd248fc42e14" />


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
<img width="275" height="57" alt="Screenshot 2026-09-13 154722" src="https://github.com/user-attachments/assets/4ca981b0-a18c-4a08-8384-ecd39565df3c" />


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
<img width="347" height="127" alt="Screenshot 2026-09-13 155240" src="https://github.com/user-attachments/assets/055b6c82-3a2e-4052-854d-2860c0894ab5" />


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
<img width="356" height="140" alt="Screenshot 2026-09-13 155348" src="https://github.com/user-attachments/assets/6e934866-7cd3-467d-a6c5-a7b54965e86b" />


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
<img width="162" height="45" alt="Screenshot 2026-09-13 155547" src="https://github.com/user-attachments/assets/df719584-ad88-4e74-a6f8-b083ccbea591" />

  
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
<img width="215" height="81" alt="Screenshot 2026-09-13 155903" src="https://github.com/user-attachments/assets/0176e8d8-083a-41d0-8e5f-0d28be3aa5c6" />


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
<img width="161" height="77" alt="Screenshot 2026-09-13 161830" src="https://github.com/user-attachments/assets/f0bc839c-b3d6-4f49-b724-dfb167138abe" />


***
