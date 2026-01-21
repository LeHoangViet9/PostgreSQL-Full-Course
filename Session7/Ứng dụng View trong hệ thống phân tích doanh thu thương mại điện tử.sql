-- Tạo bảng customer
CREATE TABLE customer (
    customer_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100),
    region VARCHAR(50)
);

-- Tạo bảng orders
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customer(customer_id),
    total_amount DECIMAL(10,2),
    order_date DATE,
    status VARCHAR(20)
);

-- Tạo bảng product
CREATE TABLE product (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    price DECIMAL(10,2),
    category VARCHAR(50)
);

-- Tạo bảng order_detail
CREATE TABLE order_detail (
    order_id INT REFERENCES orders(order_id),
    product_id INT REFERENCES product(product_id),
    quantity INT,
    PRIMARY KEY (order_id, product_id) -- Nên thêm khóa chính kết hợp
);
-- Thêm dữ liệu vào bảng customer
INSERT INTO customer (full_name, region) VALUES 
('Nguyen Van A', 'Ha Noi'),
('Tran Thi B', 'TP HCM'),
('Lê Văn C', 'Da Nang');

-- Thêm dữ liệu vào bảng product
INSERT INTO product (name, price, category) VALUES 
('Laptop Dell', 1500.00, 'Electronics'),
('Chuột không dây', 25.50, 'Accessories'),
('Bàn phím cơ', 80.00, 'Accessories');

-- Thêm dữ liệu vào bảng orders
INSERT INTO orders (customer_id, total_amount, order_date, status) VALUES 
(1, 1525.50, '2023-10-01', 'Shipped'),
(2, 80.00, '2023-10-02', 'Pending');

-- Thêm dữ liệu vào bảng order_detail
INSERT INTO order_detail (order_id, product_id, quantity) VALUES 
(1, 1, 1), -- Đơn hàng 1 mua 1 Laptop
(1, 2, 1), -- Đơn hàng 1 mua thêm 1 Chuột
(2, 3, 1); -- Đơn hàng 2 mua 1 Bàn phím

--Tạo View tổng hợp doanh thu theo khu vực:
create view v_revenue_by_region as
select c.region, sum(o.total_amount) as total_revenue
from customer c join orders o on c.customer_id=o.customer_id
group by c.region
--Viết truy vấn xem top 3 khu vực có doanh thu cao nhất
select *
from v_revenue_by_region
order by v_revenue_by_region.total_revenue desc
limit 3

--Tạo View chi tiết đơn hàng có thể cập nhật được:
create materialized view mv_monthly_sales as
select date_trunc('month',order_date) as month,
sum(total_amount) as monthly_revenue
from orders
group by date_trunc('month',order_date);

create or replace view v_pending_order as
select * from orders where status = 'Pending'
with check option
--Cập nhật status của đơn hàng thông qua View này
update v_pending_order set status ='Shipped' where order_id=1;

--Tạo View phức hợp (Nested View):
--Từ v_revenue_by_region, tạo View mới v_revenue_above_avg chỉ hiển thị khu vực có doanh thu > trung bình toàn quốc

create or replace view v_revenue_by_region as
select c.region , sum(o.total_amount) as total_revenue
from customer c join orders o on c.customer_id=o.customer_id
group by c.region;

create view v_revenue_above_avg as
select region, total_revenue from v_revenue_by_region
where total_revenue >(Select avg(total_revenue) from v_revenue_by_region)



(select avg(o1.total_amount) from orders o1)
