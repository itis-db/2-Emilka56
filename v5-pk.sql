create table temp_user_session AS SELECT * FROM user_session;
create table temp_product AS SELECT * FROM product;
create table temp_single_order AS SELECT * FROM single_order;
create table temp_orders AS SELECT * FROM orders;


alter table single_order DROP CONSTRAINT IF EXISTS single_order_pkey;
alter table single_order DROP CONSTRAINT IF EXISTS single_order_orders_id_fkey;
alter table single_order DROP CONSTRAINT IF EXISTS single_order_product_id_fkey;
alter table orders DROP CONSTRAINT IF EXISTS orders_id_address_fkey;
alter table orders DROP CONSTRAINT IF EXISTS orders_id_user_fkey;
alter table product DROP CONSTRAINT IF EXISTS id_product;
alter table user_session DROP CONSTRAINT IF EXISTS id_user;
alter table address DROP CONSTRAINT IF EXISTS id_address;
alter table orders DROP CONSTRAINT IF EXISTS id_order;

ALTER TABLE product ADD PRIMARY KEY (name);
ALTER TABLE user_session ADD PRIMARY KEY (email);
ALTER TABLE address ADD PRIMARY KEY (city, street, house_number, apartment_number, index);

ALTER TABLE orders ADD COLUMN email VARCHAR(70);
ALTER TABLE orders ADD COLUMN city VARCHAR(30);
ALTER TABLE orders ADD COLUMN street VARCHAR(30);
ALTER TABLE orders ADD COLUMN house_number INTEGER;
ALTER TABLE orders ADD COLUMN apartment_number INTEGER;
ALTER TABLE orders ADD COLUMN index VARCHAR(7);
ALTER TABLE single_order ADD COLUMN name VARCHAR(50);
ALTER TABLE single_order ADD COLUMN email VARCHAR(70);
ALTER TABLE single_order ADD COLUMN city VARCHAR(30);
ALTER TABLE single_order ADD COLUMN street VARCHAR(30);
ALTER TABLE single_order ADD COLUMN house_number INTEGER;
ALTER TABLE single_order ADD COLUMN apartment_number INTEGER;
ALTER TABLE single_order ADD COLUMN index VARCHAR(7);

UPDATE orders o
SET
    city = a.city,
    street = a.street,
    house_number = a.house_number,
    apartment_number = a.apartment_number,
    index = a.index
FROM  temp_orders tor
    JOIN address a ON tor.id_address= a.id
WHERE o.id = tor.id;

UPDATE orders o
SET
    email=u.email
FROM temp_orders tor
    JOIN user_session u ON tor.id_user = u.id
WHERE o.id=tor.id;

ALTER TABLE orders DROP COLUMN id_address, DROP COLUMN id_user;
ALTER TABLE orders ADD PRIMARY KEY (city, street, house_number, apartment_number, index, email);

UPDATE single_order so
SET
    name=p.name
FROM temp_single_order tso
    JOIN product p ON tso.product_id = p.id
WHERE so.orders_id = tso.orders_id;

UPDATE single_order so
SET
    city = o.city,
    street = o.street,
    house_number = o.house_number,
    apartment_number = o.apartment_number,
    index = o.index,
    email = o.email
FROM temp_single_order tso
    JOIN orders o ON tso.orders_id = o.id
WHERE so.product_id = tso.product_id;

ALTER TABLE single_order DROP COLUMN product_id;
ALTER TABLE single_order DROP COLUMN orders_id;
ALTER TABLE single_order ADD PRIMARY KEY (name, city, street, house_number, apartment_number, index, email);

ALTER TABLE orders ADD FOREIGN KEY (city, street, house_number, apartment_number, index) REFERENCES address(city, street, house_number, apartment_number, index);
ALTER TABLE orders ADD FOREIGN KEY (email) REFERENCES user_session(email);
ALTER TABLE single_order ADD FOREIGN KEY (name) REFERENCES product(name);
ALTER TABLE single_order ADD FOREIGN KEY (city, street, house_number, apartment_number,index, email) REFERENCES orders(city, street, house_number, apartment_number,index, email);

