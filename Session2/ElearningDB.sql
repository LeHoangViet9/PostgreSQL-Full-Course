Create database ElearningDB;
Create schema elearning;
Create table elearning.Students(
	student_id serial primary key,
	first_name varchar(50) not null,
	last_name varchar(50) not null,
	email varchar(50) not null unique
);

Create table elearning.Instructors(
	instructor_id serial primary key,
	first_name varchar(50) not null,
	last_name varchar(50) not null,
	email varchar(50) not null unique
);

Create table elearning.Courses(
	course_id serial primary key,
	course_name varchar(100) not null,
	instructor_id int REFERENCES elearning.Instructors(instructor_id)
);

Create table elearning.Enrollments(
	enrollment_id serial primary key,
	student_id int REFERENCES elearning.Students(student_id),
	course_id int REFERENCES elearning.Courses(course_id),
	enroll_date date not null
);

Create table elearning.Assignments(
	assignment_id serial primary key,
	course_id int REFERENCES elearning.Courses(course_id),
	title varchar(100) not null,
	due_date date not null
);

Create table elearning.Submissions(
	submission_id serial primary key,
	assignment_id int REFERENCES elearning.Assignments(assignment_id),
	student_id int REFERENCES elearning.Students(student_id),
	submission_date date not null,
	grade float Check(grade>=0 AND grade<=100)
)