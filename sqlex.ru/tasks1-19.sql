-- Task 1:
-- Найдите номер модели, скорость и размер жесткого диска для всех ПК стоимостью менее 500 дол. Вывести: model, speed и hd
select model, speed, hd
from pc
where price < 500;

-- Task 2:
-- Найдите производителей принтеров. Вывести: maker
select distinct maker
from product
where type = 'printer';

-- Task 3:
-- Найдите номер модели, объем памяти и размеры экранов ПК-блокнотов, цена которых превышает 1000 дол.
select model, ram, screen
from laptop
where price > 1000;

-- Task 4:
-- Найдите все записи таблицы Printer для цветных принтеров.
Select *
from printer
where color != 'n';

-- Task 5:
-- Найдите номер модели, скорость и размер жесткого диска ПК, имеющих 12x или 24x CD и цену менее 600 дол.
Select model, speed, hd
from pc
where price < 600
  and cd in ('24x', '12x');

-- Task 6:
-- Для каждого производителя, выпускающего ПК-блокноты c объёмом жесткого диска не менее 10 Гбайт, найти скорости таких
-- ПК-блокнотов. Вывод: производитель, скорость.
Select distinct p.maker, l.speed
from product p
         left join laptop l on p.model = l.model
where l.hd >= 10
  and l.speed is not null
order by p.maker;

-- Task 7:
-- Найдите номера моделей и цены всех имеющихся в продаже продуктов (любого типа) производителя B (латинская буква).
select qq.model, qq.price
from (select distinct p.maker, p.model, l.price
      from product p
               join laptop l on p.model = l.model
      union all
      select distinct p.maker, p.model, pc.price
      from product p
               join pc pc on pc.model = p.model
      union all
      select distinct p.maker, p.model, pr.price
      from product p
               join printer pr on pr.model = p.model) as qq
where qq.maker = 'B';

-- Task 8:
-- Найдите производителя, выпускающего ПК, но не ПК-блокноты.
select distinct maker
from product
where maker not in (select distinct maker
                    from product
                    where type = 'laptop')
  and type = 'pc';

-- Task 9:
-- Найдите производителей ПК с процессором не менее 450 Мгц. Вывести: Maker
select distinct maker
from product p
         inner join pc pc on p.model = pc.model
where pc.speed >= 450;

-- Task 10:
-- Найдите модели принтеров, имеющих самую высокую цену. Вывести: model, price
select model, price
from printer
where price = (select max(price)
               from printer);

-- Task 11:
-- Найдите среднюю скорость ПК.
select avg(speed)
from pc;

-- Task 12:
-- Найдите среднюю скорость ПК-блокнотов, цена которых превышает 1000 дол.
select avg(speed)
from laptop
where price > 1000;

-- Task 13:
-- Найдите среднюю скорость ПК, выпущенных производителем A.
select avg(speed)
from pc pc
         inner join product pr on pc.model = pr.model
where pr.maker = 'A';

-- Task 14:
-- Найдите класс, имя и страну для кораблей из таблицы Ships, имеющих не менее 10 орудий
select sh.class, sh.name, cl.country
from ships sh
         join classes cl on sh.class = cl.class
where cl.numGuns >= 10;

-- Task 15:
-- Найдите размеры жестких дисков, совпадающих у двух и более PC. Вывести: HD
select hd
from pc
group by hd
having count(model) >= 2;

-- Task 16:
-- Найдите пары моделей PC, имеющих одинаковые скорость и RAM. В результате каждая пара указывается только один раз,
-- т.е. (i,j), но не (j,i), Порядок вывода: модель с большим номером, модель с меньшим номером, скорость и RAM.
select distinct pc1.model, pc2.model, pc1.speed, pc1.ram
from pc as pc1,
     pc as pc2
where pc1.speed = pc2.speed
  and pc1.ram = pc2.ram
  and pc1.model <> pc2.model
  and pc1.model > pc2.model
order by pc1.model desc

-- Task 17:
-- Найдите модели ПК-блокнотов, скорость которых меньше скорости каждого из ПК. Вывести: type, model, speed
select distinct pr.type, lt.model, lt.speed
from laptop lt
         join product pr on pr.model = lt.model
where lt.speed < any (select min(speed)
                      from pc);

-- Task 18:
-- Найдите производителей самых дешевых цветных принтеров. Вывести: maker, price
select distinct pr.maker, pt.price
from printer pt
         join product pr on pt.model = pr.model
where pt.price <= (select min(price)
                   from printer
                   where color = 'y')
  and pt.color = 'y';

-- Task 19:
-- Для каждого производителя, имеющего модели в таблице Laptop, найдите средний размер экрана выпускаемых им ПК-блокнотов.
-- Вывести: maker, средний размер экрана.
select pr.maker, avg(lt.screen)
from laptop lt
         join product pr
              on lt.model = pr.model
group by pr.maker;

