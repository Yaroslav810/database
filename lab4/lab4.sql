SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE type_service;
TRUNCATE connected_services;
TRUNCATE payment;
TRUNCATE telephone;
TRUNCATE user;
TRUNCATE tariff;
TRUNCATE document;
SET FOREIGN_KEY_CHECKS = 1;


# # INSERT
# a. Без указания списка полей
INSERT INTO document VALUES (1, '1234', '123456',  '20220222', 'МВД РМЭ в Г.Йошкар-Оле');
# b. С указанием списка полей
INSERT INTO document (series, number, date_issue, issuing_authority) VALUES ('2345', '234567', '20220223', 'МВД РМЭ в Г.Киеве');
# c. С чтением значения из другой таблицы
INSERT INTO user (id_document, first_name, last_name, patronymic) SELECT id_document, 'Vladimir', 'Putin', 'Vladimirovich' FROM document;

# # DELETE
# a.Всех записей
DELETE FROM user;
# b. По условию
DELETE FROM document WHERE id_document = 3;


# NOT TASK
INSERT INTO tariff (name, description, price_in_kopecks_in_day, is_actual) VALUES ('T #1', 'First', '100', true);
INSERT INTO tariff (name, description, price_in_kopecks_in_day, is_actual) VALUES ('T #2', 'Second', '200', false);
INSERT INTO tariff (name, description, price_in_kopecks_in_day, is_actual) VALUES ('T #3', 'Third', '300', false);
INSERT INTO tariff (name, description, price_in_kopecks_in_day, is_actual) VALUES ('T #4', 'Fourth', '100', true);
INSERT INTO tariff (name, description, price_in_kopecks_in_day, is_actual) VALUES ('T #5', 'Fifth', '120', false);
INSERT INTO type_service (name, description, price_in_kopecks_in_day, is_actual) VALUES ('S #1', 'First', '5', false);
INSERT INTO type_service (name, description, price_in_kopecks_in_day, is_actual) VALUES ('S #2', 'Second', '20', true);
INSERT INTO type_service (name, description, price_in_kopecks_in_day, is_actual) VALUES ('S #3', 'Third', '30', true);
INSERT INTO document (series, number, date_issue, issuing_authority) VALUES ('3456', '234567', '20220224', 'МВД РМЭ в Г.Самара');
INSERT INTO document (series, number, date_issue, issuing_authority) VALUES ('4567', '234567', '20220225', 'МВД РМЭ в Г.Саратов');
INSERT INTO document (series, number, date_issue, issuing_authority) VALUES ('5678', '234567', '20220226', 'МВД РМЭ в Г.Казань');
INSERT INTO user (first_name, last_name, patronymic, id_document) VALUES ('Ivan', '3', 'Rurikovich', 1);
INSERT INTO user (first_name, last_name, patronymic, id_document) VALUES ('Vladimir', '1', 'Rurikovich', 2);
INSERT INTO user (first_name, last_name, patronymic, id_document) VALUES ('Igor', '2', 'Rurikovich', 3);
INSERT INTO user (first_name, last_name, patronymic, id_document) VALUES ('Oleg', '1', 'Rurikovich', 4);
INSERT INTO user (first_name, last_name, patronymic, id_document) VALUES ('Ekaterina', '2', 'Rurikovich', 5);
INSERT INTO telephone (country_code, number, registration_date, id_tariff, id_user) VALUES ('+7', '9697788877', '20220225', 1, 4);
INSERT INTO telephone (country_code, number, registration_date, id_tariff, id_user) VALUES ('+380', '9697788877', '20210225', 3, 5);
INSERT INTO telephone (country_code, number, registration_date, id_tariff, id_user) VALUES ('+1', '9697788877', '20210531', 5, 6);
INSERT INTO telephone (country_code, number, registration_date, id_tariff, id_user) VALUES ('+1', '9697788877', '20220225', 5, 7);
INSERT INTO telephone (country_code, number, registration_date, id_tariff, id_user) VALUES ('+1', '9697788877', '20211225', 5, 8);
INSERT INTO payment (id_telephone, amount_in_kopecks, date, is_successfully) VALUES (1, 30000, '20220311', true);
INSERT INTO payment (id_telephone, amount_in_kopecks, date, is_successfully) VALUES (1, 30000, '20220211', true);
INSERT INTO payment (id_telephone, amount_in_kopecks, date, is_successfully) VALUES (1, 30000, '20220211', false);
INSERT INTO payment (id_telephone, amount_in_kopecks, date, is_successfully) VALUES (1, 30000, '20220111', true);
INSERT INTO payment (id_telephone, amount_in_kopecks, date, is_successfully) VALUES (1, 30000, '20220111', false);
INSERT INTO payment (id_telephone, amount_in_kopecks, date, is_successfully) VALUES (2, 50000, '20220310', true);
INSERT INTO payment (id_telephone, amount_in_kopecks, date, is_successfully) VALUES (2, 50000, '20220210', true);
INSERT INTO payment (id_telephone, amount_in_kopecks, date, is_successfully) VALUES (2, 50000, '20220110', true);
INSERT INTO payment (id_telephone, amount_in_kopecks, date, is_successfully) VALUES (3, 30000, '20220210', true);
INSERT INTO payment (id_telephone, amount_in_kopecks, date, is_successfully) VALUES (3, 30000, '20220110', true);
INSERT INTO payment (id_telephone, amount_in_kopecks, date, is_successfully) VALUES (3, 30000, '20211210', true);

