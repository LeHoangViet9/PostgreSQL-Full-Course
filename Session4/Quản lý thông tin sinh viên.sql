
select * from students
--Cập nhật GPA của sinh viên "Bình" thành 3.6
Update students set gpa=3.6 where name='Bình';

--Xóa sinh viên có GPA thấp hơn 3.0
Delete from students where gpa <3.0;

--Liệt kê tất cả sinh viên, chỉ hiển thị tên và chuyên ngành, sắp xếp theo GPA giảm dần
Select name, major 
From students
order by gpa desc

--Liệt kê tên sinh viên duy nhất có chuyên ngành "CNTT"
select * from students where major ='CNTT' limit 1;

--Liệt kê sinh viên có GPA từ 3.0 đến 3.6
select * from students where gpa between 3.0 and 3.6;

--Liệt kê sinh viên có tên bắt đầu bằng chữ 'C' (sử dụng LIKE/ILIKE)
select * from students where name ilike 'C%';

--Hiển thị 3 sinh viên đầu tiên theo thứ tự tên tăng dần, hoặc lấy từ sinh viên thứ 2 đến thứ 4 bằng LIMIT và OFFSET
Select * from students order by gpa desc limit 3;
Select * from students order by gpa desc limit 3 offset 1;
