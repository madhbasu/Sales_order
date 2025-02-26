select * from customers
select * from products
select * from sales_order

1) Find the average sales order price based on deal size

select deal_size,round(avg(price_each)::decimal,2) as avg_sales
from sales_order
group by deal_size

2) Find total no of orders per each day. Sort data based on highest orders.

select extract(day from order_date),count(*) as no_of_orders
from sales_order
group by extract(day from order_date)
order by 2 desc

3) Display the total sales figure for each quarter. 
Represent each quarter with their respective period

select qtr_id, round(sum(sales)::decimal,2) as total_sales,
case when qtr_id=1 then 'JAN-MAR'
     when qtr_id=2 then 'APR-JUN'
	 when qtr_id=3 then 'JUL-SEP'
	 when qtr_id=4 then 'OCT-DEC'
	 end as quarter
from sales_order
group by qtr_id
order by qtr_id

4) Identify how many cars, Motorcycles, trains and ships are available in the inventory.
Treat all type of cars as just "Cars".

select distinct product_line, count(*)
from products
group by product_line

select product_line, count(*) as no_of_vehicles
from products
where product_line in ('Motorcycles','Ships','Trains')
group by product_line
union all
select  'Cars' as product_line,count(*)
from products
where lower(product_line) like '%cars%'

5) Identify the vehicles in the inventory which are short in number.
Shortage of vehicle is considered when there are less than 10 vehicles.

select product_line,count(*) as no_of_vehicles
from products
group by product_line
having count(*) < 10
order by 2 desc

6) Find the countries which have purchased more than 500 motorcycles.
select * from customers
select * from products
select * from sales_order

select c.country as country,sum(quantity_ordered)
from customers c
join sales_order so on so.customer=c.customer_id
join products p on so.product=p.product_code
where product_line='Motorcycles'
group by c.country
having sum(quantity_ordered) > 500
order by 2 desc;

7) Find the orders where the sales amount is incorrect.

select *
from sales_order
where (quantity_ordered*price_each) <> sales

8) Fetch the total sales done for each day.

select extract(day from order_date) as each_day,round(sum(sales)::decimal,2) as total_sales
from sales_order
group by 1
order by 1

9) Fetch the top 3 months which have been doing the lowest sales.

with cte as
(select month_id,round(sum(sales)::decimal,2) as total_sales,
rank() over(order by round(sum(sales)::decimal,2) asc) rnk
from sales_order
group by 1)
select cte.month_id,cte.total_sales
from cte
where cte.rnk <=3

10) Find total no of orders per each day of the week (monday to sunday). 
Sort data based on highest orders.

select extract(day from order_date),count(*) as no_of_orders
from sales_order
group by 1
order by 2 desc


11) Find out the vehicles which was sold the most and which was sold the least. 
Output should be a single record with 2 columns. 
One column for most sold vehicle and other for least sold vehicle.

with cte as (select concat(product_line,' ',sum(quantity_ordered)) as most_ordered_vehicle
from products p
join sales_order s
on p.product_code=s.product
group by product_line
order by sum(quantity_ordered) desc
limit 1),
cte2 as
(select concat(product_line,' ',sum(quantity_ordered)) as least_ordered_vehicle
from products p
join sales_order s
on p.product_code=s.product
group by product_line
order by sum(quantity_ordered) asc
limit 1)
select * from cte,cte2

12) Find all the orders which do not belong to customers from USA and are still in process.

select * from sales_order so
join customers c
on so.customer=customer_id
where country not in ('USA')
and status in ('In Process')


13) Find all orders for Planes, Ships and Trains which are neither Shipped nor In Process nor Resolved.
select * from sales_order so
join products p
on so.product=p.product_code
where product_line in ('Planes','Ships','Trains')
and status not in ('Shipped','In Process','Resolved')

14) Find customers whose phone number has either parenthesis "()" or a plus sign "+".
select * from customers
where phone like '%()%' or phone like '%+%'

15) Find customers whose phone number does not have any space.

select * from customers
where phone not like '% %'

16) Fetch all the orders between Feb 2003 and May 2003 where the quantity ordered was an even number.

select * from sales_order
where order_date between 2003-02-01 and 2003-05-01
and quantity_ordered%2=0

17) Find orders which sold the product for price higher than its original price.
select * from sales_order so
join products p
on p.product_code=so.product
where so.price_each > p.price

18) Find the average sales order price
select round(avg(price_each)::decimal,2) avg_price
from sales_order

19) Count total no of orders.
select count(*) from sales_order

20) Find the total quantity sold.
select sum(quantity_ordered) as total_quantity

21) Fetch the first order date and the last order date.

select min(order_date) as first_order_Date,max(order_date) as last_order_date
from sales_order
