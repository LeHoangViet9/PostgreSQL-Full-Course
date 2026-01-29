CREATE TABLE flights (
    flight_id SERIAL PRIMARY KEY,
    flight_name VARCHAR(100),
    available_seats INT
);

CREATE TABLE bookings (
    booking_id SERIAL PRIMARY KEY,
    flight_id INT REFERENCES flights(flight_id),
    customer_name VARCHAR(100)
);

INSERT INTO flights (flight_name, available_seats)
VALUES ('VN123', 3), ('VN456', 2);

create or replace procedure book_flight_proc(
	p_flight_id int ,
	p_customer_name varchar(100)
)
LANGUAGE plpgsql
as $$
begin
	update flights set available_seats=available_seats-1 where flight_id=p_flight_id;
	insert into bookings(flight_id,customer_name) values (p_flight_id,p_customer_id);

	commit;
exception 
	when others then 
	rollback;
end ;
$$