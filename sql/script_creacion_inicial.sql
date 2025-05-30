USE [GD1C2025]
GO

CREATE SCHEMA MAUV
GO

-- 1. Creacion tablas: materiales, sillon

-- Materiales
CREATE TABLE MAUV.Material (
    Material_Nombre nvarchar(255) PRIMARY KEY NOT NULL,
    Material_Tipo nvarchar(255),
    Material_Descripcion nvarchar(255),
    Material_Precio decimal(38, 2)
)

CREATE TABLE MAUV.Tela (
    Tela_Nombre nvarchar(255) FOREIGN KEY REFERENCES MAUV.Material(Material_Nombre),
    Tela_Color nvarchar(255),
    Tela_Textura nvarchar(255)
)

CREATE TABLE MAUV.Madera (
    Madera_Nombre nvarchar(255) FOREIGN KEY REFERENCES MAUV.Material(Material_Nombre),
    Madera_Color nvarchar(255),
    Madera_Dureza nvarchar(255)
)

CREATE TABLE MAUV.Relleno (
    Relleno_Nombre nvarchar(255) FOREIGN KEY REFERENCES MAUV.Material(Material_Nombre) NOT NULL,
    Relleno_Densidad decimal(38, 2) NULL
)


-- Sillon
CREATE TABLE MAUV.Sillon_Medida (
    Sillon_Medida_Codigo bigint PRIMARY KEY NOT NULL,
    Sillon_Medida_Alto decimal(18, 2),
    Sillon_Medida_Ancho decimal(18, 2),
    Sillon_Medida_Profundidad decimal(18, 2),
    Sillon_Medida_Precio decimal(18, 2)
    
)

CREATE TABLE MAUV.Sillon_Modelo (
    Sillon_Modelo_Codigo bigint PRIMARY KEY NOT NULL,
    Sillon_Modelo nvarchar(255),
    Sillon_Modelo_Descripcion nvarchar(255),
    Sillon_Modelo_Precio decimal(18, 2)
)


CREATE TABLE MAUV.Sillon(
    Sillon_Codigo bigint PRIMARY KEY NOT NULL,
    Sillon_Modelo bigint FOREIGN KEY REFERENCES MAUV.Sillon_Modelo(Sillon_Modelo_Codigo),
    Sillon_Medida bigint FOREIGN KEY REFERENCES MAUV.Sillon_Medida(Sillon_Medida_Codigo)
)

CREATE TABLE MAUV.SillonXMaterial (
    Material nvarchar(255) FOREIGN KEY REFERENCES MAUV.Material(Material_Nombre),
    Sillon_Codigo bigint FOREIGN KEY REFERENCES MAUV.Sillon(Sillon_Codigo)
)

-- 2. Creacion Sucursal, Cliente, Proveedor, Compra, Pedido, Factura, Envio
CREATE TABLE MAUV.Sucursal (
    -- Sucursal_Nro bigint PRIMARY KEY IDENTITY(1,1) NOT NULL, --> Se cambia según tabla maestra que trae los valores de las sucursales
    Sucursal_NroSucursal bigint PRIMARY KEY NOT NULL,
    Sucursal_Provincia nvarchar(255),
    Sucursal_Localidad nvarchar(255),
    Sucursal_Direccion nvarchar(255),
    Sucursal_Telefono nvarchar(255),
    Sucursal_Mail nvarchar(255)
)

CREATE TABLE MAUV.Cliente (
    Cliente_Dni bigint NOT NULL PRIMARY KEY,
    Cliente_Provincia nvarchar(255),
    Cliente_Nombre nvarchar(255),
    Cliente_Apellido nvarchar(255),
    Cliente_Fecha_Nacimiento datetime2(6) NULL,
    Cliente_Mail nvarchar(255),
    Cliente_Direccion nvarchar(255),
    Cliente_Telefono nvarchar(255),
    Cliente_Localidad nvarchar(255) -- Se agrega esta linea que esta en la maestra
)

CREATE TABLE MAUV.Proveedor (
    Proveedor_Cuit nvarchar(255) PRIMARY KEY NOT NULL,
    Proveedor_Provincia nvarchar(255),
    Proveedor_Localidad nvarchar(255),
    Proveedor_RazonSocial nvarchar(255),
    Proveedor_Direccion nvarchar(255),
    Proveedor_Telefono nvarchar(255),
    Proveedor_Mail nvarchar(255)
)

