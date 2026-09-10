# :pizza: Case Study #2: Pizza runner - Ingredient Optimisation WIP

## Case Study Questions

1. What are the standard ingredients for each pizza?
2. What was the most commonly added extra?
3. What was the most common exclusion?
4. Generate an order item for each record in the customers_orders table in the format of one of the following:
- Meat Lovers
- Meat Lovers - Exclude Beef
- Meat Lovers - Extra Bacon
- Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers
5. Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredients
- For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"
6. What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?

***



###  1. What are the standard ingredients for each pizza?

```sql
SELECT pn.pizza_name,
       GROUP_CONCAT(pt.topping_name ORDER BY pt.topping_name SEPARATOR ', ') AS standard_ingredients
FROM pizza_names pn
JOIN pizza_recipes pr ON pn.pizza_id = pr.pizza_id
JOIN pizza_toppings pt ON FIND_IN_SET(pt.topping_id, pr.toppings) > 0
GROUP BY pn.pizza_name;
``` 
	
#### Result set:



***

###  2. What was the most commonly added extra?

```sql
SELECT pt.topping_name,
       COUNT(*) AS times_added
FROM customer_orders co
JOIN pizza_toppings pt ON FIND_IN_SET(pt.topping_id, co.extras) > 0
WHERE co.extras != ''
GROUP BY pt.topping_name
ORDER BY times_added DESC
LIMIT 1;
``` 
	
#### Result set:


***

###  3. What was the most common exclusion?

```sql
SELECT pt.topping_name,
       COUNT(*) AS times_excluded
FROM customer_orders co
JOIN pizza_toppings pt ON FIND_IN_SET(pt.topping_id, co.exclusions) > 0
WHERE co.exclusions != ''
GROUP BY pt.topping_name
ORDER BY times_excluded DESC
LIMIT 1;
``` 
	
#### Result set:



***

###  4. Generate an order item for each record in the customers_orders table in the format of one of the following:
-- Meat Lovers
-- Meat Lovers - Exclude Beef
-- Meat Lovers - Extra Bacon
-- Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers
```sql
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
``` 
	
#### Result set:



***

###  5. Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredients

```sql
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
```
	
#### Result set:

***

###  6. What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?

```sql
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
``` 
	
#### Result set:

***