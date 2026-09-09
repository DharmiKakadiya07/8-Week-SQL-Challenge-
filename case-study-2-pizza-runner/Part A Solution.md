# :pizza: Case Study #2: Pizza runner - Runner and Customer Experience

## Case Study Questions

1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
3. Is there any relationship between the number of pizzas and how long the order takes to prepare?
4. What was the average distance travelled for each customer?
5. What was the difference between the longest and shortest delivery times for all orders?
6. What was the average speed for each runner for each delivery and do you notice any trend for these values?
7. What is the successful delivery percentage for each runner?
8. How many pizzas were delivered that had both exclusions and extras?
9. What was the total volume of pizzas ordered for each hour of the day?
10. What was the volume of orders for each day of the week?

***

###  1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)

```sql
SELECT COUNT(*) AS total_pizzas_ordered
FROM customer_orders; 
``` 
	
#### Result set:
<img width="215" height="70" alt="Screenshot 2026-09-08 195658" src="https://github.com/user-attachments/assets/7e1ac73e-acb1-4a4c-814f-eb9b6a8253b5" />


***

###  2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?

```sql
SELECT COUNT(DISTINCT order_id) AS unique_orders
FROM customer_orders;
``` 
	
#### Result set:
<img width="171" height="62" alt="Screenshot 2026-09-08 200202" src="https://github.com/user-attachments/assets/36d391f4-da74-43bf-a09a-fc85fbc97d0d" />

***

###  3. Is there any relationship between the number of pizzas and how long the order takes to prepare?

```sql
SELECT runner_id, COUNT(order_id) AS successful_deliveries
FROM runner_orders
WHERE cancellation = ''
GROUP BY runner_id;
``` 
	
#### Result set:
<img width="295" height="100" alt="Screenshot 2026-09-08 200446" src="https://github.com/user-attachments/assets/ffc8e7a5-851c-4acd-8ef4-3b77e2520ac3" />


***

###  4. What was the average distance travelled for each customer?

```sql
SELECT pn.pizza_name, COUNT(co.pizza_id) AS total_delivered
FROM customer_orders co
JOIN pizza_names pn ON co.pizza_id = pn.pizza_id
JOIN runner_orders ro ON co.order_id = ro.order_id
WHERE ro.cancellation = ''
GROUP BY pn.pizza_name;
``` 
	
#### Result set:
<img width="237" height="72" alt="Screenshot 2026-09-08 200537" src="https://github.com/user-attachments/assets/04cb44ca-e120-419e-a87b-9dd1e147d305" />

***

###  5. What was the difference between the longest and shortest delivery times for all orders?

```sql
SELECT co.customer_id,
       SUM(CASE WHEN pn.pizza_name = 'Meatlovers' THEN 1 ELSE 0 END) AS meatlovers,
       SUM(CASE WHEN pn.pizza_name = 'Vegetarian' THEN 1 ELSE 0 END) AS vegetarian
FROM customer_orders co
JOIN pizza_names pn ON co.pizza_id = pn.pizza_id
GROUP BY co.customer_id;
``` 
	
#### Result set:
<img width="343" height="147" alt="Screenshot 2026-09-08 202537" src="https://github.com/user-attachments/assets/2ece86d2-144d-4250-b1cf-951fcea8ef78" />

***

###  6. What was the average speed for each runner for each delivery and do you notice any trend for these values?

```sql
SELECT MAX(pizza_count) AS max_pizzas_in_single_order
FROM (
    SELECT co.order_id, COUNT(co.pizza_id) AS pizza_count
    FROM customer_orders co
    JOIN runner_orders ro ON co.order_id = ro.order_id
    WHERE ro.cancellation = ''
    GROUP BY co.order_id
) AS order_counts;
``` 
	
#### Result set:
<img width="228" height="55" alt="Screenshot 2026-09-08 202625" src="https://github.com/user-attachments/assets/6cbae493-f53e-46bb-99d6-6fa31375f1c6" />


***

###  7. What is the successful delivery percentage for each runner?

```sql
-- alter the cancellation column so that empty cells have 'null' as value
SELECT co.customer_id,
       SUM(CASE WHEN co.exclusions = '' AND co.extras = '' THEN 1 ELSE 0 END) AS no_changes,
       SUM(CASE WHEN co.exclusions != '' OR co.extras != '' THEN 1 ELSE 0 END) AS at_least_1_change
FROM customer_orders co
JOIN runner_orders ro ON co.order_id = ro.order_id
WHERE ro.cancellation = ''
GROUP BY co.customer_id;
```
	
#### Result set:
<img width="362" height="138" alt="Screenshot 2026-09-08 202752" src="https://github.com/user-attachments/assets/7823b1d1-3c98-4090-9c37-47447c1acfaa" />


***

###  8. How many pizzas were delivered that had both exclusions and extras?

```sql
SELECT COUNT(*) AS pizzas_with_both_changes
FROM customer_orders co
JOIN runner_orders ro ON co.order_id = ro.order_id
WHERE ro.cancellation = ''
AND co.exclusions != ''
AND co.extras != '';
```

#### Result Set:
<img width="242" height="47" alt="Screenshot 2026-09-08 202942" src="https://github.com/user-attachments/assets/0027dcb4-b98a-4a58-96da-6410b82be589" />


***

### 9. What was the total volume of pizzas ordered for each hour of the day?

```sql
SELECT HOUR(order_time) AS hour_of_day,
       COUNT(*) AS total_pizzas
FROM customer_orders
GROUP BY HOUR(order_time)
ORDER BY hour_of_day;
```
### Result Set:
<img width="251" height="165" alt="Screenshot 2026-09-08 203030" src="https://github.com/user-attachments/assets/8779a9b1-ca74-4d67-9208-b5a53676dc9f" />


***

### 10. What was the volume of orders for each day of the week?

```sql
SELECT DAYNAME(order_time) AS day_of_week,
       COUNT(*) AS total_pizzas
FROM customer_orders
GROUP BY DAYNAME(order_time), DAYOFWEEK(order_time)
ORDER BY DAYOFWEEK(order_time);
```

### Result Set:
<img width="255" height="120" alt="Screenshot 2026-09-08 203153" src="https://github.com/user-attachments/assets/f7a8379e-a34c-4216-8646-6372b5d2a6f7" />


***