CREATE TABLE MAUV.Compra (
    Compra_Numero decimal(18,0) PRIMARY KEY NOT NULL,
    Compra_Sucursal bigint FOREIGN KEY REFERENCES MAUV.Sucursal(Sucursal_Nro) NOT NULL,
    Compra_Proveedor nvarchar(255) FOREIGN KEY REFERENCES MAUV.Proveedor(Proveedor_Cuit) NOT NULL,
    Compra_Fecha datetime2(6),
    Compra_Total decimal(18,2)
)

CREATE TABLE MAUV.Pedido (
    Pedido_Numero decimal(18,0) PRIMARY KEY NOT NULL,
    Pedido_Fecha datetime2(6),
    Pedido_Estado nvarchar(255),
    Pedido_Total decimal(18,2),
    Pedido_Sucursal bigint FOREIGN KEY REFERENCES MAUV.Sucursal(Sucursal_Nro),
    Pedido_Cliente bigint FOREIGN KEY REFERENCES MAUV.Cliente(Cliente_Dni)
)

CREATE TABLE MAUV.Cancelacion_Pedido (
    Cancelacion_Pedido_Numero decimal(18,0) FOREIGN KEY REFERENCES MAUV.Pedido(Pedido_Numero) NOT NULL,
    Pedido_Cancelacion_Fecha datetime2(6),
    Pedido_Cancelacion_Motivo varchar(255)
)

CREATE TABLE MAUV.Factura (
    Factura_Numero bigint PRIMARY KEY NOT NULL,
    Factura_Fecha datetime2(6) NULL,
    Factura_Total decimal(38,2) NULL,
    Factura_Cliente bigint FOREIGN KEY REFERENCES MAUV.Cliente(Cliente_Dni) NOT NULL,
    Factura_Sucursal bigint FOREIGN KEY REFERENCES MAUV.Sucursal(Sucursal_Nro) NOT NULL
)

CREATE TABLE MAUV.Envio (
    Envio_Numero decimal(18, 0) PRIMARY KEY NOT NULL,
    Envio_Factura bigint FOREIGN KEY REFERENCES MAUV.Factura(Factura_Numero),
    Envio_Fecha_Programada datetime2(6),
    Envio_Fecha datetime2(6),
    Envio_ImporteTraslado decimal(18,2),
    Envio_ImporteSubida decimal(18,2),
    Envio_Total decimal(18,2)
)


-- 3. Creacion detalles Pedido, Factura, Compra
CREATE TABLE MAUV.Detalle_Pedido (
    Detalle_Pedido_Numero decimal(18,0) PRIMARY KEY NOT NULL,
    Detalle_Pedido_Sillon bigint FOREIGN KEY REFERENCES MAUV.Sillon(Sillon_Codigo) NOT NULL,
    Detalle_Pedido_Cantidad bigint,
    Detalle_Pedido_Precio decimal(18,2),
    Detalle_Pedido_Subtotal decimal(18,2)
    FOREIGN KEY (Detalle_Pedido_Numero) REFERENCES MAUV.Pedido(Pedido_Numero)
)

CREATE TABLE MAUV.Detalle_Factura (
    Detalle_Factura_Numero bigint FOREIGN KEY REFERENCES MAUV.Factura(Factura_Numero) NOT NULL,
    Detalle_Factura_DetPedido decimal(18,0) FOREIGN KEY REFERENCES MAUV.Detalle_Pedido(Detalle_Pedido_Numero) NOT NULL,
    Detalle_Factura_Precio decimal(18, 2),
    Detalle_Factura_Cantidad decimal(18,0),
    Detalle_Factura_Subtotal decimal(18, 2)
)

CREATE TABLE MAUV.Detalle_Compra (
    Detalle_Compra_Numero decimal(18,0) FOREIGN KEY REFERENCES MAUV.Compra(Compra_Numero) NOT NULL,
    Detalle_Compra_Material nvarchar(255) FOREIGN KEY REFERENCES MAUV.Material(Material_Nombre) NOT NULL,
    Detalle_Compra_Precio decimal(18,2) NULL,
    Detalle_Compra_Cantidad decimal(18,0) NULL,
    Detalle_Compra_SubTotal decimal(18,2) NULL
)

