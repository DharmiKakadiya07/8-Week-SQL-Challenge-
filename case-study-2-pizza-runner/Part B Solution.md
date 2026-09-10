# :pizza: Case Study #2: Pizza runner - Runner and Customer Experience

## Case Study Questions

1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
3. Is there any relationship between the number of pizzas and how long the order takes to prepare?
4. What was the average distance travelled for each customer?
5. What was the difference between the longest and shortest delivery times for all orders?
6. What was the average speed for each runner for each delivery and do you notice any trend for these values?
7. What is the successful delivery percentage for each runner?

***

###  1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)

```sql
SELECT FLOOR(DATEDIFF(registration_date, '2021-01-01') / 7) + 1 AS week_number,
       COUNT(*) AS runners_signed_up
FROM runners
GROUP BY week_number
ORDER BY week_number;
``` 
	
#### Result set:


***

###  2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?

```sql
SELECT ro.runner_id,
       ROUND(AVG(TIMESTAMPDIFF(MINUTE, co.order_time, ro.pickup_time))) AS avg_pickup_minutes
FROM runner_orders ro
JOIN customer_orders co ON ro.order_id = co.order_id
WHERE ro.cancellation = ''
GROUP BY ro.runner_id;
``` 
	
#### Result set:


***

###  3. Is there any relationship between the number of pizzas and how long the order takes to prepare?

```sql
SELECT pizza_count,
       ROUND(AVG(prep_time)) AS avg_prep_minutes
FROM (
    SELECT co.order_id,
           COUNT(co.pizza_id) AS pizza_count,
           TIMESTAMPDIFF(MINUTE, co.order_time, ro.pickup_time) AS prep_time
    FROM customer_orders co
    JOIN runner_orders ro ON co.order_id = ro.order_id
    WHERE ro.cancellation = ''
    GROUP BY co.order_id, co.order_time, ro.pickup_time
) AS order_prep
GROUP BY pizza_count
ORDER BY pizza_count;
``` 
	
#### Result set:


***

###  4. What was the average distance travelled for each customer?

```sql
SELECT co.customer_id,
       ROUND(AVG(ro.distance), 1) AS avg_distance_km
FROM customer_orders co
JOIN runner_orders ro ON co.order_id = ro.order_id
WHERE ro.cancellation = ''
GROUP BY co.customer_id
ORDER BY co.customer_id;
``` 
	
#### Result set:


***

###  5. What was the difference between the longest and shortest delivery times for all orders?

```sql
SELECT MAX(duration) - MIN(duration) AS delivery_time_difference
FROM runner_orders
WHERE cancellation = '';
``` 
	
#### Result set:


***

###  6. What was the average speed for each runner for each delivery and do you notice any trend for these values?

```sql
SELECT ro.runner_id,
       ro.order_id,
       ro.distance,
       ro.duration,
       ROUND(ro.distance / (ro.duration / 60), 1) AS avg_speed_kmh
FROM runner_orders ro
WHERE ro.cancellation = ''
ORDER BY ro.runner_id, ro.order_id;
``` 
	
#### Result set:


***

###  7. What is the successful delivery percentage for each runner?

```sql
SELECT runner_id,
       COUNT(order_id) AS total_orders,
       SUM(CASE WHEN cancellation = '' THEN 1 ELSE 0 END) AS successful_orders,
       ROUND(SUM(CASE WHEN cancellation = '' THEN 1 ELSE 0 END) * 100 / COUNT(order_id), 0) AS success_percentage
FROM runner_orders
GROUP BY runner_id
ORDER BY runner_id;
``` 
	
#### Result set:

***

