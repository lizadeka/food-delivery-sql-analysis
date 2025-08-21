use online_food_del;

-- Query 1: Find top 3 most frequently ordered items.
select 
	mi.item_name, 
    sum(od.quantity) as most_freq_ordered
from menu_items mi
join order_details od on od.item_id = mi.item_id
group by mi.item_name
order by most_freq_ordered desc
limit 3
;

-- Query 2: Find average quantity per order per restaurant.
select r.restaurant_name ,round(avg(od.quantity),1) as AverageQuantityPerOrder
from restaurant r
join orders o on o.restaurant_id = r.restaurant_id
join order_details od on od.order_id = o.order_id
group by r.restaurant_name
;

-- Query 3: List customers and the restaurants they’ve ordered from more than once.
select c.customer_name,
	r.restaurant_name,
    count(o.order_id) as orders
from customers c
join orders o on o.customer_id = c.customer_id
join restaurant r on r.restaurant_id = o.restaurant_id
group by c.customer_name, r.restaurant_name
having orders > 1
;

-- Query 4: Top 5 expensive menu items
with RankedMenu as (
    select 
        item_name,
        price,
        ROW_NUMBER() over (order by price desc) as rn
    from menu_items
)
select item_name, price
from RankedMenu
where rn <= 5;

-- Query 5: Count Orders Placed by Metro vs Non-Metro Customers
select -- c.customer_id ,
		-- c.customer_name, 
        -- c.city,
		count(o.order_id) as orders,
        case when c.city = "Delhi" then "Metro customer"
			when c.city = "Mumbai" then "Metro customer"
			else "Non-Metro customer"
		end as City_type
from customers c
join orders o on o.customer_id = c.customer_id
group by City_type
-- order by orders desc
;

-- Query 6: High vs Low Value Orders (Based on Total Price)
select od.order_id,
	sum(od.quantity*mi.price) as total_value,
    case when sum(od.quantity*mi.price) > 1000 then "High value"
		else "Low value"
	end as order_category
from order_details od
join menu_items mi on mi.item_id = od.item_id
group by od.order_id
;

-- Query 7: Customer reward tier by number of orders placed
with reward_tier as 
( select c.customer_name, 
	count(distinct o.order_id) as total_orders,
 case
		when count(distinct o.order_id) >= 10 then "Gold"
         when count(distinct o.order_id) between 5 and 9 then "Silver"
         else "Bronze"
 	end as reward
from customers c
join orders o on o.customer_id = c.customer_id
group by c.customer_name
order by total_orders desc
)
select rt.reward,
		count(*) as num_customers
from reward_tier rt
group by  rt.reward
order by num_customers desc
;

-- Query 8: Find customers who placed more orders than the average number of orders per customer.
select customer_name, 
	customer_id
from customers 
where customer_id in (
	select customer_id
    from orders
    group by customer_id
    having count(customer_id) > (
		select avg(order_count)
			from (
            select customer_id, count(order_id) as order_count
            from orders
            group by customer_id
    )as customer_orders
    )
    )
;

-- Query 9: Find all restaurants that have received more orders than the average number of orders per restaurant.
SELECT 
	r.restaurant_id,
	r.restaurant_name,
    count(o.order_id) as total_count
    from restaurant r
    join orders o on o.restaurant_id = r.restaurant_id
    group by r.restaurant_id
    having count(o.order_id) > (
		select round(avg(total_count),2) from (
			select restaurant_id,
				count(o.order_id) as total_count
                from orders o
                group by restaurant_id
			) as temp
		)
    ;

-- Query 10: List the most frequently ordered menu item (overall), and how many times it was ordered.
select item_name,
	order_count as times_ordered
    from (
select sum(od.quantity) as order_count, 
	mi.item_name
    from menu_items mi
    join order_details od on mi.item_id = od.item_id
    group by mi.item_name
    order by order_count desc
    limit 3
    ) as temp
    ;
    
-- Query 11: First Order of Each Customer
select * from
(select customer_id,
		order_id, restaurant_id, order_date,
        row_number() over(partition by customer_id order by order_date) as r_n
        from orders ) as temp
where r_n = 1;

-- Query 12: Get First Item in the Menu per restaurant (Find the alphabetically first item per restaurant.)
select * from
(select restaurant_id, item_name,
	row_number() over(partition by restaurant_id order by item_name) as items
    from menu_items
    ) as temp
    where items = 1;
    
-- Query 13:Restaurant with Highest Price Menu Item ,1 per restaurant ---(Find the most expensive item in each restaurant.)
select * from 
(
select restaurant_id, item_name, price,
row_number() over(partition by restaurant_id order by price desc) as expensive_item
from menu_items ) as temp
where expensive_item = 1;

-- Query 14: Get Previous and Next Item Ordered by Each Customer
select customer_id,
	order_id,
    order_date,
    lag(order_id) over(partition by customer_id order by order_date) as prev_order_id,
    lead(order_id) over(partition by customer_id order by order_date) as next_order_id
    from orders    
;

