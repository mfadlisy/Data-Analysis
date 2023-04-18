-- How is the monthly performance of pizza sales?
SELECT DATENAME(MONTH,o.date) AS [Month],
		COUNT(od.order_id) AS [Count Order],
		SUM(p.price * od.quantity) AS [Revenue]
FROM PizzaSales..orders AS o
 LEFT JOIN PizzaSales..order_details AS od
  ON o.order_id = od.order_id
 LEFT JOIN PizzaSales..pizzas AS p
  ON od.pizza_id = p.pizza_id
GROUP BY DATENAME(month,o.date)
ORDER BY COUNT(od.order_id) DESC;

-- How is the daily performance of pizza sales?
SELECT DATENAME(DAY,o.date) AS [Day],
		COUNT(od.order_id) AS [Count Order],
		SUM(p.price * od.quantity) AS [Revenue]
FROM PizzaSales..orders AS o
 LEFT JOIN PizzaSales..order_details AS od
  ON o.order_id = od.order_id
 LEFT JOIN PizzaSales..pizzas AS p
  ON od.pizza_id = p.pizza_id
GROUP BY DATENAME(DAY,o.date)
ORDER BY COUNT(od.order_id) DESC;

-- What time is the most pizza order?
SELECT DATENAME(HOUR,o.time) AS [Time],
		COUNT(od.order_id) AS [Count Order],
		SUM(p.price * od.quantity) AS [Revenue]
FROM PizzaSales..orders AS o
 LEFT JOIN PizzaSales..order_details AS od
  ON o.order_id = od.order_id
 LEFT JOIN PizzaSales..pizzas AS p
  ON od.pizza_id = p.pizza_id
GROUP BY DATENAME(HOUR,o.time)
ORDER BY COUNT(od.order_id) DESC;

-- What pizza product names are most ordered?
SELECT pt.name AS [Pizza Name],
	   COUNT(od.order_id) AS [Count Pizza],
	   SUM(p.price * od.quantity) AS [Revenue]
FROM PizzaSales..order_details AS od
 LEFT JOIN PizzaSales..pizzas AS p
  ON od.pizza_id = p.pizza_id
 LEFT JOIN PizzaSales..pizza_types AS pt
  ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY COUNT(od.order_id) DESC;

-- What pizza category are most ordered?
SELECT pt.category AS [Pizza Category],
	   COUNT(od.order_id) AS [Count Pizza],
	   SUM(p.price * od.quantity) AS [Revenue]
FROM PizzaSales..order_details AS od
 LEFT JOIN PizzaSales..pizzas AS p
  ON od.pizza_id = p.pizza_id
 LEFT JOIN PizzaSales..pizza_types AS pt
  ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category
ORDER BY COUNT(od.order_id) DESC;

-- What pizza size are most ordered?
SELECT p.size AS [Pizza Size],
	   COUNT(od.order_id) AS [Count Pizza],
	   SUM(p.price * od.quantity) AS [Revenue]
FROM PizzaSales..order_details AS od
 LEFT JOIN PizzaSales..pizzas AS p
  ON od.pizza_id = p.pizza_id
 LEFT JOIN PizzaSales..pizza_types AS pt
  ON p.pizza_type_id = pt.pizza_type_id
GROUP BY p.size
ORDER BY COUNT(od.order_id) DESC;
