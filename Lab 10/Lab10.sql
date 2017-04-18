-- Joseph Gust 4/18/17--

-- #1 preReqsFor --
create or replace function preReqsFor(int, REFCURSOR) returns refcursor as 
$$
declare
   myCourseNum int       := $1;
   resultset   REFCURSOR := $2;
begin
   open resultset for 
  	  select num, name, credits
      from courses
      where num in (select preReqNum
     			   from   Prerequisites
       			   where  courseNum = myCourseNum
                   );
   return resultset;
end;
$$ 
language plpgsql;

select preReqsFor(499, 'results');
Fetch all from results;

-- #2 isPreReqFor --
create or replace function isPreReqFor(int, REFCURSOR) returns refcursor as 
$$
declare
   myCourseNum int       := $1;
   resultset   REFCURSOR := $2;
begin
   open resultset for 
  	  select num, name, credits
      from courses
      where num in (select courseNum
     			   from   Prerequisites
       			   where  preReqNum = myCourseNum
                   );
   return resultset;
end;
$$ 
language plpgsql;

select isPreReqFor(120, 'results');
Fetch all from results;