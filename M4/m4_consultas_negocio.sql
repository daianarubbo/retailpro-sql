SELECT 
    EXTRACT(MONTH FROM fecha_venta) AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado,
    COUNT(*) AS cantidad_pedidos,
    AVG(cantidad * precio_unitario) AS ticket_promedio
FROM ventas
GROUP BY EXTRACT(MONTH FROM fecha_venta)
ORDER BY mes;

SELECT 
    id_producto,
    SUM(cantidad) AS unidades_vendidas,
    SUM(cantidad * precio_unitario) AS total_generado
FROM ventas
GROUP BY id_producto
ORDER BY total_generado DESC
LIMIT 5;

SELECT 
    id_cliente,
    COUNT(*) AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1;

SELECT 
    EXTRACT(MONTH FROM fecha_venta) AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado,
    CASE 
        WHEN SUM(cantidad * precio_unitario) > (SELECT AVG(total) FROM (SELECT SUM(cantidad * precio_unitario) AS total FROM ventas GROUP BY EXTRACT(MONTH FROM fecha_venta)) AS subconsulta)
        THEN 'Por encima'
        ELSE 'Por debajo'
    END AS comparacion
FROM ventas
GROUP BY EXTRACT(MONTH FROM fecha_venta);

-- ============================================
-- HALLAZGOS
-- ============================================
-- 1. El producto 1 (Laptop Pro 15) es el que más plata generó: solo con
--    3 unidades vendidas, representa más de la mitad de toda la
--    facturación del mes.
-- 2. El producto 1 es tan caro que con pocas unidades ya recauda mucho
--    dinero. En cambio, con el mouse pasa lo contrario: se vendieron
--    muchas más unidades (13), pero el ingreso total generado es mucho
--    menor.
-- 3. Al tener registradas ventas de un solo mes, la comparación contra
--    el promedio mensual no es representativa todavía. Haría falta
--    cargar varios meses de historia para que ese análisis tenga
--    sentido real.
