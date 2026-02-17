-- нет источника // константы
SELECT 123 AS Col01,
       'A' AS Col02;

-- одна таблица
SELECT
    OrderLineID AS Order_Line_ID,
    StockItemID,
    Price = UnitPrice, -- синоним
    'Batch 1' AS BatchID, -- константа
    (Quantity * UnitPrice) AS Total -- арифметическое выражение
FROM Sales.OrderLines;

-- выборка всего
SELECT *
FROM Sales.OrderLines;

-- ORDER BY
SELECT * FROM Sales.OrderLines l
ORDER BY l.Description; -- asc (по умолчанию) - по возрастания, desc - по убыванию

-- Разбивка на страницы
SELECT * FROM Sales.OrderLines l
ORDER BY l.Description
OFFSET 20 ROWS -- указыаем сколько пропускаем строк
FETCH NEXT 50 ROWS ONLY;

-- DISTINCT
SELECT DISTINCT Contact
FROM Sales.OrderLines;

-- простое условие
SELECT *
FROM Sales.StockItems
WHERE Sales.StockItemName = 'Chocolate sharks 20g';

-- простой LIKE
SELECT *
FROM Sales.StockItems
WHERE Sales.StockItemName like 'Chocolate%';

-- работа с NULL
SELECT *
FROM Sales.StockItems
WHERE Sales.StockItemName IS NULL;

-- получение даты
SELECT 'GETDATE' AS STFunction, GETDATE();
SELECT 'SYSDATETIME' AS STFunction, SYSDATETIME();

SELECT o.OrderDate,
       MONTH(o.OrderDate) as Month,
       DAY(o.OrderDate) as Day,
       YEAR(o.OrderDate) as Yead
FROM o.Sales;

-- получение разницы дат
SELECT DATEDIFF(yy, '2017-01-01', '2018-01-01') AS YearDiff;
SELECT DATEDIFF(dd, '2017-01-01', '2018-01-01') AS DayDiff;

-- --------------------------------------------------------------
-- простая вставка
INSERT INTO warehouse.colors
(colorId, colorName, LastEditedBy)
VALUES (NEXTVAL('Sequences.colors_id_seq'), 'Ohra', 1);

-- копирование через SELECT
SELECT first_name, last_name
INTO actor_copy
FROM actor
WHERE actor.actor_id < 10;

-- MSSQL
INSERT INTO category (category_id, name, last_update)
    OUTPUT category_id, name, last_update
    INTO category_copy(category_id, name, last_update)
VALUES (NEXTVAL(category_category_id_seq), 'trash movie', now()),
       (NEXTVAL(category_category_id_seq), 'unknown', now());

-- MSSQL
BEGIN transaction;
INSERT INTO category (category_id, name, last_update)
VALUES (NEXTVAL(category_category_id_seq), 'trash movie', now());
COMMIT;

INSERT INTO category_temp (category_id, name, last_update)
SELECT name, last_update
FROM category
WHERE category_id > 10;

-- простой UPDATE
UPDATE People
SET PhoneNumber = '799922234567',
    FaxNumber   = '799922236677'
WHERE PersonId = 3;

-- UPDATE с подзапросом
UPDATE People
SET FirstSale = (SELECT MIN(Invoice)
                 FROM Invoices AS I
                 WHERE People.PersonId = I.SalesPersonId);

-- UPDATE всей таблицы
UPDATE People
SET PersonSale  = NULL,
    PersonSale2 = NULL;

-- DELETE с условием
DELETE FROM Colors
WHERE ColorName like '%2%';

-- C Exist
DELETE FROM Colors
WHERE EXISTS (SELECT * FROM new_colors);