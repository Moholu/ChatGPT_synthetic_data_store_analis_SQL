--Creacion de VISTAS
-- Crea la vista para analisis de promociones
CREATE VIEW vista_promociones AS 
SELECT fv.id_venta, 
       fv.fecha,
	   fv.monto_total,
	   prom.nombre AS promo,
	   prom.descuento,
	   prom.fecha_inicio AS inicio_promo,
	   prom.fecha_fin AS fin_promo,
	   prom.medio,
	   cl.nombre AS cliente,
	   cl.ubicacion,
	   cl.genero,
	   cl.edad,
	   pr.nombre AS producto,
	   cp.nombre AS categoria_producto,
	   pr.precio_de_venta
FROM FACT_VENTAS fv, 
	 CLIENTES cl, 
	 TIENDA td,
	 PRODUCTO pr,
	 CATEGORIA_PRODUCTO cp,
	 PROMOCION prom
WHERE fv.id_cliente = cl.id_cliente
AND   fv.id_tienda = td.id_tienda
AND   fv.id_producto = pr.id_producto
AND   pr.id_categoria_producto=cp.id_categoria_producto
AND   fv.id_promocion = prom.id_promocion;


--Crea vista para analisis de ventas
CREATE VIEW ventas AS 
SELECT fv.id_venta, 
       fv.fecha,
	   fv.monto_total,
	   fv.metodo_de_pago,
	   cl.nombre AS cliente,
	   cl.ubicacion,
	   cl.genero,
	   cl.edad,
	   pr.nombre AS producto,
	   pr.precio_de_venta,
	   td.nombre AS nombre_tienda,
	   td.ubicacion AS ubicacion_tienda,
	   cv.nombre AS canal_venta
FROM FACT_VENTAS fv, 
	 CLIENTES cl, 
	 TIENDA td,
	 PRODUCTO pr,
	 CANAL_VENTAS cv 
WHERE fv.id_cliente = cl.id_cliente
AND   fv.id_tienda = td.id_tienda
AND   fv.id_producto = pr.id_producto
AND   td.id_canal_ventas = cv.id_canal_ventas;

--crea vista para analisis del inventario
CREATE VIEW vista_inventario AS
 SELECT fv.id_venta,
    fv.fecha,
    td.nombre AS tienda,
    pr.id_producto,
    pr.nombre AS producto,
    cp.nombre AS categoria_producto,
	prov.nombre AS proveedor,
    fi.fecha_actualizacion AS fecha_ultimo_conteo,
    fi.stock_sistema,
    fi.stock_fisico,
    fi.estado_producto,
    pr.precio_de_venta,
    pr.costo_de_adquisicion
   FROM fact_inventario fi,
    fact_ventas fv,
    tienda td,
    producto pr,
    categoria_producto cp,
	proveedores prov
  WHERE fi.id_inventario = fv.id_producto 
  AND fi.id_tienda = td.id_tienda 
  AND fi.id_producto = pr.id_producto 
  AND pr.id_categoria_producto = cp.id_categoria_producto
  AND pr.id_proveedor = prov.id_proveedor;