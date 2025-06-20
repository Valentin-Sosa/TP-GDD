USE [GD1C2025]
GO

DROP VIEW MAUV.BI_Vista_Ganancias_Mensuales;
DROP VIEW MAUV.BI_Vista_Promedio_Factura_Mensual_Provincia;
DROP VIEW MAUV.BI_Vista_Volumen_Pedidos;
DROP VIEW MAUV.BI_Vista_Rendimiento_Modelos;
DROP VIEW MAUV.BI_Vista_Tiempo_Promedio_Fabricacion;
DROP VIEW MAUV.BI_Vista_Conversion_Pedidos;
DROP VIEW MAUV.BI_Vista_Promedio_Compras_Mensual;
DROP VIEW MAUV.BI_Vista_Compras_Tipo_Material;
DROP VIEW MAUV.BI_Vista_Porcentaje_Cumplimiento_Envios;
DROP VIEW MAUV.BI_Vista_Top_Localidades_Costo_Envio;
GO

DELETE FROM [MAUV].[BI_Tiempo]
DELETE FROM [MAUV].[BI_Ubicacion]
DELETE FROM [MAUV].[BI_Rango_Etario_Cliente]
DELETE FROM [MAUV].[BI_Turno_Ventas]
DELETE FROM [MAUV].[BI_Tipo_Material]
DELETE FROM [MAUV].[BI_Modelo_Sillon]
DELETE FROM [MAUV].[BI_Estado_Pedido]
DELETE FROM [MAUV].[BI_Sucursal]
DELETE FROM [MAUV].[BI_Indicadores_Facturacion]
DELETE FROM [MAUV].[BI_Indicadores_Ventas_Modelo]
DELETE FROM [MAUV].[BI_Indicadores_Pedidos]
DELETE FROM [MAUV].[BI_Indicadores_Compras]
DELETE FROM [MAUV].[BI_Indicadores_Envios]
GO

DROP TABLE [MAUV].[BI_Tiempo]
DROP TABLE [MAUV].[BI_Ubicacion]
DROP TABLE [MAUV].[BI_Rango_Etario_Cliente]
DROP TABLE [MAUV].[BI_Turno_Ventas]
DROP TABLE [MAUV].[BI_Tipo_Material]
DROP TABLE [MAUV].[BI_Modelo_Sillon]
DROP TABLE [MAUV].[BI_Estado_Pedido]
DROP TABLE [MAUV].[BI_Sucursal]
DROP TABLE [MAUV].[BI_Indicadores_Facturacion]
DROP TABLE [MAUV].[BI_Indicadores_Ventas_Modelo]
DROP TABLE [MAUV].[BI_Indicadores_Pedidos]
DROP TABLE [MAUV].[BI_Indicadores_Compras]
DROP TABLE [MAUV].[BI_Indicadores_Envios]
GO

DROP FUNCTION MAUV.obtener_rango_etario_id
DROP FUNCTION MAUV.obtener_turno_venta_id
DROP FUNCTION MAUV.obtener_numero_cuatrimestre
DROP FUNCTION MAUV.obtener_tiempo_id
GO

DROP PROCEDURE [MAUV].[BI_crear_tablas_dimensiones]
DROP PROCEDURE [MAUV].[BI_crear_tablas_indicadores]
DROP PROCEDURE [MAUV].[BI_crear_funciones_utilitarias]
DROP PROCEDURE [MAUV].[BI_popular_dimensiones]
DROP PROCEDURE [MAUV].[BI_popular_indicadores]
DROP PROCEDURE [MAUV].[BI_crear_vistas]
GO
