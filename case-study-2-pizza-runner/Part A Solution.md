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


***

###  2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?

```sql
SELECT COUNT(DISTINCT order_id) AS unique_orders
FROM customer_orders;
``` 
	
#### Result set:

***

###  3. Is there any relationship between the number of pizzas and how long the order takes to prepare?

```sql
SELECT runner_id, COUNT(order_id) AS successful_deliveries
FROM runner_orders
WHERE cancellation = ''
GROUP BY runner_id;
``` 
	
#### Result set:


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


***