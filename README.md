# MiniStore — Análisis de Inventario y Ventas con Outer JOINs

Este repositorio contiene las consultas SQL orientadas a auditar la calidad de los datos y resolver problemas de correspondencia entre el catálogo de productos y el historial de transacciones de MiniStore.

## Preguntas y Respuestas del Análisis

### 1. ¿Por qué usaste LEFT JOIN para la Consulta 1 y no INNER JOIN? ¿Qué se perdería si usaras INNER JOIN?
Se utilizó un `LEFT JOIN` porque la pregunta de negocio exige identificar los productos que **nunca** fueron vendidos. Si se hubiera utilizado un `INNER JOIN`, la base de datos solo devolvería los registros que tienen una coincidencia exacta en ambas tablas. Como consecuencia, los productos 108 ('Hub USB-C 7p') y 109 ('Parlante Bluetooth') habrían desaparecido por completo del resultado, ocultando la información sobre el inventario estancado.

### 2. ¿Por qué usaste RIGHT JOIN para la Consulta 2? ¿Qué tabla está a la izquierda y cuál a la derecha en tu consulta?
Se utilizó un `RIGHT JOIN` para asegurar que ninguna transacción de la tabla `ventas` quede fuera del análisis, priorizando el lado derecho de la relación. En nuestra consulta, la tabla `productos` se encuentra a la izquierda del `JOIN` y la tabla `ventas` a la derecha (`FROM productos p RIGHT JOIN ventas v`). Esto permite retener la venta con `producto_id = 999` y detectar que se trata de un registro huérfano, ya que al no existir en el catálogo, sus campos correspondientes a productos se completan con valores nulos.

### 3. ¿Qué representan los valores NULL en cada resultado? Explicá con un ejemplo concreto.
Los valores `NULL` no son errores, sino indicadores de la ausencia de correspondencia en el cruce de tablas:
* En la **Consulta 1** (con `LEFT JOIN`), que el campo `venta_id` o los datos de ventas sean `NULL` significa que ese producto específico del catálogo (por ejemplo, el 'Hub USB-C 7p', ID 108) nunca registró ninguna transacción de venta.
* En la **Consulta 2** (con `RIGHT JOIN`), que el campo `producto_id` o los datos de productos sean `NULL` significa que la venta registrada (por ejemplo, la `venta_id = 10`) hace referencia a un código de producto (`999`) que no existe en el catálogo actual, evidenciando un error de carga o una inconsistencia operativa.

### 4. ¿Cuándo usarías FULL OUTER JOIN en un caso real de negocio?
Un `FULL OUTER JOIN` se utiliza en escenarios de **auditoría integral y conciliación de datos**. Es ideal cuando se necesita fusionar dos fuentes de información independientes (por ejemplo, cruzar el inventario físico de un almacén con el sistema contable de ventas) para detectar de forma simultánea todas las discrepancias en ambas direcciones: tanto productos que nunca se vendieron o faltantes en el sistema, como ventas registradas sin respaldo físico o errores de registro en las transacciones.
