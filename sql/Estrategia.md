1. Introducción

Este documento expone la estrategia de diseño e implementación adoptada por el grupo para abordar el Trabajo Práctico en la asignatura Gestión de Datos, cuyo objetivo es desarrollar un modelo de datos completo sobre el dominio de un emprendimiento de sillones a medida.

En esta primera parte, se trabajó desde la interpretación del enunciado hasta el armado del DER y su correspondiente migración a un modelo relacional implementado en SQL Server. El sistema busca representar el ciclo completo de pedidos, incluyendo sucursales, clientes, productos personalizados y materiales específicos utilizados en la fabricación.

Se detalla a continuación el análisis del dominio, la justificación del modelo, las decisiones de diseño y las particularidades técnicas de la implementación realizada hasta el momento.

2. Creación del modelo de Datos Relacional

Para la creación del modelo de datos relacional se partió de un diagrama de entidad relación(DER) creado a partir de la tabla maestra de datos otorgada en el trabajo práctico y los casos de uso especificados en el enunciado.
Para ver más en detalle el DER

Para la creación de las tablas del modelo transaccional se basó en las distintas entidades desarrolladas a continuación en el siguiente apartado.

3. Entidades

En esta sección se encuentra el detalle de los puntos claves de cada entidad, como claves primarias, foráneas y constraints.
Se ignora la explicación de atributos explícitos especificados en los casos de uso, a modo de concentrar la explicación de cada apartado en sus puntos relevantes.

Material:
Para la implementación de la entidad Material, es importante remarcar el uso de una primary key llamada Material_Nombre. Seleccionamos este atributo como PK, ya que, basándonos en los datos de la tabla maestra, se puede observar, como este es un campo único e identificador de cada material en el sistema.
Sub- entidades:Tela, Madera, Relleno
Relaciones: Un material puede tener múltiple Tela, Madera, Relleno. Además puede tener múltiples sillones y detalle de compra.
Constraints utilizadas: Utilizamos la constraint para material indicando que el precio no puede ser negativo.
material_precio_no_negativo

Sillon:
Para la implementación de la entidad Sillon, es importante remarcar el uso de una primary key llamada Sillon_Codigo. Seleccionamos este atributo como PK, ya que, basándonos en los datos de la tabla maestra, se puede observar, como este es un campo único e identificador de cada sillon en el sistema, permitiéndonos diferenciarlos. Además Sillon cuenta con dos FK que hacen referencia a Sillon_Modelo_Codigo y Sillon_Medida_Codigo.
La entidad SillonXMaterial fue creada con el fin de indicar que un sillon va a tener múltiples materiales y un material puede tener diferentes sillones. La misma tendrá FK a Material_Nombre y Sillon_Codigo.

Sub- entidades:Sillon_Medida,Sillon_Modelo, SillonXMaterial
Relaciones:Un sillón tiene un detalle de pedido y además, las sub-entidades anteriormente mencionada, cuenta con un modelo, una medida y materiales.
Constraints utilizadas: Para evitar inconsistencias desarrollamos las siguientes constraints para las entidades Sillon_Medida y Sillon_Modelo, fijando que el atributo precio de las mismas no sea negativo.
sillon_medida_precio_no_negativo
sillon_modelo_precio_no_negativo
Sucursal:

Para la implementación de la entidad sucursal, es importante remarcar el uso de una primary key llamada Sucursal_NroSucursal. Seleccionamos este atributo como PK, ya que, basándonos en los datos de la tabla maestra, se puede observar, como este es un campo único e identificador de cada sucursal en el sistema.
Relaciones:
Una sucursal puede tener pedidos asociados, por lo que también tiene compras y facturas asociadas.

Cliente:
Para esta entidad es importante recalcar su PK, nos pareció correcto utilizar el DNI de cada persona para su identificación en el sistema. Una posible consideración a futuro sería implementar una PK compuesta del DNI, nombre y apellido, así eliminando el posible problema de DNIs duplicados.
Relaciones:
Un cliente puede realizar pedidos y tener facturas asociadas a esos pedidos
Constraints utilizadas:
cliente_mayor_edad: chequea que el cliente sea mayor de edad a partir de su fecha de nacimiento.
cliente_dni_positivo: chequea que el cliente posea DNI positivo.

