# :pizza: Case Study #2: Pizza runner - Pizza Metrics

## Case Study Questions

1. How many pizzas were ordered?
2. How many unique customer orders were made?
3. How many successful orders were delivered by each runner?
4. How many of each type of pizza was delivered?
5. How many Vegetarian and Meatlovers were ordered by each customer?
6. What was the maximum number of pizzas delivered in a single order?
7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
8. How many pizzas were delivered that had both exclusions and extras?
9. What was the total volume of pizzas ordered for each hour of the day?
10. What was the volume of orders for each day of the week?

***

###  1. How many pizzas were ordered?

```sql 
-- count the number of the rows in the customer_order table
SELECT COUNT(*) AS total_pizzas_ordered
FROM customer_orders;
```
#### Result set:
![Part_A_Question_1](image.png)

***

###  2. How many unique customer orders were made?

```sql
-- count the number of distinct customer ids in customer table
SELECT COUNT(DISTINCT order_id) AS unique_orders
FROM customer_orders;
``` 
	
#### Result set:
![Part_A_Question_2](image-1.png)

***

###  3. How many successful orders were delivered by each runner?

```sql
SELECT runner_id, COUNT(order_id) AS successful_deliveries
FROM runner_orders
WHERE cancellation = ''
GROUP BY runner_id;
``` 

#### Result set:
![Part_A_Question_3](image-2.png)

***

###  4. How many of each type of pizza was delivered?

```sql
SELECT pn.pizza_name, COUNT(co.pizza_id) AS total_delivered
FROM customer_orders co
JOIN pizza_names pn ON co.pizza_id = pn.pizza_id
JOIN runner_orders ro ON co.order_id = ro.order_id
WHERE ro.cancellation = ''
GROUP BY pn.pizza_name;
``` 
	
#### Result set:
![Part_A_Question_4](image-3.png)

***

###  5. How many Vegetarian and Meatlovers were ordered by each customer?

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

###  6. What was the maximum number of pizzas delivered in a single order?

```sql

``` 
	
#### Result set:


***

###  7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?

```sql
-- cleaning the tables so its easier to write the queries 
-- alter the exclustions column so that empty cells have 'null' as value

``` 

#### Result set:



***
