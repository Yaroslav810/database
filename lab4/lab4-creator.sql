DROP DATABASE IF EXISTS lab_4;

CREATE DATABASE lab_4;

USE lab_4;

CREATE TABLE IF NOT EXISTS type_service
(
    id_type_service int unsigned not null auto_increment primary key,
    name varchar(50) not null,
    description varchar(250) not null,
    price_in_kopecks_in_day int unsigned not null,
    is_actual bit not null
);

CREATE TABLE IF NOT EXISTS tariff
(
    id_tariff int unsigned not null auto_increment primary key,
    name varchar(50) not null,
    description varchar(250) not null,
    price_in_kopecks_in_day int unsigned not null,
    is_actual bit not null
);

CREATE TABLE IF NOT EXISTS document
(
    id_document int unsigned not null auto_increment primary key,
    series varchar(10) not null,
    number varchar(10) not null,
    date_issue date not null,
    issuing_authority varchar(100) not null
);

CREATE TABLE IF NOT EXISTS user
(
    id_user int unsigned not null auto_increment primary key,
    first_name varchar(50) not null,
    last_name varchar(50) not null,
    patronymic varchar(50) null,
    id_document int unsigned,
    foreign key (id_document) references document (id_document)
);

CREATE TABLE IF NOT EXISTS telephone
(
    id_telephone int unsigned not null auto_increment primary key,
    country_code varchar(5) not null,
    number varchar(10) not null,
    registration_date datetime not null,
    id_tariff int unsigned,
    id_user int unsigned,
    foreign key (id_tariff) references tariff (id_tariff),
    foreign key (id_user) references user (id_user)
);

CREATE TABLE IF NOT EXISTS payment
(
    id_payment int unsigned not null auto_increment primary key,
    amount_in_kopecks int unsigned not null,
    date datetime not null,
    is_successfully bit not null,
    id_telephone int unsigned,
    foreign key (id_telephone) references telephone (id_telephone)
);

CREATE TABLE IF NOT EXISTS connected_services
(
    id_connected_services int unsigned not null auto_increment primary key,
    id_type_service int unsigned not null,
    id_telephone int unsigned not null,
    foreign key (id_type_service) references type_service (id_type_service),
    foreign key (id_telephone) references telephone (id_telephone)
);
