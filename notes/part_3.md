## Основные операции по работе с SQL

_**DDL** (data defenition language)_ - язык описания баз данных, чтобы определить, что будет лежать в базе данных
(CREATE, ALTER, DROP, TR NCATE)  
_**DML** (data manipulation language)_ - язык оперирования данными (SELECT, INSERT, UPDATE, DELETE)
_**DCL** (data control language)_ - язык управления доступом (GRANT, REVOKE, DENY)
_**TCL** (transaction control language)_ - язык управления транзакциями (COMMIT, ROLLBACK, SAVEPOINT)

**Операции: **

1. Выборка (SELECT)
2. Проекция (PROJECT)
3. Соединения (JOIN)
4. Деление (DIVIDE BY)

5. Объединение (UNION)
6. Пересечение (INTERSECT)
7. Вычитание (DIFFERENCE, MINUS)
8. Декартово произведение (CARTESIAN)

## DML

### Операция SELECT

PostreSQL syntax:

```
[ WITH [ RECURSIVE ] with_query [, ...] ]
SELECT [ ALL | DISTINCT [ ON ( expression [, ...] ) ] ]
    [ * | expression [ [ AS ] output_name ] [, ...] ]
    [ FROM from_item [, ...] ]
    [ WHERE condition ]
    [ GROUP BY [ ALL | DISTINCT ] grouping_element [, ...] ]
    [ HAVING condition ]
    [ WINDOW window_name AS ( window_definition ) [, ...] ]
    [ { UNION | INTERSECT | EXCEPT } [ ALL | DISTINCT ] select ]
    [ ORDER BY expression [ ASC | DESC | USING operator ] [ NULLS { FIRST | LAST } ] [, ...] ]
    [ LIMIT { count | ALL } ]
    [ OFFSET start [ ROW | ROWS ] ]
    [ FETCH { FIRST | NEXT } [ count ] { ROW | ROWS } { ONLY | WITH TIES } ]
    [ FOR { UPDATE | NO KEY UPDATE | SHARE | KEY SHARE } [ OF table_name [, ...] ] [ NOWAIT | SKIP LOCKED ] [...] ]

where from_item can be one of:

    [ ONLY ] table_name [ * ] [ [ AS ] alias [ ( column_alias [, ...] ) ] ]
                [ TABLESAMPLE sampling_method ( argument [, ...] ) [ REPEATABLE ( seed ) ] ]
    [ LATERAL ] ( select ) [ [ AS ] alias [ ( column_alias [, ...] ) ] ]
    with_query_name [ [ AS ] alias [ ( column_alias [, ...] ) ] ]
    [ LATERAL ] function_name ( [ argument [, ...] ] )
                [ WITH ORDINALITY ] [ [ AS ] alias [ ( column_alias [, ...] ) ] ]
    [ LATERAL ] function_name ( [ argument [, ...] ] ) [ AS ] alias ( column_definition [, ...] )
    [ LATERAL ] function_name ( [ argument [, ...] ] ) AS ( column_definition [, ...] )
    [ LATERAL ] ROWS FROM( function_name ( [ argument [, ...] ] ) [ AS ( column_definition [, ...] ) ] [, ...] )
                [ WITH ORDINALITY ] [ [ AS ] alias [ ( column_alias [, ...] ) ] ]
    from_item join_type from_item { ON join_condition | USING ( join_column [, ...] ) [ AS join_using_alias ] }
    from_item NATURAL join_type from_item
    from_item CROSS JOIN from_item

and grouping_element can be one of:

    ( )
    expression
    ( expression [, ...] )
    ROLLUP ( { expression | ( expression [, ...] ) } [, ...] )
    CUBE ( { expression | ( expression [, ...] ) } [, ...] )
    GROUPING SETS ( grouping_element [, ...] )

and with_query is:

    with_query_name [ ( column_name [, ...] ) ] AS [ [ NOT ] MATERIALIZED ] ( select | values | insert | update | delete )
        [ SEARCH { BREADTH | DEPTH } FIRST BY column_name [, ...] SET search_seq_col_name ]
        [ CYCLE column_name [, ...] SET cycle_mark_col_name [ TO cycle_mark_value DEFAULT cycle_mark_default ] USING cycle_path_col_name ]

TABLE [ ONLY ] table_name [ * ]
```

