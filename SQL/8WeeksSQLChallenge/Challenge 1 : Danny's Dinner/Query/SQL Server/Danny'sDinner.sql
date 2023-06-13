select * from DannysDinner..members
select * from DannysDinner..menu
select * from DannysDinner..sales

-- Q1 : What is the total amount each customer spent at the restaurant?
select s.customer_id,
	   sum(m.price) as amount
from DannysDinner..sales s
left join DannysDinner..menu m
on s.product_id = m.product_id
group by s.customer_id

-- Q2 : How many days has each customer visited the restaurant
SELECT s.customer_id,
	   count (distinct s.order_date) as day
from DannysDinner..sales s
group by s.customer_id

-- Q3 : What was the first item from the menu purchased by each customer?
select customer_id,
	   product_name
from (select s.customer_id,
			 s.order_date,
			 m.product_name,
			 dense_rank() over (partition by s.customer_id order by s.order_date) rank
	  from DannysDinner..sales s
	  left join DannysDinner..menu m on s.product_id = m.product_id
	  left join DannysDinner..members ms on s.customer_id = ms.customer_id) a
where rank = 1
group by customer_id, product_name

-- Q4 : What is the most purchased item on the menu and how many times was it purchased by all customers?
select top 1
	   m.product_name,
	   count(s.customer_id) as times
from DannysDinner..sales s
left join DannysDinner..menu m on s.product_id = m.product_id
group by m.product_name
order by times desc

-- Q5 : Which item was the most popular for each customer?
select customer_id,
	   product_name
from (select s.customer_id,
			 m.product_name,
			 count(m.product_name) order_count,
			 dense_rank() over (partition by s.customer_id order by count(m.product_id) desc) rank
	  from DannysDinner..sales s
	  left join DannysDinner..menu m on s.product_id = m.product_id
	  group by s.customer_id, m.product_name) a
where rank = 1

-- Q6 : Which item was purchased first by the customer after they became a member?
select top 1 with ties
	   s.customer_id,
	   m.product_name,
	   s.order_date,
	   ms.join_date,
	   row_number() over (partition by s.customer_id order by s.order_date)
from DannysDinner..sales s
left join DannysDinner..menu m on s.product_id = m.product_id
left join DannysDinner..members ms on s.customer_id = ms.customer_id
where s.order_date > ms.join_date
order by row_number() over (partition by s.customer_id order by s.order_date)

-- Q7 : Which item was purchased just before the customer became a member?
select customer_id,
	   product_name
from (select s.customer_id,
			 s.order_date,
			 m.product_name,
			 dense_rank() over (partition by s.customer_id order by s.order_date desc) rank
	  from DannysDinner..sales s
	  left join DannysDinner..menu m on s.product_id = m.product_id
	  left join DannysDinner..members ms on s.customer_id = ms.customer_id
	  where s.order_date < ms.join_date) a
where rank = 1
group by customer_id, product_name

-- Q8 : What is the total items and amount spent for each member before they became a member?
select s.customer_id,
	   count(distinct s.product_id) items,
	   sum(m.price) amount
from DannysDinner..sales s
left join DannysDinner..menu m on s.product_id = m.product_id
left join DannysDinner..members ms on s.customer_id = ms.customer_id
where s.order_date < ms.join_date
group by s.customer_id

-- Q9 : If each $1 spent equates to 10 points and sushi has a 2x points multiplier
-- how many points would each customer have?
select s.customer_id,
	   sum(cp.points) points
from DannysDinner..sales s
left join (select *,
		   case when product_name = 'sushi' then price*20
				else price*10 end points
		   from DannysDinner..menu) cp on s.product_id = cp.product_id
group by s.customer_id

-- Q10 : In the first week after a customer joins the program (including their join date)
-- they earn 2x points on all items, not just sushi — how many points do customer A and B
-- have at the end of January?
select customer_id,
	   sum(points) points
from (select s.customer_id,
             case when product_name = 'sushi' and
			           s.order_date between dateadd(day, -1, ms.join_date) and
					   dateadd(day, 6, ms.join_date) then m.price*40
				  when product_name = 'sushi' or
				       s.order_date between dateadd(day, -1, ms.join_date) and
					   dateadd(day, 6,	ms.join_date) then m.price*20
				  else price*10 end points
	  from DannysDinner..members ms
	  left join DannysDinner..sales s on s.customer_id = ms.customer_id
	  left join DannysDinner..menu m on s.product_id = m.product_id
	  where s.order_date <= '20210131') a
group by customer_id

-- Bonus Question
-- Recreate table with column: customer_id, order_date, product_name, price, member(Y/N)
select s.customer_id,
	   s.order_date,
	   m.product_name,
	   m.price,
	   case when s.order_date >= ms.join_date then 'Y'
	        else 'N' end member
from DannysDinner..sales s
left join DannysDinner..menu m on s.product_id = m.product_id
left join DannysDinner..members ms on s.customer_id = ms.customer_id
order by s.customer_id, s.order_date, m.product_name

-- Recreate table with column: customer_id, order_date, product_name, price, member(Y/N),
-- ranking(null/number)
select *,
       case when member = 'Y' then rank() over (partition by customer_id, member order by order_date)
            else NULL end ranking
from (select s.customer_id,
             s.order_date,
             m.product_name,
             m.price,
             case when s.order_date >= ms.join_date then 'Y'
                  else 'N' end member
      from DannysDinner..sales s
      left join DannysDinner..menu m on s.product_id = m.product_id
      left join DannysDinner..members ms on s.customer_id = ms.customer_id) a
order by customer_id, order_date, product_name;
