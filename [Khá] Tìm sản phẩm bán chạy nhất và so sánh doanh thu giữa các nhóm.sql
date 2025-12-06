create schema sales;
set search_path to sales;

create table customers
(
    customer_id   serial primary key,
    customer_name varchar(50),
    city          varchar(50)
);

create table products
(
    product_id   serial primary key,
    product_name varchar(50),
    category     varchar(50)
);

create table orders
(
    order_id    int primary key,
    customer_id int references customers (customer_id),
    order_date  date,
    total_price decimal(10, 2)
);

create table order_items
(
    item_id    serial primary key,
    order_id   int references orders (order_id),
    product_id int references products (product_id),
    quantity   int,
    price      decimal(10, 2)
);

INSERT INTO customers (customer_name, city)
VALUES ('Nguyễn Văn A', 'Hà Nội'),
       ('Trần Thị B', 'Đà Nẵng'),
       ('Lê Văn C', 'Hồ Chí Minh'),
       ('Phạm Thị D', 'Hà Nội');
INSERT INTO products (product_name, category)
VALUES ('Laptop Dell', 'Electronics'),
       ('IPhone 15', 'Electronics'),
       ('Bàn học gỗ', 'Furniture'),
       ('Ghế xoay', 'Furniture');
INSERT INTO orders (order_id, customer_id, order_date, total_price)
VALUES (101, 1, '2024-12-20', 3000),
       (102, 2, '2025-01-05', 1500),
       (103, 1, '2025-02-10', 2500),
       (104, 3, '2025-02-15', 4000),
       (105, 4, '2025-03-01', 800);
INSERT INTO order_items (order_id, product_id, quantity, price)
VALUES (101, 1, 2, 1500),
       (102, 2, 1, 1500),
       (103, 3, 5, 500),
       (104, 2, 4, 1000);


-- Viết truy vấn con (Subquery) để tìm sản phẩm có doanh thu cao nhất trong bảng orders
select p.*, max(o.total_price) as total_revenue
from products p
         join order_items oi on p.product_id = oi.product_id
         join orders o on oi.order_id = o.order_id
group by p.product_id, p.product_name
having max(total_price) >= all (select total_price from orders);

-- Viết truy vấn hiển thị tổng doanh thu theo từng nhóm category
select p.category, sum(o.price * o.quantity) as total_revenue
from order_items o
         join products p on o.product_id = p.product_id
group by p.category;

select p.category, max(o.total_price) as total_revenue
from products p
         join order_items oi on p.product_id = oi.product_id
         join orders o on oi.order_id = o.order_id
group by p.product_id, p.product_name
having max(total_price) >= all (select total_price from orders)
intersect
select p.category, max(o.total_price) as total_revenue
from products p
         join order_items oi on p.product_id = oi.product_id
         join orders o on oi.order_id = o.order_id
where o.total_price > 3000
group by p.product_id, p.product_name;
