# 1. Добавить внешние ключи.
ALTER TABLE dealer ADD FOREIGN KEY (id_company) REFERENCES company (id_company);
ALTER TABLE production ADD FOREIGN KEY (id_company) REFERENCES company (id_company);
ALTER TABLE production ADD FOREIGN KEY (id_medicine) REFERENCES medicine (id_medicine);
ALTER TABLE `order` ADD FOREIGN KEY (id_production) REFERENCES production (id_production);
ALTER TABLE `order` ADD FOREIGN KEY (id_dealer) REFERENCES dealer (id_dealer);
ALTER TABLE `order` ADD FOREIGN KEY (id_pharmacy) REFERENCES pharmacy (id_pharmacy);

# 2. Выдать информацию по всем заказам лекарства “Кордерон” ком пании “Аргус” с указанием названий аптек, дат, объема заказов.
SELECT ph.name, date, quantity FROM `order`
    INNER JOIN production pr ON `order`.id_production = pr.id_production
    INNER JOIN company c ON pr.id_company = c.id_company
    INNER JOIN medicine m ON pr.id_medicine = m.id_medicine AND m.name = 'Кордеон'
    INNER JOIN pharmacy ph ON `order`.id_pharmacy = ph.id_pharmacy AND c.name = 'Аргус';

# 3. Дать список лекарств компании “Фарма”, на которые не были сделаны заказы до 25 января.
