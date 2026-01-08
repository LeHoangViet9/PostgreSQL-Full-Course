Create database HotelDB;
Create schema hotel;
Create table hotel.Roomtypes(
	room_type_id SERIAL PRIMARY KEY,
	type_name VARCHAR(50) NOT NULL UNIQUE,
	price_per_night NUMERIC(10,2) CHECK (price_per_night > 0),
	max_capacity INT CHECK(max_capacity > 0)
);
Create table hotel.Rooms(
	room_id SERIAL PRIMARY KEY,
	room_number VARCHAR(10) not null unique,
	room_type_id INT REFERENCES hotel.RoomTypes(room_type_id),
	status VARCHAR(20) CHECK (status IN ('Available','Occupied','Maintenance'))
);
Create table hotel.Customers(
	customer_id SERIAL PRIMARY KEY,
	full_name varchar(100) not null,
	email VARCHAR(100) UNIQUE NOT NULL,
	phone VARCHAR(15) NOT NULL
);
create table hotel.Bookings(
	booking_id SERIAL PRIMARY KEY,
	customer_id int REFERENCES hotel.Customers(customer_id),
	room_id int REFERENCES hotel.Rooms(room_id),
	check_in date not null,
	check_out date not null,
	status varchar(20) CHECK (status IN ('Pending','Confirmed','Cancelled'))
);
Create table hotel.Payments(
	payment_id SERIAL PRIMARY KEY,
	booking_id INT REFERENCES hotel.Bookings(booking_id),
	amount NUMERIC(10,2) CHECK (amount >= 0),
	payment_date DATE NOT NULL,
	method VARCHAR(20) CHECK (method IN ('Credit Card','Cash','Bank Transfer'))
)