Alter table library.books
add genre varchar(100);

Alter table library.books
Rename available to is_available;

Alter table library.members
drop column email;

DROP TABLE IF EXISTS sales.OrderDetails;