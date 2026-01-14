CREATE TABLE Student (
    id serial PRIMARY KEY,
    full_name VARCHAR(100),
    gender VARCHAR(10),
    birth_year INT,
    major VARCHAR(50),
    gpa DECIMAL(2,1)
);
INSERT INTO Student ( full_name, gender, birth_year, major, gpa) VALUES
( 'Nguyễn Văn A', 'Nam', 2002, 'CNTT', 3.6),
( 'Trần Thị Bích Ngọc', 'Nữ', 2001, 'Kinh tế', 3.2),
( 'Lê Quốc Cường', 'Nam', 2003, 'CNTT', 2.7),
( 'Phạm Minh Anh', 'Nữ', 2000, 'Luật', 3.9),
( 'Nguyễn Văn A', 'Nam', 2002, 'CNTT', 3.6),
( 'Lưu Đức Tài', NULL, 2004, 'Cơ khí', NULL),
( 'Võ Thị Thu Hằng', 'Nữ', 2001, 'CNTT', 3.0);

--Thêm sinh viên “Phan Hoàng Nam”, giới tính Nam, sinh năm 2003, ngành CNTT, GPA 3.8
insert into Student(full_name, gender, birth_year, major, gpa) values
('Phan Hoàng Nam','Nam',2003,'CNTT',3.8);

--Sinh viên “Lê Quốc Cường” vừa cải thiện học lực, cập nhật gpa = 3.4
update Student set gpa=3.4 where full_name='Lê Quốc Cường';

--Xóa tất cả sinh viên có gpa IS NULL
delete from Student where gpa is null;

--Hiển thị sinh viên ngành CNTT có gpa >= 3.0, chỉ lấy 3 kết quả đầu tiên
select * from Student where gpa>=3.0 limit 3;

--Liệt kê danh sách ngành học duy nhất
select DISTINCT major from Student;

--Hiển thị sinh viên ngành CNTT, sắp xếp giảm dần theo GPA, sau đó tăng dần theo tên
select * from Student where major='CNTT' order by gpa desc, full_name asc;

--Tìm sinh viên có tên bắt đầu bằng “Nguyễn”
select * from Student where full_name ilike 'Nguyễn%';

--Hiển thị sinh viên có năm sinh từ 2001 đến 2003
select * from Student where birth_year between 2001 and 2003;