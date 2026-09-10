# :pizza: Case Study #2: Pizza runner - Pricing and Ratings

## Case Study Questions

1. If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money has Pizza Runner made so far if there are no delivery fees?
2. What if there was an additional $1 charge for any pizza extras? Add cheese is $1 extra
3. The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, how would you design an additional table for this new dataset - generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.
4. Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries?
- customer_id
- order_id
- runner_id
- rating
- order_time
- pickup_time
- Time between order and pickup
- Delivery duration
- Average speed
- Total number of pizzas
5. If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled - how much money does Pizza Runner have left over after these deliveries?

***

###  1. If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money has Pizza Runner made so far if there are no delivery fees?

```sql
SELECT 
    SUM(CASE WHEN pn.pizza_name = 'Meatlovers' THEN 12
             WHEN pn.pizza_name = 'Vegetarian' THEN 10
             ELSE 0
        END) AS total_revenue
FROM customer_orders co
JOIN pizza_names pn ON co.pizza_id = pn.pizza_id
JOIN runner_orders ro ON co.order_id = ro.order_id
WHERE ro.cancellation = '';
``` 
	
#### Result set:


***

###  2. What if there was an additional $1 charge for any pizza extras? Add cheese is $1 extra

```sql
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
``` 
	
#### Result set:



***

###  3. The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, how would you design an additional table for this new dataset - generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.

```sql
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

``` 
	
#### Result set:



***

###  4. Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries?

- customer_id
- order_id
- runner_id
- rating
- order_time
- pickup_time
- Time between order and pickup
- Delivery duration
- Average speed
- Total number of pizzas

```sql

``` 
	
#### Result set:


***

###  5. If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled - how much money does Pizza Runner have left over after these deliveries?

```sql
 
``` 
	
#### Result set:

***


