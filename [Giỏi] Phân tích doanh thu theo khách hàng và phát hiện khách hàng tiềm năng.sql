set search_path to sales;
-- 1. Viết truy vấn hiển thị tổng doanh thu và tổng số đơn hàng của mỗi khách hàng
select o.customer_id, c.customer_name, count(o.customer_id) as order_count, sum(total_price) as total_revenue
from orders o
         join customers c on o.customer_id = c.customer_id
group by o.customer_id, c.customer_name
having sum(total_price) > 2000;
-- 2. Viết truy vấn con (Subquery) để tìm doanh thu trung bình của tất cả khách hàng
select c.*, sum(o.total_price) as total_revenue
from customers c
         join orders o on c.customer_id = o.customer_id
group by c.customer_name, c.customer_id
having sum(o.total_price) > (select avg(total_price)
                             from orders);
-- 3. Dùng HAVING + GROUP BY để lọc ra thành phố có tổng doanh thu cao nhất
select c.city, sum(o.total_price) as total_revenue
from customers c
         join orders o on c.customer_id = o.customer_id
group by c.city
order by sum(o.total_price) desc
limit 1;
-- 4. Dùng INNER JOIN giữa customers, orders, order_items để hiển thị chi tiết: tên khách hàng, tên thành phố, tổng sản phẩm đã mua, tổng chi tiêu
select c.customer_name as "Tên khách hàng", c.city as "Tên thành phố", sum(oi.quantity) as "Tổng sản phẩm đã mua", sum(o.total_price) as "Tổng chi tiêu"
from customers c
         join orders o on c.customer_id = o.customer_id
         join order_items oi on o.order_id = oi.order_id
group by c.customer_id;