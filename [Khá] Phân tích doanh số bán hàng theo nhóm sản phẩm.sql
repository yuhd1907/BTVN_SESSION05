create schema sales;
set search_path to sales;
-- Tạo bảng products
create table products
(
    product_id   serial primary key,
    product_name varchar(50),
    category     varchar(50)
);
-- Tạo bảng orders
create table orders
(
    order_id    int primary key,
    product_id  int references products (product_id),
    quantity    int,
    total_price decimal(15, 2)
);
-- Thêm dữ liệu vào bảng products và orders
INSERT INTO products (product_name, category)
VALUES ('Laptop Dell', 'Electronics'),
       ('IPhone 15', 'Electronics'),
       ('Bàn học gỗ', 'Furniture'),
       ('Ghế xoay', 'Furniture');
INSERT INTO orders (order_id, product_id, quantity, total_price)
VALUES (101, 1, 2, 2200),
       (102, 2, 3, 3300),
       (103, 3, 5, 2500),
       (104, 4, 4, 1600),
       (105, 1, 1, 1100);
-- Truy vấn hiển thị tổng doanh thu và số lượng sản phẩm bán được co từng nhóm doanh mục
select p.category, sum(o.total_price) as total_sales, sum(o.quantity) as total_quantity
from orders as o
         join products p on o.product_id = p.product_id
group by p.category;
-- Chỉ hiển thị những nhóm có tổng doanh thu lớn hơn 2000
select category
from products
         join orders o on products.product_id = o.product_id
group by category
having sum(total_price) > 2000;
-- Sắp xếp theo tổng doanh thu giảm dần
select category
from products
         join orders o on products.product_id = o.product_id
group by category
order by sum(total_price) desc;