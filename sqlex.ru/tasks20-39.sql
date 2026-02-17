--Task 20 (2):
-- Найдите производителей, выпускающих по меньшей мере три различных модели ПК. Вывести: Maker, число моделей ПК.
select p.maker, count(p.model)
from product p
where p.type = 'PC'
group by p.maker
having count(distinct p.model) >= 3;

-- Task 21 (1):
-- Найдите максимальную цену ПК, выпускаемых каждым производителем, у которого есть модели в таблице PC.
-- Вывести: maker, максимальная цена.
select pr.maker, max(pc.price)
from pc pc
         left join product pr on pc.model = pr.model
group by pr.maker;

-- Task 22 (1):
-- Для каждого значения скорости ПК, превышающего 600 МГц, определите среднюю цену ПК с такой же скоростью.
-- Вывести: speed, средняя цена.
select p.speed, AVG(p.price)
from pc p
where p.speed > 600
group by p.speed;

-- Task 23 (2):
-- Найдите производителей, которые производили бы как ПК со скоростью не менее 750 МГц, так и ПК-блокноты со скоростью не менее 750 МГц.
-- Вывести: Maker
select pr.maker
from product pr
         join pc p on pr.model = p.model
where p.speed >= 750
intersect
select pr.maker
from product pr
         join laptop l on pr.model = l.model
where l.speed >= 750;

-- Task 24 (2):
-- Перечислите номера моделей любых типов, имеющих самую высокую цену по всей имеющейся в базе данных продукции.
with mmx as (select model, max(price) as max_price
             from pc
             group by model
             union all
             select model, max(price) as max_price
             from laptop
             group by model
             union all
             select model, max(price) as max_price
             from printer
             group by model),
     mx as (select max(max_price) as mp
            from mmx)
select model
from mmx
where max_price = (select mp from mx);


-- Task 25 (2):
-- fixme not completed
-- Найдите производителей принтеров, которые производят ПК с наименьшим объемом RAM и с самым быстрым процессором среди
-- всех ПК, имеющих наименьший объем RAM. Вывести: Maker
with cl as (select model, ram, max(speed) as max
            from pc
            where ram in (select min(ram) as min from pc)
            group by model, ram),
     mm as (select maker
            from cl p1
                     join product p2 on p1.model = p2.model)

select distinct maker
from product
where maker in (select maker from mm);



-- Task 26 (2)
-- Найдите среднюю цену ПК и ПК-блокнотов, выпущенных производителем A (латинская буква). Вывести: одна общая средняя цена.
with all_models as (select pc.price, pc.model
                    from pc
                             join product pr on pc.model = pr.model
                    where pr.maker = 'A'
                    union all
                    select lp.price, lp.model
                    from laptop lp
                             join product pr on lp.model =
                                                pr.model
                    where pr.maker = 'A')
select avg(price)
from all_models;


-- Task 27 (2)
-- Найдите средний размер диска ПК каждого из тех производителей, которые выпускают и принтеры. Вывести: maker,
-- средний размер HD.
with spr as (select distinct p1.maker
             from product p1
             where type = 'printer'),
     pcm as (select p1.maker, p1.model
             from product p1
                      join spr on p1.maker = spr.maker
             where p1.type = 'pc')

select maker, avg(hd)
from pc
         join pcm on pc.model = pcm.model
group by maker;

