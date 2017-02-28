-- Joseph Gust 2/27/17 Lab 6

-- Question 1
-- Display the name and city of customers who live in any city that makes the most different kinds of products. 

select c.name,
	   c.city
from customers c
where c.city =(select city
			   from products p2			 
           	   group by city
           	   order by count(city) DESC
               limit 1
               )
;

-- Question 2
-- Display the names of products whose priceUSD is strictly above the average priceUSD, 
-- in reverse-alphabetical order.

select name
from products
where priceUSD > (select avg(priceUSD)
				   from products
				   )
group by name, priceUSD
order by name DESC
;

-- Question 3
-- Display the customer name, pid ordered, and the total for all orders, sorted by total 
-- from low to high. 

select c.name,
	   o.pid,
	   o.totalUSD
from orders o inner join customers c on o.cid = c.cid
order by o.totalUSD ASC

-- Question 4
-- Display all customer names (in alphabetical order) and their total ordered, and 
-- nothing more. Use coalesce to avoid showing NULLs. 

select c.name,
	   sum(totalUSD) as "totalOrdered"
from orders o inner join customers c on o.cid = c.cid
group by o.cid, c.name
order by name ASC
;

-- Question 5
-- Display the names of all customers who bought products from agents based in Newark along with
-- the names of the products they ordered, and the names of the agents who sold it to them. 

select c.name as "Customer",
	   p.name as "Product",
       a.name as "Agent"
from orders o inner join customers c on o.cid = c.cid
			  inner join products p on o.pid = p.pid
              inner join agents a on o.aid = a.aid
where a.city = 'Newark'
;
       
-- Question 6
-- Write a query to check the accuracy of the totalUSD column in the Orders table. This 
-- means calculating Orders.totalUSD from data in other tables and comparing those values to
-- the values in Orders.totalUSD. Display all rows in Orders where Orders.totalUSD is 
-- incorrect, if any. 

-- All of the totals are correct if you take out the discount but not the commission
-- but I also took commission out, making them all incorrect
select o.*, (p.priceUSD * o.qty) - (p.priceUSD * o.qty * (c.discount / 100)) - (((p.priceUSD * o.qty) - (p.priceUSD * o.qty * (c.discount / 100))) *  (a.commissionPCT / 100))
from orders o inner join customers c on o.cid = c.cid
			  inner join products p on o.pid = p.pid
              inner join agents a on o.aid = a.aid
where o.totalUSD != (p.priceUSD * o.qty) - (p.priceUSD * o.qty * (c.discount / 100)) - (((p.priceUSD * o.qty) - (p.priceUSD * o.qty * (c.discount / 100))) *  (a.commissionPCT / 100))
;

-- Question 7
-- What’s the difference between a LEFT OUTER JOIN and a RIGHT OUTER JOIN? Give 
-- example queries in SQL to demonstrate. (Feel free to use the CAP database to make 
-- your points here.)


-- A LEFT OUTER JOIN takes all rows from the left table and joins them with any matches from
-- the right table.  If there are no matches from the right table it will put null where
-- values from the right table would go.

-- Every order has a matching customer so this LEFT OUTER JOIN has no null values
select *
from orders o LEFT OUTER JOIN customers c on o.cid = c.cid
;

-- A RIGHT OUTER JOIN is the same as a LEFT OUTER JOIN, but it takes all rows from the right
-- table and tries to find matches from the left table.

-- Not Every customer has made an order, so there are null values in this RIGHT OUTER JOIN
select *
from orders o RIGHT OUTER JOIN customers c on o.cid = c.cid
;
