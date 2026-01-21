CREATE TABLE customer (
    customer_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(15)
);

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customer(customer_id),
    total_amount DECIMAL(10, 2),
    order_date DATE
);

INSERT INTO customer (full_name, email, phone)
VALUES 
('Nguyễn Văn A', 'vana@email.com', '0901234567'),
('Trần Thị B', 'thib@email.com', '0912345678'),
('Lê Văn C', 'vanc@email.com', '0987654321');

INSERT INTO orders (customer_id, total_amount, order_date)
VALUES 
(1, 150000.00, '2024-03-20'),
(2, 290000.50, '2024-03-21'),
(1, 75000.00, '2024-03-22');

--Tạo một View tên v_order_summary hiển thị:
--full_name, total_amount, order_date
create view v_order_summary as
select c.full_name, o.total_amount, o.order_date
from customer c join orders o
on c.customer_id=o.customer_id;

--Viết truy vấn để xem tất cả dữ liệu từ View
select * from v_order_summary

--Cập nhật tổng tiền đơn hàng thông qua View (gợi ý: dùng WITH CHECK OPTION nếu cần)
create or replace view v_high_value_orders as
select c.full_name, o.total_amount, o.order_date from customer c join orders o
on c.customer_id=o.customer_id
where o.total_amount > 100000



--Tạo một View thứ hai v_monthly_sales thống kê tổng doanh thu mỗi tháng
create view v_monthly_sales as 
select extract(month from order_date) as month , sum(o.total_amount) as "Tổng tiền đơn hàng"
from customer c join orders o
on c.customer_id=o.customer_id
group by extract(month from order_date)

--Thử DROP View và ghi chú sự khác biệt giữa DROP VIEW và DROP MATERIALIZED VIEW trong PostgreSQL
drop view v_order_summary

--sử dụng view khi dữ liệu thay đổi liên tục và cần độ chính xác
-- sử dụng materialized view khi làm báo cáo trên một lượng dũ liệu khổng lồ mà dữ liệu đó không cần cập nhập từng giây, giúp giảm tải cho hệ thống

