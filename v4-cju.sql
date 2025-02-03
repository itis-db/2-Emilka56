with cte AS (
    select id from user_session where id>10
) select id_user, price, delivery_date from cte join orders on cte.id = orders.id_user;

with cte AS (
    select name, id, genre from product where genre in ('Rock', 'Rap')
) select id, quantity, name, genre from cte join single_order on single_order.product_id =  cte.id;

with cte AS (
    select name from product where name in ('Nevermind- Nirvana', 'Hard Reboot- Noize MC')
    union
    select street from address where city='Moscow')
select * from cte;
