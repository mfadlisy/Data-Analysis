-- Sales Analysis Questions

-- How many total pizza sales per month?
SELECT DATENAME(MONTH,o.date) AS month,
       COUNT(od.order_id) AS count_order,
	   SUM(od.quantity) as total_sales,
	   SUM(p.price * od.quantity) AS sales_income
FROM PizzaSales..order_details od
LEFT JOIN PizzaSales..orders o ON od.order_id = o.order_id
LEFT JOIN PizzaSales..pizzas p ON od.pizza_id = p.pizza_id
GROUP BY DATENAME(MONTH,o.date)
ORDER BY SUM(od.quantity) DESC

-- How many total pizza sales per day?
SELECT DATENAME(DAY,o.date) AS day,
       COUNT(od.order_id) AS count_order,
	   SUM(od.quantity) as total_sales,
	   SUM(p.price * od.quantity) AS sales_income
FROM PizzaSales..order_details od
LEFT JOIN PizzaSales..orders o ON od.order_id = o.order_id
LEFT JOIN PizzaSales..pizzas p ON od.pizza_id = p.pizza_id
GROUP BY DATENAME(DAY,o.date)
ORDER BY SUM(od.quantity) DESC

-- What are the busiest hours when it comes to ordering pizza?
SELECT DATENAME(HOUR,o.time) AS time,
		COUNT(od.order_id) AS count_order,
		SUM(od.quantity) AS total_sales
FROM PizzaSales..orders AS o
 LEFT JOIN PizzaSales..order_details AS od
  ON o.order_id = od.order_id
 LEFT JOIN PizzaSales..pizzas AS p
  ON od.pizza_id = p.pizza_id
GROUP BY DATENAME(HOUR,o.time)
ORDER BY total_sales DESC

-- What type of pizza sells the most?
SELECT TOP 5 pt.name AS pizza_type,
       SUM(od.quantity) AS total_sales
FROM PizzaSales..order_details od
LEFT JOIN PizzaSales..pizzas p ON od.pizza_id = p.pizza_id
LEFT JOIN PizzaSales..pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY total_sales DESC

-- What is the most ordered pizza size?
SELECT TOP 5 size,
       SUM(quantity) AS total_sales
FROM PizzaSales..order_details
JOIN PizzaSales..pizzas ON order_details.pizza_id = pizzas.pizza_id
GROUP BY size
ORDER BY total_sales DESC;

-- What is the total revenue from pizza sales?
SELECT SUM(od.quantity * p.price) AS total_revenue
FROM PizzaSales..order_details od
JOIN PizzaSales..pizzas p ON od.pizza_id = p.pizza_id;
