USE [GD1C2025]
GO

CREATE SCHEMA MAUV
GO

------------------------------------------------------
-- Creacion de tablas + constraints
------------------------------------------------------

CREATE or ALTER PROCEDURE MAUV.crear_tablas AS
BEGIN
    -- 1. Creacion tablas: materiales, sillon

    -- Materiales
    CREATE TABLE MAUV.Material (
        Material_Nombre nvarchar(255) PRIMARY KEY NOT NULL,
        Material_Tipo nvarchar(255) NOT NULL,
        Material_Descripcion nvarchar(255) NOT NULL,
        Material_Precio decimal(38, 2) NOT NULL
    )

    CREATE TABLE MAUV.Tela (
        Tela_Nombre nvarchar(255) FOREIGN KEY REFERENCES MAUV.Material(Material_Nombre) NOT NULL,
        Tela_Color nvarchar(255) NOT NULL,
        Tela_Textura nvarchar(255) NOT NULL
    )

    CREATE TABLE MAUV.Madera (
        Madera_Nombre nvarchar(255) FOREIGN KEY REFERENCES MAUV.Material(Material_Nombre) NOT NULL,
        Madera_Color nvarchar(255) NOT NULL,
        Madera_Dureza nvarchar(255) NOT NULL
    )

    CREATE TABLE MAUV.Relleno (
        Relleno_Nombre nvarchar(255) FOREIGN KEY REFERENCES MAUV.Material(Material_Nombre) NOT NULL,
        Relleno_Densidad decimal(38, 2) NOT NULL
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
        Cliente_Localidad nvarchar(255)
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
        Compra_Sucursal bigint FOREIGN KEY REFERENCES MAUV.Sucursal(Sucursal_NroSucursal) NOT NULL,
        Compra_Proveedor nvarchar(255) FOREIGN KEY REFERENCES MAUV.Proveedor(Proveedor_Cuit) NOT NULL,
        Compra_Fecha datetime2(6),
        Compra_Total decimal(18,2)
    )

    CREATE TABLE MAUV.Pedido (
        Pedido_Numero decimal(18,0) PRIMARY KEY NOT NULL,
        Pedido_Fecha datetime2(6),
        Pedido_Estado nvarchar(255),
        Pedido_Total decimal(18,2),
        Pedido_Sucursal bigint FOREIGN KEY REFERENCES MAUV.Sucursal(Sucursal_NroSucursal),
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
        Factura_Sucursal bigint FOREIGN KEY REFERENCES MAUV.Sucursal(Sucursal_NroSucursal) NOT NULL
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
        Detalle_Pedido_Codigo bigint PRIMARY KEY NOT NULL,
        Detalle_Pedido_Numero decimal(18,0) FOREIGN KEY REFERENCES MAUV.Pedido(Pedido_Numero) NOT NULL,
        Detalle_Pedido_Sillon bigint FOREIGN KEY REFERENCES MAUV.Sillon(Sillon_Codigo) NOT NULL,
        Detalle_Pedido_Cantidad bigint,
        Detalle_Pedido_Precio decimal(18,2),
        Detalle_Pedido_Subtotal decimal(18,2)
    )

    CREATE TABLE MAUV.Detalle_Factura (
        Detalle_Factura_Codigo bigint PRIMARY KEY IDENTITY(1,1) NOT NULL,
        Detalle_Factura_Numero bigint FOREIGN KEY REFERENCES MAUV.Factura(Factura_Numero) NOT NULL,
        Detalle_Factura_DetPedido bigint FOREIGN KEY REFERENCES MAUV.Detalle_Pedido(Detalle_Pedido_Codigo) NOT NULL,
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
END;
GO

------------------------------------------------------
-- Creacion de Triggers
------------------------------------------------------

-- TODO

------------------------------------------------------
-- Migracion de datos desde maestra
------------------------------------------------------

CREATE or ALTER PROCEDURE MAUV.migrar_materiales AS
BEGIN
    INSERT INTO MAUV.Material (
        Material_Nombre,
        Material_Tipo, 
        Material_Descripcion,
        Material_Precio
    )
    SELECT DISTINCT
        Material_Nombre,
        Material_Tipo, 
        Material_Descripcion,
        Material_Precio
    FROM
        gd_esquema.Maestra
    WHERE
        Material_Nombre IS NOT NULL;

    INSERT INTO MAUV.Tela (
        Tela_Nombre,
        Tela_Color,    
        Tela_Textura
    )
    SELECT DISTINCT
        Material_Nombre,
        Tela_Color,    
        Tela_Textura
    FROM
        gd_esquema.Maestra
    WHERE
        Material_Nombre IS NOT NULL AND Tela_Color IS NOT NULL AND Tela_Textura IS NOT NULL;

    INSERT INTO MAUV.Madera (
        Madera_Nombre,
        Madera_Color,
        Madera_Dureza
    )
    SELECT DISTINCT
        Material_Nombre,
        Madera_Color,
        Madera_Dureza
    FROM
        gd_esquema.Maestra
    WHERE
        Material_Nombre IS NOT NULL AND Madera_Color IS NOT NULL AND Madera_Dureza IS NOT NULL;

    INSERT INTO MAUV.Relleno (
        Relleno_Nombre,
        Relleno_Densidad
    )
    SELECT DISTINCT
        Material_Nombre,
        Relleno_Densidad
    FROM
        gd_esquema.Maestra
    WHERE
        Material_Nombre IS NOT NULL AND Relleno_Densidad IS NOT NULL;
END;
GO

CREATE or ALTER PROCEDURE MAUV.migrar_sillones AS
BEGIN
    -- Sillones

    -- Temporary table needed as we need to generate `medida_codigo` to connect it to sillon table
    -- This is because master table does not provide one
    CREATE TABLE MAUV.sillon_temporal (
        sillon_codigo bigint,
        modelo_codigo bigint,
        modelo nvarchar(255),
        modelo_descripcion nvarchar(255),
        modelo_precio decimal(18,2),
        medida_codigo bigint IDENTITY(1,1),
        medida_ancho decimal(18,2),
        medida_alto decimal(18,2),
        medida_profundidad decimal(18,2),
        medida_precio decimal(18,2),
    )

    INSERT INTO MAUV.sillon_temporal (
        sillon_codigo,
        modelo_codigo,
        modelo,
        modelo_descripcion,
        modelo_precio,
        medida_ancho,
        medida_alto,
        medida_profundidad,
        medida_precio
    ) 
    SELECT DISTINCT 
        Sillon_Codigo, 
        Sillon_Modelo_Codigo, 
        Sillon_Modelo, 
        Sillon_Modelo_Descripcion, 
        Sillon_Modelo_Precio, 
        Sillon_Medida_Alto, 
        Sillon_Medida_Ancho,
        Sillon_Medida_Profundidad,
        Sillon_Medida_Precio
    FROM gd_esquema.Maestra;
    
    INSERT INTO MAUV.Sillon_Medida (
        Sillon_Medida_Codigo,
        Sillon_Medida_Alto,
        Sillon_Medida_Ancho,
        Sillon_Medida_Precio,
        Sillon_Medida_Profundidad
    )
    SELECT
        medida_codigo,
        medida_alto,
        medida_ancho,
        medida_precio,
        medida_profundidad
    FROM
        MAUV.sillon_temporal
    WHERE
        medida_codigo IS NOT NULL AND medida_alto IS NOT NULL AND medida_ancho IS NOT NULL AND medida_profundidad IS NOT NULL;

    INSERT INTO MAUV.Sillon_Modelo (
        Sillon_Modelo_Codigo,
        Sillon_Modelo,
        Sillon_Modelo_Descripcion,
        Sillon_Modelo_Precio
    )
    SELECT DISTINCT
        modelo_codigo,
        modelo,
        modelo_descripcion,
        modelo_precio
    FROM
        MAUV.sillon_temporal
    WHERE
        modelo_codigo IS NOT NULL;

    INSERT INTO MAUV.Sillon (
        Sillon_Codigo,
        Sillon_Modelo,
        Sillon_Medida
    )
    SELECT
        sillon_codigo,
        modelo_codigo,   
        medida_codigo
    FROM
        MAUV.sillon_temporal
    WHERE
        sillon_codigo IS NOT NULL;

    INSERT INTO MAUV.SillonXMaterial (
        Material,
        Sillon_Codigo
    )
    SELECT DISTINCT
        Material_Nombre,
        Sillon_Codigo
    FROM
        gd_esquema.Maestra
    WHERE
        Material_Nombre IS NOT NULL AND Sillon_Codigo IS NOT NULL;

    DROP TABLE MAUV.sillon_temporal
END;
GO

CREATE or ALTER PROCEDURE MAUV.migrar_sucursales_clientes_proveedores AS
BEGIN
    INSERT INTO MAUV.Sucursal (
        Sucursal_NroSucursal,
        Sucursal_Provincia,
        Sucursal_Localidad,
        Sucursal_Direccion,
        Sucursal_Telefono,
        Sucursal_Mail
    )
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

    INSERT INTO MAUV.Cliente (
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
    SELECT DISTINCT
        Cliente_Dni,
        Cliente_Provincia,
        Cliente_Nombre,
        Cliente_Apellido,
        Cliente_FechaNacimiento,
        Cliente_Mail,
        Cliente_Direccion,
        Cliente_Telefono,
        Cliente_Localidad
    FROM
        gd_esquema.Maestra
    WHERE Cliente_Dni IS NOT NULL;

    INSERT INTO MAUV.Proveedor (
        Proveedor_Cuit,
        Proveedor_Provincia,
        Proveedor_Localidad,
        Proveedor_RazonSocial,
        Proveedor_Direccion,
        Proveedor_Telefono,
        Proveedor_Mail
    )
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
END;
GO


CREATE or ALTER PROCEDURE MAUV.migrar_compras AS
BEGIN
    INSERT INTO MAUV.Compra (
        Compra_Numero,
        Compra_Sucursal,
        Compra_Proveedor,
        Compra_Fecha,
        Compra_Total
    )
    SELECT DISTINCT
        Compra_Numero,
        Sucursal_NroSucursal,
        Proveedor_Cuit,
        Compra_Fecha,
        Compra_Total
    FROM
        gd_esquema.Maestra
    WHERE
        Compra_Numero IS NOT NULL AND Sucursal_NroSucursal IS NOT NULL;
END;
GO

CREATE or ALTER PROCEDURE MAUV.migrar_pedidos AS
BEGIN
    INSERT INTO MAUV.Pedido (
        Pedido_Numero,
        Pedido_Fecha,
        Pedido_Estado,
        Pedido_Total,
        Pedido_Sucursal,
        Pedido_Cliente
    )
    SELECT DISTINCT
        Pedido_Numero,
        Pedido_Fecha,
        Pedido_Estado,
        Pedido_Total,
        Sucursal_NroSucursal,
        Cliente_Dni
    FROM
        gd_esquema.Maestra
    WHERE
        Pedido_Numero IS NOT NULL AND Sucursal_NroSucursal IS NOT NULL AND Cliente_Dni IS NOT NULL;  

    INSERT INTO MAUV.Cancelacion_Pedido (
        Cancelacion_Pedido_Numero,
        Pedido_Cancelacion_Fecha,
        Pedido_Cancelacion_Motivo
    )
    SELECT DISTINCT
        Pedido_Numero,
        Pedido_Cancelacion_Fecha,
        Pedido_Cancelacion_Motivo
    FROM
        gd_esquema.Maestra
    WHERE
        Pedido_Numero IS NOT NULL AND Pedido_Cancelacion_Motivo IS NOT NULL AND Pedido_Cancelacion_Motivo IS NOT NULL;
END;
GO

CREATE or ALTER PROCEDURE MAUV.migrar_facturas_envios AS
BEGIN
    INSERT INTO MAUV.Factura (
        Factura_Numero,
        Factura_Fecha,
        Factura_Total,
        Factura_Cliente,
        Factura_Sucursal
    )
    SELECT DISTINCT
        Factura_Numero,
        Factura_Fecha,
        Factura_Total,
        Cliente_Dni,
        Sucursal_NroSucursal
    FROM
        gd_esquema.Maestra
    WHERE
        Factura_Numero IS NOT NULL AND Cliente_Dni IS NOT NULL AND Sucursal_NroSucursal IS NOT NULL;

    INSERT INTO MAUV.Envio (
        Envio_Numero,
        Envio_Factura,
        Envio_Fecha_Programada,
        Envio_Fecha,
        Envio_ImporteTraslado,
        Envio_ImporteSubida,
        Envio_Total
    )
    SELECT DISTINCT
        Envio_Numero,
        Factura_Numero,
        Envio_Fecha_Programada,
        Envio_Fecha,
        Envio_ImporteTraslado,
        Envio_ImporteSubida,
        Envio_Total
    FROM
        gd_esquema.Maestra
    WHERE
        Envio_Numero IS NOT NULL AND Factura_Numero IS NOT NULL;
END;
GO

CREATE or ALTER PROCEDURE MAUV.migrar_detalles AS
BEGIN
    -- As we have done with sillones
    -- here we need to create another temporary table to store the Detalle_Pedido pk
    -- and be able to pass it to Detalle_Factura
    CREATE TABLE MAUV.detalles_temp (
        detalle_pedido_codigo bigint IDENTITY(1,1),
        detalle_pedido_numero decimal(18,0),
        detalle_pedido_sillon bigint,
        detalle_pedido_cantidad bigint,
        detalle_pedido_precio decimal(18,2),
        detalle_pedido_subtotal decimal(18,2),
        detalle_factura_numero bigint,
        detalle_factura_precio decimal(18,2),
        detalle_factura_cantidad decimal(18,0),
        detalle_factura_subtotal decimal(18,2)
    )

    INSERT INTO MAUV.detalles_temp (
        detalle_pedido_numero,
        detalle_pedido_sillon,
        detalle_pedido_cantidad,
        detalle_pedido_precio,
        detalle_pedido_subtotal,
        detalle_factura_numero,
        detalle_factura_precio,
        detalle_factura_cantidad,
        detalle_factura_subtotal
    )
    SELECT DISTINCT
        Pedido_Numero,
        Sillon_Codigo,
        Detalle_Pedido_Cantidad,
        Detalle_Pedido_Precio,
        Detalle_Pedido_Subtotal,
        Factura_Numero,
        Detalle_Factura_Precio,
        Detalle_Factura_Cantidad,
        Detalle_Factura_Subtotal
    FROM
        gd_esquema.Maestra
    WHERE
        Pedido_Numero IS NOT NULL AND Sillon_Codigo IS NOT NULL;

    INSERT INTO MAUV.Detalle_Pedido (
        Detalle_Pedido_Codigo,
        Detalle_Pedido_Numero,
        Detalle_Pedido_Sillon,
        Detalle_Pedido_Cantidad,
        Detalle_Pedido_Precio,
        Detalle_Pedido_Subtotal
    )
    SELECT
        detalle_pedido_codigo,
        detalle_pedido_numero,
        detalle_pedido_sillon,
        detalle_pedido_cantidad,
        detalle_pedido_precio,
        detalle_pedido_subtotal
    FROM 
        MAUV.detalles_temp

    INSERT INTO MAUV.Detalle_Factura (
        Detalle_Factura_Numero,
        Detalle_Factura_DetPedido,
        Detalle_Factura_Precio,
        Detalle_Factura_Cantidad,
        Detalle_Factura_Subtotal
    )
    SELECT
        detalle_factura_numero,
        detalle_pedido_codigo,
        detalle_factura_precio,
        detalle_factura_cantidad,
        detalle_factura_subtotal
    FROM 
        MAUV.detalles_temp
     WHERE
        detalle_factura_numero IS NOT NULL;

    INSERT INTO MAUV.Detalle_Compra (
        Detalle_Compra_Numero,
        Detalle_Compra_Material,
        Detalle_Compra_Precio,
        Detalle_Compra_Cantidad,
        Detalle_Compra_SubTotal
    )
    SELECT DISTINCT
        Compra_Numero,
        Material_Nombre,
        Detalle_Compra_Precio,
        Detalle_Compra_Cantidad,
        Detalle_Compra_SubTotal
    FROM
        gd_esquema.Maestra
    WHERE
        Compra_Numero IS NOT NULL AND Material_Nombre IS NOT NULL;
    
    DROP TABLE MAUV.detalles_temp;
END;
GO

BEGIN TRY
    BEGIN TRANSACTION;
        EXEC MAUV.crear_tablas;
        EXEC MAUV.migrar_materiales;
        EXEC MAUV.migrar_sillones;
        EXEC MAUV.migrar_sucursales_clientes_proveedores;
        EXEC MAUV.migrar_compras;
        EXEC MAUV.migrar_pedidos;
        EXEC MAUV.migrar_facturas_envios;
        EXEC MAUV.migrar_detalles;
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    THROW;  
END CATCH;