Proveedor:
Para la implementación de la entidad proveedor, es importante remarcar el uso de una primary key llamada Proveedor_Cuit. Seleccionamos este atributo como PK, ya que, basándonos en los datos de la tabla maestra, se puede observar, como este es un campo único e identificador de cada proveedor en el sistema.
Relaciones: Un proveedor puede tener muchas compras.

Compra:
Los aspectos a remarcar de esta entidad son su PK Compra_Numero, elegida basándose en los casos de uso donde se especifica que es un identificador único de cada compra, y sus dos FK, una referenciando a la sucursal donde se realizó la compra y otra referenciado a la PK de la entidad proveedor.

Detalle_compra:
El detalle de compra está compuesto por dos FK, Detalle_Compra_Numero que hace referencia a su compra asociada y Detalle_Compra_Material que apunta a los materiales seleccionados para la compra.
Constraints utilizadas:
detalle_compra_precio_no_negativo: chequea que el precio no sea negativo.
detalle_compra_cantidad_positiva: chequea que la cantidad del material especificado sea positiva.
detalle_compra_subtotal_no_negativo: chequea que el subtotal no sea negativo.

Pedido:
Para la implementación de la entidad pedido, es importante remarcar el uso de una primary key llamada Pedido_Numero. Seleccionamos este atributo como PK, ya que, basándonos en los datos de la tabla maestra, se puede observar, como este es un campo único e identificador de cada pedido en el sistema. Además cuenta con dos FK a Sucursal_NroSucursal y Cliente_Dni.
Sub- entidades:cancelacion_Pedido
Relaciones:Un pedido puede tener una cancelacion_Pedido, una sucursal, un cliente y un detalle_Pedido.
Constraints utilizadas:Utilizamos la constraint para pedido indicando que el total no puede ser negativo.
pedido_total_positivo

Detalle_Pedido:
Para la implementación de la entidad Detalle_Pedido, es importante remarcar el uso de una primary key llamada Detalle_Pedido_Codigo. Seleccionamos este atributo como PK, ya que nos permite diferenciar a cada Detalle_Pedido del sistema. Cuenta además con dos FK a Pedido_Numero y Sillon_Codigo
Relaciones:Un detalle de pedido tiene un pedido, un detalle de factura, y muchos sillones
Constraints utilizadas:
detalle_pedido_cantidad_positiva
detalle_pedido_precio_no_negativo
detalle_pedido_subtotal_no_negativo

Factura:
Para la implementación de la entidad Material, es importante remarcar el uso de una primary key llamada Factura_Numero, ya que, basándonos en los casos de uso, se puede observar, como este es un identificador único de cada factura.
Para esta entidad basándonos en los casos de uso determinamos la agregación de dos FK’s llamadas, Factura_Cliente referenciado a la PK del cliente asociado y, Factura_Sucursal referenciando a la PK de la sucursal en la que fue efectuada la compra.

Detalle_Factura:
Para esta entidad se creó una PK llamada Detalle_Factura_Codigo encontrada en los casos de uso y la tabla maestra, a su vez cuenta con dos FK, una Detalle_Factura_Numero para hacer referencia a que factura está asociado este detalle y otra basándose en los casos de uso, Detalle_Factura_DetPedido, que hace referencia al número de detalle de pedido a partir del cual se fabricó el sillon.
Constraints utilizadas:
Para chequear que los siguientes atributos son positivos se implementaron las siguientes constraints:
detalle_factura_cantidad_positiva:
detalle_factura_precio_no_negativo
detalle_factura_subtotal_no_negativo

Envío:
Para la implementación de la entidad envio, es importante remarcar el uso de una primary key llamada Envio_Numero. Seleccionamos este atributo como PK, ya que, basándonos en los datos de la tabla maestra, se puede observar, como este es un campo único e identificador de cada envío en el sistema. Además tiene una FK a Factura_Numero.
Relaciones:Un envío tiene una factura.
Constraints utilizadas:
envio_importe_traslado_no_negativo
envio_importe_subida_no_negativo
envio_total_no_negativo 4. Triggers
Considerando que la creación de triggers se realiza en EXEC, ya que, sql no nos permite crear triggers dentro de procedures.
Los siguientes triggers fueron implementados:
trg_cancelacion_pedido_fecha_valida: trigger para que una cancelación de pedido no haga referencia a un pedido creado en fechas posteriores.
trg_pedido_no_modificar_fecha_pasada: trigger para que no sea posible modificar un pedido con fecha pasada.
trg_factura_no_modificar_fecha_pasada: trigger para que no sea posible modificar una factura con fecha pasada. 5. Migración de datos
Para lograr la migración de datos se creó los siguientes procedures:
migrar_materiales:
La migración se encarga de copiar datos desde la tabla maestra hacia las tablas de los correspondientes materiales respetando atributos especificos de cada tipo. Insertamos materiales genéricos en MAUV.Material, solo inserta filas con Material_Nombre no nulo, y usamos DISTINCT para evitar duplicados. Luego se insertan materiales en los distintos tipos.

