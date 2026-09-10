create database pizza_runner;
use pizza_runner;

CREATE TABLE runners (
  runner_id INTEGER,
  registration_date DATE
);
INSERT INTO runners
  (runner_id, registration_date)
VALUES
  (1, '2021-01-01'),
  (2, '2021-01-03'),
  (3, '2021-01-08'),
  (4, '2021-01-15');
  
CREATE TABLE customer_orders (
  order_id INTEGER,
  customer_id INTEGER,
  pizza_id INTEGER,
  exclusions VARCHAR(4),
  extras VARCHAR(4),
  order_time TIMESTAMP
);
INSERT INTO customer_orders
  (order_id, customer_id, pizza_id, exclusions, extras, order_time)
VALUES
  ('1', '101', '1', '', '', '2020-01-01 18:05:02'),
  ('2', '101', '1', '', '', '2020-01-01 19:00:52'),
  ('3', '102', '1', '', '', '2020-01-02 23:51:23'),
  ('3', '102', '2', '', '', '2020-01-02 23:51:23'),
  ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
  ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
  ('4', '103', '2', '4', '', '2020-01-04 13:23:46'),
  ('5', '104', '1', '', '1', '2020-01-08 21:00:29'),
  ('6', '101', '2', '', '', '2020-01-08 21:03:13'),
  ('7', '105', '2', '', '1', '2020-01-08 21:20:29'),
  ('8', '102', '1', '', '', '2020-01-09 23:54:33'),
  ('9', '103', '1', '4', '1, 5', '2020-01-10 11:22:59'),
  ('10', '104', '1', '', '', '2020-01-11 18:34:49'),
  ('10', '104', '1', '2, 6', '1, 4', '2020-01-11 18:34:49');
  
CREATE TABLE runner_orders (
  order_id INTEGER,
  runner_id INTEGER,
  pickup_time VARCHAR(19),
  distance VARCHAR(7),
  duration VARCHAR(10),
  cancellation VARCHAR(23)
);
INSERT INTO runner_orders
  (order_id, runner_id, pickup_time, distance, duration, cancellation)
VALUES
  ('1', '1', '2020-01-01 18:15:34', '20km', '32 minutes', ''),
  ('2', '1', '2020-01-01 19:10:54', '20km', '27 minutes', ''),
  ('3', '1', '2020-01-03 00:12:37', '13.4km', '20 mins', ''),
  ('4', '2', '2020-01-04 13:53:03', '23.4', '40', ''),
  ('5', '3', '2020-01-08 21:10:57', '10', '15', ''),
  ('6', '3', '', '', '', 'Restaurant Cancellation'),
  ('7', '2', '2020-01-08 21:30:45', '25km', '25mins', ''),
  ('8', '2', '2020-01-10 00:15:02', '23.4 km', '15 minute', ''),
  ('9', '2', '', '', '', 'Customer Cancellation'),
  ('10', '1', '2020-01-11 18:50:20', '10km', '10minutes', '');

CREATE TABLE pizza_names (
  pizza_id INTEGER,
  pizza_name TEXT
);
INSERT INTO pizza_names
  (pizza_id, pizza_name)
VALUES
  (1, 'Meatlovers'),
  (2, 'Vegetarian');

CREATE TABLE pizza_recipes (
  pizza_id INTEGER,
  toppings TEXT
);
INSERT INTO pizza_recipes
  (pizza_id, toppings)
VALUES
  (1, '1, 2, 3, 4, 5, 6, 8, 10'),
  (2, '4, 6, 7, 9, 11, 12');

CREATE TABLE pizza_toppings (
  topping_id INTEGER,
  topping_name TEXT
);
INSERT INTO pizza_toppings
  (topping_id, topping_name)
VALUES
  (1, 'Bacon'),
  (2, 'BBQ Sauce'),
  (3, 'Beef'),
  (4, 'Cheese'),
  (5, 'Chicken'),
  (6, 'Mushrooms'),
  (7, 'Onions'),
  (8, 'Pepperoni'),
  (9, 'Peppers'),
  (10, 'Salami'),
  (11, 'Tomatoes'),
  (12, 'Tomato Sauce');
  
