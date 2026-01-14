CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    full_name VARCHAR(100),
    department VARCHAR(50),
    position VARCHAR(50),
    salary BIGINT,
    bonus BIGINT,
    join_year INT
);
INSERT INTO employees (full_name, department, position, salary, bonus, join_year) VALUES
('Nguyễn Văn Huy', 'IT', 'Developer', 18000000, 1000000, 2021),
('Trần Thị Mai', 'HR', 'Recruiter', 12000000, NULL, 2020),
('Lê Quốc Trung', 'IT', 'Tester', 15000000, 800000, 2023),
('Nguyễn Văn Huy', 'IT', 'Developer', 18000000, 1000000, 2021),
('Phạm Ngọc Hân', 'Finance', 'Accountant', 14000000, NULL, 2019),
('Bùi Thị Lan', 'HR', 'HR Manager', 20000000, 3000000, 2018),
('Đặng Hữu Tài', 'IT', 'Developer', 17000000, NULL, 2022);

--Xóa các bản ghi trùng nhau hoàn toàn về tên, phòng ban và vị trí
delete from employees
where id not in (Select Min(id)
FROM employees
group by full_name, department, "position"
);

--Tăng 10% lương cho những nhân viên làm trong phòng IT có mức lương dưới 18,000,000
update employees set salary =salary *1.1 where department ='IT' and salary < 18000000;
--Với nhân viên có bonus IS NULL, đặt giá trị bonus = 500000
update employees set bonus =500000 where bonus is null;

--Hiển thị danh sách nhân viên thuộc phòng IT hoặc HR, gia nhập sau năm 2020, và có tổng thu nhập (salary + bonus) lớn hơn 15,000,000
select  full_name, department, "position", salary,bonus,
salary + coalesce(bonus,0) as total_income from employees
where department in ('IT','HR') and join_year >2020 and salary + coalesce(bonus,0)>15000000;


--Chỉ lấy 3 nhân viên đầu tiên sau khi sắp xếp giảm dần theo tổng thu nhap 
select  full_name, department, "position", salary,bonus,
salary + coalesce(bonus,0) as total_income from employees
order by total_income desc limit 3;

--Tìm tất cả nhân viên có tên bắt đầu bằng “Nguyễn” hoặc kết thúc bằng “Hân”
select * from employees where full_name ilike 'Nguyễn%' or full_name ilike '%Hân';

--Liệt kê các phòng ban duy nhất có ít nhất một nhân viên có bonus IS NOT NULL
select distinct department
from employees
where bonus is null

--Hiển thị nhân viên gia nhập trong khoảng từ 2019 đến 2022 (BETWEEN)
select * from employees where employees.join_year between 2019 and 2022;