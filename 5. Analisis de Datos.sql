/*La compañia fue fundada en el mes de enero de 2023, iniciando operaciones en esa fecha*/

-- Que producto se vende mas?
SELECT PRODUCTO,
COUNT(*) AS cantidad FROM ventas
GROUP BY producto
ORDER BY COUNT(*) DESC;
/*El producto que mas se vende es 'Edicion Limitada' con 12 unidades vendidas en total desde el inicio de operaciones */

-- Que tipo de clientes les vendemos?
SELECT ubicacion,
COUNT(*) AS cantidad FROM ventas
GROUP BY ubicacion
ORDER BY COUNT(*) DESC;
/*Los clientes que mas compran por ubicacion son los de Monterrey */

SELECT genero,
COUNT(*) AS cantidad FROM ventas
GROUP BY genero
ORDER BY COUNT(*) DESC;
/*Los clientes que mas compran son del genero masculino */

SELECT edad,
COUNT(*) AS cantidad FROM ventas
GROUP BY edad
ORDER BY COUNT(*) DESC;
/*Los clientes que mas compran son de 35 años de edad */

--Resumen de ventas por canal de venta, se observa que las tiendas fisicas tiene la mayoria de ventas
SELECT canal_venta,
       SUM(monto_total) AS suma_total
FROM ventas
GROUP BY canal_venta
ORDER BY suma_total DESC;

--Resumen de ventas por ubicacion y nombre de tienda:
SELECT ubicacion_tienda,
       nombre_tienda,
       SUM(monto_total) AS suma_total
FROM ventas
GROUP BY ubicacion_tienda, nombre_tienda
ORDER BY suma_total DESC;


-- TENDENCIAS Y PATRONES DE COMPRA

-- Tendencia: Que tipo de producto se vende mas?
SELECT vi.categoria_producto,
COUNT (v.*) 
FROM VENTAS V
JOIN vista_inventario vi ON v.id_venta=vi.id_venta
group by vi.categoria_producto
ORDER BY COUNT(v.*) DESC;
/*Los productos que mas se han vendido son los de categoria tecnologia en la historia de la compañia*/

-- Patron: En que mes se vendio mas de la categoria Tecnologia?
SELECT vi.categoria_producto,EXTRACT(MONTH FROM v.fecha) AS mes,
COUNT (v.*) 
FROM VENTAS V
JOIN vista_inventario vi ON v.id_venta=vi.id_venta
WHERE vi.categoria_producto='Tecnologia'
group by vi.categoria_producto, mes
ORDER BY COUNT(v.*) DESC;
/*El mes en el que mas se venden productos de tecnologia es el mes de Junio (mes 6)*/

-- Patron: Mes que mas se ha vendido en todas las categorias
SELECT EXTRACT(MONTH FROM fecha) AS mes,
COUNT (*) 
FROM VENTAS
group by mes
ORDER BY COUNT(*) DESC;
/*Nuestro negocio no muestra un patron de ventas estacionales ni de temporada al considerar todos los productos*/

-- CAMPAÑAS PROMOCIONALES

-- Impacto bruto y global de las campañas sobre el total de ventas.
SELECT SUM(v.monto_total)-SUM(pro.monto_total) AS venta_sin_promo, 
	   SUM(pro.monto_total) AS ventas_promo
FROM ventas v
LEFT JOIN vista_promociones pro ON v.id_venta=pro.id_venta;

-- que promociones han tenido mayor impacto?
SELECT promo, SUM(monto_total) AS venta_total
FROM vista_promociones
GROUP BY promo
ORDER BY venta_total DESC;
/*Venta total por promocion*/

--Suma de ventas por promocion, fechas de promocion y medio
SELECT promo AS nombre_promocion, 
	   inicio_promo, fin_promo, 
	   medio, 
	   SUM(monto_total) AS suma_monto_total
FROM vista_promociones
GROUP BY promo, inicio_promo, fin_promo, medio
ORDER BY suma_monto_total DESC;

--INVENTARIOS
--Estado del inventario por categoria de producto para el total del inventario en stock
SELECT categoria_producto, 
       estado_producto, 
	   SUM(stock_sistema) AS total_stock_sistema, 
	   SUM(stock_fisico) AS total_stock_fisico, 
	   SUM(costo_de_adquisicion) AS costo_total, 
	   SUM (precio_de_venta) AS precio_total
FROM vista_inventario
GROUP BY categoria_producto, estado_producto
ORDER BY categoria_producto DESC;

--Costo total de los productos en el inventarios por categoria:
SELECT categoria_producto,
      SUM(costo_de_adquisicion) AS costo_total
FROM vista_inventario
GROUP BY categoria_producto
ORDER BY SUM(costo_de_adquisicion) DESC;

--Costo total de los productos en los inventarios por nombre de proveedor y categoria de producto:
SELECT proveedor,
      categoria_producto,
      SUM(costo_de_adquisicion) AS costo_total
FROM vista_inventario
GROUP BY proveedor, categoria_producto
ORDER BY SUM(costo_de_adquisicion) DESC;