Create database SalesDB;
Create schema sales;
Create table sales.Customers(
	customer_id serial primary key,
	first_name varchar(50) not null,
	last_name varchar(50) not null,
	email varchar(50) not null unique,
	phone varchar(15) 
);

Create table sales.Products(
	product_id serial primary key,
	product_name varchar(100) not null,
	price numeric(10,2) not null,
	stock_quantity int not null
);

Create table sales.Orders(
	order_id serial primary key,
	customer_id int REFERENCES sales.Customers(customer_id),
	order_date date not null
);

Create table OrderItems(
	order_item_id serial primary key,
	order_id int REFERENCES sales.Orders(order_id),
	product_id int REFERENCES sales.Products(product_id),
	quantity int check(quantity>=1)
);
Alter table public.OrderItems set schema sales;