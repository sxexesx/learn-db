create schema if not exists public;

drop type if exists user_type cascade;
drop type if exists user_status cascade;

create type user_type as enum ('ADMIN', 'CLIENT', 'MASTER');
create type user_status as enum ('AVAILABLE', 'BLOCKED', 'VACATION');

create table if not exists public.user
(
    id           serial      not null primary key,
    email        varchar(32),
    phone_number varchar(10),
    password     varchar(32) not null,
    user_type    user_type   not null,
    user_state   user_status not null,
    description  text
);

--------------
---- DATA ----
--------------
insert into public.user(email, phone_number, password, user_type, user_state, description)
values ('alex@gmail.com', '9109109910', 'test', 'ADMIN', 'AVAILABLE', null),
       ('ivan89@icloud.com', '9155317515', 'test', 'CLIENT', 'AVAILABLE', null),
       ('pegii@gmail.com', '9114568123', 'test', 'CLIENT', 'AVAILABLE', null),
       ('elena3.14@mail.ru', '9097856431', 'test', 'CLIENT', 'AVAILABLE', null),
       ('vjones@yandex.ru', '9105648274', 'test', 'CLIENT', 'AVAILABLE', null),
       ('elena.needle@gmail.com', '9578945613', 'test', 'MASTER', 'AVAILABLE', null);
