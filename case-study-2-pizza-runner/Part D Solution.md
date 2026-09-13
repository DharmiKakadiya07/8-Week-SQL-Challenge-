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
<img width="145" height="50" alt="Screenshot 2026-09-13 132855" src="https://github.com/user-attachments/assets/b1651c1b-71f3-4eb1-946b-73123eba27aa" />

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
<img width="172" height="47" alt="Screenshot 2026-09-13 132928" src="https://github.com/user-attachments/assets/0cf3c628-4576-4995-beaa-b353eb069149" />

***

###  3. The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, how would you design an additional table for this new dataset - generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.

```sql
DROP TABLE IF EXISTS runner_rating;
CREATE TABLE runner_rating (order_id INTEGER, rating INTEGER) ;

-- Order 6 and 9 were cancelled
INSERT INTO runner_rating
VALUES ('1', '1'),
       ('2', '1'),
       ('3', '4'),
       ('4', '1'),
       ('5', '2'),
       ('7', '5'),
       ('8', '2'),
       ('10', '5');
       
SELECT * FROM runner_rating;
``` 
	
#### Result set:
<img width="157" height="197" alt="Screenshot 2026-09-13 132727" src="https://github.com/user-attachments/assets/72042aba-0ee8-435a-ba13-91da6916a42b" />


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
SELECT 
    co.customer_id,
    co.order_id,
    ro.runner_id,
    rr.rating,
    co.order_time,
    ro.pickup_time,
    ROUND(TIMESTAMPDIFF(MINUTE, co.order_time, ro.pickup_time)) AS time_to_pickup_mins,
    ro.duration AS delivery_duration_mins,
    ROUND(ro.distance / (ro.duration / 60), 1) AS avg_speed_kmh,
    COUNT(co.pizza_id) AS total_pizzas
FROM customer_orders co
JOIN runner_orders ro ON co.order_id = ro.order_id
JOIN runner_ratings rr ON co.order_id = rr.order_id
WHERE ro.cancellation = ''
GROUP BY 
    co.customer_id,
    co.order_id,
    ro.runner_id,
    rr.rating,
    co.order_time,
    ro.pickup_time,
    ro.duration,
    ro.distance
ORDER BY co.order_id;
``` 
	
#### Result set:
<img width="1170" height="226" alt="Screenshot 2026-09-13 131629" src="https://github.com/user-attachments/assets/d8275c7c-ff91-4b3e-b5a9-afab85d5c260" />

***

###  5. If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled - how much money does Pizza Runner have left over after these deliveries?

```sql
SELECT 
    ROUND(
        SUM(
            CASE WHEN pn.pizza_name = 'Meatlovers' THEN 12
                 WHEN pn.pizza_name = 'Vegetarian' THEN 10
                 ELSE 0
            END
        ) - SUM(DISTINCT ro.distance * 0.30)
    , 2) AS profit_after_runner_payments
FROM customer_orders co
JOIN pizza_names pn ON co.pizza_id = pn.pizza_id
JOIN runner_orders ro ON co.order_id = ro.order_id
WHERE ro.cancellation = '';

``` 
	
#### Result set:
<img width="255" height="60" alt="Screenshot 2026-09-13 131757" src="https://github.com/user-attachments/assets/2d870101-6095-4c94-a571-0bea73459aef" />

***