# # UPDATE
# a. Всех записей
UPDATE tariff SET is_actual = false;
# b. По условию обновляя один атрибут
UPDATE type_service SET price_in_kopecks_in_day = '10', is_actual = true WHERE is_actual = false;
# c.По условию обновляя несколько атрибутов
UPDATE tariff SET price_in_kopecks_in_day = '200', is_actual = true WHERE is_actual = false;

# # SELECT
# a. С набором извлекаемых атрибутов
SELECT name, price_in_kopecks_in_day FROM tariff;
# b. Со всеми атрибутами
SELECT * FROM type_service;
# c. С условием по атрибуту
SELECT * FROM document WHERE date_issue = '20220223';

# # SELECT ORDER BY + TOP (LIMIT)
# a. С сортировкой по возрастанию ASC + ограничение вывода количества записей
SELECT CONCAT(first_name, ' ', last_name) AS full_name, id_document FROM user ORDER BY full_name LIMIT 3;
# b. С сортировкой по убыванию DESC
SELECT CONCAT(first_name, ' ', last_name) AS full_name, id_document FROM user ORDER BY id_document DESC;
# c. С сортировкой по двум атрибутам + ограничение вывода количества записей
SELECT * FROM tariff ORDER BY name, price_in_kopecks_in_day LIMIT 3;
# d. С сортировкой по первому атрибуту, из списка извлекаемых
SELECT * FROM tariff ORDER BY 1;

# # Работа с датами
# a. WHERE по дате
SELECT * FROM telephone WHERE registration_date = '20220225';
# b. WHERE дата в диапазоне
SELECT * FROM telephone WHERE registration_date BETWEEN '20210101' AND '20211231';
# c. Извлечь из таблицы не всю дату, а только год
SELECT CONCAT(country_code, number) AS number, YEAR(registration_date) AS registration_date_year FROM telephone;

# # Функции агрегации
# a. Посчитать количество записей в таблице
SELECT COUNT(*) AS all_tariffs FROM tariff;
# b. Посчитать количество уникальных записей в таблице
SELECT COUNT(DISTINCT country_code) AS all_country_codes FROM telephone;
# c. Вывести уникальные значения столбца
SELECT DISTINCT country_code FROM telephone;
# d. Найти максимальное значение столбца
SELECT MAX(price_in_kopecks_in_day) AS most_expensive_service FROM type_service;
# e. Найти минимальное значение столбца
SELECT MIN(price_in_kopecks_in_day) AS most_cheapest_service FROM type_service;
# f. Написать запрос COUNT () + GROUP BY
SELECT country_code, COUNT(country_code) FROM telephone GROUP BY country_code;

# # SELECT GROUP BY + HAVING
# a. Написать 3 разных запроса с использованием GROUP BY + HAVING
# Для каждого запроса написать комментарий с пояснением, какую информацию извлекает запрос
# Запрос должен быть осмысленным, т.е. находить информацию, которую можно использовать
# Вывод оплат номер телефона чья суммарная сумма > 100 000
SELECT id_telephone, SUM(amount_in_kopecks) FROM payment GROUP BY id_telephone HAVING SUM(amount_in_kopecks) > 100000;
# Средняя внесённая сумма больше 40 000
SELECT AVG(amount_in_kopecks) AS avg_amount, id_telephone FROM payment GROUP BY id_telephone HAVING avg_amount > 40000;
# Максимальные платежи пользователей, которые только в этом году совершили платёж
SELECT MAX(amount_in_kopecks) AS max_amount, date, id_telephone FROM payment GROUP BY id_telephone HAVING MIN(date) >= '20220101';

# # SELECT JOIN
# a. LEFT JOIN двух таблиц и WHERE по одному из атрибутов
SELECT * FROM user LEFT JOIN document d ON d.id_document = user.id_document WHERE date_issue >= '20220224';
# b. RIGHT JOIN. Получить такую же выборку, как и в 3.9a
SELECT * FROM document RIGHT JOIN user u ON u.id_document = document.id_document WHERE date_issue >= '20220224';
# c. LEFT JOIN трех таблиц + WHERE по атрибуту из каждой таблицы
SELECT CONCAT(t.country_code, t.number) AS phone, CONCAT(u.first_name, ' ', u.last_name) AS name, CONCAT(d.series, ' ', d.number) AS passport
FROM document d
LEFT JOIN user u on d.id_document = u.id_document
LEFT JOIN telephone t on u.id_user = t.id_user
WHERE t.registration_date >= '20220101';
# d. INNER JOIN двух таблиц
SELECT * FROM user INNER JOIN document d ON d.id_document = user.id_document;

# # Подзапросы
# a. Написать запрос с условием WHERE IN (подзапрос)
SELECT * FROM user WHERE id_document IN (SELECT id_document FROM document);
# b. Написать запрос SELECT atr1, atr2, (подзапрос) FROM ...
SELECT (SELECT CONCAT(first_name, ' ', last_name) FROM user WHERE user.id_document = document.id_document) FROM document;
# c. Написать запрос вида SELECT * FROM (подзапрос)
SELECT number, registration_date FROM (SELECT CONCAT(country_code, number) AS number, registration_date, id_user FROM telephone) AS t;
# d. Написать запрос вида SELECT * FROM table JOIN (подзапрос) ON
SELECT CONCAT(first_name, ' ', last_name) AS name, CONCAT(d.series, ' ', d.number) AS passport FROM user JOIN (SELECT * FROM document) d ON d.id_document = user.id_document;