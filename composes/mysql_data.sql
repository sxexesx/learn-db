create database if not exists dev;
use dev;

create table user
(
    id          int auto_increment,
    email       varchar(32) null,
    password    varchar(32) null,
    description text        null,
    constraint pkid
        primary key (id)
);


insert into
    dev.user(email, password, description)
values
    ('alex@gmail.com', 'test', null),
    ('ivan89@icloud.com', 'test', null),
    ('pegii@gmail.com', 'test', null),
    ('elena3.14@mail.ru', 'test', null),
    ('vjones@yandex.ru', 'test', null),
    ('elena.needle@gmail.com', 'test', null);