CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    stock INT,
    price NUMERIC(10,2)
);

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_name VARCHAR(100),
    total_amount NUMERIC(10,2),
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(order_id),
    product_id INT REFERENCES products(product_id),
    quantity INT,
    subtotal NUMERIC(10,2)
);

--Viết Transaction thực hiện toàn bộ quy trình đặt hàng
DO $$
DECLARE
    v_order_id INT;
    v_total NUMERIC(10,2) := 0;
    v_price NUMERIC(10,2);
    v_stock INT;
BEGIN

    SELECT stock, price
    INTO v_stock, v_price
    FROM products
    WHERE product_id = 1
    FOR UPDATE;

    IF v_stock < 2 THEN
        RAISE EXCEPTION ;
    END IF;

    SELECT stock, price
    INTO v_stock, v_price
    FROM products
    WHERE product_id = 2
    FOR UPDATE;

    IF v_stock < 1 THEN
        RAISE EXCEPTION ;
    END IF;

    INSERT INTO orders(customer_name, total_amount)
    VALUES ('Nguyen Van A', 0)
    RETURNING order_id INTO v_order_id;
	
    SELECT price INTO v_price FROM products WHERE product_id = 1;
    INSERT INTO order_items(order_id, product_id, quantity, subtotal)
    VALUES (v_order_id, 1, 2, v_price * 2);

    UPDATE products SET stock = stock - 2 WHERE product_id = 1;
    v_total := v_total + v_price * 2;

    SELECT price INTO v_price FROM products WHERE product_id = 2;
    INSERT INTO order_items(order_id, product_id, quantity, subtotal)
    VALUES (v_order_id, 2, 1, v_price);

    UPDATE products SET stock = stock - 1 WHERE product_id = 2;
    v_total := v_total + v_price;

    UPDATE orders
    SET total_amount = v_total
    WHERE order_id = v_order_id;
	
	Exception 
	WHEN OTHERS THEN
	ROLLBACK;
END $$;


