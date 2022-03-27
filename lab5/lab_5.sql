# 1. Добавить внешние ключи
ALTER TABLE booking ADD FOREIGN KEY (id_client) REFERENCES client (id_client);
ALTER TABLE room ADD FOREIGN KEY (id_room_category) REFERENCES room_category (id_room_category);
ALTER TABLE room ADD FOREIGN KEY (id_hotel) REFERENCES hotel (id_hotel);
ALTER TABLE room_in_booking ADD FOREIGN KEY (id_booking) REFERENCES booking (id_booking);
ALTER TABLE room_in_booking ADD FOREIGN KEY (id_room) REFERENCES room (id_room);

# 2. Выдать информацию о клиентах гостиницы “Космос”, проживающих в номерах категории “Люкс” на 1 апреля 2019г
SELECT client.name, client.phone FROM client
    LEFT JOIN booking b ON client.id_client = b.id_client
    LEFT JOIN room_in_booking rib on b.id_booking = rib.id_booking
    LEFT JOIN room r on r.id_room = rib.id_room
    LEFT JOIN hotel h on h.id_hotel = r.id_hotel
    LEFT JOIN room_category rc on rc.id_room_category = r.id_room_category
    WHERE
          rc.name = 'Люкс' &&
          h.name = 'Космос' &&
          rib.checkin_date <= '2019-04-01' &&
          rib.checkout_date > '2019-04-01';

# 3. Дать список свободных номеров всех гостиниц на 22 апреля
SELECT h.name, room.number, room.price FROM room
    INNER JOIN hotel h ON h.id_hotel = room.id_hotel
    INNER JOIN room_in_booking rib ON room.id_room = rib.id_room
    WHERE
          rib.checkin_date <= '2019-04-22' &&
          rib.checkout_date > '2019-04-22'
    GROUP BY h.name, room.number;

# 4. Дать количество проживающих в гостинице “Космос” на 23 марта по каждой категории номеров
SELECT rc.name, COUNT(*) FROM room_in_booking
    INNER JOIN room r ON room_in_booking.id_room = r.id_room
    INNER JOIN room_category rc ON r.id_room_category = rc.id_room_category
    INNER JOIN hotel h ON r.id_hotel = h.id_hotel && r.id_hotel = h.id_hotel
    WHERE
          h.name = 'Космос' &&
          room_in_booking.checkin_date <= '2019-03-23' &&
          room_in_booking.checkout_date > '2019-03-23'
    GROUP BY
          rc.name;

# 5. Дать список последних проживавших клиентов по всем комнатам гостиницы “Космос”, выехавшим в апреле с указанием даты выезда
SELECT r.number, c.name, rib.checkout_date FROM client c
    INNER JOIN booking b ON c.id_client = b.id_client
    INNER JOIN room_in_booking rib ON b.id_booking = rib.id_booking
    INNER JOIN room r ON r.id_room = rib.id_room
    INNER JOIN (
        SELECT r.id_room, MAX(checkout_date) AS last_checkout_date FROM room_in_booking rib
        INNER JOIN room r ON rib.id_room = r.id_room
        INNER JOIN hotel h ON r.id_hotel = h.id_hotel
        WHERE
            h.name = 'Космос' &&
            MONTH(rib.checkout_date) = 4
        GROUP BY
            r.id_room
    ) AS sr ON r.id_room = sr.id_room && rib.checkout_date = sr.last_checkout_date;

# 6. Продлить на 2 дня дату проживания в гостинице “Космос” всем клиентам комнат категории “Бизнес”, которые заселились 10 мая
UPDATE room_in_booking rib
    INNER JOIN room r ON rib.id_room = r.id_room
    INNER JOIN room_category rc ON r.id_room_category = rc.id_room_category
    INNER JOIN hotel h ON r.id_hotel = h.id_hotel
    SET
        rib.checkout_date = rib.checkout_date + INTERVAL 2 DAY
    WHERE
        h.name = 'Космос' &&
        rc.name = 'Бизнес' &&
        rib.checkin_date = '2019-05-10';

# 7. Найти все "пересекающиеся" варианты проживания.
# Правильное состояние: не может быть забронирован один номер на одну дату несколько раз, т.к. нельзя заселиться нескольким
# клиентам в один номер. Записи в таблице room_in_booking с id_room_in_booking = 5 и 2154 являются примером неправильного состояния,
# которые необходимо найти. Результирующий кортеж выборки должен содержать информацию о двух конфликтующих номерах.
SELECT rib1.id_room_in_booking, rib1.checkin_date, rib2.checkin_date, rib1.checkout_date, rib2.checkout_date
FROM room_in_booking rib1
    INNER JOIN room_in_booking rib2 ON rib1.id_room = rib2.id_room && rib1.id_booking != rib2.id_booking
    WHERE
        rib1.checkin_date BETWEEN rib2.checkin_date AND rib2.checkout_date &&
        rib1.checkout_date BETWEEN rib2.checkin_date AND rib2.checkout_date;

# 8. Создать бронирование в транзакции
BEGIN;
INSERT INTO client (name, phone) VALUES ('Yaroslav', '+7969778307*');
INSERT INTO booking (id_client, booking_date) VALUES ((SELECT id_client FROM client WHERE name = 'Yaroslav' && phone = '+7969778307*'), '2022-03-18');
COMMIT;

# 9. Добавить необходимые индексы для всех таблиц
CREATE INDEX IX_issuance_room_category_id_room_category ON room_category(id_room_category);
CREATE INDEX IX_issuance_hotel_id_hotel ON hotel(id_hotel);
CREATE INDEX IX_issuance_hotel_name ON hotel(name);
CREATE INDEX IX_issuance_room_id_hotel ON room(id_hotel);
CREATE INDEX IX_issuance_room_id_room_category ON room(id_room_category);
CREATE INDEX IX_issuance_room_in_booking_checkin_date ON room_in_booking(checkin_date);
CREATE INDEX IX_issuance_room_in_booking_checkout_date ON room_in_booking(checkout_date);
CREATE INDEX IX_issuance_client_name_phone ON client(name, phone);
