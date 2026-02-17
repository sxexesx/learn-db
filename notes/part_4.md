# JOIN

Аналог горизонтального соединения

<div>
  <img width="500" height="500" src="src/img09.png" alt="">
</div>

`CROSS JOIN` - декартово произведение(каждой строчке одной таблицы сопоставляем каждую строчку другой)  
Пример:
`FROM t1 CROSS JOIN t2`  
Старый синтаксис (SQL-89): `FROM t1, t2`

<div>
  <img width="300" height="320" src="src/img05.png" alt="">
</div>

`INNER JOIN` - декартово произведение + фильтрация
Пример:
`FROM t1 [INNER] JOIN t2 on t1.id = t2.id`

<div>
  <img width="300" height="320" src="src/img06.png" alt="">
</div>

`LEFT/RIGHT JOIN` - INNER JOIN + внешние строки
Пример:
`FROM t1 LEFT [OUTER] JOIN t2 on t1.id = t2.id`

<div>
  <img width="300" height="320" src="src/img07.png" alt="">
</div>

`FULL JOIN` - LEFT + RIGHT JOIN
Пример:
`FROM t1 FULL [OUTER] JOIN t2 on t1.id = t2.id`

Рекомендуется делать индекс по тем колонкам, по которым делаем JOIN.

# UNION

Аналог вертикального соединения.  
`UNION ALL` дублирует одинаковые строки.

`UNION` - это `UNION ALL` + `DISTINCT`

<div>
  <img width="500" height="240" src="src/img08.png" alt="">
</div>

# Агрегатные функции

- COUNT, SUM, AVG, MIN, MAX
- В качестве выражения используются константа, столбец, функция
- NULL игнорируется кроме COUNT(*)
- В SELECT можно писать агрегатные функции

# GROUP BY

Используются вместе с агригирующими функциями

```
SELECT ...
FROM ...
[WHERE] ...
[GROUP BY [GROUPING SETS | ROLLUP | CUBE] ...]
[HAVING] ...
[ORDER BY] ...
```


# GROUPING SETS, ROLLUP, CUBE

| GROUPONG SETS                    | ЭКВИВАЛЕНТ                                                       |
|----------------------------------|------------------------------------------------------------------|
| GROUP BY GROUPING SETS (a,b,c)   | GROUP BY a UNION ALL <br/> GROUP BY b UNION ALL <br/> GROUP BY c |
| GROUP BY GROUPING SETS (a,(b,c)) | GROUP BY a UNION ALL <br/> GROUP BY (b,c)                        |

`ROLLUP` позволяет проанализировать данные, постепенно переходя от конкретной информации к обобщенной, что соответствует 
классическому подходу к аналитике. При этом, порядок указания столбцов имеет решающее влияние на структуру подитогов.

```
SELECT Страна, Город, COUNT(Пользователь)
FROM Пользователи GROUP BY ROLLUP(Страна, Город);
```

Результат: ABC + AB + A + ()

Оператор `CUBE` расширяет аналитические возможности за счет создания подитогов по всем комбинациям группирующих 
атрибутов. Однако это может привести к увеличению числа строк в результате агрегации, особенно при работе с большими 
объемами данных.  
Возможность увидеть все комбинации выбора, включая пустую строку

```
SELECT Страна, Город, COUNT(Пользователь)
FROM Пользователи GROUP BY CUBE(Страна, Город);
```

Результат: ABC + AB + BC + A + B + C + ()  

Тогда как GROUP BY `AA, BB, CC`  