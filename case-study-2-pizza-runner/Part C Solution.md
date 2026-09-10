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
<img width="292" height="92" alt="Screenshot 2026-09-10 164905" src="https://github.com/user-attachments/assets/2083ab97-9ae2-4866-ab63-5262a4806364" />

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
<img width="265" height="57" alt="Screenshot 2026-09-10 164921" src="https://github.com/user-attachments/assets/5e8ba11b-5cb9-4fe6-a286-3d63c962e71a" />

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
<img width="262" height="61" alt="Screenshot 2026-09-10 164928" src="https://github.com/user-attachments/assets/cf8968d4-a826-43bd-8977-c27200820d91" />


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
<img width="482" height="331" alt="Screenshot 2026-09-10 165001" src="https://github.com/user-attachments/assets/4c164e07-3704-418c-ad14-571efd04c36c" />


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
<img width="432" height="272" alt="Screenshot 2026-09-10 165016" src="https://github.com/user-attachments/assets/263ed689-5e32-4d6a-a978-3b2183fa043e" />


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
<img width="260" height="97" alt="Screenshot 2026-09-10 165025" src="https://github.com/user-attachments/assets/e9641f5b-c366-46d4-b56a-e3952827e55d" />

***
