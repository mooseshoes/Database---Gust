-- Joseph Gust  2/14/2017   Lab 4

-- Question 1
select city
from agents
where aid in (select aid
			from orders
			where cid = 'c006'
			)
;

-- Question 2
select distinct pid
from orders
where aid in (select aid
    from orders
    where cid = ( select cid
        from customers
        where city = 'Kyoto'
        )
    )
order by pid DESC
;

-- Question 3
select cid, name
from customers
where cid not in( select distinct cid
			   from orders
			   where aid = 'a01'
              )
;

-- Question 4
select cid
from orders
where pid = 'p07'
and cid in (select distinct cid
    from orders
    where pid = 'p01'
    )
;

-- Question 5
select pid
from products
where pid not in (select pid
				  from orders
				  where cid in( select distinct cid
			    			    from orders
			 				    where aid = 'a08'
                )
)
order by pid DESC
;

-- Question 6
select name, discount, city
from customers
where cid in (select distinct cid
			  from orders
			  where aid in (select aid
              				from agents
             				where city in ('Tokyo', 'New York')
             				)
)
;

-- Question 7
select *
from customers
where discount in (select discount
				   from customers
				   where city in ('Duluth', 'London')
                   )
-- I decided not to include the customers in Duluth & London, if
-- you want to include them just highlight the above code and
-- leave out the code following this comment
and cid not in (select cid
				from customers
				where city in ('Duluth', 'London')
                )
;

-- Question 8
-- Check constraints allow you to restrict the potential values for 
-- columns in a table.  So let's say you have a table for an employee, 
-- and you have an age column.  You would want the values in the age
-- column to be above 0, because you're probably not going to hire someone
-- who hasn't yet been born.
-- A bad use of check constraints would be limiting a person's net worth
-- to a positive number.  Although there are no negative dollar bills, a
-- person can be in debt making it possible to have a negative net worth.