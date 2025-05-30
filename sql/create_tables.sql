USE [GD1C2025]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [MAUV].[Sucursal] (
    [sucursal_nro] [bigint] NOT NULL PRIMARY KEY,
    [sucursal_provincia] [nvarchar](255),
    [sucursal_localidad] [nvarchar](255),
    [sucursal_direccion] [nvarchar](255),
    [sucursal_telefono] [nvarchar](255),
    [sucursal_mail] [nvarchar](255)
    FOREIGN KEY ([pedido_sucursal]) REFERENCES [MAUV].[Sucursal]([sucursal_nro]),
)

CREATE TABLE [MAUV].[Pedido] (
    [pedido_numero] [bigint] NOT NULL PRIMARY KEY,
    [pedido_fecha] [nvarchar](255),
    [pedido_estado] [nvarchar](255),
    [pedido_total] [nvarchar](255),
    [pedido_sucursal] [nvarchar](255),
    [pedido_cliente] [nvarchar](255),
    FOREIGN KEY ([pedido_sucursal]) REFERENCES [MAUV].[Sucursal](sucursal_nro),
);