-- Insertamos los Materiales válidos en MAUV.<Nombre_Tabla>
INSERT INTO MAUV.Material (
    Material_Nombre,
    Material_Tipo, 
    Material_Descripcion,
    Material_Precio
)
-- Usamos DISTINCT para evitar duplicados
SELECT DISTINCT
    Material_Nombre,
    Material_Tipo, 
    Material_Descripcion,
    Material_Precio
FROM
    gd_esquema.Maestra
WHERE
    Material_Nombre IS NOT NULL;

-- Insertamos las telas válidos en MAUV.Tela>
INSERT INTO MAUV.Tela (
    Tela_Nombre,
    Tela_Color,    
    Tela_Textura
)
-- Usamos DISTINCT para evitar duplicados
SELECT DISTINCT
    Tela_Nombre,
    Tela_Color,    
    Tela_Textura
FROM
    gd_esquema.Maestra
WHERE
    Tela_Nombre IS NOT NULL;

-- Insertamos las maderas válidos en MAUV.Madera
INSERT INTO MAUV.Madera (
    Madera_Nombre,
    Madera_Color,
    Madera_Dureza
)
-- Usamos DISTINCT para evitar duplicados
SELECT DISTINCT
    Madera_Nombre,
    Madera_Color,
    Madera_Dureza
FROM
    gd_esquema.Maestra
WHERE
    -- Validamos que el campo que referencia a Material no sea NULL
    Madera_Nombre IS NOT NULL;

-- Insertamos los rellenos válidos en MAUV.<Nombre_Tabla>
INSERT INTO MAUV.Relleno (
    Relleno_Nombre,
    Relleno_Densidad
)

-- Usamos DISTINCT para evitar duplicados
SELECT DISTINCT
    Relleno_Nombre,
    Relleno_Densidad
FROM
    gd_esquema.Maestra
WHERE
    Relleno_Nombre IS NOT NULL;

-- SILLON
-- Insertamos los sillones válidos en MAUV.<Nombre_Tabla>
INSERT INTO MAUV.Sillon_Medida (
    Sillon_Medida_Codigo,
    Sillon_Medida_Alto,
    Sillon_Medida_Ancho,
    Sillon_Medida_Precio,
    Sillon_Medida_Profundidad
)
-- Usamos DISTINCT para evitar duplicados
SELECT DISTINCT
    Sillon_Medida_Codigo,
    Sillon_Medida_Alto,
    Sillon_Medida_Ancho,
    Sillon_Medida_Precio,
    Sillon_Medida_Profundidad
FROM
    gd_esquema.Maestra
WHERE
    Sillon_Medida_Codigo IS NOT NULL;

-- Insertamos los sillones modelos válidos en MAUV.<Nombre_Tabla>
INSERT INTO MAUV.Sillon_Modelo (
    Sillon_Modelo_Codigo,
    Sillon_Modelo,
    Sillon_Modelo_Descripcion,
    Sillon_Modelo_Precio
)
-- Usamos DISTINCT para evitar duplicados
SELECT DISTINCT
    Sillon_Modelo_Codigo,
    Sillon_Modelo,
    Sillon_Modelo_Descripcion,
    Sillon_Modelo_Precio
FROM
    gd_esquema.Maestra
WHERE
    Sillon_Modelo_Codigo IS NOT NULL;

-- Insertamos los sillones válidos en MAUV.<Nombre_Tabla>
INSERT INTO MAUV.Sillon (
    Sillon_Codigo,
    Sillon_Modelo,
    Sillon_Medida
)
-- Usamos DISTINCT para evitar duplicados
SELECT DISTINCT
    Sillon_Codigo,
    Sillon_Modelo,
    Sillon_Medida
FROM
    gd_esquema.Maestra
WHERE
    Sillon_Codigo IS NOT NULL;

-- Insertamos los sillones x material válidos en MAUV.<Nombre_Tabla>
INSERT INTO MAUV.SillonXMaterial (
    Material,
    Sillon_Codigo
)
-- Usamos DISTINCT para evitar duplicados
SELECT DISTINCT
    Material,
    Sillon_Codigo
