-- ══════════════════════════════════════════
-- MiniStore — Soluciones con Outer JOINs
-- Autor: Josefina
-- ══════════════════════════════════════════

-- ── CONSULTA 1: LEFT JOIN ─────────────────
-- Pregunta de negocio: ¿Qué productos del catálogo nunca fueron vendidos?
-- Se usa LEFT JOIN para priorizar todos los productos de la tabla izquierda (productos)
-- y el filtro WHERE ... IS NULL aisla exclusivamente aquellos que no registran ventas.
SELECT 
    p.producto_id,
    p.nombre,
    p.categoria,
    p.precio
FROM productos p
LEFT JOIN ventas v ON p.producto_id = v.producto_id
WHERE v.venta_id IS NULL;


-- ── CONSULTA 2: RIGHT JOIN ────────────────
-- Pregunta de negocio: ¿Existen ventas registradas con productos
-- que no figuran en nuestro catálogo? (posible error de carga de datos)
-- Se usa RIGHT JOIN para priorizar todas las filas de la tabla derecha (ventas)
-- y el filtro detecta los registros huérfanos sin correspondencia en el catálogo.
SELECT 
    v.venta_id,
    v.producto_id AS producto_id_en_ventas,
    v.cliente_id,
    v.cantidad,
    v.fecha_venta
FROM productos p
RIGHT JOIN ventas v ON p.producto_id = v.producto_id
WHERE p.producto_id IS NULL;


-- ── CONSULTA 3: FULL OUTER JOIN ───────────
-- Pregunta de negocio: Vista completa de auditoría que muestre
-- todos los productos y todas las ventas sin perder ninguna fila.
SELECT 
    COALESCE(p.producto_id, v.producto_id) AS producto_id,
    p.nombre AS producto_catalogo,
    v.venta_id,
    v.cantidad,
    v.fecha_venta
FROM productos p
FULL OUTER JOIN ventas v ON p.producto_id = v.producto_id;