select * from runners;
select * from customer_orders;
select * from runner_orders;
select * from pizza_recipes;
select * from pizza_toppings;



-- A: Pizza Metrics

-- Q1: How many pizzas were ordered?
SELECT COUNT(*) AS total_pizzas_ordered
FROM customer_orders;

-- Q2: How many unique customer orders were made?
SELECT COUNT(DISTINCT order_id) AS unique_orders
FROM customer_orders;

-- Q3: How many successful orders were delivered by each runner?
SELECT runner_id, COUNT(order_id) AS successful_deliveries
FROM runner_orders
WHERE cancellation = ''
GROUP BY runner_id;

-- Q4: How many of each type of pizza was delivered?
SELECT pn.pizza_name, COUNT(co.pizza_id) AS total_delivered
FROM customer_orders co
JOIN pizza_names pn ON co.pizza_id = pn.pizza_id
JOIN runner_orders ro ON co.order_id = ro.order_id
WHERE ro.cancellation = ''
GROUP BY pn.pizza_name;

-- Q5: How many Vegetarian and Meatlovers were ordered by each customer?
SELECT co.customer_id,
       SUM(CASE WHEN pn.pizza_name = 'Meatlovers' THEN 1 ELSE 0 END) AS meatlovers,
       SUM(CASE WHEN pn.pizza_name = 'Vegetarian' THEN 1 ELSE 0 END) AS vegetarian
FROM customer_orders co
JOIN pizza_names pn ON co.pizza_id = pn.pizza_id
GROUP BY co.customer_id;

-- Q6: What was the maximum number of pizzas delivered in a single order?
SELECT MAX(pizza_count) AS max_pizzas_in_single_order
FROM (
    SELECT co.order_id, COUNT(co.pizza_id) AS pizza_count
    FROM customer_orders co
    JOIN runner_orders ro ON co.order_id = ro.order_id
    WHERE ro.cancellation = ''
    GROUP BY co.order_id
) AS order_counts;

-- Q7: For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
SELECT co.customer_id,
       SUM(CASE WHEN co.exclusions = '' AND co.extras = '' THEN 1 ELSE 0 END) AS no_changes,
       SUM(CASE WHEN co.exclusions != '' OR co.extras != '' THEN 1 ELSE 0 END) AS at_least_1_change
FROM customer_orders co
JOIN runner_orders ro ON co.order_id = ro.order_id
WHERE ro.cancellation = ''
GROUP BY co.customer_id;

-- Q8: How many pizzas were delivered that had both exclusions and extras?
SELECT COUNT(*) AS pizzas_with_both_changes
FROM customer_orders co
JOIN runner_orders ro ON co.order_id = ro.order_id
WHERE ro.cancellation = ''
AND co.exclusions != ''
AND co.extras != '';

-- Q9: What was the total volume of pizzas ordered for each hour of the day?
SELECT HOUR(order_time) AS hour_of_day,
       COUNT(*) AS total_pizzas
FROM customer_orders
GROUP BY HOUR(order_time)
ORDER BY hour_of_day;

-- Q10: What was the volume of orders for each day of the week?
SELECT DAYNAME(order_time) AS day_of_week,
       COUNT(*) AS total_pizzas
FROM customer_orders
GROUP BY DAYNAME(order_time), DAYOFWEEK(order_time)
ORDER BY DAYOFWEEK(order_time);




-- B: Runner and Customer Experience

-- Q1: How many runners signed up for each 1 week period? (Week starts from 2021-01-01)
SELECT FLOOR(DATEDIFF(registration_date, '2021-01-01') / 7) + 1 AS week_number,
       COUNT(*) AS runners_signed_up
FROM runners
GROUP BY week_number
ORDER BY week_number;

-- Q2: Average time in minutes for each runner to arrive at HQ to pickup the order
SELECT ro.runner_id,
       ROUND(AVG(TIMESTAMPDIFF(MINUTE, co.order_time, ro.pickup_time))) AS avg_pickup_minutes
FROM runner_orders ro
JOIN customer_orders co ON ro.order_id = co.order_id
WHERE ro.cancellation = ''
GROUP BY ro.runner_id;

