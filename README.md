# retailpro-sql

Proyecto Data Analytics - Coderhouse

## Descripción

Repositorio del proyecto integrador **RetailPro**: una base de datos relacional (`Ventas_Tech_DB`) que modela las operaciones de venta de una distribuidora de tecnología, junto con las consultas SQL que responden las preguntas de negocio definidas en el brief inicial del curso.

## Modelo de datos

4 tablas relacionadas:
- **categorias** — categorías de producto (Computación, Accesorios, Audio, Almacenamiento)
- **productos** — catálogo, vinculado a categorias
- **clientes** — clientes registrados
- **ventas** — tabla de hechos, vinculada a clientes y productos

## Contenido del repositorio

| Archivo | Módulo | Descripción |
|---|---|---|
| `ventas_tech_db.sql` | M3 | DDL (creación de tablas), restricciones (PK/FK) y carga inicial de datos |
| `M4/m4_consultas_negocio.sql` | M4 | Consultas de agregación (COUNT, SUM, AVG) sobre ventas: resumen mensual, ranking de productos, clientes recurrentes |
| `m5_consultas_joins.sql` | M5 | Consultas con JOIN (vista enriquecida, clientes/productos sin ventas) y UNION ALL (consolidado por categoría) |

## Cómo usarlo

1. Ejecutar `ventas_tech_db.sql` primero — crea el esquema y carga los datos base.
2. Ejecutar los archivos de M4 y M5 sobre esa misma base para correr las consultas de análisis.

**Motor utilizado:** PostgreSQL 18
