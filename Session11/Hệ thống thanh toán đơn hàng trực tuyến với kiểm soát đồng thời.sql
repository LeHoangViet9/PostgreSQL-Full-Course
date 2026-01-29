BEGIN;

SELECT wallet_balance
FROM Customer
WHERE name = 'Tran Thi B'
FOR UPDATE;

INSERT INTO Orders(customer_id, total_amount, status)
SELECT id, 0, 'PENDING'
FROM Customer
WHERE name = 'Tran Thi B'
RETURNING id INTO TEMP TABLE tmp_order;

SAVEPOINT sp_product_1;

-- Khóa tồn kho
SELECT stock, price
FROM Product
WHERE id = 1
FOR UPDATE;

-- Giả sử còn hàng
INSERT INTO Order_Items(order_id, product_id, quantity, price)
SELECT id, 1, 1, price
FROM tmp_order, Product
WHERE Product.id = 1;

UPDATE Product
SET stock = stock - 1
WHERE id = 1;


SAVEPOINT sp_product_3;

-- Khóa tồn kho
SELECT stock, price
FROM Product
WHERE id = 3
FOR UPDATE;

-- Nếu hết hàng → rollback riêng phần này
DO $$
BEGIN
    IF (SELECT stock FROM Product WHERE id = 3) < 2 THEN
        RAISE NOTICE 'Sản phẩm 3 hết hàng → rollback riêng';
        ROLLBACK TO SAVEPOINT sp_product_3;
    ELSE
        INSERT INTO Order_Items(order_id, product_id, quantity, price)
        SELECT id, 3, 2, price
        FROM tmp_order, Product
        WHERE Product.id = 3;

        UPDATE Product
        SET stock = stock - 2
        WHERE id = 3;
    END IF;
END $$;


UPDATE Orders
SET total_amount = (
    SELECT SUM(quantity * price)
    FROM Order_Items
    WHERE order_id = Orders.id
)
WHERE id IN (SELECT id FROM tmp_order);


UPDATE Customer
SET wallet_balance = wallet_balance - (
    SELECT total_amount
    FROM Orders
    WHERE id IN (SELECT id FROM tmp_order)
)
WHERE name = 'Tran Thi B';


UPDATE Orders
SET status = 'COMPLETED'
WHERE id IN (SELECT id FROM tmp_order);

COMMIT;


UPDATE Product SET stock = 0 WHERE id = 3;



