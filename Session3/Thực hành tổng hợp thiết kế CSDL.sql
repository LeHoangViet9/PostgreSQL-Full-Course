Create database CompanyDB;

Create table Departments(
	department_id serial primary key,
	department_name varchar(100) not null
);

Create table Employees(
	emp_id serial primary key,
	name varchar(100) not null,
	dob date ,
	department_id int REFERENCES Departments(department_id)
);

Create table Projects(
	project_id serial primary key,
	project_name varchar(100) not null,
	start_date date ,
	end_date date check ( end_date is null OR end_date>start_date)
);
Create table EmployeeProjects(
	emp_id int references Employees(emp_id),
	project_id int REFERENCES Projects(project_id),
	primary key(emp_id, project_id)
);