INSERT INTO address  (city, street, house_number,apartment_number, index)
SELECT DISTINCT
    (ARRAY['Kazavn', 'Moscow', 'Orenburg', ' Krasnodar', 'Yekaterinburg'])[FLOOR(random() * 5 + 1)],
    'Street ' ||  (ARRAY['Sovetskaya', 'Lenin', 'Pushkinskaya', 'Sadovaya', 'Rizhskaya'])[FLOOR(random() * 5 + 1)],
    FLOOR(random() * 300 + 1),
    FLOOR(random() * 100 + 1),
    (ARRAY[101000, 123456, 109147, 103009, 117436])[FLOOR(random() * 5 + 1)]
FROM generate_series(1, 100);

INSERT INTO user_session (name, surname, phone, email, role)
SELECT
    (ARRAY['Polina', 'Emily', 'Damir', 'Denis', 'Kseniya', 'Svetlana', 'Ludmilla', 'Ruslan', 'Ivan', 'Maya'])[FLOOR(random() * 10 + 1)],
    (ARRAY['Yahudin', 'Ivanko', 'Amaryan', 'Kim', 'Brown', 'Shein', 'Kovalenko', 'Queen', 'Morozov', 'Lanko'])[FLOOR(random() * 10 + 1)],
    (ARRAY['89228190607', '89227196657', '89225450654', '89226780407', '89227890307'])[FLOOR(random() * 5 + 1)],
    'user_' || generate_series || '@example.com',
    (ARRAY['Admin', 'Client'])[FLOOR(random()*2+1)]
FROM generate_series(1, 100);

INSERT INTO product (name, genre, price, description)
SELECT
    (ARRAY['Dark Side of the Moon - Pink Floyd', 'Californication - Red Hot Chili Peppers', 'Nevermind- Nirvana', 'OK Computer - Radiohead ', 'Led Zeppelin - Led Zeppelin', 'The Wall - Pink Floyd', 'Hard Reboot- Noize MC'])[FLOOR(random() * 7 + 1)],
    (ARRAY['Blues', 'Metal', 'Pop', 'Rock', 'Rap', 'Blues'])[FLOOR(random() * 6 + 1)],
    FLOOR(random() * 10000 + 750),
    'Label:' || (ARRAY['EMI', '4AD Records', 'Stiff Records', 'Sub Pop Records', 'Factory Records'])[FLOOR(random() * 5 + 1)] || ' Release date: ' || (ARRAY['12/04/2020', '31/06/1998', '25/05/20221', '08/03/1967', '15/07/2004'])[FLOOR(random() * 5 + 1)]
FROM generate_series(1, 100);

INSERT INTO orders (orders_date, delivery_date, price, id_user, id_address)
SELECT
    NOW() - INTERVAL '1 day' * FLOOR(random() * 365),
    NOW() + INTERVAL '1 day' * FLOOR(random() * 365),
    FLOOR(random() * 10500 + 750),
    t.id_user,
    t.id_address
FROM (
         SELECT DISTINCT
             FLOOR(random() * 100 + 1) AS id_user,
             FLOOR(random() * 100 + 1) AS id_address
         FROM generate_series(1, 200)
         WHERE FLOOR(random() * 100 + 1) <> FLOOR(random() * 100 + 1) -- Убедитесь, что id_user ≠ id_address
     ) AS t(id_user, id_address)
LIMIT 100;

-- Создаем временную таблицу для хранения уникальных пар (product_id, orders_id)
CREATE TEMP TABLE temp_orders AS
SELECT
    FLOOR(random() * 100 + 1) AS product_id,
    FLOOR(random() * 100 + 1) AS orders_id
FROM generate_series(1, 200);

-- Удаляем дубликаты из временной таблицы
DELETE FROM temp_orders
WHERE (product_id, orders_id) IN (
    SELECT product_id, orders_id
    FROM temp_orders
    GROUP BY product_id, orders_id
    HAVING COUNT(*) > 1
);

-- Вставляем данные из временной таблицы в основную таблицу
INSERT INTO single_order (quantity, product_id, orders_id)
SELECT
    FLOOR(random() * 10 + 1),
    product_id,
    orders_id
FROM temp_orders;

-- Удаляем временную таблицу
DROP TABLE temp_orders;

CREATE TEMP TABLE temp_product_names AS
WITH words AS (
    SELECT unnest(ARRAY['Dark', 'Sunny', 'Mystic', 'Electric', 'Lost', 'Golden', 'Silent', 'Wild', 'Bright', 'Hidden']) AS word
),
     combinations AS (
         SELECT
             initcap(word1.word || ' ' || word2.word || ' ' || word3.word) AS name,
             row_number() OVER () AS id  -- Генерируем айдишники для всех комбинаций
         FROM words AS word1, words AS word2, words AS word3
         GROUP BY word1.word, word2.word, word3.word
     )
SELECT
    id,
    name
FROM combinations
WHERE id BETWEEN 1 AND 200
ORDER BY random();

-- обновление таблички продукт
UPDATE product
SET name = temp_product_names.name
FROM temp_product_names
WHERE product.id = temp_product_names.id;

-- удаление временной таблички
DROP TABLE temp_product_names;

--изменения для таблицы orders
--только одна запись для каждой уникальной комбинации(id_user, id_address)
DELETE FROM orders
WHERE id NOT IN (
    SELECT MIN(id)
    FROM orders
    GROUP BY id_user, id_address
);

--уникальное ограничение
ALTER TABLE orders
    ADD CONSTRAINT unique_order_combination
        UNIQUE (id_user, id_address);

