
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;
DROP TYPE IF EXISTS status_type;
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    full_name VARCHAR(50),
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(15) NOT NULL UNIQUE,
    city VARCHAR(100),
    join_date DATE
);

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(30),
    price NUMERIC(15,2) CHECK (price > 0),
    stock_quantity INT CHECK (stock_quantity >= 0)
);

CREATE TYPE status_type AS ENUM ('PENDING', 'CONFIRMED', 'DELIVERED', 'SUCCESS');

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    order_date DATE DEFAULT CURRENT_DATE,
    total_amount NUMERIC(15,2) CHECK (total_amount > 0),
    status status_type DEFAULT 'PENDING'
);
CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT NOT NULL REFERENCES orders(order_id) ON DELETE CASCADE,
    product_id INT NOT NULL REFERENCES products(product_id),
    quantity INT CHECK (quantity > 0),
    unit_price NUMERIC(15,2) CHECK (unit_price > 0)
);


-- 1 Insert 
--Them 10 khach hang voi day du thong tin
insert into customers(full_name,email,phone,city,join_date) values
('Trần Trịnh Ngọc Hà','ngocha1@gmail.com','0345168451','Hưng Yên','2025-06-14'),
('Trần Trịnh Phương Tuấn','phuongtuan@gmail.com','0343468452','Bến Tre','2025-07-14'),
('Cristiano Ronaldo','ronaldo@gmail.com','0345466843','Lisbon','2025-06-25'),
('Lionel Messi','messi@gmail.com','0847468454','Rosario','2023-12-12'),
('Nguyễn Thanh Tùng','mtp@gmail.com','034458455','Hưng Yên','2025-05-10'),
('Flop Quá','flop@gmail.com','0354716846','Hà Nội','2025-12-31'),
('Trần Tổng','tong@gmail.com','0342366847','Hưng Yên','2025-06-14'),
('Lê Hoàng Việt','leviet@gmail.com','0345168458','Hưng Yên','2025-06-14'),
('Em Của Ngày Hôm Qua','2013@gmail.com','0878168459','Thái Bình','2025-06-14'),
('Nơi Này Có Anh','2017@gmail.com','0347768460','Hưng Yên','2025-09-04');

--Thêm 15 sản phẩm – ít nhất 3 danh mục
INSERT INTO products (product_name, category, price, stock_quantity) VALUES
('iPhone 15','Electronics',25000000,10),
('Samsung S24','Electronics',22000000,8),
('Laptop Dell','Electronics',18000000,5),
('Tai nghe Sony','Electronics',3500000,0),
('Áo thun nam','Fashion',250000,20),
('Quần jean','Fashion',500000,15),
('Giày Nike','Fashion',2500000,12),
('Bàn học','Furniture',1500000,7),
('Ghế văn phòng','Furniture',3000000,6),
('Tủ quần áo','Furniture',5000000,4),
('Chuột Logitech','Electronics',500000,30),
('Bàn phím cơ','Electronics',1200000,18),
('Áo khoác','Fashion',800000,0),
('Đèn ngủ','Furniture',400000,9),
('Loa Bluetooth','Electronics',2000000,11);

--Thêm 8 đơn hàng
INSERT INTO orders (customer_id, order_date, total_amount, status) VALUES
(1,'2025-07-01',25000000,'PENDING'),
(2,'2025-07-02',5000000,'CONFIRMED'),
(3,'2025-07-03',18000000,'DELIVERED'),
(4,'2025-07-04',3500000,'SUCCESS'),
(5,'2025-07-05',250000,'PENDING'),
(6,'2025-07-06',800000,'CONFIRMED'),
(7,'2025-07-07',3000000,'SUCCESS'),
(8,'2025-07-08',1200000,'PENDING');

INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
(1, 1, 1, 25000000),
(1, 11, 2, 500000),
(2, 5, 3, 250000),
(3, 3, 1, 18000000),
(4, 2, 1, 3500000),
(5, 6, 2, 500000);

-- 2 Update 
-- Cập nhật giá sản phẩm thuộc category 'Electronics' tăng 10%
update products set price = price*1.1 where category ='Electronics';

--Cập nhật số điện thoại cho khách hàng có email cụ thể
update customers set phone=09876543 where email='flop@gmail.com';

--Cập nhật trạng thái đơn hàng từ 'PENDING' sang 'CONFIRMED'
update orders set status ='CONFIRMED' where status ='PENDING';

--3 Delect 
--Xóa các sản phẩm có số lượng tồn kho = 0
delete from products where stock_quantity=0;

--Xóa khách hàng không có đơn hàng nào
delete from customers as c where not exists (
Select 1 
From orders as o
Where o.customer_id=c.customer_id
);

--Phần 2: Truy vấn dữ liệu
--Tìm khách hàng theo tên (sử dụng ILIKE)
select * from customers where full_name ilike '%Hà%'

--Lọc sản phẩm theo khoảng giá (sử dụng BETWEEN)
select * from products where products.price between 500000 and 1000000;

--Tìm khách hàng chưa có số điện thoại (IS NULL)
select * from customers where phone is null;

--Top 5 sản phẩm có giá cao nhất (ORDER BY + LIMIT)
select * from products order by price desc limit 5;

-- Phân trang danh sách đơn hàng (LIMIT + OFFSET)
Select * from orders limit 3 offset 1;

--Đếm số khách hàng theo thành phố (DISTINCT + COUNT)
select DISTINCT city, count(customer_id) as total_customers
from customers group by ccity

--Tìm đơn hàng trong khoảng thời gian (BETWEEN với DATE)
select * from orders where order_date between '2025-07-01' and '2025-07-05';

--Sản phẩm chưa được bán (NOT EXISTS)
select * from products as p where not exists(
select 1 from order_items as oi where p.product_id=oi.product_id
)
