Create schema libary
Create table libary.Books(
 book_id serial PRIMARY KEY,
 title varchar(100) not null,
 author varchar(50) not null,
 published_year int,
 price NUMERIC(10,2)
);