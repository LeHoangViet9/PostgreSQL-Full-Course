
Select * from products;

--Thêm sản phẩm mới: 'Điều hòa Panasonic', category 'Home Appliances', giá 400.00, stock 10
Insert into products (name, category, price, stock) values
('Điều hòa Panasonic', 'Home Appliances', 400.00, 10);

--Cập nhật stock của 'Laptop Dell' thành 7
update products set stock =7 where name='Laptop Dell';

--Xóa các sản phẩm có stock bằng 0 (nếu có)
delete from products where stock =0;

--Liệt kê tất cả sản phẩm theo giá tăng dần
select * from products order by price asc;

--Liệt kê danh mục duy nhất của các sản phẩm (DISTINCT)
Select distinct category from products;

--Liệt kê sản phẩm có giá từ 100 đến 1000
select * from products where price between 100 and 1000;

--Liệt kê các sản phẩm có tên chứa từ 'LG' hoặc 'Samsung' (sử dụng LIKE/ILIKE)
select * from products where name ilike '%LG%' or name ilike '%Samsung%';

--Hiển thị 2 sản phẩm đầu tiên theo giá giảm dần, hoặc lấy sản phẩm thứ 2 đến thứ 3 bằng LIMIT và OFFSET
select * from products order by price desc limit 3;
select * from products order by price desc limit 2 offset 1;





