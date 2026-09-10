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
<img width="255" height="122" alt="Screenshot 2026-09-10 154009" src="https://github.com/user-attachments/assets/8bbe3b16-3702-49fd-965c-a51b9c2aa3aa" />


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
<img width="120" height="12" alt="Screenshot 2026-09-10 154138" src="https://github.com/user-attachments/assets/bf0e675d-4628-4c22-8ea9-c0aebde210ba" />


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
<img width="257" height="150" alt="Screenshot 2026-09-10 154152" src="https://github.com/user-attachments/assets/7fe5b40f-e361-4b2f-b14c-3355ded9e2d0" />


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
<img width="206" height="55" alt="Screenshot 2026-09-10 154343" src="https://github.com/user-attachments/assets/f5bd01d3-cdd8-4846-b63f-76ad8aac57f2" />


***

###  5. What was the difference between the longest and shortest delivery times for all orders?

```sql
SELECT MAX(duration) - MIN(duration) AS delivery_time_difference
FROM runner_orders
WHERE cancellation = '';
``` 
	
#### Result set:
<img width="227" height="75" alt="Screenshot 2026-09-10 155007" src="https://github.com/user-attachments/assets/32ef47a9-54c5-4deb-b3c4-606a1e173dc0" />


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
<img width="472" height="212" alt="Screenshot 2026-09-10 155036" src="https://github.com/user-attachments/assets/a16dcb53-b703-442a-b9f3-45914b755073" />


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
<img width="507" height="105" alt="Screenshot 2026-09-10 155058" src="https://github.com/user-attachments/assets/297bb737-77f5-4390-a87a-46f774e6009c" />

***

***

