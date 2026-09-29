SELECT 
    v.fecha_venta,
    c.nombre AS cliente,
    c.ciudad,
    p.nombre_producto,
    cat.nombre_categoria,
    v.cantidad,
    v.precio_unitario,
    (v.cantidad * v.precio_unitario) AS total_venta
FROM ventas v
INNER JOIN clientes c ON v.id_cliente = c.id_cliente
INNER JOIN productos p ON v.id_producto = p.id_producto
INNER JOIN categorias cat ON p.id_categoria = cat.id_categoria;


SELECT 
    c.nombre,
    c.email,
    c.fecha_registro
FROM clientes c
LEFT JOIN ventas v ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL;


SELECT 
    p.nombre_producto,
    cat.nombre_categoria,
    p.precio
FROM productos p
LEFT JOIN ventas v ON p.id_producto = v.id_producto
LEFT JOIN categorias cat ON p.id_categoria = cat.id_categoria
WHERE v.id_venta IS NULL;


SELECT canal, COUNT(*) AS cantidad_ventas, SUM(total) AS total_facturado
FROM (
    SELECT 
        v.fecha_venta,
        (v.cantidad * v.precio_unitario) AS total,
        'Computación' AS canal
    FROM ventas v
    INNER JOIN productos p ON v.id_producto = p.id_producto
    INNER JOIN categorias cat ON p.id_categoria = cat.id_categoria
    WHERE cat.nombre_categoria = 'Computación'

    UNION ALL

    SELECT 
        v.fecha_venta,
        (v.cantidad * v.precio_unitario) AS total,
        'Otras categorías' AS canal
    FROM ventas v
    INNER JOIN productos p ON v.id_producto = p.id_producto
    INNER JOIN categorias cat ON p.id_categoria = cat.id_categoria
    WHERE cat.nombre_categoria != 'Computación'
) AS union_ventas
GROUP BY canal;

-- Nota: Las consultas 2 y 3 devuelven 0 filas porque, en el esquema actual,
-- todos los clientes cargados realizaron al menos una compra y todos los
-- productos tienen al menos una venta registrada. Las consultas están
-- correctamente armadas con LEFT JOIN y WHERE...IS NULL; simplemente no
-- hay casos que cumplan la condición con los datos actuales.