-- Query 15: Next Order Date for Each Customer (Look ahead to see when the customer placed their next order.)
select c.customer_id, c.customer_name,
	o.order_date as current_order_date,
	lead(o.order_date) over(partition by customer_id order by order_date) as next_order_date
from orders o
join customers c on c.customer_id = o.customer_id;

-- Query 16 : Find the Cheapest Item per Restaurant
select * from (
select mi.restaurant_id, 
	r.restaurant_name,
	mi.price,
    mi.item_name,
    rank() over(partition by restaurant_id order by price asc) as cheap_item
    from menu_items mi
    join restaurant r on r.restaurant_id = mi.restaurant_id
    ) as temp
where cheap_item = 1
order by price asc
;
    ;
    
-- Query 17: Rank Restaurants by Total Revenue Without Gaps (restaurants with the same revenue should have the same rank, without skipping numbers.)
select mi.restaurant_id,
	sum(mi.price * od.quantity) as total_revenue,
    dense_rank() over(order by sum(mi.price * od.quantity) desc) as rank_1
    from menu_items mi
    join order_details od on od.item_id = mi.item_id
    group by mi.restaurant_id
    ;
    
-- Query 18: customer_total_spend
create view customer_total_spend as
select c.customer_id, 
		c.customer_name, 
        sum(od.quantity * mi.price) as total_spent
from customers c
join orders o on o.customer_id = c.customer_id
join order_details od on od.order_id = o.order_id
join menu_items mi on mi.item_id = od.item_id
group by c.customer_id
;
-- filter customers : big spenders > 10000
select * from customer_total_spend
where total_spent > 10000;

-- Query 19: Create a SQL view named avg_spend_per_order that displays each order’s ID, the customer ID, and the total spend for that order.
create view avg_spend_per_order as
select  o.order_id, 
		c.customer_id,
        sum(od.quantity * mi.price) as total_spent
from customers c
join orders o on o.customer_id = c.customer_id
join order_details od on od.order_id = o.order_id
join menu_items mi on mi.item_id = od.item_id
group by o.order_id, c.customer_id
;
-- filtering : avg_spend is greater than 5000
select * from avg_spend_per_order
where total_spent > 5000;

-- Query 20: Create a SQL view named restaurant_performance that displays each restaurant’s ID, name, total number of orders, and total
-- revenue.
create view restaurant_performance as
select r.restaurant_id,
		r.restaurant_name,
        count(distinct o.order_id) as total_orders,
        sum(od.quantity * mi.price) as total_revenue
from restaurant r
join orders o on o.restaurant_id = r.restaurant_id
join order_details od on od.order_id = o.order_id
join menu_items mi on mi.item_id = od.item_id
group by r.restaurant_id, r.restaurant_name
;
-- filtering : top performing restaurants
select * from restaurant_performance
order by total_revenue desc
limit 5
;

-- Query 21: Create a SQL view named city_customer_spending that displays each city and the total amount spent by customers from that city.
create view city_customer_spending as
select c.city, 
		-- c.customer_name, 
        sum(od.quantity * mi.price) as total_spent
from customers c
join orders o on o.customer_id = c.customer_id
join order_details od on od.order_id = o.order_id
join menu_items mi on mi.item_id = od.item_id
group by c.city
;
-- filtering : top 5 cities
select * from city_customer_spending
order by total_spent desc
limit 5;

-- Query 22: Create a SQL view named customers_without_orders that lists all customers who have never placed an order. The view should include the
-- customer ID, name, email, city, and signup date.
create view customers_without_orders as
select c.customer_id,
		c.customer_name,
        c.email,
        c.city,
        c.signup_date
from customers c
left join orders o on o.customer_id = c.customer_id
where o.order_id is null
-- group by c.customer_id, c.customer_name
;
select * from customers_without_orders;


-- Query 23 — “Big cart” orders: orders with 5+ items (quantity-wise)
-- Goal:
-- Find orders with 5+ items using a temp table of order item counts.

create temporary table temp_big_cart as
select o.order_id,
		sum(od.quantity) as total_items
from orders o
join order_details od on od.order_id = o.order_id
group by o.order_id
;

select * from temp_big_cart
where total_items >= 5
;

-- Query 24 — High Value Orders
-- Goal:
-- Make a temporary table with each order’s total value.
-- Then, show only orders above ₹1,000.

create temporary table temp_High_Value_Orders as
select o.order_id,
		c.customer_id, 
		c.customer_name, 
        sum(od.quantity * mi.price) as total_spent
from customers c
join orders o on o.customer_id = c.customer_id
join order_details od on od.order_id = o.order_id
join menu_items mi on mi.item_id = od.item_id
group by o.order_id;

select * 
 from temp_High_Value_Orders
where total_spent > 1000
order by total_spent asc;
    

-- Query 25: Total orders per customer
with orders_per_customer as
(select o.customer_id,
		count(o.order_id) as total_orders
        from orders o
        group by o.customer_id)
        
