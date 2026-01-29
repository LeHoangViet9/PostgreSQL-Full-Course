create table accounts(
	account_id serial primary key,
	owner_name varchar(100),
	balance numeric(10,2)
);
create or replace procedure transfer_money(
	p_to_account int,
	p_from_account int,
	p_amount numeric
)
LANGUAGE plpgsql
as $$
begin
	update accounts set balance=balance-p_amount where account_id=p_from_account;
	   IF NOT FOUND THEN
            RAISE EXCEPTION 'Sender account not found';
        END IF;
	update accounts set balance=balance+p_amount where account_id=p_to_account;
	   IF NOT FOUND THEN
            RAISE EXCEPTION 'Receiver account not found';
        END IF;
	commit;
	exception
	when others then
	rollback;
end ;
$$;


insert into accounts(owner_name,balance) values
('A',500.00), ('B',300.00);
select * from accounts;

CALL transfer_money(1, 2, 100.00);

