USE [GD1C2025]
GO

DELETE FROM [MAUV].[Sucursal]
DELETE FROM [MAUV].[Pedido]
DELETE FROM [MAUV].[Cliente]
DELETE FROM [MAUV].[Factura]
DELETE FROM [MAUV].[Detalle_Factura]
DELETE FROM [MAUV].[Sillon]
DELETE FROM [MAUV].[Envio]
DELETE FROM [MAUV].[Cancelacion_Pedido]
DELETE FROM [MAUV].[Compra]
DELETE FROM [MAUV].[Detalle_Compra]
DELETE FROM [MAUV].[Proveedor]
DELETE FROM [MAUV].[Detalle_Pedido]
DELETE FROM [MAUV].[Sillon_Medida]
DELETE FROM [MAUV].[SillonXMaterial]
DELETE FROM [MAUV].[Sillon_Modelo]
DELETE FROM [MAUV].[Tela]
DELETE FROM [MAUV].[Madera]
DELETE FROM [MAUV].[Relleno]
DELETE FROM [MAUV].[Material]
GO

DROP TABLE [MAUV].[Sucursal]
DROP TABLE [MAUV].[Pedido]
DROP TABLE [MAUV].[Cliente]
DROP TABLE [MAUV].[Factura]
DROP TABLE [MAUV].[Detalle_Factura]
DROP TABLE [MAUV].[Sillon]
DROP TABLE [MAUV].[Envio]
DROP TABLE [MAUV].[Cancelacion_Pedido]
DROP TABLE [MAUV].[Compra]
DROP TABLE [MAUV].[Detalle_Compra]
DROP TABLE [MAUV].[Proveedor]
DROP TABLE [MAUV].[Detalle_Pedido]
DROP TABLE [MAUV].[Sillon_Medida]
DROP TABLE [MAUV].[SillonXMaterial]
DROP TABLE [MAUV].[Sillon_Modelo]
DROP TABLE [MAUV].[Tela]
DROP TABLE [MAUV].[Madera]
DROP TABLE [MAUV].[Relleno]
DROP TABLE [MAUV].[Material]
GO

DROP PROCEDURE MAUV.crear_tablas;
DROP PROCEDURE MAUV.crear_triggers;
DROP PROCEDURE MAUV.migrar_materiales;
DROP PROCEDURE MAUV.migrar_sillones;
DROP PROCEDURE MAUV.migrar_sucursales_clientes_proveedores;
DROP PROCEDURE MAUV.migrar_compras;
DROP PROCEDURE MAUV.migrar_pedidos;
DROP PROCEDURE MAUV.migrar_facturas_envios;
DROP PROCEDURE MAUV.migrar_detalles;
GO

DROP SCHEMA [MAUV]
GO
