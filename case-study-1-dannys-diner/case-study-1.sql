CREATE DATABASE dannys_diner;
USE dannys_diner;
CREATE TABLE sales (
    customer_id VARCHAR(10),
    order_date date,
    product_id INT
);


INSERT INTO sales VALUES
('A','2021-01-01',1),
('A','2021-01-01',2),
('A','2021-01-07',2),
('A','2021-01-10',3),
('A','2021-01-11',3),
('A','2021-01-11',3),
('B','2021-01-01',2),
('B','2021-01-02',2),
('B','2021-01-04',1),
('B','2021-01-11',1),
('B','2021-01-16',3),
('B','2021-02-01',3),
('C','2021-01-01',3),
('C','2021-01-01',3),
('C','2021-01-07',3);


CREATE TABLE menu (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50),
    price INT
);

INSERT INTO menu VALUES
(1,'sushi',10),
(2,'curry',15),
(3,'ramen',12);


CREATE TABLE members (
    customer_id VARCHAR(10),
    join_date DATE
);

INSERT INTO members VALUES
('A','2021-01-07'),
('B','2021-01-09');

select * from menu;
select * from Sales;
select * from members;


-- Q1: What is the total amount each customer spent at the restaurant?
SELECT customer_id, sum(price) as 'total_spent' FROM sales
JOIN menu ON menu.product_id = sales.product_id
GROUP BY customer_id;



-- Q2: How many days has each customer visited the restaurant?
SELECT customer_id,COUNT(DISTINCT(order_date)) AS 'nr_of_visits' FROM sales
GROUP BY customer_id;



-- Q3: What was the first item from the menu purchased by each customer?
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



-- Q4: What is the most purchased item on the menu and how many times was it purchased by all customers?
Select m.product_name, count(s.product_id) as most_purchased
from sales as s
Join menu as m
 On s.product_id = m.product_id
group by m.product_name
Order By most_purchased desc
limit 1;


-- Q5: Which item was the most popular for each customer?
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


-- Q6: Which item was purchased first by the customer after they became a member?
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



-- Q7: Which item was purchased just before the customer became a member?
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


-- Q8: What is the total items and amount spent for each member before they became a member?
SELECT s.customer_id, COUNT(s.product_id) AS total_items, SUM(m.price) AS total_amount_spent
FROM sales AS s
JOIN menu AS m
ON s.product_id = m.product_id
JOIN members AS mem
ON s.customer_id = mem.customer_id
WHERE s.order_date < mem.join_date
GROUP BY s.customer_id;


-- Q9: If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
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



-- Q10: In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?
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