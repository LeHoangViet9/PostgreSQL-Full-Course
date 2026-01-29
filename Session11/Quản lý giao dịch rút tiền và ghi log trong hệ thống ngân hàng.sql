CREATE TABLE accounts (
    account_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    balance NUMERIC(15,2)
);

CREATE TABLE transactions (
    transaction_id SERIAL PRIMARY KEY,
    account_id INT REFERENCES accounts(account_id),
    amount NUMERIC(15,2),
    trans_type VARCHAR(20),
    created_at TIMESTAMP DEFAULT NOW()
);
INSERT INTO accounts (account_id, customer_name, balance) VALUES
(1, 'Nguyen Van A', 1000.00),
(2, 'Tran Thi B', 500.00),
(3, 'Le Van C', 200.00);

INSERT INTO transactions (account_id, amount, trans_type) VALUES
(1, 200.00, 'DEPOSIT'),
(2, 300.00, 'DEPOSIT');

CREATE OR REPLACE PROCEDURE withdraw_money(
    p_account_id INT,
    p_amount NUMERIC
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_balance NUMERIC;
BEGIN
    -- 1. Kiểm tra và khóa tài khoản
    SELECT balance
    INTO v_balance
    FROM accounts
    WHERE account_id = p_account_id
    FOR UPDATE;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Account not found';
    END IF;

    -- 2. Kiểm tra số dư
    IF v_balance < p_amount THEN
        RAISE EXCEPTION 'Insufficient balance';
    END IF;

    -- 3. Trừ tiền
    UPDATE accounts
    SET balance = balance - p_amount
    WHERE account_id = p_account_id;

    -- 4. Ghi log giao dịch
    INSERT INTO transactions(account_id, amount, trans_type)
    VALUES (p_account_id, p_amount, 'WITHDRAW');

END;
$$;

BEGIN;
CALL withdraw_money(1, 300);
COMMIT;



