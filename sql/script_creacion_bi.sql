
USE [GD1C2025]
GO

------------------------------------------------------
-- Creacion de tablas: Dimensiones
------------------------------------------------------
CREATE TABLE MAUV.BI_Tiempo (
    id decimal(18,0) PRIMARY KEY IDENTITY(1,1),
    Anio decimal(18,0),
    Cuatrimestre decimal(18,0),
    Mes decimal(18,0)
)

CREATE TABLE MAUV.BI_Ubicacion (
    id DECIMAL(18,0) PRIMARY KEY IDENTITY(1,1),
    Provincia nvarchar(255),
    Localidad nvarchar(255)
)

CREATE TABLE MAUV.BI_Rango_Etario_Cliente (
    id DECIMAL(18,0) PRIMARY KEY IDENTITY(1,1),
    Rango nvarchar(255)
)

CREATE TABLE MAUV.BI_Turno_Ventas (
    id DECIMAL(18,0) PRIMARY KEY IDENTITY(1,1),
    Rango nvarchar(255)
)

CREATE TABLE MAUV.BI_Tipo_Material (
    id DECIMAL(18,0) PRIMARY KEY IDENTITY(1,1),
    Tipo nvarchar(255)
)

CREATE TABLE MAUV.BI_Modelo_Sillon (
    id DECIMAL(18,0) PRIMARY KEY IDENTITY(1,1),
    Modelo nvarchar(255)
)

CREATE TABLE MAUV.BI_Estado_Pedido (
    id DECIMAL(18,0) PRIMARY KEY IDENTITY(1,1),
    Estado nvarchar(255)
)

-- Creamos una tabla aparte por si debemos agregar mas campos en el futuro, solo relacionados con BI
-- De esta manera no contaminamos los datos de negocio con los de análisis.
CREATE TABLE MAUV.BI_Sucursal (
    Sucursal_Nro bigint PRIMARY KEY
)

GO


------------------------------------------------------
-- Creacion de tablas: Indicadores
------------------------------------------------------

CREATE TABLE MAUV.BI_Indicadores_Facturacion (
    Suma_Subtotal decimal(18,2),
    Cantidad_Facturas decimal(18,0),
    Sucursal_Nro bigint FOREIGN KEY REFERENCES MAUV.BI_Sucursal(Sucursal_Nro),
    Tiempo_id decimal(18,0) FOREIGN KEY REFERENCES MAUV.BI_Tiempo(id),
    Ubicacion_id decimal(18,0) FOREIGN KEY REFERENCES MAUV.BI_Ubicacion(id),
    PRIMARY KEY(Sucursal_Nro, Tiempo_id, Ubicacion_id)
)

CREATE TABLE MAUV.BI_Indicadores_Ventas_Modelo (
    Modelo nvarchar(255),
    Cantidad_Ventas decimal(18,0),
    Suma_Valor_Ventas decimal(18,2),
    Tiempo_id decimal(18,0) FOREIGN KEY REFERENCES MAUV.BI_Tiempo(id),
    Ubicacion_id decimal(18,0) FOREIGN KEY REFERENCES MAUV.BI_Ubicacion(id),
    Rango_Etario_id decimal(18,0) FOREIGN KEY REFERENCES MAUV.BI_Rango_Etario_Cliente(id),
    PRIMARY KEY(Tiempo_id, Ubicacion_id, Rango_Etario_id)
)

CREATE TABLE MAUV.BI_Indicadores_Pedidos (
    Cantidad decimal(18,0),
    Cantidad_Entregado decimal(18,0),
    Cantidad_Cancelado decimal(18,0),
    Cantidad_Pendiente decimal(18,0),
    Suma_Tiempo_Registro_Factura decimal(18,0),
    Sucursal_Nro decimal(18,0) FOREIGN KEY REFERENCES MAUV.BI_Sucursal(id),
    Tiempo_id decimal(18,0) FOREIGN KEY REFERENCES MAUV.BI_Tiempo(id),
    Turno_Ventas decimal(18,0) FOREIGN KEY REFERENCES MAUV.Turno_Ventas(id),
    PRIMARY KEY(Sucursal_Nro, Tiempo_id, Turno_Ventas)
)

CREATE TABLE MAUV.BI_Indicadores_Compras (
    Suma_Subtotal decimal(18,2),
    Cantidad_Compras decimal(18,0),
    Sucursal_Nro bigint FOREIGN KEY REFERENCES MAUV.BI_Sucursal(Sucursal_Nro),
    Tiempo_id decimal(18,0) FOREIGN KEY REFERENCES MAUV.BI_Tiempo(id),
    Ubicacion_id decimal(18,0) FOREIGN KEY REFERENCES MAUV.BI_Ubicacion(id),
    Tipo_Material_id decimal(18,0) FOREIGN KEY REFERENCES MAUV.BI_Tipo_Material(id),
    PRIMARY KEY(Sucursal_Nro, Tiempo_id, Ubicacion_id, Tipo_Material_id)
)

CREATE TABLE MAUV.BI_Indicadores_Envios (
    Cantidad decimal(18,0)
    Cantidad_En_Tiempo decimal(18,0),
    Suma_Costo_Total decimal(18,2),
    Tiempo_id decimal(18,0) FOREIGN KEY REFERENCES MAUV.BI_Tiempo(id),
    Ubicacion_id decimal(18,0) FOREIGN KEY REFERENCES MAUV.BI_Ubicacion(id),
    PRIMARY KEY(Tiempo_id, Ubicacion_id)
)

GO
