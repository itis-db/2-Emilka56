create table address(
                        id serial constraint id_address primary key,
                        city varchar(30),
                        street varchar(30),
                        house_number integer,
                        apartment_number integer,
                        index varchar(7) CONSTRAINT check_only_digits CHECK (index ~'^[0-9]+$')
    );
create table user_session(
                             id serial constraint id_user primary key,
                             name varchar(50),
                             surname varchar(50),
                             phone varchar(50),
                             email varchar(70),
                             role varchar(10)
);
create table product(
                        id serial constraint id_product primary key,
                        name varchar(50),
                        genre varchar(20),
                        price numeric(10,2) not null,
                        description text
);
create table orders(
                       id serial constraint id_order primary key,
                       orders_date date default current_date,
                       delivery_date date check(delivery_date>"orders".orders_date),
                       id_user int references user_session(id),
                       price numeric(10,2) not null,
                       id_address int references address(id)
);
create table single_order(
                             product_id int references product(id),
                             orders_id int references orders(id),
                             quantity integer check (quantity>0),
                             primary key(product_id, orders_id)
);




