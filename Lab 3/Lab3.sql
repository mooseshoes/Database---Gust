-- Joseph Gust   2/7/2017    Lab 3
-- Question 1
select ordnumber, totalusd
from orders;

-- Question 2
select name, city
from agents
where name = 'Smith';

-- Question 3
select pid, name, priceusd
from products
where quantity > 200100;

-- Question 4
select name, city
from customers
where city = 'Duluth';

-- Question 5
select name
from agents
where city != 'New York'
  and city != 'Duluth';
  
-- Question 6
select *
from products
where city != 'Dallas'
  and city != 'Duluth'
  and priceusd >= 1;
  
-- Question 7
Select *
from orders
where month = 'Feb'
   or month = 'May';
   
-- Question 8
select *
from orders
where month = 'Feb'
  and totalusd >= 600;
  
-- Question 9
select *
from orders
where cid = 'c005';