# 🍜🍔🍣 Case Study #1: Danny's Diner

## Case Study Questions
1. What is the total amount each customer spent at the restaurant?
2. How many days has each customer visited the restaurant?
3. What was the first item from the menu purchased by each customer?
4. What is the most purchased item on the menu and how many times was it purchased by all customers?
5. Which item was the most popular for each customer?
6. Which item was purchased first by the customer after they became a member?
7. Which item was purchased just before the customer became a member?
10. What is the total items and amount spent for each member before they became a member?
11. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
12. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?
***

## Q1. What is the total amount each customer spent at the restaurant?

```sql
SELECT customer_id, SUM(price) AS total_spent
FROM sales
JOIN menu ON menu.product_id = sales.product_id
GROUP BY customer_id;
```

### Result set:

| customer_id | total_spent |
| ----------- | ----------- |
| A           | 76          |
| B           | 74          |
| C           | 36          |

*** 

###  Q2: How many days has each customer visited the restaurant?

```sql
SELECT customer_id, COUNT(DISTINCT(order_date)) AS 'nr_of_visits' FROM sales
GROUP BY customer_id;
```
## Result set:
| customer_id | nr_of_visits      |
| ----------- | ------------      |
| A           | 4                 |
| B           | 6                 |
| C           | 2                 |

***

## Q3: What was the first item from the menu purchased by each customer?

```sql
WITH first_orders AS (
    SELECT
        s.customer_id,
        m.product_name,
        DENSE_RANK() OVER (
            PARTITION BY s.customer_id
            ORDER BY s.order_date
        ) AS purchase_rank
    FROM sales AS s
    JOIN menu AS m
        ON s.product_id = m.product_id
)
SELECT
    customer_id,
    product_name AS first_item
FROM first_orders
WHERE purchase_rank = 1;
```
## Result set:
| customer_id | first_item |
| ----------- | ---------- |
| A           | sushi      |
| A           | curry      |
| B           | curry      |
| C           | ramen      |
| C           | ramen      |
***

### Q4: What is the most purchased item on the menu and how many times was it purchased by all customers?

```sql
Select m.product_name, count(s.product_id) as most_purchased
from sales as s
Join menu as m
 On s.product_id = m.product_id
group by m.product_name
Order By most_purchased desc
limit 1;
```

## Result set:
| product_name | most_purchased |
| ------------ | -------------- |
| ramen        | 8              |
***

### Q5: Which item was the most popular for each customer?

```sql
with customer_product_counts As(
Select s.customer_id, m.product_name, count(s.product_id) as purchase_count,
DENSE_RANK () Over(
partition by  s.customer_id
order by count(s.product_id) desc
) as rank_no
from sales as s
Join menu as m
 On s.product_id = m.product_id
group by s.customer_id, m.product_name
)
Select  customer_id, product_name, purchase_count
FROM customer_product_counts
WHERE rank_no = 1
ORDER BY customer_id;
```

### Result Set:
| customer_id | product_name | purchase_count |
| ----------- | ------------ | -------------- |
| A           | ramen        | 3              |
| B           | curry        | 2              |
| B           | ramen        | 2              |
| B           | sushi        | 2              |
| C           | ramen        | 3              |

***


### Q6:  Which item was purchased first by the customer after they became a member?

```sql
with member_orders as (
Select s.customer_id, s.order_date, m.product_name,
DENSE_RANK() over (
partition by s.customer_id
order by s.order_date
) As order_rank
from sales as s
join members as mem
on s.customer_id = mem.customer_id
join menu as m
ON s.product_id = m.product_id
    WHERE s.order_date >= mem.join_date
)
select customer_id, product_name, order_date
FROM member_orders
WHERE order_rank = 1
ORDER BY customer_id;
```

### Result Set:
| customer_id | product_name | order_date |
| ----------- | ------------ | ---------- |
| A           | curry        | 2021-01-07 |
| B           | sushi        | 2021-01-11 |

***


### Q7: Which item was purchased just before the customer became a member?

```sql
with member_orders as (
Select s.customer_id, s.order_date, m.product_name,
DENSE_RANK() over (
partition by s.customer_id
order by s.order_date
) As order_rank
from sales as s
join members as mem
on s.customer_id = mem.customer_id
join menu as m
ON s.product_id = m.product_id
WHERE s.order_date < mem.join_date
)
select customer_id, product_name, order_date
FROM member_orders
WHERE order_rank = 1
ORDER BY customer_id;
```

### Result Set:
|customer_id|product_name|order_date |
| --------- | ---------- | --------- |
|A	        |sushi       |2021-01-01 |
|A	        |curry	     |2021-01-01 |
|B	        |curry	     |2021-01-01 |
***


### Q8: What is the total items and amount spent for each member before they became a member?

```sql
SELECT s.customer_id, COUNT(s.product_id) AS total_items, SUM(m.price) AS total_amount_spent
FROM sales AS s
JOIN menu AS m
ON s.product_id = m.product_id
JOIN members AS mem
ON s.customer_id = mem.customer_id
WHERE s.order_date < mem.join_date
GROUP BY s.customer_id;
```

### Result Set:
| customer_id | total_items | total_amount_spent |
| ----------- | ----------- | ------------------ |
| A           | 2           | 25                 |
| B           | 3           | 40                 |
***


### Q9: If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?

```sql
SELECT s.customer_id, 
SUM(
        CASE
            WHEN m.product_id = '1' THEN m.price * 10 * 2
            ELSE m.price * 10
        END
    ) AS total_points
FROM sales AS s
JOIN menu AS m
ON s.product_id = m.product_id
GROUP BY s.customer_id;
```

### Result Set:
| customer_id | total_points |
| ----------- | ------------ |
| A           | 860          |
| B           | 940          |
| C           | 360          |
***


### Q10: In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?


```sql
SELECT s.customer_id,
SUM(
        CASE
            WHEN s.order_date BETWEEN mem.join_date AND mem.join_date + 6
                THEN m.price * 10 * 2
            WHEN m.product_name = 'sushi'
                THEN m.price * 10 * 2
            ELSE m.price * 10
        END
    ) AS total_points
FROM sales AS s
JOIN menu AS m
    ON s.product_id = m.product_id
JOIN members AS mem
    ON s.customer_id = mem.customer_id
WHERE s.order_date <= '2021-01-31'
GROUP BY s.customer_id;
```

### Result Set:
| customer_id | total_points |
| ----------- | ------------ |
| A           | 1370         |
| B           | 820          |

***


