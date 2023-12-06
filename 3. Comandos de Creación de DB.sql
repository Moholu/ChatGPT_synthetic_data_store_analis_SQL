--Creacion de ENTIDADES

CREATE TABLE empleados (ID_empleados int PRIMARY KEY,
nombre VARCHAR (45), cargo VARCHAR (20), departamento VARCHAR (30)
);

CREATE TABLE clientes (ID_cliente int PRIMARY KEY,
nombre VARCHAR (45), ubicacion VARCHAR (200), genero VARCHAR (10), edad INT 
);

CREATE TABLE promocion (ID_promocion int PRIMARY KEY,
nombre VARCHAR (45), fecha_inicio DATE, fecha_fin DATE, descuento DECIMAL (1,2), medio VARCHAR (20)
);

CREATE TABLE canal_ventas (ID_canal_ventas int PRIMARY KEY,
nombre VARCHAR (45), descripcion VARCHAR (50)
);

CREATE TABLE tienda (ID_tienda int PRIMARY KEY,
nombre VARCHAR (45), ubicacion VARCHAR (50), ID_canal_ventas int, FOREIGN KEY (ID_canal_ventas) references canal_ventas (ID_canal_ventas)
);

CREATE TABLE categoria_producto (ID_categoria_producto int PRIMARY KEY,
nombre VARCHAR (45), descripcion VARCHAR (50)
);

CREATE TABLE proveedores (ID_proveedor int PRIMARY KEY,
nombre VARCHAR (45), telefono VARCHAR (50), ubicacion VARCHAR (50)
);

CREATE TABLE producto (ID_producto int PRIMARY KEY,
nombre VARCHAR (45), descripcion VARCHAR (50), marca VARCHAR (15), costo_de_adquisicion DECIMAL (6,2),
 			 precio_de_venta DECIMAL (7,2), ID_categoria_producto int, FOREIGN KEY (ID_categoria_producto) references categoria_producto(ID_categoria_producto),
					  ID_proveedor int, FOREIGN KEY (ID_proveedor) references proveedores (ID_proveedor)
);

--Creacion de TABLAS DE HECHOS

CREATE TABLE fact_ventas (ID_venta int PRIMARY KEY,
						  fecha DATE, 
						  hora TIME,
						  monto_total DECIMAL (9,2),
						  metodo_de_pago VARCHAR (15),
						  ID_producto int, FOREIGN KEY (ID_producto) references producto (ID_producto), 
						  ID_empleados int, FOREIGN KEY (ID_empleados) references empleados (ID_empleados),
						  ID_cliente int, FOREIGN KEY (ID_cliente) references clientes (ID_cliente),
						  ID_promocion int, FOREIGN KEY (ID_promocion) references promocion (ID_promocion),
						  ID_tienda int, FOREIGN KEY (ID_tienda) references tienda (ID_tienda)
);	
CREATE TABLE fact_inventario (ID_inventario int PRIMARY KEY,
							  fecha_actualizacion DATE,
							  stock_sistema int,
							  stock_fisico int,
							  estado_producto VARCHAR (10),
							  ID_producto int, FOREIGN KEY (ID_producto) references producto (ID_producto), 
						      ID_empleados int, FOREIGN KEY (ID_empleados) references empleados (ID_empleados),
						      ID_tienda int, FOREIGN KEY (ID_tienda) references tienda (ID_tienda)
);	

--Modificaciones para la carga de datos
						 
ALTER TABLE promocion
ALTER COLUMN descuento TYPE numeric (3,2);

ALTER TABLE empleados
ALTER COLUMN departamento TYPE VARCHAR (40);

ALTER TABLE categoria_producto
ALTER COLUMN descripcion TYPE TEXT;		

ALTER TABLE fact_ventas
ALTER COLUMN metodo_de_pago TYPE VARCHAR(50);

ALTER TABLE fact_inventario
ALTER COLUMN estado_producto TYPE VARCHAR(15);

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