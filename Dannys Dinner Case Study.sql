CREATE TABLE sales (
  customer_id VARCHAR(1),
  order_date DATE,
  product_id INTEGER
);

INSERT INTO sales
  (customer_id, order_date, product_id)
VALUES
  ('A', '2021-01-01', '1'),
  ('A', '2021-01-01', '2'),
  ('A', '2021-01-07', '2'),
  ('A', '2021-01-10', '3'),
  ('A', '2021-01-11', '3'),
  ('A', '2021-01-11', '3'),
  ('B', '2021-01-01', '2'),
  ('B', '2021-01-02', '2'),
  ('B', '2021-01-04', '1'),
  ('B', '2021-01-11', '1'),
  ('B', '2021-01-16', '3'),
  ('B', '2021-02-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-07', '3');
 

CREATE TABLE menu (
  product_id INTEGER,
  product_name VARCHAR(5),
  price INTEGER
);

INSERT INTO menu
  (product_id, product_name, price)
VALUES
  ('1', 'sushi', '10'),
  ('2', 'curry', '15'),
  ('3', 'ramen', '12');
  

CREATE TABLE members (
  customer_id VARCHAR(1),
  join_date DATE
);

INSERT INTO members
  (customer_id, join_date)
VALUES
  ('A', '2021-01-07'),
  ('B', '2021-01-09');
  
  

/* --------------------
   Case Study Questions
   --------------------*/

-- 1. What is the total amount each customer spent at the restaurant?
SELECT 
    s.customer_id, SUM(m.price) AS total_spend
FROM
    sales s
        JOIN
    menu m ON s.product_id = m.product_id
GROUP BY s.customer_id
ORDER BY total_spend desc;

-- 2. How many days has each customer visited the restaurant?
SELECT 
    customer_id, COUNT(DISTINCT order_date) AS days
FROM
    sales
GROUP BY customer_id
ORDER BY days DESC;

-- 3. What was the first item from the menu purchased by each customer?
SELECT DISTINCT s.customer_id, 
first_value(m.product_name) over(partition by s.customer_id order by s.order_date) as first_item
FROM sales s 
	JOIN menu m 
ON s.product_id = m.product_id;

-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?
SELECT 
    m.product_name, COUNT(1) AS times
FROM
    sales s
        JOIN
    menu m ON s.product_id = m.product_id
GROUP BY m.product_name
ORDER BY times DESC
LIMIT 1;

-- 5. Which item was the most popular for each customer?
with cte as
	(SELECT 
		s.customer_id, m.product_name, COUNT(1) AS times
	FROM
		sales s
			JOIN
		menu m ON s.product_id = m.product_id
	GROUP BY s.customer_id , m.product_name)

select 
	distinct customer_id, 
	first_value(product_name) over(partition by customer_id order by times desc) as top 
from cte;

-- 6. Which item was purchased first by the customer after they became a member?
SELECT 
	DISTINCT customer_id,
	first_value(product_name) over(partition by customer_id order by order_date) as top 
FROM
	(SELECT 
		s.customer_id, 
		mb.join_date,
		s.order_date,
		m.product_name
	FROM
		sales s
			JOIN
		members mb
			JOIN
		menu m ON s.customer_id = mb.customer_id
			AND s.product_id = m.product_id
	WHERE
		s.order_date >= mb.join_date) x;
        
-- 7. Which item was purchased just before the customer became a member?
SELECT 
	DISTINCT customer_id,
	first_value(product_name) over(partition by customer_id order by order_date DESC) as item 
FROM
	(SELECT 
		s.customer_id, 
		mb.join_date,
		s.order_date,
		m.product_name
	FROM
		sales s
			JOIN
		members mb
			JOIN
		menu m ON s.customer_id = mb.customer_id
			AND s.product_id = m.product_id
	WHERE
		s.order_date < mb.join_date) x;
        
-- alternate method--

select x.customer_id, m.product_name
from
	(select 
		s.customer_id, 
		mb.join_date, 
		s.order_date, 
		s.product_id,
		rank() over(partition by s.customer_id order by s.order_date DESC) as rn
	from sales s join members mb
	on s.customer_id = mb.customer_id
	where s.order_date < mb.join_date) x
join menu m 
	on x.product_id = m.product_id
where rn=1 
order by customer_id;


-- 8. What is the total items and amount spent for each member before they became a member?
SELECT 
    s.customer_id,
    COUNT(s.product_id) AS items,
    SUM(m.price) AS amt
FROM
    sales s
        JOIN
    menu m
        JOIN
    members mb ON s.product_id = m.product_id
        AND s.customer_id = mb.customer_id
WHERE
    s.order_date < mb.join_date
GROUP BY s.customer_id;


-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
SELECT 
    s.customer_id,
    SUM(CASE
        WHEN m.product_name = 'sushi' THEN 20 * m.price
        ELSE 10 * m.price
    END) AS points
FROM
    sales s
        JOIN
    menu m ON s.product_id = m.product_id
GROUP BY s.customer_id;


-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, 
-- not just sushi - how many points do customer A and B have at the end of January?

SELECT 
    s.customer_id,
    SUM(CASE
        WHEN s.order_date BETWEEN mb.join_date AND DATE_ADD(mb.join_date, INTERVAL 6 DAY) THEN 20 * m.price
        ELSE (CASE
            WHEN m.product_name = 'sushi' THEN 20 * m.price
            ELSE 10 * m.price
        END)
    END) AS points
FROM
    sales s
        JOIN
    members mb
        JOIN
    menu m ON s.customer_id = mb.customer_id
        AND s.product_id = m.product_id
WHERE
    EXTRACT(MONTH FROM s.order_date) = 1
GROUP BY s.customer_id;


-- Q11. Join All The Things that Danny and his team can use to quickly derive insights without needing to join the underlying tables using SQL --
SELECT 
    x.*,
    CASE
        WHEN mb.join_date IS NULL THEN 'N'
        ELSE CASE
            WHEN x.order_date >= mb.join_date THEN 'Y'
            ELSE 'N'
        END
    END AS member
FROM
    (SELECT 
        s.customer_id, s.order_date, m.product_name, m.price
    FROM
        sales s
    JOIN menu m ON s.product_id = m.product_id) x
        LEFT JOIN
    members mb ON x.customer_id = mb.customer_id;
    

-- Q12. Rank All The Things --
with cte as
(SELECT 
    x.*,
    CASE
        WHEN mb.join_date IS NULL THEN 'N'
        ELSE CASE
            WHEN x.order_date >= mb.join_date THEN 'Y'
            ELSE 'N'
        END
    END AS member
FROM
    (SELECT 
        s.customer_id, s.order_date, m.product_name, m.price
    FROM
        sales s
    JOIN menu m ON s.product_id = m.product_id) x
        LEFT JOIN
    members mb ON x.customer_id = mb.customer_id)

SELECT 
	cte.*,
    CASE
		WHEN cte.member='N' then null
        ELSE RANK() OVER(PARTITION BY cte.customer_id, cte.member order by cte.order_date)
        END AS ranking
	from cte;
			
