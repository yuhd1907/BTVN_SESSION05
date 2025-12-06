create schema sales1;
set search_path to sales1;

CREATE TABLE customers
(
    customer_id   SERIAL PRIMARY KEY,
    customer_name VARCHAR(100),
    city          VARCHAR(50)
);

CREATE TABLE orders
(
    order_id     SERIAL PRIMARY KEY,
    customer_id  INT REFERENCES customers (customer_id),
    order_date   DATE,
    total_amount NUMERIC(10, 2)
);

CREATE TABLE order_items
(
    item_id      SERIAL PRIMARY KEY,
    order_id     INT REFERENCES orders (order_id),
    product_name VARCHAR(100),
    quantity     INT,
    price        NUMERIC(10, 2)
);

-- Thêm dữ liệu vào bảng customers
INSERT INTO customers (customer_name, city)
VALUES ('Nguyen Van A', 'Ha Noi'),
       ('Tran Thi B', 'Ho Chi Minh'),
       ('Le Van C', 'Da Nang');

-- Thêm dữ liệu vào bảng orders
-- (Giả sử customer_id 1, 2, 3 tương ứng với các khách hàng vừa tạo ở trên)
INSERT INTO orders (customer_id, order_date, total_amount)
VALUES (1, '2023-10-01', 1500000.00),
       (2, '2023-10-02', 250000.50),
       (1, '2023-10-05', 500000.00);

-- Thêm dữ liệu vào bảng order_items
-- (Giả sử order_id 1, 2, 3 tương ứng với các đơn hàng vừa tạo ở trên)
INSERT INTO order_items (order_id, product_name, quantity, price)
VALUES (1, 'Ban phim co', 1, 1000000.00),
       (1, 'Chuot khong day', 1, 500000.00),
       (2, 'Tai nghe', 1, 250000.50),
       (3, 'Lot chuot', 2, 250000.00);


-- ALIAS:
-- Hiển thị danh sách tất cả các đơn hàng với các cột:
-- Tên khách (customer_name)
-- Ngày đặt hàng (order_date)
-- Tổng tiền (total_amount)
select c.customer_name "Tên khách", o.order_date "Ngày đặt hàng", o.total_amount "Tổng tiền"
from customers c
         join orders o on c.customer_id = o.customer_id;
-- Aggregate Functions:
-- Tính các thông tin tổng hợp:
-- Tổng doanh thu (SUM(total_amount))
-- Trung bình giá trị đơn hàng (AVG(total_amount))
-- Đơn hàng lớn nhất (MAX(total_amount))
-- Đơn hàng nhỏ nhất (MIN(total_amount))
-- Số lượng đơn hàng (COUNT(order_id))
select sum(total_amount), avg(total_amount), max(total_amount), min(total_amount), count(order_id)
from orders;
-- GROUP BY / HAVING:
-- Tính tổng doanh thu theo từng thành phố
-- chỉ hiển thị những thành phố có tổng doanh thu lớn hơn 10.000
select c.city, sum(total_amount) as total_revenue
from customers c
         join orders o on c.customer_id = o.customer_id
group by c.city
having sum(total_amount) > 10000;
-- JOIN:
-- Liệt kê tất cả các sản phẩm đã bán, kèm:
-- Tên khách hàng
-- Ngày đặt hàng
-- Số lượng và giá
-- (JOIN 3 bảng customers, orders, order_items)
select oi.product_name, c.customer_name, o.order_date, oi.quantity, oi.price
from customers c
         join orders o on c.customer_id = o.customer_id
         join order_items oi on o.order_id = oi.order_id;
-- Subquery:
-- Tìm tên khách hàng có tổng doanh thu cao nhất.
-- Gợi ý: Dùng SUM(total_amount) trong subquery để tìm MAX
select customer_name
from customers
where customer_id = (select customer_id as total_revenue
                     from orders
                     group by customer_id
                     order by sum(total_amount) desc
                     limit 1);
-- UNION và INTERSECT:
-- Dùng UNION để hiển thị danh sách tất cả thành phố có khách hàng hoặc có đơn hàng
-- Dùng INTERSECT để hiển thị các thành phố vừa có khách hàng vừa có đơn hàng
select city
from customers
union
select c.city
from customers c
         join orders o on c.customer_id = o.customer_id;

select city
from customers
intersect
select c.city
from customers c
         join orders o on c.customer_id = o.customer_id;