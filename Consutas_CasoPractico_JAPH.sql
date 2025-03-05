/*
b) Explorar la tabla “menu_items” para conocer los productos del menú.
- Realizar consultas para contestar las siguientes preguntas:
● Encontrar el número de artículos en el menú.
● ¿Cuál es el artículo menos caro y el más caro en el menú?
● ¿Cuántos platos americanos hay en el menú?
● ¿Cuál es el precio promedio de los platos? */

select * from menu_items;
select count (menu_item_id) from menu_items;
--R= hay 32 artíulos en el menú 

select min(price) from menu_items;
--R= el artículo menos caro tiene un valor de 5 dolares 

select max(price) from menu_items;
--R= el artículo más caro tiene un valor de 19.95 dolares

select category, count(*) as total
from menu_items
where category= 'American'
group by category;
--R= 6 platillos del menú son americanos

select round(avg(price),2) as promedio_precio
from menu_items;
--R= el precio promedio de los platillos es de 13.29 dolares

--
/*
c) Explorar la tabla “order_details” para conocer los datos que han sido recolectados.
- Realizar consultas para contestar las siguientes preguntas:
● ¿Cuántos pedidos únicos se realizaron en total?
● ¿Cuáles son los 5 pedidos que tuvieron el mayor número de artículos?
● ¿Cuándo se realizó el primer pedido y el último pedido?
● ¿Cuántos pedidos se hicieron entre el '2023-01-01' y el '2023-01-05'?*/

select * from order_details;

select count (distinct order_id) as pedidos_unicos
from order_details;
--R= el total de pedidos únicos es de 5370

SELECT order_id, count(*) as total_items
FROM order_details
group by order_id
order by total_items desc
limit 5; 
/*R= 
440	14
2675	14
3473	14
4305	14
443	    14*/

select 
min(concat(order_date,' ', order_time)) as min_time,
max(concat(order_date,' ', order_time)) as max_time
from order_details; 
--R= la fecha de la primera y última compra son 
-- "2023-01-01 11:38:36"	"2023-03-31 22:15:48" respectivamente 

select count(*) from order_details 
where order_date between '2023-01-01' and '2023-01-05'; 
--R= 702 pedidos se hicieron en ese periodo de tiempo


--
/*
d) Usar ambas tablas para conocer la reacción de los clientes respecto al menú.
Realizar un left join entre entre order_details y menu_items con el identificador
item_id(tabla order_details) y menu_item_id(tabla menu_items).*/

select o.item_id, m.item_name, m.category, count (o.item_id) as total_pedidos
from order_details as o
left join menu_items as m
on m.menu_item_id = o.item_id
group by o.item_id, m.item_name, m.category
order by total_pedidos desc;
/*
"item_name"	"category"	"total_pedidos"
"Hamburger"	"American"	622
"Edamame"	"Asian"	620
"Korean Beef Bowl"	"Asian"	588
"Cheeseburger"	"American"	583
"French Fries"	"American"	571
-
"item_name"	"category"	"total_pedidos"
"Cheese Quesadillas"	"Mexican"	233
"Steak Tacos"	"Mexican"	214
"Cheese Lasagna"	"Italian"	207
"Potstickers"	"Asian"	205
"Chicken Tacos"	"Mexican"	123*/

select o.item_id, m.item_name, m.category, count (o.item_id) as total_pedidos
from order_details as o
left join menu_items as m
on m.menu_item_id = o.item_id
group by o.item_id, m.item_name, m.category
order by m.category, total_pedidos desc;
/*R= 
*/


/*Una vez que hayas explorado los datos en las tablas correspondientes y respondido las
preguntas planteadas, realiza un análisis adicional utilizando este join entre las tablas. El
objetivo es identificar 5 puntos clave que puedan ser de utilidad para los dueños del
restaurante en el lanzamiento de su nuevo menú.*/

SELECT SUM(m.price * 1) AS totaldeingresos
FROM order_details AS o
LEFT JOIN menu_items AS m
ON m.menu_item_id = o.item_id; -- total de ingresos generados por todo 


select o.item_id, m.item_name, m.category, m.price, 
	count (o.item_id) as total_pedidos,
	(m.price * count(o.item_id)) as ingresos_totales
from order_details as o
left join menu_items as m
on m.menu_item_id = o.item_id
group by o.item_id, m.item_name, m.category, m.price
order by total_pedidos desc
limit 5;  -- consulta para saber los 5 productos más vendidos 

select o.item_id, m.item_name, m.category, m.price, 
	count (o.item_id) as total_pedidos,
	(m.price * count(o.item_id)) as ingresos_totales
from order_details as o
left join menu_items as m
on m.menu_item_id = o.item_id
group by o.item_id, m.item_name, m.category, m.price
order by total_pedidos 
limit 5;  -- consulta para saber los 5 productos menos vendidos

select o.item_id, m.item_name, m.category, m.price, 
	count (o.item_id) as total_pedidos,
	(m.price * count(o.item_id)) as ingresos_totales
from order_details as o
left join menu_items as m
on m.menu_item_id = o.item_id
group by o.item_id, m.item_name, m.category, m.price
order by ingresos_totales desc
limit 6;  -- consulta para saber los 5 productos que generan más ingresos

select o.item_id, m.item_name, m.category, m.price, 
	count (o.item_id) as total_pedidos,
	(m.price * count(o.item_id)) as ingresos_totales
from order_details as o
left join menu_items as m
on m.menu_item_id = o.item_id
group by o.item_id, m.item_name, m.category, m.price
order by ingresos_totales
limit 5;  -- consulta para saber los 5 productos que generan menos ingresos

select o.item_id, m.item_name, m.category, m.price, 
	count (o.item_id) as total_pedidos,
	(m.price * count(o.item_id)) as ingresos_totales
from order_details as o
left join menu_items as m
on m.menu_item_id = o.item_id
group by o.item_id, m.item_name, m.category, m.price
having (count(o.item_id)) > 500
	and (m.price * count(o.item_id)) > 1000
order by ingresos_totales desc
limit 5; -- consulta para obtener los productos más vendidos y con mayores ingresos

select m.category, 
count (o.item_id) as total_pedidos, sum(m.price) as ingresos_categoria
from order_details as o
left join menu_items as m
on m.menu_item_id = o.item_id
group by m.category
order by ingresos_categoria desc; -- consulta para saber los ingresos por categoria 