FROM
    gd_esquema.Maestra
WHERE
    Material IS NOT NULL AND Sillon_Codigo IS NOT NULL;

-- Insertamos los sucursales válidas en MAUV.<Nombre_Tabla>
INSERT INTO MAUV.Sucursal (
    Sucursal_NroSucursal,
    Sucursal_Provincia,
    Sucursal_Localidad,
    Sucursal_Direccion,
    Sucursal_Telefono,
    Sucursal_Mail
)
-- Usamos DISTINCT para evitar duplicados
SELECT DISTINCT
    Sucursal_NroSucursal,
    Sucursal_Provincia,
    Sucursal_Localidad,
    Sucursal_Direccion,
    Sucursal_Telefono,
    Sucursal_Mail
FROM
    gd_esquema.Maestra
WHERE
    Sucursal_NroSucursal IS NOT NULL;

-- Insertamos los clientes validos en MAUV.Cliente
INSERT INTO MAUV.Cliente(
    Cliente_Dni,
    Cliente_Provincia,
    Cliente_Nombre,
    Cliente_Apellido,
    Cliente_Fecha_Nacimiento,
    Cliente_Mail,
    Cliente_Direccion,
    Cliente_Telefono,
    Cliente_Localidad
)
-- Usamos distinct para evitar duplicados
SELECT DISTINCT
    Cliente_Dni,
    Cliente_Provincia,
    Cliente_Nombre,
    Cliente_Apellido,
    Cliente_Fecha_Nacimiento,
    Cliente_Mail,
    Cliente_Direccion,
    Cliente_Telefono,
    Cliente_Localidad
FROM
    gd_esquema.Maestra
-- Cada INSERT verifica que el campo (primaria o foranea) no sea nulo
WHERE Cliente_Dni IS NOT NULL;

-- Insertamos los proveedores válidos en MAUV.<Nombre_Tabla>
INSERT INTO MAUV.Proveedor (
    Proveedor_Cuit,
    Proveedor_Provincia,
    Proveedor_Localidad,
    Proveedor_RazonSocial,
    Proveedor_Direccion,
    Proveedor_Telefono,
    Proveedor_Mail
)
-- Usamos DISTINCT para evitar duplicados
SELECT DISTINCT
    Proveedor_Cuit,
    Proveedor_Provincia,
    Proveedor_Localidad,
    Proveedor_RazonSocial,
    Proveedor_Direccion,
    Proveedor_Telefono,
    Proveedor_Mail
FROM
    gd_esquema.Maestra
WHERE
    Proveedor_Cuit IS NOT NULL;

-- Insertamos las compras válidos en MAUV.<Nombre_Tabla>
INSERT INTO MAUV.Compra (
    Compra_Numero,
    Compra_Sucursal,
    Compra_Proveedor,
    Compra_Fecha,
    Compra_Total
)
-- Usamos DISTINCT para evitar duplicados
SELECT DISTINCT
    Compra_Numero,
    Compra_Sucursal,
    Compra_Proveedor,
    Compra_Fecha,
    Compra_Total
FROM
    gd_esquema.Maestra
WHERE
    Compra_Numero IS NOT NULL;

-- Insertamos los pedidos válidos en MAUV.<Nombre_Tabla>
INSERT INTO MAUV.Pedido (
    Pedido_Numero,
    Pedido_Fecha,
    Pedido_Estado,
    Pedido_Total,
    Pedido_Sucursal,
    Pedido_Cliente
)
-- Usamos DISTINCT para evitar duplicados
SELECT DISTINCT
    Pedido_Numero,
    Pedido_Fecha,
    Pedido_Estado,
    Pedido_Total,
    Pedido_Sucursal,
    Pedido_Cliente
FROM
    gd_esquema.Maestra
WHERE
    Pedido_Numero IS NOT NULL AND Pedido_Sucursal IS NOT NULL AND Pedido_Cliente IS NOT NULL;  

-- Insertamos las cancelaciones de pedidos válidos en MAUV.<Nombre_Tabla>
INSERT INTO MAUV.Cancelacion_Pedido (
    Cancelacion_Pedido_Numero,
    Pedido_Cancelacion_Fecha,
    Pedido_Cancelacion_Motivo
)
-- Usamos DISTINCT para evitar duplicados
SELECT DISTINCT
    Cancelacion_Pedido_Numero,
    Pedido_Cancelacion_Fecha,
    Pedido_Cancelacion_Motivo