migrar_sillones:
El procedimiento MAUV.migrar_sillones carga los datos de sillones desde la tabla maestra gd_esquema.Maestra utilizando una tabla temporal que permite generar códigos de medidas (medida_codigo) ausentes en el origen. A partir de esta tabla intermedia, se insertan registros en las tablas Sillon_Medida, Sillon_Modelo, Sillon y SillonXMaterial, vinculando cada sillón con su modelo, sus medidas y sus materiales. Finalmente, se elimina la tabla temporal para mantener la limpieza del esquema.

migrar_sucursales_clientes_proveedores:
Este procedimiento importa los datos de sucursales, clientes y proveedores desde la tabla gd_esquema.Maestra. Utiliza consultas como INSERT INTO, y SELECT DISTINCT para evitar duplicados y asegura que los registros tengan claves primarias válidas (Sucursal_NroSucursal, Cliente_Dni, Proveedor_Cuit) mediante filtros IS NOT NULL. De este modo, se completa la carga inicial de las entidades básicas del negocio.
migrar_compras:
Este procedimiento migra los datos de compras a proveedores, insertando registros en la tabla Compra con número de compra, proveedor, sucursal, fecha y total. Además, se asegura que las claves foráneas (Sucursal_NroSucursal y Proveedor_Cuit) estén presentes antes de insertar los registros, para mantener la integridad referencial.
migrar_pedidos:
Este procedimiento carga los pedidos realizados por clientes. Inserta registros en la tabla Pedido, estableciendo relaciones con Cliente y Sucursal, y luego inserta en la tabla Cancelacion_Pedido aquellos pedidos que tienen motivo y fecha de cancelación. De esta forma, la lógica garantiza que solo se migren datos válidos y que se mantenga la estructura opcional de cancelación como se definió en el modelo.
migrar_facturas_envios:
Este procedimiento migra las facturas emitidas y sus envíos asociados. Inserta primero las facturas con sus datos principales (número, fecha, total, cliente, sucursal), y luego los envíos relacionados usando Factura_Numero como clave foránea. Se encarga de asegurar que solo se carguen registros completos y válidos usando condiciones IS NOT NULL.
migrar_detalles:
Este procedimiento realiza la migración de los detalles de pedidos, facturas y compras. Dado que algunos identificadores no existen en origen, se utiliza una tabla temporal detalles_temp para generar los códigos necesarios (por ejemplo, Detalle_Pedido_Codigo) y reunir información distribuida entre pedidos y facturas. Luego:
Inserta en Detalle_Pedido usando el código generado.
Inserta en Detalle_Factura, relacionando cada factura con su ítem del pedido.
Inserta en Detalle_Compra los insumos adquiridos por compra.
Finalmente, elimina la tabla temporal para mantener limpio el esquema.

Consideraciones:
En el procedure de migrar_sillones necesitamos una tabla temporal ya que necesitamos generar "medida_codigo" para conectarla a la tabla sillón. Esto ocurre porque no tenemos el dato en la tabla maestra.
En el procedure de migrar_detalles, sucede un caso similar donde esta tabla no existía, por lo tanto, , necesitamos crear otra tabla temporal para almacenar el Detalle_Pedido PK y poder pasarla a Detalle_Factura.

Por último, el script ejecuta de forma transaccional todo el proceso de creación y migración de datos. Dentro de un bloque TRY...CATCH, se inicia una transacción que agrupa:
La creación de todas las tablas (crear_tablas).
La creación de triggers (crear_triggers).
La migración completa de datos desde la tabla gd_esquema.Maestra, invocando los procedimientos de carga correspondientes: materiales, sillones, sucursales, clientes, proveedores, compras, pedidos, facturas, envíos y detalles.
Si todo se ejecuta correctamente, se hace COMMIT, asegurando que los datos queden persistidos de forma definitiva. En caso de error, se ejecuta un ROLLBACK automático, que revierte todos los cambios para evitar inconsistencias en la base de datos.
