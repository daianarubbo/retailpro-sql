# RetailPro — Base de Datos de Distribuidora Tecnológica

Este repositorio contiene la arquitectura de base de datos relacional y las consultas analíticas de SQL para **RetailPro**, un sistema diseñado para la gestión comercial y logística de una distribuidora de productos tecnológicos.

El proyecto abarca desde el modelado relacional y la definición de restricciones de integridad hasta el desarrollo de consultas avanzadas para la toma de decisiones del negocio.

---

## 🛠️ Herramientas Utilizadas

* **Sistema de Gestión de Base de Datos (SGBD):** PostgreSQL 18
* **Cliente de Administración:** pgAdmin 4
* **Control de Versiones:** GitHub

---

## 📐 Estructura de la Base de Datos (`Ventas_Tech_DB`)

El modelo consta de 4 tablas vinculadas en un esquema estrella/relacional, donde la tabla `ventas` actúa como tabla de hechos centralizada.

### Diagrama Entidad-Relación (Lógico)

* **`categorias`** `(1)` ─── `<pertenece>` ─── `(N)` **`productos`**
* **`clientes`** `(1)` ─── `<realiza>` ─── `(N)` **`ventas`**
* **`productos`** `(1)` ─── `<contenido_en>` ─── `(N)` **`ventas`**

### Detalle de Tablas

1. **`categorias`**: Catálogo de clasificaciones de productos.
   * `id_categoria` (PK, INT)
   * `nombre_categoria` (VARCHAR(50), NOT NULL)
   * `descripcion` (VARCHAR(200))
2. **`productos`**: Inventario de artículos tecnológicos.
   * `id_producto` (PK, INT)
   * `nombre_producto` (VARCHAR(100), NOT NULL)
   * `id_categoria` (FK -> `categorias.id_categoria`)
   * `precio` (DECIMAL(10,2), NOT NULL)
   * `stock` (INT, DEFAULT 0)
   * `activo` (BOOLEAN, DEFAULT TRUE)
3. **`clientes`**: Padrón de compradores registrados.
   * `id_cliente` (PK, INT)
   * `nombre` (VARCHAR(100), NOT NULL)
   * `email` (VARCHAR(100), UNIQUE)
   * `ciudad` (VARCHAR(50))
   * `fecha_registro` (DATE, NOT NULL)
4. **`ventas`**: Registro transaccional de operaciones.
   * `id_venta` (PK, INT)
   * `id_cliente` (FK -> `clientes.id_cliente`)
   * `id_producto` (FK -> `productos.id_producto`)
   * `cantidad` (INT, NOT NULL)
   * `precio_unitario` (DECIMAL(10,2), NOT NULL)
   * `fecha_venta` (DATE, NOT NULL)

---

## 🚀 Guía Paso a Paso de Ejecución

Para desplegar la base de datos y replicar los análisis, ejecute los scripts SQL presentes en el repositorio siguiendo estrictamente este orden secuencial:

### Paso 1: Creación de Estructura y Carga de Datos
Ejecutar el archivo `M3/ventas_tech_db.sql`:
1. Abrir pgAdmin 4 y conectarse al servidor de PostgreSQL 18.
2. Crear la base de datos `Ventas_Tech_DB`.
3. Abrir el *Query Tool* sobre la base de datos creada.
4. Ejecutar el script `M3/ventas_tech_db.sql` para crear las tablas, definir las claves primarias (`PK`), claves foráneas (`FK`) e insertar el conjunto de datos iniciales.

### Paso 2: Consultas de Agregación y Negocio
Ejecutar el archivo `M4/m4_consultas_negocio.sql`:
1. Cargar el script en el *Query Tool*.
2. Ejecutar las consultas de agregación que calculan métricas mensuales, rankings de facturación por producto y volumen de clientes recurrentes.

### Paso 3: Consultas de Consolidación y Uniones
Ejecutar el archivo `M5/m5_consultas_joins.sql`:
1. Cargar el script en el *Query Tool*.
2. Ejecutar las consultas complejas que combinan información entre múltiples tablas mediante operaciones `JOIN` y combinaciones sintéticas con `UNION ALL`.

---

## 📊 Ejemplos de Consultas Analíticas Principales

### 1. Resumen Mensual de Ventas (Agregación)
Consulta para obtener la facturación total, cantidad de pedidos y ticket promedio agrupado por mes:

```sql
SELECT 
    EXTRACT(MONTH FROM fecha_venta) AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado,
    COUNT(id_venta) AS cantidad_pedidos,
    ROUND(AVG(cantidad * precio_unitario), 2) AS ticket_promedio
FROM ventas
GROUP BY EXTRACT(MONTH FROM fecha_venta)
ORDER BY mes;
```

### 2. Ranking Top 5 Productos por Total Generado (JOIN + GROUP BY)
Consulta para identificar los 5 productos que aportaron mayor volumen monetario a la empresa:

```sql
SELECT 
    p.id_producto,
    p.nombre_producto,
    SUM(v.cantidad) AS unidades_vendidas,
    SUM(v.cantidad * v.precio_unitario) AS total_generado
FROM ventas v
JOIN productos p ON v.id_producto = p.id_producto
GROUP BY p.id_producto, p.nombre_producto
ORDER BY total_generado DESC
LIMIT 5;
```

### 3. Ventas de Computación vs. Otras categorías (UNION ALL)
Consulta que compara la cantidad de ventas y el total facturado de la categoría Computación frente al resto de las categorías:

```sql
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
```
