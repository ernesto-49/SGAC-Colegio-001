# 🏫 Sistema de Gestión Académica (SGAC) - Base de Datos

Este repositorio contiene la estructura e implementación en **Microsoft SQL Server** de la base de datos para el **Sistema de Gestión Académica (SGAC) - Colegio 001 José Lishner Tudela**.

---

## 📊 Características de la Base de Datos

- **Motor:** Microsoft SQL Server
- **Tablas:** 16 tablas relacionales normalizadas en Tercera Forma Normal (3FN).
- **Validaciones Integradas:**
  - Control de calificaciones cualitativas (Primaria) y numéricas (Secundaria).
  - Regla de negocio con Trigger `TRG_MATRICULA_unica_por_anio` para prevenir duplicados de matrícula en el mismo periodo escolar.
  - Restricciones `CHECK` para formatos de DNI, correos y tipos de evaluaciones/asistencias.

---

## 📁 Estructura del Repositorio

- `database/colegio_db_v3.sql`: Script DDL para creación de la base de datos, tablas, claves primarias/foráneas y triggers.
- `database/datos_prueba.sql`: Script DML cargado con datos de prueba realistas para institución, estudiantes, matrículas, asignaturas, notas y asistencias.

---

## 🚀 Instrucciones de Despliegue

1. Clonar el repositorio:
   ```bash
   git clone [https://github.com/TU_USUARIO/SGAC-Colegio-DB.git](https://github.com/TU_USUARIO/SGAC-Colegio-DB.git)