-- Q3: Is there any relationship between the number of pizzas and how long the order takes to prepare?
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

-- Q4: What was the average distance travelled for each customer?
SELECT co.customer_id,
       ROUND(AVG(ro.distance), 1) AS avg_distance_km
FROM customer_orders co
JOIN runner_orders ro ON co.order_id = ro.order_id
WHERE ro.cancellation = ''
GROUP BY co.customer_id
ORDER BY co.customer_id;

-- Q5: What was the difference between the longest and shortest delivery times for all orders?
SELECT MAX(duration) - MIN(duration) AS delivery_time_difference
FROM runner_orders
WHERE cancellation = '';

-- Q6: What was the average speed for each runner for each delivery and do you notice any trend for these values?
-- Speed = distance / time (converting minutes to hours)
SELECT ro.runner_id,
       ro.order_id,
       ro.distance,
       ro.duration,
       ROUND(ro.distance / (ro.duration / 60), 1) AS avg_speed_kmh
FROM runner_orders ro
WHERE ro.cancellation = ''
ORDER BY ro.runner_id, ro.order_id;

-- Q7: What is the successful delivery percentage for each runner?
SELECT runner_id,
       COUNT(order_id) AS total_orders,
       SUM(CASE WHEN cancellation = '' THEN 1 ELSE 0 END) AS successful_orders,
       ROUND(SUM(CASE WHEN cancellation = '' THEN 1 ELSE 0 END) * 100 / COUNT(order_id), 0) AS success_percentage
FROM runner_orders
GROUP BY runner_id
ORDER BY runner_id;

-- C: Ingredient Optimisation

-- Q1: What are the standard ingredients for each pizza?
SELECT pn.pizza_name,
       GROUP_CONCAT(pt.topping_name ORDER BY pt.topping_name SEPARATOR ', ') AS standard_ingredients
FROM pizza_names pn
JOIN pizza_recipes pr ON pn.pizza_id = pr.pizza_id
JOIN pizza_toppings pt ON FIND_IN_SET(pt.topping_id, pr.toppings) > 0
GROUP BY pn.pizza_name;

-- Q2: What was the most commonly added extra?
SELECT pt.topping_name,
       COUNT(*) AS times_added
FROM customer_orders co
JOIN pizza_toppings pt ON FIND_IN_SET(pt.topping_id, co.extras) > 0
WHERE co.extras != ''
GROUP BY pt.topping_name
ORDER BY times_added DESC
LIMIT 1;

-- Q3: What was the most common exclusion?
SELECT pt.topping_name,
       COUNT(*) AS times_excluded
FROM customer_orders co
JOIN pizza_toppings pt ON FIND_IN_SET(pt.topping_id, co.exclusions) > 0
WHERE co.exclusions != ''
GROUP BY pt.topping_name
ORDER BY times_excluded DESC
LIMIT 1;

-- Q4: Generate an order item for each record in the customers_orders table in the format of one of the following:
-- Meat Lovers
-- Meat Lovers - Exclude Beef
-- Meat Lovers - Extra Bacon
-- Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers
SELECT 
    co.order_id,
    co.customer_id,
    pn.pizza_name,
    CONCAT(
        pn.pizza_name,
        -- Add exclusions if they exist
        CASE 
            WHEN co.exclusions != '' 
            THEN CONCAT(' - Exclude ', 
                (SELECT GROUP_CONCAT(pt.topping_name ORDER BY pt.topping_name SEPARATOR ', ')
                 FROM pizza_toppings pt
                 WHERE FIND_IN_SET(pt.topping_id, co.exclusions) > 0))
            ELSE ''
        END,
        -- Add extras if they exist
        CASE 
            WHEN co.extras != '' 
            THEN CONCAT(' - Extra ', 
                (SELECT GROUP_CONCAT(pt.topping_name ORDER BY pt.topping_name SEPARATOR ', ')
                 FROM pizza_toppings pt
                 WHERE FIND_IN_SET(pt.topping_id, co.extras) > 0))
            ELSE ''
        END
    ) AS order_description