DROP TABLE temp_orders;
DROP TABLE temp_single_order;

ALTER TABLE address DROP COLUMN IF EXISTS id;
ALTER TABLE product DROP COLUMN IF EXISTS id;
ALTER TABLE user_session DROP COLUMN IF EXISTS id;
ALTER TABLE orders DROP COLUMN IF EXISTS id;
ALTER TABLE single_order DROP COLUMN IF EXISTS id;

--rollback
ALTER TABLE address DROP CONSTRAINT IF EXISTS address_pkey CASCADE;
ALTER TABLE user_session DROP CONSTRAINT IF EXISTS user_session_pkey CASCADE; --проверить
ALTER TABLE orders DROP CONSTRAINT IF EXISTS orders_pkey CASCADE;
ALTER TABLE single_order DROP CONSTRAINT IF EXISTS single_order_pkey CASCADE;
ALTER TABLE product DROP CONSTRAINT IF EXISTS product_pkey CASCADE;


ALTER TABLE address ADD COLUMN id SERIAL PRIMARY KEY;
ALTER TABLE product ADD COLUMN id SERIAL PRIMARY KEY;
ALTER TABLE single_order ADD COLUMN id SERIAL PRIMARY KEY;
ALTER TABLE orders ADD COLUMN id SERIAL PRIMARY KEY;
ALTER TABLE user_session ADD COLUMN id SERIAL PRIMARY KEY;

ALTER TABLE orders DROP CONSTRAINT IF EXISTS orders_id_address_fkey;
ALTER TABLE orders DROP CONSTRAINT IF EXISTS orders_id_user_fkey;
ALTER TABLE single_order DROP CONSTRAINT IF EXISTS single_order_orders_id_fkey;
ALTER TABLE single_order DROP CONSTRAINT IF EXISTS single_order_product_id_fkey;

ALTER TABLE single_order ADD COLUMN product_id INTEGER;
ALTER TABLE single_order ADD COLUMN orders_id INTEGER;
ALTER TABLE orders ADD COLUMN id_address INTEGER;
ALTER TABLE orders ADD COLUMN id_user INTEGER;

UPDATE orders o
SET id_address = a.id
    FROM address a
WHERE o.city = a.city
  AND o.street = a.street
  AND o.house_number = a.house_number
  AND o.apartment_number = a.apartment_number
  AND o.index = a.index;

UPDATE orders o
SET id_user = u.id
    FROM user_session u
WHERE o.email = u.email;

UPDATE single_order so
SET product_id = p.id
    FROM product p
WHERE so.name = p.name;

UPDATE single_order so
SET orders_id = o.id
    FROM orders o
WHERE so.city = o.city
  AND so.street = o.street
  AND so.house_number = o.house_number
  AND so.apartment_number = o.apartment_number
  AND so.index = o.index
  AND so.email = o.email;

ALTER TABLE orders ADD CONSTRAINT orders_id_address_fkey FOREIGN KEY (id_address) REFERENCES address(id);
ALTER TABLE orders ADD CONSTRAINT orders_id_user_fkey FOREIGN KEY (id_user) REFERENCES user(id);
ALTER TABLE single_order ADD CONSTRAINT single_order_orders_id_fkey FOREIGN KEY (orders_id) REFERENCES orders(id);
ALTER TABLE single_order ADD CONSTRAINT single_order_product_id_fkey FOREIGN KEY (product_id) REFERENCES product(id);

ALTER TABLE orders DROP COLUMN city;
ALTER TABLE orders DROP COLUMN street;
ALTER TABLE orders DROP COLUMN house_number;
ALTER TABLE orders DROP COLUMN apartment_number;
ALTER TABLE orders DROP COLUMN "index";
ALTER TABLE orders DROP COLUMN email;
ALTER TABLE  single_order DROP COLUMN email;
ALTER TABLE  single_order DROP COLUMN "name";
ALTER TABLE single_order DROP COLUMN city;
ALTER TABLE single_order DROP COLUMN street;
ALTER TABLE single_order DROP COLUMN house_number;
ALTER TABLE single_order DROP COLUMN apartment_number;
ALTER TABLE single_order DROP COLUMN "index";



















