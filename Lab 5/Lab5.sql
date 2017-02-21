-- Joseph Gust  2/21/17   Lab 5

-- Question 1
-- Show the cities of agents booking an order for a customer whose id is 'c006'. Use joins
select a.city
from orders o inner join customers c on o.cid = c.cid
			  inner join agents a on o.aid = a.aid
where o.cid = 'c006'
;

-- Question 2 NOT FINISHED
-- Show the ids of products ordered through any agent who makes at least one order for 
-- a customer in Kyoto, sorted by pid from highest to lowest. Use joins; no subqueries. 
select o1.pid
from orders o1 full outer join orders o2 on o1.ordnumber = o2.ordnumber
			   inner join customers c on o1.cid = c.cid
			   inner join agents a on o1.aid = a.aid
where o1.aid = o2.aid
	and c.city = 'Kyoto'
order by o1.pid DESC
;

-- Question 3
-- Show the names of customers who have never placed an order. Use a subquery.
select name
from customers
where cid not in (select distinct cid
				  from orders
                  )
;

-- Question 4
-- Show the names of customers who have never placed an order. Use an outer join.
select c.name
from orders o full outer join customers c on o.cid = c.cid
where o.cid is null
;

-- Question 5
-- Show the names of customers who placed at least one order through an agent in their 
-- own city, along with those agent(s') names. 
select distinct c.name as "customer",
	  			a.name as "agent"
from orders o inner join customers c on o.cid = c.cid
	  	      inner join agents a on o.aid = a.aid
where c.city = a.city
;

-- Question 6
-- Show the names of customers and agents living in the same city, along with the name of the
-- shared city, regardless of whether or not the customer has ever placed an order with that agent.
select c.name as "customer",
	   a.name as "agent",
       c.city as "city"
from customers c inner join agents a on c.city = a.city
;

-- Question 7  NOT FINISHED
-- Show the name and city of customers who live in thecity that makes the fewest
-- different kinds of products. (Hint: Use count and group by on the Products table.)
select c.name as "name",
	   c.city as "city",
       count(p.city) as "products" 
from products p inner join customers c on p.city = c.city
group by c.name, c.city
order by "products" ASC
;