FROM customer_orders co
JOIN pizza_names pn ON co.pizza_id = pn.pizza_id
ORDER BY co.order_id;

-- Q5: Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredients
-- For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"
SELECT 
    co.order_id,
    co.customer_id,
    pn.pizza_name,
    GROUP_CONCAT(
        CASE 
            WHEN FIND_IN_SET(pt.topping_id, co.extras) > 0 
            THEN CONCAT('2x', pt.topping_name)
            ELSE pt.topping_name
        END
        ORDER BY pt.topping_name SEPARATOR ', '
    ) AS ingredient_list
FROM customer_orders co
JOIN pizza_names pn ON co.pizza_id = pn.pizza_id
JOIN pizza_recipes pr ON co.pizza_id = pr.pizza_id
JOIN pizza_toppings pt 
    ON FIND_IN_SET(pt.topping_id, pr.toppings) > 0
    AND FIND_IN_SET(pt.topping_id, co.exclusions) = 0
GROUP BY co.order_id, co.customer_id, pn.pizza_name
ORDER BY co.order_id;

-- Q6: What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?
-- in all delivered pizzas sorted by most frequent first
SELECT 
    pt.topping_name,
    SUM(
        CASE WHEN FIND_IN_SET(pt.topping_id, co.extras) > 0 THEN 2
             WHEN FIND_IN_SET(pt.topping_id, co.exclusions) > 0 THEN 0
             ELSE 1
        END
    ) AS total_quantity
FROM customer_orders co
JOIN runner_orders ro ON co.order_id = ro.order_id
JOIN pizza_recipes pr ON co.pizza_id = pr.pizza_id
JOIN pizza_toppings pt ON FIND_IN_SET(pt.topping_id, pr.toppings) > 0
WHERE ro.cancellation = ''
GROUP BY pt.topping_name
ORDER BY total_quantity DESC;

-- Part D: Pricing and Ratings

-- Q1: If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money has Pizza Runner made so far if there are no delivery fees?
SELECT 
    SUM(CASE WHEN pn.pizza_name = 'Meatlovers' THEN 12
             WHEN pn.pizza_name = 'Vegetarian' THEN 10
             ELSE 0
        END) AS total_revenue
FROM customer_orders co
JOIN pizza_names pn ON co.pizza_id = pn.pizza_id
JOIN runner_orders ro ON co.order_id = ro.order_id
WHERE ro.cancellation = '';

-- Q2: What if there was an additional $1 charge for any pizza extras?
-- Add cheese is $1 extra
SELECT 
    SUM(
        -- Base pizza price
        CASE WHEN pn.pizza_name = 'Meatlovers' THEN 12
             WHEN pn.pizza_name = 'Vegetarian' THEN 10
             ELSE 0
        END +
        -- Extra toppings charge $1 each
        CASE WHEN co.extras != '' 
             THEN (LENGTH(co.extras) - LENGTH(REPLACE(co.extras, ',', '')) + 1)
             ELSE 0
        END
    ) AS total_revenue
FROM customer_orders co
JOIN pizza_names pn ON co.pizza_id = pn.pizza_id
JOIN runner_orders ro ON co.order_id = ro.order_id
WHERE ro.cancellation = '';


-- Q3: The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, how would you design an additional table for this new dataset - generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.
-- Ratings between 1-5 for each successful delivery

CREATE TABLE runner_ratings (
    rating_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    runner_id INT NOT NULL,
    customer_id INT NOT NULL,
    rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    rating_comment VARCHAR(255),
    rated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Inserting realistic ratings for each successful delivery
INSERT INTO runner_ratings (order_id, runner_id, customer_id, rating, rating_comment)
VALUES
    (1,  1, 101, 5, 'Super fast delivery!'),
    (2,  1, 101, 4, 'Great service'),
    (3,  1, 102, 3, 'A little late but friendly'),
    (4,  2, 103, 1, 'Very late delivery, pizza was cold'),
    (5,  3, 104, 5, 'Perfect delivery!'),
    (7,  2, 105, 4, 'Good service'),
    (8,  2, 102, 4, 'Quick and efficient'),
    (10, 1, 104, 5, 'Excellent as always!');



