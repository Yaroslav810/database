# 1. Добавить внешние ключи.
ALTER TABLE dealer
    ADD FOREIGN KEY (id_company) REFERENCES company (id_company);
ALTER TABLE production
    ADD FOREIGN KEY (id_company) REFERENCES company (id_company);
ALTER TABLE production
    ADD FOREIGN KEY (id_medicine) REFERENCES medicine (id_medicine);
ALTER TABLE `order`
    ADD FOREIGN KEY (id_production) REFERENCES production (id_production);
ALTER TABLE `order`
    ADD FOREIGN KEY (id_dealer) REFERENCES dealer (id_dealer);
ALTER TABLE `order`
    ADD FOREIGN KEY (id_pharmacy) REFERENCES pharmacy (id_pharmacy);

# 2. Выдать информацию по всем заказам лекарства “Кордерон” ком пании “Аргус” с указанием названий аптек, дат, объема заказов.
SELECT ph.name, date, quantity
FROM `order`
         JOIN production pr ON `order`.id_production = pr.id_production
         JOIN company c ON pr.id_company = c.id_company
         JOIN medicine m ON pr.id_medicine = m.id_medicine AND m.name = 'Кордеон'
         JOIN pharmacy ph ON `order`.id_pharmacy = ph.id_pharmacy AND c.name = 'Аргус';

# 3. Дать список лекарств компании “Фарма”, на которые не были сделаны заказы до 25 января.
SELECT medicine.name
FROM medicine
         JOIN production p on medicine.id_medicine = p.id_medicine
         JOIN company c on c.id_company = p.id_company && c.name = 'Фарма'
         LEFT JOIN `order` o on p.id_production = o.id_production && o.date < '20190125'
WHERE
    o.id_order IS NULL;

# 4. Дать минимальный и максимальный баллы лекарств каждой фирмы, которая оформила не менее 120 заказов.
SELECT c.name, MIN(rating), MAX(rating)
FROM production
         JOIN company c ON c.id_company = production.id_company
         JOIN `order` o ON production.id_production = o.id_production
GROUP BY c.name
HAVING COUNT(o.id_order) > 120;

# 5. Дать списки сделавших заказы аптек по всем дилерам компании “AstraZeneca”. Если у дилера
# нет заказов, в названии аптеки проставить NULL.
SELECT dealer.name, p.name
FROM dealer
         LEFT JOIN `order` o ON dealer.id_dealer = o.id_dealer
         LEFT JOIN pharmacy p ON p.id_pharmacy = o.id_pharmacy
         LEFT JOIN company c ON c.id_company = dealer.id_company
WHERE c.name = 'AstraZeneca';

# 6. Уменьшить на 20% стоимость всех лекарств, если она превышает 3000, а длительность лечения не более 7 дней.
UPDATE medicine m
    JOIN production p on m.id_medicine = p.id_medicine
SET p.price = 0.8 * p.price
WHERE p.price > 3000
  AND m.cure_duration <= 7;

# 7. Добавить необходимые индексы.
CREATE INDEX IX_issuance_company_name ON company(name);
CREATE INDEX IX_issuance_medicine_name ON medicine(name);
CREATE INDEX IX_issuance_medicine_cure_duration ON medicine(cure_duration);
CREATE INDEX IX_issuance_production_price ON production(price);
CREATE INDEX IX_issuance_order_date ON `order`(date);
