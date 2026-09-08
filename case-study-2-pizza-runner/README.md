# 🍕 Case Study #2: Pizza Runner

## Table of Contents
- [Problem Statement](#problem-statement)
- [Dataset Overview](#dataset-overview)
- [Business Questions](#business-questions)
- [Approach](#approach)

---

## Problem Statement

Danny launched Pizza Runner, a pizza delivery service that combines an Uber-like runner network with a mobile app for orders. He has collected data on orders, runners, and pizza customisations, but needs analytical insights to optimise his delivery operations and better understand customer behaviour.

The objective of this case study is to analyse operational data using SQL to generate meaningful business insights related to delivery performance, pizza preferences, and runner efficiency.

Official Case Study Source:
https://8weeksqlchallenge.com/case-study-2/

---

## Dataset Overview

The dataset consists of six relational tables containing information about runners, orders, pizzas, and toppings.

### Runners Table
Records runner registration information.

| Column | Description |
|---|---|
| runner_id | Unique identifier for each runner |
| registration_date | Date the runner registered |

### Customer Orders Table
Records every pizza ordered by customers.

| Column | Description |
|---|---|
| order_id | Unique identifier for each order |
| customer_id | Unique identifier for each customer |
| pizza_id | Identifier of the ordered pizza |
| exclusions | Ingredients removed from the pizza |
| extras | Ingredients added to the pizza |
| order_time | Timestamp when the order was placed |

### Runner Orders Table
Records delivery information for each order.

| Column | Description |
|---|---|
| order_id | Unique identifier for each order |
| runner_id | Identifier of the assigned runner |
| pickup_time | Time the runner picked up the order |
| distance | Distance travelled for delivery |
| duration | Time taken for delivery |
| cancellation | Reason for cancellation if applicable |

### Pizza Names Table
Maps pizza IDs to their names.

| Column | Description |
|---|---|
| pizza_id | Unique identifier for each pizza |
| pizza_name | Name of the pizza |

### Pizza Recipes Table
Records the standard toppings for each pizza.

| Column | Description |
|---|---|
| pizza_id | Unique identifier for each pizza |
| toppings | List of topping IDs for the pizza |

### Pizza Toppings Table
Maps topping IDs to their names.

| Column | Description |
|---|---|
| topping_id | Unique identifier for each topping |
| topping_name | Name of the topping |

---

## Business Questions

This case study is divided into sections:

### A. Pizza Metrics
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

### B. Runner and Customer Experience
1. How many runners signed up for each 1 week period?
2. What was the average time in minutes it took for each runner to arrive at Pizza Runner HQ to pickup the order?
3. Is there any relationship between the number of pizzas and how long the order takes to prepare?
4. What was the average distance travelled for each customer?
5. What was the difference between the longest and shortest delivery times for all orders?
6. What was the average speed for each runner for each delivery?
7. What is the successful delivery percentage for each runner?

---

## Approach

The analysis was performed using structured SQL techniques including:
- Joining multiple tables to combine operational and product data
- Aggregating data using functions such as COUNT, SUM, AVG, and MAX
- Using date and time functions such as TIMESTAMPDIFF, HOUR, and DAYNAME
- Applying subqueries to answer multi-step business questions
- Using conditional logic with CASE WHEN to categorise and pivot data
- Cleaning inconsistent data by standardising NULL and empty values
