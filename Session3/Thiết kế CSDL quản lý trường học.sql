Create database SchoolDB;
Create table Students(
	student_id serial primary key,
	name varchar(100) not null,
	dob date 
);
Create table Courses(
	course_id serial primary key,
	course_name varchar(100) not null,
	credits int
);
Create table Enrollments(
	enrollment_id serial primary key,
	grade char(1) check(grade in('A','B','C','D','F')),
	student_id int references Students(student_id),
	course_id int references Courses(course_id)
);
