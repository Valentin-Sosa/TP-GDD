
USE [GD1C2025]
GO

------------------------------------------------------
-- Creacion de tablas: Dimensiones
------------------------------------------------------
CREATE or ALTER PROCEDURE MAUV.BI_crear_tablas_dimensiones AS
BEGIN
    CREATE TABLE MAUV.BI_Tiempo (
        id decimal(18,0) PRIMARY KEY IDENTITY(1,1),
        Anio decimal(18,0),
        Mes decimal(18,0),
        Cuatrimestre decimal(18,0)
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
END;
GO


------------------------------------------------------
-- Creacion de tablas: Indicadores
------------------------------------------------------
CREATE or ALTER PROCEDURE MAUV.BI_crear_tablas_indicadores AS
BEGIN
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
        Suma_Valor_Ventas decimal(18,2),
        Cantidad_Ventas decimal(18,0),
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
        Sucursal_Nro bigint FOREIGN KEY REFERENCES MAUV.BI_Sucursal(Sucursal_Nro),
        Tiempo_id decimal(18,0) FOREIGN KEY REFERENCES MAUV.BI_Tiempo(id),
        Turno_Ventas_id decimal(18,0) FOREIGN KEY REFERENCES MAUV.BI_Turno_Ventas(id),
        PRIMARY KEY(Sucursal_Nro, Tiempo_id, Turno_Ventas_id)
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
        Cantidad decimal(18,0),
        Cantidad_En_Tiempo decimal(18,0),
        Suma_Costo_Total decimal(18,2),
        Tiempo_id decimal(18,0) FOREIGN KEY REFERENCES MAUV.BI_Tiempo(id),
        Ubicacion_id decimal(18,0) FOREIGN KEY REFERENCES MAUV.BI_Ubicacion(id),
        PRIMARY KEY(Tiempo_id, Ubicacion_id)
    )
END;
GO

