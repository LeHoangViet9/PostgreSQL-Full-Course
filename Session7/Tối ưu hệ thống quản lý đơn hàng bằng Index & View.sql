CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    city VARCHAR(50)
);
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    category TEXT[],
    price NUMERIC(10,2)
);
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    product_id INT REFERENCES products(product_id),
    order_date DATE,
    quantity INT
);
INSERT INTO customers (full_name, email, city) VALUES 
('Nguyen Van A', 'a.nguyen@email.com', 'Ha Noi'),
('Tran Thi B', 'b.tran@email.com', 'Ho Chi Minh'),
('Le Van C', 'c.le@email.com', 'Da Nang'),
('Pham Thi D', 'd.pham@email.com', 'Can Tho'),
('Hoang Van E', 'e.hoang@email.com', 'Hai Phong');
INSERT INTO products (product_name, category, price) VALUES 
('Laptop Dell XPS', '{Electronics, Computers}', 1500.00),
('iPhone 15 Pro', '{Electronics, Mobile}', 1200.00),
('Samsung Monitor', '{Electronics, Accessories}', 300.00),
('Mechanical Keyboard', '{Accessories, Peripheral}', 100.00),
('Wireless Mouse', '{Accessories, Peripheral}', 50.00);
INSERT INTO orders (customer_id, product_id, order_date, quantity) VALUES 
(1, 1, '2024-01-10', 1), 
(1, 4, '2024-01-12', 2), 
(2, 2, '2024-01-15', 1), 
(2, 5, '2024-01-15', 1), 
(3, 3, '2024-01-18', 2), 
(4, 1, '2024-01-20', 1), 
(4, 2, '2024-01-22', 1), 
(5, 5, '2024-01-25', 5), 
(1, 2, '2024-01-26', 1), 
(3, 4, '2024-01-27', 1);

--Tạo chỉ mục B-tree trên cột email để tối ưu tìm khách hàng theo email
create index idx_customers_email on customers(email);

--Tạo chỉ mục Hash trên cột city để lọc theo thành phố
create index idx_customers_city on customers using hash(city)

--Tạo chỉ mục GIN trên cột category của products để hỗ trợ tìm theo danh mục (mảng)
create index idx_products_category on products using gin(category);

--Tạo chỉ mục GiST trên cột price để hỗ trợ tìm sản phẩm trong khoảng giá
create index idx_products_price on products using gist(price);

--Tìm khách hàng có email cụ thể
EXPLAIN ANALYZE
select * from custorm where email='a.nguyen@email.com';

-- Tìm sản phẩm có category chứa 'Electronics'
-- Lưu ý: Với kiểu mảng TEXT[], ta dùng toán tử @>
EXPLAIN ANALYZE
select * from products where category @>'{Electronics}';

-- Tìm sản phẩm trong khoảng giá từ 500 đến 1000
EXPLAIN ANALYZE
select * from products where price between 500 and 1000;

-- Index cho email (Thực tế UNIQUE constraint đã tự tạo index này, nhưng ta có thể tạo lại để test)
CREATE INDEX idx_customers_email ON customers(email);

-- Index cho khoảng giá
CREATE INDEX idx_products_price ON products(price);

-- GIN Index cho cột category (Kiểu mảng)
CREATE INDEX idx_products_category ON products USING GIN (category);

--Thực hiện Clustered Index trên bảng orders theo cột order_date
create index idx_orders_order_date on orders(order_date)
CLUSTER orders using idx_orders_order_date

--Sử dụng View để:
--Xem top 3 khách hàng mua nhiều nhất
create view v_top3_customer as
select c.full_name, sum(o.quantity) as total_quantity_purchased
from customers c join orders o on o.customer_id = c.customer_id
group by c.full_name
order by total_quantity_purchased desc limit 3

--Xem tổng doanh thu theo từng sản phẩm
create view v_revenue_by_product as 
select p.product_name,sum(o.quantity*p.price) as total_revenue
from products p join orders o on o.product_id = p.product_id
group by p.product_name;

--Tạo View để chỉnh sửa thành phố (city)
create view v_customer_city as 
select customer_id,full_name,city from customers

update v_customer_city set city='Da Lat' where customer_id=1