### Порядок выполнения SELECT

```
(5) SELECT (5-2) DISTINCT (5-3) TOP (5-1) <select_list>  
(1) FROM (1-J) <left_table> <join_type> JOIN <right_table> ON <predicate>  
        (1-A) <left_table> <join_type> APPLY <right_table_expression> AS <alias>  
        (1-P) <left_table> <join_type> PIVOT <pivot_specification> AS <alias>  
        (1-U) <left_table> <join_type> UNPIVOT <unpivot_specification> AS <alias>  
(2) WHERE <where_predicate>  
(3) GROUP BY (group_by_predicate)  
(4) HAVING (having_predicate)  
(6) ORDER BY <order_by_list>  
```

Примеры: [селекты](part_3.sql)

### Фильтрация WHERE

Операции с приоритетами:

| Level | Оператор                                                                           |
|-------|------------------------------------------------------------------------------------|
| 1     | `~` (побитовое НЕ)                                                                 |
| 2     | `*` (умножение), `/` (деление), `%` (остаток)                                      |
| 3     | `+`, `-`, `&` (побитовое И), `^` (побитовое исключающее ИЛИ), `\|` (побитовое ИЛИ) |
| 4     | операторы сравнения - `=, >, <, >=, <=, !=, !>, !<`                                |
| 5     | `NOT`                                                                              |
| 6     | `AND`                                                                              |
| 7     | `ALL, ANY, BETWEEN, IN, LIKE, OR, SOME`                                            |
| 8     | `=` (присваивание )                                                                |

#### BETWEEN

`WHERE x BETWEEN x1 AND x2` -> `x >= x1 AND x <= x2`

#### LIKE

`%` - любая строка, содержащая 0 и больше символов  
`_` - любой одиночный символ  
`[]` - любой одиночный символ содержащийся в наборе `[a-f]` или наборе `[abcdef]`  
`[^]` - любой одиночный символ НЕ содержащийся в наборе  

### NULL

1. NULL не имеет типа
2. NULL может записываться в поля любого типа
3. Любая операция с NULL дает в результате NULL
4. Любое сравнение с NULL дает в результате **UNKNOWN** 
5. NULL при чтении (в OLAP системах) может сильно влиять на производительность

`ISNULL(A, B)` - если первый аргумент null, тогда возвращается второй аргумент
`COALESCE(A,B,C,D)` - первое не NULL значение


### Даты и строки

Установка даты для запроса:
```
SET DATEFORMAT mdy
...
GO
```  
`GETDATE`, `GETUTCDATE` - функции получения времени  
`DAY`, `MONTH`, `YEAR`, `DATEPART` - получение части даты  
`DATEDIFF`- получение разницы дат  
`DATEADD`, `EOMONTH`   

CONVERT(), FORMAT() - для преобразования дат с заданием формата отображения. По умолчанию 'yyyy-MM-dd'  
Collation - параметры сортировки (например, Cyrillic_General_CI_AS)  


### INSERT
[примеры](part_3.sql)

1. ORDER в INSERT не гарантирует порядок вставки
2. SELECT * INTO переносит не только значения, но и ПК
3. Указывать поля в INSERT необходимо для того, чтобы сохранялся порядок вставки

### UPDATE
[примеры](part_3.sql)

Недетерменированный update - когда на одну строку, которая обновляется, приходится несколько приджоиных строк

### DELETE / TRUNCATE
Отличие от Truncate:
1. DELETE - это DML, Truncate - это DDL 
2. Удаляет все данные из таблицы
3. Ему нельзя задать условие
4. Требует больше разрешений чем DELETE
5. Truncate не влияет на sequence