------------------------------------------------------
-- Creacion de funciones utilitarias
------------------------------------------------------
CREATE or ALTER PROCEDURE MAUV.BI_crear_funciones_utilitarias AS
BEGIN
    EXEC('CREATE FUNCTION MAUV.obtener_rango_etario_id(@date DATE) RETURNS INT AS
    BEGIN
        DECLARE @edad INT;

        SET @edad = DATEDIFF(YEAR, @date, GETDATE());

        DECLARE @id INT;
        SET @id = CASE WHEN @edad < 25 THEN 1
                    WHEN @edad BETWEEN 25 AND 35 THEN 2 
                    WHEN @edad > 35 AND @edad <= 50 THEN 3
                    WHEN @edad > 50 THEN 4
        END;

        RETURN @id
    END')

    EXEC('CREATE FUNCTION MAUV.obtener_turno_venta_id(@date DATETIME) RETURNS INT AS
    BEGIN
        DECLARE @hora INT;

        SET @hora = DATEPART(HOUR, @date)

        DECLARE @id INT;
        SET @id = CASE WHEN @hora >= 8 AND @hora < 14 THEN 1
                    WHEN @hora >= 14 AND @hora < 20 THEN 2
        END;

        RETURN @id
    END')

    EXEC('CREATE FUNCTION MAUV.obtener_numero_cuatrimestre(@date DATE) RETURNS INT AS
    BEGIN
        DECLARE @mes INTEGER;

        SET @mes = MONTH(@date);

        DECLARE @cuatri INT;
        SET @cuatri = CASE WHEN @mes BETWEEN 1 AND 4 THEN 1
                    WHEN @mes BETWEEN 5 AND 8 THEN 2
                    WHEN @mes BETWEEN 9 AND 12 THEN 3
        END;
                            
        RETURN @cuatri;
    END')

    EXEC('CREATE FUNCTION MAUV.obtener_tiempo_id(@date DATE) RETURNS INT AS
    BEGIN
        DECLARE @tiempo_id INTEGER;

        SET @tiempo_id = (SELECT id FROM MAUV.BI_Tiempo WHERE anio = YEAR(@date) AND mes = MONTH(@date));
                            
        RETURN @tiempo_id;
    END')
END;
GO

------------------------------------------------------
-- Populacion de tablas: dimensiones
------------------------------------------------------
CREATE or ALTER PROCEDURE MAUV.BI_popular_dimensiones AS
BEGIN
    INSERT INTO MAUV.BI_Tiempo (
        Anio,
        Mes,
        Cuatrimestre
    )
    (
        SELECT DISTINCT YEAR(Cliente_Fecha_Nacimiento), MONTH(Cliente_Fecha_Nacimiento), MAUV.obtener_numero_cuatrimestre(Cliente_Fecha_Nacimiento) FROM MAUV.Cliente  
        UNION SELECT DISTINCT YEAR(Compra_Fecha), MONTH(Compra_Fecha), MAUV.obtener_numero_cuatrimestre(Compra_Fecha) FROM MAUV.Compra  
        UNION SELECT DISTINCT YEAR(Pedido_Fecha), MONTH(Pedido_Fecha), MAUV.obtener_numero_cuatrimestre(Pedido_Fecha) FROM MAUV.Pedido 
        UNION SELECT DISTINCT YEAR(Pedido_Cancelacion_Fecha), MONTH(Pedido_Cancelacion_Fecha), MAUV.obtener_numero_cuatrimestre(Pedido_Cancelacion_Fecha) FROM MAUV.Cancelacion_Pedido 
        UNION SELECT DISTINCT YEAR(Factura_Fecha), MONTH(Factura_Fecha), MAUV.obtener_numero_cuatrimestre(Factura_Fecha) FROM MAUV.Factura
        UNION SELECT DISTINCT YEAR(Envio_Fecha), MONTH(Envio_Fecha), MAUV.obtener_numero_cuatrimestre(Envio_Fecha) FROM MAUV.Envio
        UNION SELECT DISTINCT YEAR(Envio_Fecha_Programada), MONTH(Envio_Fecha_Programada), MAUV.obtener_numero_cuatrimestre(Envio_Fecha_Programada) FROM MAUV.Envio

    );

    INSERT INTO MAUV.BI_Ubicacion (
        Provincia,
        Localidad
    )
    (
        SELECT DISTINCT Sucursal_Provincia, Sucursal_Localidad FROM MAUV.Sucursal
        UNION SELECT DISTINCT Cliente_Provincia, Cliente_Localidad FROM MAUV.Cliente
        UNION SELECT DISTINCT Proveedor_Provincia, Proveedor_Localidad FROM MAUV.Proveedor
    );

    INSERT INTO MAUV.BI_Rango_Etario_Cliente (
        Rango
    ) VALUES ('< 25'), ('25-35'), ('35-50'), ('> 50');

    INSERT INTO MAUV.BI_Turno_Ventas (
        Rango
    ) VALUES ('08:00 - 14:00'), ('14:00 - 20:00');

    INSERT INTO MAUV.BI_Tipo_Material (
        Tipo
    ) VALUES ('Madera'), ('Relleno'), ('Tela');

    INSERT INTO MAUV.BI_Modelo_Sillon (
        Modelo
    ) SELECT DISTINCT Sillon_Modelo FROM Sillon_Modelo;

    INSERT INTO MAUV.BI_Estado_Pedido (
        Estado
    ) VALUES ('Entregado'), ('Pendiente'), ('Cancelado');

     INSERT INTO MAUV.BI_Sucursal (
        Sucursal_Nro
    ) SELECT DISTINCT Sucursal_NroSucursal FROM MAUV.Sucursal;
END;
GO

------------------------------------------------------
-- Populacion de tablas: indicadores
------------------------------------------------------
CREATE or ALTER PROCEDURE MAUV.BI_popular_indicadores AS
BEGIN
    INSERT INTO MAUV.BI_Indicadores_Facturacion (
        Suma_Subtotal,
        Cantidad_Facturas,
        Sucursal_Nro,
        Tiempo_Id,
        Ubicacion_id
    ) (
        SELECT DISTINCT 
            SUM(f.Factura_Total) AS Suma_Subtotal,
            COUNT(*) AS Cantidad_Facturas,
            s.Sucursal_NroSucursal,
            t.id,
            u.id
        FROM MAUV.Factura f
        INNER JOIN MAUV.Sucursal s ON s.Sucursal_NroSucursal = f.Factura_Sucursal 
        INNER JOIN MAUV.BI_Tiempo t  ON t.id = MAUV.obtener_tiempo_id(f.Factura_Fecha)
        INNER JOIN MAUV.BI_Ubicacion u ON u.Provincia = s.Sucursal_Provincia AND u.Localidad = s.Sucursal_Localidad
		GROUP BY s.Sucursal_NroSucursal, t.id, u.id
    );

    INSERT INTO MAUV.BI_Indicadores_Ventas_Modelo (
        Modelo,
        Cantidad_Ventas,
        Suma_Valor_Ventas,
        Tiempo_id,
        Ubicacion_id,
        Rango_Etario_id
    ) SELECT DISTINCT
        sm.Sillon_Modelo, 
        COUNT(*) AS Cantidad_Ventas, 
        SUM(Pedido_Total) AS Suma_Valor_Ventas, 
        t.id, 
        u.id, 
        r.id
    FROM MAUV.Pedido p
    INNER JOIN MAUV.Detalle_Pedido dp ON dp.Detalle_Pedido_Codigo = p.Pedido_Numero
    INNER JOIN MAUV.Sillon s on dp.Detalle_Pedido_Sillon = s.Sillon_Codigo
    INNER JOIN MAUV.Sillon_Modelo sm on  s.Sillon_Modelo = sm.Sillon_Modelo_Codigo
    INNER JOIN MAUV.Sucursal su on su.Sucursal_NroSucursal = p.Pedido_Sucursal
    INNER JOIN MAUV.Cliente c on c.Cliente_Dni = p.Pedido_Cliente
    INNER JOIN MAUV.BI_Tiempo t  ON t.id = MAUV.obtener_tiempo_id(p.Pedido_Fecha)
    INNER JOIN MAUV.BI_Ubicacion u ON u.Provincia = su.Sucursal_Provincia AND u.Localidad = su.Sucursal_Localidad
    INNER JOIN MAUV.BI_Rango_Etario_Cliente r ON r.rango = MAUV.obtener_rango_etario_id(c.Cliente_Fecha_Nacimiento)
    GROUP BY sm.Sillon_Modelo, r.id, t.id, u.id;


    INSERT INTO MAUV.BI_Indicadores_Pedidos (
        Cantidad,
        Cantidad_Entregado,
        Cantidad_Cancelado,
        Cantidad_Pendiente,
        Suma_Tiempo_Registro_Factura,
        Sucursal_Nro,
        Tiempo_id,
        Turno_Ventas_id
    ) SELECT DISTINCT 
        COUNT(*) AS Cantidad,
        SUM(CASE WHEN p.Pedido_Estado = 'ENTREGADO' THEN 1 ELSE 0 END),
        SUM(CASE WHEN p.Pedido_Estado = 'CANCELADO' THEN 1 ELSE 0 END),
        SUM(CASE WHEN p.Pedido_Estado = 'PENDIENTE' THEN 1 ELSE 0 END),
        SUM(DATEDIFF(DAY, p.Pedido_Fecha, f.Factura_Fecha)),
        s.Sucursal_Nro,
        t.id,
        tv.id
    FROM MAUV.Pedido p
    INNER JOIN MAUV.Detalle_Pedido dp ON dp.Detalle_Pedido_Codigo = p.Pedido_Numero
    INNER JOIN MAUV.Detalle_Factura df ON df.Detalle_Factura_DetPedido = dp.Detalle_Pedido_Codigo
    INNER JOIN MAUV.Factura f ON f.Factura_Numero = df.Detalle_Factura_Numero
    INNER JOIN MAUV.BI_Sucursal s ON s.Sucursal_Nro = p.Pedido_Sucursal
    INNER JOIN MAUV.BI_Tiempo t ON t.id = MAUV.obtener_tiempo_id(p.Pedido_Fecha)
    INNER JOIN MAUV.BI_Turno_Ventas tv ON tv.id = MAUV.obtener_turno_venta_id(p.Pedido_Fecha)
    GROUP BY s.Sucursal_Nro, t.id, tv.id;
    

    INSERT INTO MAUV.BI_Indicadores_Compras(
        Suma_Subtotal,
        Cantidad_Compras,
        Sucursal_Nro,
        Tiempo_id,
        Ubicacion_id,
        Tipo_Material_id
    ) SELECT
        SUM(dc.Detalle_Compra_SubTotal) AS Suma_Subtotal,
        COUNT(*) AS Cantidad_Compras,
        c.Compra_Sucursal,
        t.id AS Tiempo_id,
        u.id AS Ubicacion_id,
        tm.id AS Tipo_Material_id
    FROM MAUV.Compra c
    INNER JOIN MAUV.Detalle_Compra dc ON c.Compra_Numero = dc.Detalle_Compra_Numero
    INNER JOIN MAUV.Material m ON m.Material_Nombre = dc.Detalle_Compra_Material
    INNER JOIN MAUV.BI_Tipo_Material tm ON tm.Tipo = m.Material_Tipo
    INNER JOIN MAUV.Sucursal s ON s.Sucursal_NroSucursal = c.Compra_Sucursal
    INNER JOIN MAUV.BI_Tiempo t ON t.id = MAUV.obtener_tiempo_id(c.Compra_Fecha)
    INNER JOIN MAUV.BI_Ubicacion u ON u.Provincia = s.Sucursal_Provincia AND u.Localidad = s.Sucursal_Localidad
    GROUP BY
        c.Compra_Sucursal,
        t.id,
        u.id,
        tm.id;
    
    INSERT INTO MAUV.BI_Indicadores_Envios (
        Cantidad,
        Cantidad_En_Tiempo,
        Suma_Costo_Total,
        Tiempo_id,
        Ubicacion_id
    ) SELECT DISTINCT
        COUNT (*) AS Cantidad,
        SUM(CASE WHEN e.Envio_Fecha <= e.Envio_Fecha_Programada 
                THEN 1
                ELSE 0
            END
        ),
        SUM(e.Envio_Total),
        t.id,
        u.id
    FROM MAUV.Envio e
    INNER JOIN MAUV.Factura f ON e.Envio_Factura = f.Factura_Numero
    INNER JOIN MAUV.Sucursal s ON s.Sucursal_NroSucursal = f.Factura_Sucursal
    INNER JOIN MAUV.BI_Tiempo t ON t.id = MAUV.obtener_tiempo_id(e.Envio_Fecha)
    INNER JOIN MAUV.BI_Ubicacion u ON u.Provincia = s.Sucursal_Provincia AND u.Localidad = s.Sucursal_Localidad
    GROUP BY t.id, u.id;
END;
GO

------------------------------------------------------
-- Creacion de vistas
------------------------------------------------------
CREATE or ALTER PROCEDURE MAUV.BI_crear_vistas AS
BEGIN
    CREATE VIEW MAUV.BI_Vista_Ganancias_Mensuales AS
    SELECT
        t.Mes,
        u.Provincia,
        SUM(f.Suma_Subtotal) - SUM(c.Suma_Subtotal) AS Ganancia
    FROM MAUV.BI_Indicadores_Facturacion f
    JOIN MAUV.BI_Indicadores_Compras c
    ON f.Sucursal_Nro = c.Sucursal_Nro AND f.Tiempo_id = c.Tiempo_id
    JOIN MAUV.BI_Tiempo t ON f.Tiempo_id = t.id
    -- ver si realmente hace falta
    JOIN MAUV.BI_Ubicacion u ON f.Ubicacion_id = u.id
    GROUP BY t.Mes, u.Provincia;

        
END;
GO

------------------------------------------------------
-- Ejecución de procedures
------------------------------------------------------
BEGIN TRY
    BEGIN TRANSACTION;
        EXEC MAUV.BI_crear_tablas_dimensiones;
        EXEC MAUV.BI_crear_tablas_indicadores;
        EXEC MAUV.BI_crear_funciones_utilitarias;
        EXEC MAUV.BI_popular_dimensiones;
        EXEC MAUV.BI_popular_indicadores;
        EXEC MAUV.BI_crear_vistas;
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    THROW;  
END CATCH;
