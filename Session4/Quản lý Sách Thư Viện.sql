CREATE TABLE books (
    id SERIAL PRIMARY KEY,
    title VARCHAR(200),
    author VARCHAR(100),
    category VARCHAR(50),
    publish_year INT,
    price INT,
    stock INT
);
INSERT INTO books (title, author, category, publish_year, price, stock) VALUES
('Lập trình C cơ bản', 'Nguyễn Văn Nam', 'CNTT', 2018, 95000, 20),
('Học SQL qua ví dụ', 'Trần Thị Hạnh', 'CSDL', 2020, 125000, 12),
('Lập trình C cơ bản', 'Nguyễn Văn Nam', 'CNTT', 2018, 95000, 20),
('Phân tích dữ liệu với Python', 'Lê Quốc Bảo', 'CNTT', 2022, 180000, NULL),
('Quản trị cơ sở dữ liệu', 'Nguyễn Thị Minh', 'CSDL', 2021, 150000, 5),
('Học máy cho người mới bắt đầu', 'Nguyễn Văn Nam', 'AI', 2023, 220000, 8),
('Khoa học dữ liệu cơ bản', 'Nguyễn Văn Nam', 'AI', 2023, 220000, NULL);


-- Xóa các bản ghi trùng lặp hoàn toàn về title, author và publish_year
delete from books
where id not in (select Min(id)
from books 
group by title, author, publish_year
);

--Tăng giá 10% cho những sách xuất bản từ năm 2021 trở đi và có price < 200000
update books set price = price *1.1 
where books.publish_year>2021 and books.price <200000;

--Với những sách có stock IS NULL, cập nhật stock = 0
update books set stock =0 where stock is null

--Liệt kê danh sách sách thuộc chủ đề CNTT hoặc AI có giá trong khoảng 100000 - 250000
select * from books 
where category = 'CNTT' or price between 100000 and 250000;

--Sắp xếp giảm dần theo price, rồi tăng dần theo title
select * from books
order by price desc , title asc;

--Tìm các sách có tiêu đề chứa từ “học” (không phân biệt hoa thường)
select * from books where title ilike '%học%';

--Liệt kê các thể loại duy nhất (DISTINCT) có ít nhất một cuốn sách xuất bản sau năm 2020
select DISTINCT category from books where publish_year >2020

--Chỉ hiển thị 2 kết quả đầu tiên, bỏ qua 1 kết quả đầu tiên (dùng LIMIT + OFFSET)
select * from books limit 2 offset 1