select c.customer_name, opc.total_orders
from orders_per_customer opc
join customers c on c.customer_id = opc.customer_id
order by total_orders desc
;

-- Query 26. Customers who never ordered 
with not_active_customers as
( select o.customer_id,
	count(o.order_id) as times_ordered
	from orders o
    group by o.customer_id
)
select c.customer_id,
 		c.customer_name,
		nac.times_ordered
from customers c
left join not_active_customers nac on nac.customer_id = c.customer_id
where nac.customer_id is null
;

-- Query 27. Items sold per day (quantity) 
with day_items as
(select o.order_date as d,
	sum(od.quantity) as items_sold
	from order_details od
    join orders o on o.order_id = od.order_id
    group by o.order_date
)
select *
from day_items
order by d
;

-- Query 28. Customers Who Ordered From More Than 3 Restaurants
with cust_rest_count as 
(select customer_id,
	count(distinct restaurant_id) as rest_count
    from orders
    group by customer_id
)
select c.customer_name, cr.rest_count
	from cust_rest_count cr
    join customers c on c.customer_id = cr.customer_id
    where cr.rest_count > 3
    order by cr.rest_count desc
    ;
    
-- Query 29. Restaurant Revenue Leaderboard - We want to rank restaurants based on how much money they made. 
with rest_revenue as
(select mi.restaurant_id,
	sum(mi.price * od.quantity) as total_revenue,
    rank() over(order by sum(mi.price * od.quantity) desc) as revenue_rank
    from menu_items mi
    join order_details od on od.item_id = mi.item_id
    group by mi.restaurant_id)

select r.restaurant_name,
	rr.total_revenue,
    rr.revenue_rank
from rest_revenue rr
join restaurant r on r.restaurant_id = rr.restaurant_id
order by rr.total_revenue desc
;

-- Query 30:Customers in a Specific City
delimiter //
create procedure customerincity(in city_name varchar(5))
begin
select * from customers
where city = city_name;
end //
delimiter ;

call customerincity('Delhi');

-- Query 31: Best-Selling Menu Items
delimiter //
create procedure bestsellingitems(in limit_num int)
begin
select mi.item_name,
		sum(od.quantity) as total_sold
from menu_items mi
join order_details od on od.item_id = mi.item_id
group by mi.item_name
order by total_sold desc
limit limit_num;
end //
delimiter ;

call bestsellingitems(5);

-- Query 32. Top N Customers by Orders - Task: Make a stored procedure that shows the top N customers based on how many orders they have placed.
delimiter //
create procedure customers_by_orders(in limit_num int)
begin
select
		c.customer_name,
		count(o.order_id) as total_orders
        from orders o
        join customers c on c.customer_id = o.customer_id
        group by c.customer_id, c.customer_name
        order by total_orders desc
        limit limit_num
        ;
end //
delimiter ;

call customers_by_orders(4);

-- Query 33. First Order Date for Each Customer - Task: Make a stored procedure that shows when each customer placed their very first order.
delimiter //
create procedure first_order_of_customer()
begin
select o.customer_id,
		min(o.order_date) as first_order
	from orders o
    group by customer_id
;
end //
delimiter ;

call first_order_of_customer();

-- Query 34:  Customer Signups Category - Task: Classify customers as “Early Bird” (signup before 2024), “Regular” (2024), or “New” (2025)
select customer_id,
		customer_name,
        case when year(signup_date) < 2024 then "Early Bird"
			when year(signup_date) = 2024 then "Regular"
            else "New"
		end as Signup_category
from customers;

-- Query 35: Monthly Order Summary - Task: Build a CTE for monthly orders and then filter only months with >50 orders.
with monthly_order_summary as
( select monthname(order_date) as month,
		count(order_id) as total_orders
        from orders
        group by monthname(order_date)
)
select * 
from monthly_order_summary
where total_orders > 50
;

-- Query 36: Restaurants With More Items Than Avg - Task: Show restaurants that offer more menu items than the overall average.
select r.restaurant_id,
		r.restaurant_name,
        count(mi.item_id) as item_count
from restaurant r
join menu_items mi on mi.restaurant_id = r.restaurant_id
group by r.restaurant_id, r.restaurant_name
having count(mi.item_id) >
(
select round(avg(item_count),2) as avg_item_count from
(
select count(item_id) as item_count
 from menu_items
 group by restaurant_id
) as temp
);

-- Query 37: Restaurant Size Category -- Task: Based on menu items, mark restaurants as Small (<5 items), Medium (5–10), or Large (>10) and then count the restaurants in each category
with categorized as (
    select r.restaurant_id,
           r.restaurant_name,
           count(mi.item_id) as item_count,
           case 
               when count(mi.item_id) > 10 then 'Large'
               when count(mi.item_id) between 5 and 10 then 'Medium'
               else 'Small'
           end as size_category
    from restaurant r
    join menu_items mi on mi.restaurant_id = r.restaurant_id
    group by r.restaurant_id, r.restaurant_name
)
select size_category, count(*) as restaurant_count
from categorized
group by size_category
order by restaurant_count desc;
