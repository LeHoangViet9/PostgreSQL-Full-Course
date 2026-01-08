Create database EcommerceDB;
Create schema shop;
Create table shop.Users(
	user_id SERIAL PRIMARY KEY,
	username VARCHAR(50) UNIQUE NOT NULL,
	email VARCHAR(100) UNIQUE NOT NULL,
	password VARCHAR(100) NOT NULL,
	role VARCHAR(20) CHECK (role IN ('Customer','Admin'))
);
Create table shop.Categories(
	category_id serial primary key,
	category_name VARCHAR(100) UNIQUE NOT NULL
);
Create table shop.Products(
	product_id SERIAL PRIMARY KEY,
	product_name VARCHAR(100) NOT NULL,
	price NUMERIC(10,2) CHECK (price > 0),
	stock INT CHECK (stock >= 0),
	category_id INT REFERENCES shop.Categories(category_id)
);
Create table shop.Orders(
	order_id SERIAL PRIMARY KEY,
	user_id INT REFERENCES shop.Users(user_id),
	order_date DATE NOT NULL,
	status VARCHAR(20) CHECK (status IN ('Pending','Shipped','Delivered','Cancelled'))
);
Create table shop.OrderDetails(
	order_detail_id SERIAL PRIMARY KEY,
	order_id int REFERENCES shop.Orders(order_id),
	product_id int REFERENCES shop.Products(product_id),
	quantity INT CHECK (quantity > 0),
	price_each NUMERIC(10,2) CHECK (price_each > 0)
);
Create table shop.Payments(
	payment_id SERIAL PRIMARY KEY,
	order_id int REFERENCES shop.Orders(order_id),
	amount NUMERIC(10,2) CHECK (amount >= 0),
	payment_date DATE NOT NULL,
	method VARCHAR(30) CHECK (method IN ('Credit Card','Momo','Bank Transfer','Cash'))
)