FROM
    gd_esquema.Maestra
WHERE
    Cancelacion_Pedido_Numero IS NOT NULL;

-- Insertamos las facturas válidos en MAUV.<Nombre_Tabla>
INSERT INTO MAUV.Factura (
    Factura_Numero,
    Factura_Fecha,
    Factura_Total,
    Factura_Cliente,
    Factura_Sucursal
)
-- Usamos DISTINCT para evitar duplicados
SELECT DISTINCT
    Factura_Numero,
    Factura_Fecha,
    Factura_Total,
    Factura_Cliente,
    Factura_Sucursal
FROM
    gd_esquema.Maestra
WHERE
    Factura_Numero IS NOT NULL AND Factura_Cliente IS NOT NULL AND Factura_Sucursal IS NOT NULL;

-- Insertamos los envios válidos en MAUV.<Nombre_Tabla>
INSERT INTO MAUV.Envio (
    Envio_Numero,
    Envio_Factura,
    Envio_Fecha_Programada,
    Envio_Fecha,
    Envio_ImporteTraslado,
    Envio_ImporteSubida,
    Envio_Total
)
-- Usamos DISTINCT para evitar duplicados
SELECT DISTINCT
    Envio_Numero,
    Envio_Factura,
    Envio_Fecha_Programada,
    Envio_Fecha,
    Envio_ImporteTraslado,
    Envio_ImporteSubida,
    Envio_Total
FROM
    gd_esquema.Maestra
WHERE
    Envio_Numero IS NOT NULL AND Envio_Factura IS NOT NULL;

-- Insertamos los detalles de pedidos válidos en MAUV.<Nombre_Tabla>
INSERT INTO MAUV.Detalle_Pedido (
    Detalle_Pedido_Numero,
    Detalle_Pedido_Sillon,
    Detalle_Pedido_Cantidad,
    Detalle_Pedido_Precio,
    Detalle_Pedido_Subtotal
)
-- Usamos DISTINCT para evitar duplicados
SELECT DISTINCT
    Detalle_Pedido_Numero,
    Detalle_Pedido_Sillon,
    Detalle_Pedido_Cantidad,
    Detalle_Pedido_Precio,
    Detalle_Pedido_Subtotal
FROM
    gd_esquema.Maestra
WHERE
    Detalle_Pedido_Numero IS NOT NULL AND Detalle_Pedido_Sillon IS NOT NULL AND Detalle_Pedido_Subtotal IS NOT NULL;

-- Insertamos los detalles de factuars válidos en MAUV.<Nombre_Tabla>
INSERT INTO MAUV.Detalle_Factura (
    Detalle_Factura_Numero,
    Detalle_Factura_DetPedido,
    Detalle_Factura_Precio,
    Detalle_Factura_Cantidad,
    Detalle_Factura_Subtotal
)

-- Usamos DISTINCT para evitar duplicados
SELECT DISTINCT
    Detalle_Factura_Numero,
    Detalle_Factura_DetPedido,
    Detalle_Factura_Precio,
    Detalle_Factura_Cantidad,
    Detalle_Factura_Subtotal
FROM
    gd_esquema.Maestra
WHERE
    Detalle_Factura_Numero IS NOT NULL AND Detalle_Factura_DetPedido IS NOT NULL;

-- Insertamos los detalles de compras válidos en MAUV.<Nombre_Tabla>
INSERT INTO MAUV.Detalle_Compra (
    Detalle_Compra_Numero,
    Detalle_Compra_Material,
    Detalle_Compra_Precio,
    Detalle_Compra_Cantidad,
    Detalle_Compra_SubTotal
)
-- Usamos DISTINCT para evitar duplicados
SELECT DISTINCT
    Detalle_Compra_Numero,
    Detalle_Compra_Material,
    Detalle_Compra_Precio,
    Detalle_Compra_Cantidad,
    Detalle_Compra_SubTotal
FROM
    gd_esquema.Maestra
WHERE
    Detalle_Compra_Numero IS NOT NULL AND Detalle_Compra_Material IS NOT NULL;

