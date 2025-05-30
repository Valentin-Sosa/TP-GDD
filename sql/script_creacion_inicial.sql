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
    Sucursal_Nro bigint PRIMARY KEY IDENTITY(1,1) NOT NULL,
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
    Cliente_Telefono nvarchar(255)
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
    Compra_Total decimal(18,0)
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
