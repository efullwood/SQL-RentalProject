use uptown;

-- What is the list of all instrument rentals in inventory? 
select * from rental;
select * from instrument;


-- What are the youngest and oldest customers of Uptown Rentals? Write one SQL program to display both.
select cust_name, cust_age
from customer
where cust_age = (select max(cust_age) from customer)
union all
select cust_name, cust_age
from customer
where cust_age = (select min(cust_age) from customer);


-- List the aggregated (summed) rental amounts per customer. 
-- Sequence the result to show the customer with the highest rental amount first.
select customer_ID, cust_name, sum(rental_cost)
as 'total rental cost'
from customer
join rental on customer.customer_ID = rental.customer_customer_ID  
group by customer_ID
order by `total rental cost` desc;

-- Which customer has the most rentals (the highest count) across all time?
select customer_ID, cust_name, count(rent_date) as 'total rentals'
from customer
join rental on customer.customer_ID = rental.customer_customer_ID
group by customer_ID
order by `total rentals` desc
limit 3;
-- Ric Martin and Lauren Cox are tied at 2 rentals

-- Which customer had the most rentals in January 2015, and what was their average rental total per rental?
select customer_ID, cust_name, count(rent_date) as 'total rentals', 
avg(rental_cost) as 'average rental cost'
from customer
join rental on customer.customer_ID = rental.customer_customer_ID
where rental.rent_date between '2015-01-01' and '2015-01-31'
group by customer_ID
order by `total rentals` desc
limit 1;

-- Which staff member (name) is associated with the most rentals in January 2015?
select staff_ID, staff_name , count(rent_date) as 'total rentals'
from staff
join rental on staff.staff_ID = rental.staff_staff_ID
where rental.rent_date between '2015-01-01' and '2015-01-31'
group by staff_ID
order by `total rentals` desc
limit 1;

-- For each customer that has an overdue rental, how many days have passed since the rental was due?
select cust_name, days_overdue
from customer
join rental on customer.customer_ID = rental.customer_customer_ID
where rental.days_overdue > 0;
-- Ric Martin has had two instances of days overdue, each for two days.

-- What is the total rental amount by Rental tier?
select sum(rental_cost) as 'total cost' , daily_overdue_fee_rent_tier
as 'Rental Tier'
from rental
join instrument on rental.instrument_serial_num = instrument.serial_num
group by daily_overdue_fee_rent_tier;

-- Who are the top three store staff members in terms of total rental amounts?
select staff_ID, staff_name , count(rent_date) as 'total rentals'
from staff
join rental on staff.staff_ID = rental.staff_staff_ID
group by staff_ID
order by `total rentals` desc;
-- Only Liz Conners and Tom Lindel currently have rentals

-- What is the total rental amount by instrument type, where the instrument type is Flute or Bass Guitar?
select daily_cost_inst_type as 'instrument type',
count(rental.rent_date) as 'total rentals', 
sum(rental.rental_cost) as 'total rental cost'
from rental
join instrument on rental.instrument_serial_num = instrument.serial_num
where daily_cost_inst_type in ('Flute', 'Bass Guitar')
group by daily_cost_inst_type;


-- What is the name of any customer who has two or more overdue rentals?
select customer.cust_name
from customer
join rental on customer.customer_ID = rental.customer_customer_ID
where rental.days_overdue > 0
group by customer.customer_ID, customer.cust_name
having count(rental.rental_ID) >= 2;
-- Ric Martin

-- How many unique instruments has each customer ordered?
select customer.cust_name, count(distinct rental.instrument_serial_num) as 'unique instruments rented'
from customer
join rental on customer.customer_ID = rental.customer_customer_ID
group by customer.cust_name;

-- Which customer spent the most on a rental?
select customer.cust_name
from customer
where customer.customer_ID = 
(select rental.customer_customer_ID
    from rental
    group by rental.customer_customer_ID
    order by sum(rental.rental_cost) desc
    limit 1);
-- Joseph Dow


show errors;