PRINT '---------------------------------------------------------------';
PRINT 'Resumen: registros NO insertables por tener PK en NULL en Maestra';
PRINT '---------------------------------------------------------------';

SELECT COUNT(*) AS [Clientes_sin_DNI] FROM gd_esquema.Maestra WHERE Cliente_Dni IS NULL;
SELECT COUNT(*) AS [Proveedores_sin_CUIT] FROM gd_esquema.Maestra WHERE Proveedor_Cuit IS NULL;
SELECT COUNT(*) AS [Sucursales_sin_NroSucursal] FROM gd_esquema.Maestra WHERE Sucursal_NroSucursal IS NULL;
SELECT COUNT(*) AS [Materiales_sin_Nombre] FROM gd_esquema.Maestra WHERE Material_Nombre IS NULL;
SELECT COUNT(*) AS [Sillon_Modelo_sin_Codigo] FROM gd_esquema.Maestra WHERE Sillon_Modelo_Codigo IS NULL;
SELECT COUNT(*) AS [Sillon_Medida_sin_Codigo] FROM gd_esquema.Maestra WHERE Sillon_Codigo IS NULL;
SELECT COUNT(*) AS [Sillones_sin_Codigo] FROM gd_esquema.Maestra WHERE Sillon_Codigo IS NULL;
SELECT COUNT(*) AS [Pedidos_sin_Numero] FROM gd_esquema.Maestra WHERE Pedido_Numero IS NULL;
SELECT COUNT(*) AS [Facturas_sin_Numero] FROM gd_esquema.Maestra WHERE Factura_Numero IS NULL;
SELECT COUNT(*) AS [Envios_sin_Numero] FROM gd_esquema.Maestra WHERE Envio_Numero IS NULL;
SELECT COUNT(*) AS [Compras_sin_Numero] FROM gd_esquema.Maestra WHERE Compra_Numero IS NULL;
SELECT COUNT(*) AS [Detalle_Compra_sin_Numero] FROM gd_esquema.Maestra WHERE Compra_Numero IS NULL;
SELECT COUNT(*) AS [Detalle_Pedido_sin_Numero] FROM gd_esquema.Maestra WHERE Pedido_Numero IS NULL;
SELECT COUNT(*) AS [Detalle_Factura_sin_Numero] FROM gd_esquema.Maestra WHERE Factura_Numero IS NULL;

PRINT '---------------------------------------------------------------';
PRINT 'Resumen final: cantidad de registros insertados en cada tabla MAUV';
PRINT '---------------------------------------------------------------';

SELECT COUNT(*) AS [Clientes] FROM MAUV.Cliente;
SELECT COUNT(*) AS [Proveedores] FROM MAUV.Proveedor;
SELECT COUNT(*) AS [Sucursales] FROM MAUV.Sucursal;
SELECT COUNT(*) AS [Materiales] FROM MAUV.Material;
SELECT COUNT(*) AS [Telas] FROM MAUV.Tela;
SELECT COUNT(*) AS [Maderas] FROM MAUV.Madera;
SELECT COUNT(*) AS [Rellenos] FROM MAUV.Relleno;
SELECT COUNT(*) AS [Sillones] FROM MAUV.Sillon;
SELECT COUNT(*) AS [Sillon_Modelo] FROM MAUV.Sillon_Modelo;
SELECT COUNT(*) AS [Sillon_Medida] FROM MAUV.Sillon_Medida;
SELECT COUNT(*) AS [SillonXMaterial] FROM MAUV.SillonXMaterial;
SELECT COUNT(*) AS [Compras] FROM MAUV.Compra;
SELECT COUNT(*) AS [Pedidos] FROM MAUV.Pedido;
SELECT COUNT(*) AS [Cancelaciones_Pedido] FROM MAUV.Cancelacion_Pedido;
SELECT COUNT(*) AS [Facturas] FROM MAUV.Factura;
SELECT COUNT(*) AS [Envios] FROM MAUV.Envio;
SELECT COUNT(*) AS [Detalle_Compra] FROM MAUV.Detalle_Compra;
SELECT COUNT(*) AS [Detalle_Pedido] FROM MAUV.Detalle_Pedido;
SELECT COUNT(*) AS [Detalle_Factura] FROM MAUV.Detalle_Factura;

