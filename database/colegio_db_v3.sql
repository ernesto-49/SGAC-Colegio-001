-- =====================================================================
-- Script de creacion de la base de datos: colegio_db
-- Sistema de registros academicos del colegio (Primaria y Secundaria)
-- Generado el 2026-10-07 a partir de modelo_datos.py
--
-- Contenido:
--   1. Creacion de la base de datos (si no existe)
--   2. Creacion de las 16 tablas con PK, UNIQUE, CHECK y DEFAULT
--   3. Claves foraneas (FK)
--   4. Trigger TRG_MATRICULA_unica_por_anio:
--      un estudiante no puede matricularse en dos secciones del mismo anio escolar
-- =====================================================================

IF DB_ID('colegio_db') IS NULL
    CREATE DATABASE [colegio_db];
GO
USE [colegio_db];
GO

CREATE TABLE [INSTITUCION] (
    [id_institucion] INT IDENTITY(1,1) NOT NULL,
    [codigo_modular] VARCHAR(10) NOT NULL,
    [nombre] VARCHAR(150) NOT NULL,
    [direccion] VARCHAR(200) NULL,
    [telefono] VARCHAR(20) NULL,
    [correo] VARCHAR(100) NULL,
    [pagina_web] VARCHAR(150) NULL,
    [logo] VARCHAR(255) NULL,
    [estado] BIT NOT NULL DEFAULT (1),
    CONSTRAINT [PK_INSTITUCION] PRIMARY KEY ([id_institucion])
);
GO

CREATE TABLE [NIVEL] (
    [id_nivel] INT IDENTITY(1,1) NOT NULL,
    [nombre] VARCHAR(50) NOT NULL,
    CONSTRAINT [PK_NIVEL] PRIMARY KEY ([id_nivel])
);
GO

CREATE TABLE [GRADO] (
    [id_grado] INT IDENTITY(1,1) NOT NULL,
    [id_nivel] INT NOT NULL,
    [nombre] VARCHAR(20) NOT NULL,
    CONSTRAINT [PK_GRADO] PRIMARY KEY ([id_grado])
);
GO

CREATE TABLE [ANIO_ESCOLAR] (
    [id_anio] INT IDENTITY(1,1) NOT NULL,
    [anio] INT NOT NULL,
    [fecha_inicio] DATE NOT NULL,
    [fecha_fin] DATE NOT NULL,
    CONSTRAINT [PK_ANIO_ESCOLAR] PRIMARY KEY ([id_anio]),
    CONSTRAINT [CK_ANIO_ESCOLAR_fecha_fin] CHECK (fecha_fin >= fecha_inicio)
);
GO

CREATE TABLE [PERIODO] (
    [id_periodo] INT IDENTITY(1,1) NOT NULL,
    [id_anio] INT NOT NULL,
    [bimestre] TINYINT NOT NULL,
    [fecha_inicio] DATE NOT NULL,
    [fecha_fin] DATE NOT NULL,
    CONSTRAINT [PK_PERIODO] PRIMARY KEY ([id_periodo]),
    CONSTRAINT [UQ_PERIODO_id_anio_bimestre] UNIQUE ([id_anio], [bimestre]),
    CONSTRAINT [CK_PERIODO_bimestre] CHECK (bimestre BETWEEN 1 AND 4),
    CONSTRAINT [CK_PERIODO_fecha_fin] CHECK (fecha_fin >= fecha_inicio)
);
GO

CREATE TABLE [PERSONAL] (
    [id_personal] INT IDENTITY(1,1) NOT NULL,
    [tipo_documento] VARCHAR(20) NOT NULL,
    [nro_documento] VARCHAR(15) NOT NULL,
    [ap_paterno] VARCHAR(50) NOT NULL,
    [ap_materno] VARCHAR(50) NOT NULL,
    [nombres] VARCHAR(80) NOT NULL,
    [sexo] CHAR(1) NULL,
    [fecha_nacimiento] DATE NULL,
    [nro_colegiatura] VARCHAR(20) NULL,
    [especialidad] VARCHAR(100) NULL,
    [telefono] VARCHAR(20) NULL,
    [correo] VARCHAR(100) NULL,
    [estado] BIT NOT NULL DEFAULT (1),
    CONSTRAINT [PK_PERSONAL] PRIMARY KEY ([id_personal]),
    CONSTRAINT [CK_PERSONAL_sexo] CHECK (sexo IN ('M','F'))
);
GO

CREATE TABLE [SECCION] (
    [id_seccion] INT IDENTITY(1,1) NOT NULL,
    [id_grado] INT NOT NULL,
    [id_anio] INT NOT NULL,
    [nombre] VARCHAR(5) NOT NULL,
    [id_personal] INT NULL,
    [aula] VARCHAR(20) NULL,
    [capacidad_max] INT NULL,
    [turno] VARCHAR(20) NULL,
    [estado] BIT NOT NULL DEFAULT (1),
    CONSTRAINT [PK_SECCION] PRIMARY KEY ([id_seccion]),
    CONSTRAINT [UQ_SECCION_id_grado_id_anio_nombre] UNIQUE ([id_grado], [id_anio], [nombre]),
    CONSTRAINT [CK_SECCION_capacidad_max] CHECK (capacidad_max > 0)
);
GO

CREATE TABLE [ASIGNATURA] (
    [id_asignatura] INT IDENTITY(1,1) NOT NULL,
    [codigo] VARCHAR(20) NOT NULL,
    [nombre] VARCHAR(100) NOT NULL,
    [id_grado] INT NOT NULL,
    [id_personal] INT NULL,
    [aula] VARCHAR(20) NULL,
    [id_anio] INT NOT NULL,
    [estado] BIT NOT NULL DEFAULT (1),
    CONSTRAINT [PK_ASIGNATURA] PRIMARY KEY ([id_asignatura])
);
GO

CREATE TABLE [ESTUDIANTE] (
    [id_estudiante] INT IDENTITY(1,1) NOT NULL,
    [nombres] VARCHAR(80) NOT NULL,
    [ap_paterno] VARCHAR(50) NOT NULL,
    [ap_materno] VARCHAR(50) NOT NULL,
    [sexo] CHAR(1) NULL,
    [tipo_documento] VARCHAR(20) NOT NULL,
    [nro_documento] VARCHAR(15) NOT NULL,
    [fecha_nacimiento] DATE NULL,
    [telefono] VARCHAR(20) NULL,
    [celular] VARCHAR(20) NULL,
    [correo] VARCHAR(100) NULL,
    [direccion] VARCHAR(200) NULL,
    [foto] VARCHAR(255) NULL,
    [estado] BIT NOT NULL DEFAULT (1),
    CONSTRAINT [PK_ESTUDIANTE] PRIMARY KEY ([id_estudiante]),
    CONSTRAINT [CK_ESTUDIANTE_sexo] CHECK (sexo IN ('M','F'))
);
GO

CREATE TABLE [APODERADO] (
    [id_apoderado] INT IDENTITY(1,1) NOT NULL,
    [ap_paterno] VARCHAR(50) NOT NULL,
    [ap_materno] VARCHAR(50) NOT NULL,
    [nombres] VARCHAR(80) NOT NULL,
    [dni] VARCHAR(15) NOT NULL,
    [parentesco] VARCHAR(30) NULL,
    [domicilio] VARCHAR(200) NULL,
    [centro_trabajo] VARCHAR(150) NULL,
    [telefono] VARCHAR(20) NULL,
    [email] VARCHAR(100) NULL,
    [estado] BIT NOT NULL DEFAULT (1),
    CONSTRAINT [PK_APODERADO] PRIMARY KEY ([id_apoderado])
);
GO

CREATE TABLE [MATRICULA] (
    [id_matricula] INT IDENTITY(1,1) NOT NULL,
    [id_estudiante] INT NOT NULL,
    [id_seccion] INT NOT NULL,
    [fecha_matricula] DATE NOT NULL,
    CONSTRAINT [PK_MATRICULA] PRIMARY KEY ([id_matricula]),
    CONSTRAINT [UQ_MATRICULA_id_estudiante_id_seccion] UNIQUE ([id_estudiante], [id_seccion])
);
GO

CREATE TABLE [APODERADO_ESTUDIANTE] (
    [id_apoderado] INT NOT NULL,
    [id_estudiante] INT NOT NULL,
    CONSTRAINT [PK_APODERADO_ESTUDIANTE] PRIMARY KEY ([id_apoderado], [id_estudiante])
);
GO

CREATE TABLE [HORARIO] (
    [id_horario] INT IDENTITY(1,1) NOT NULL,
    [id_seccion] INT NOT NULL,
    [id_asignatura] INT NOT NULL,
    [id_personal] INT NOT NULL,
    [dia] VARCHAR(15) NOT NULL,
    [hora_inicio] TIME NOT NULL,
    [hora_fin] TIME NOT NULL,
    [estado] BIT NOT NULL DEFAULT (1),
    CONSTRAINT [PK_HORARIO] PRIMARY KEY ([id_horario]),
    CONSTRAINT [UQ_HORARIO_id_seccion_dia_hora_inicio] UNIQUE ([id_seccion], [dia], [hora_inicio]),
    CONSTRAINT [CK_HORARIO_hora_fin] CHECK (hora_fin > hora_inicio)
);
GO

CREATE TABLE [USUARIO] (
    [id_usuario] INT IDENTITY(1,1) NOT NULL,
    [username] VARCHAR(50) NOT NULL,
    [clave_hash] VARCHAR(255) NOT NULL,
    [correo] VARCHAR(100) NULL,
    [rol] VARCHAR(20) NOT NULL,
    [id_personal] INT NULL,
    [id_apoderado] INT NULL,
    [id_estudiante] INT NULL,
    [estado] BIT NOT NULL DEFAULT (1),
    CONSTRAINT [PK_USUARIO] PRIMARY KEY ([id_usuario]),
    CONSTRAINT [CK_USUARIO_rol] CHECK (rol IN ('director','administrativo','docente','apoderado','estudiante'))
);
GO

CREATE TABLE [NOTA] (
    [id_nota] INT IDENTITY(1,1) NOT NULL,
    [id_matricula] INT NOT NULL,
    [id_asignatura] INT NOT NULL,
    [id_periodo] INT NOT NULL,
    [tipo_evaluacion] VARCHAR(50) NULL,
    [nota_num] DECIMAL(4,2) NULL,
    [nota_literal] CHAR(2) NULL,
    [observaciones] VARCHAR(255) NULL,
    CONSTRAINT [PK_NOTA] PRIMARY KEY ([id_nota]),
    CONSTRAINT [UQ_NOTA_id_matricula_id_asignatura_id_periodo_tipo_evaluacion] UNIQUE ([id_matricula], [id_asignatura], [id_periodo], [tipo_evaluacion]),
    CONSTRAINT [CK_NOTA_nota_num] CHECK (nota_num BETWEEN 0 AND 20),
    CONSTRAINT [CK_NOTA_nota_literal] CHECK (nota_literal IN ('AD','A','B','C')),
    CONSTRAINT [CK_NOTA_chk1] CHECK ((nota_num IS NOT NULL AND nota_literal IS NULL) OR (nota_num IS NULL AND nota_literal IS NOT NULL))
);
GO

CREATE TABLE [ASISTENCIA] (
    [id_asistencia] INT IDENTITY(1,1) NOT NULL,
    [id_matricula] INT NOT NULL,
    [fecha] DATE NOT NULL,
    [estado_asistencia] VARCHAR(20) NOT NULL,
    [observaciones] VARCHAR(255) NULL,
    CONSTRAINT [PK_ASISTENCIA] PRIMARY KEY ([id_asistencia]),
    CONSTRAINT [UQ_ASISTENCIA_id_matricula_fecha] UNIQUE ([id_matricula], [fecha]),
    CONSTRAINT [CK_ASISTENCIA_estado_asistencia] CHECK (estado_asistencia IN ('asistio','tardanza','falta','justificada'))
);
GO

ALTER TABLE [GRADO] ADD CONSTRAINT [FK_GRADO_id_nivel] FOREIGN KEY ([id_nivel]) REFERENCES [NIVEL]([id_nivel]);
GO

ALTER TABLE [PERIODO] ADD CONSTRAINT [FK_PERIODO_id_anio] FOREIGN KEY ([id_anio]) REFERENCES [ANIO_ESCOLAR]([id_anio]);
GO

ALTER TABLE [SECCION] ADD CONSTRAINT [FK_SECCION_id_grado] FOREIGN KEY ([id_grado]) REFERENCES [GRADO]([id_grado]);
GO

ALTER TABLE [SECCION] ADD CONSTRAINT [FK_SECCION_id_anio] FOREIGN KEY ([id_anio]) REFERENCES [ANIO_ESCOLAR]([id_anio]);
GO

ALTER TABLE [SECCION] ADD CONSTRAINT [FK_SECCION_id_personal] FOREIGN KEY ([id_personal]) REFERENCES [PERSONAL]([id_personal]);
GO

ALTER TABLE [ASIGNATURA] ADD CONSTRAINT [FK_ASIGNATURA_id_grado] FOREIGN KEY ([id_grado]) REFERENCES [GRADO]([id_grado]);
GO

ALTER TABLE [ASIGNATURA] ADD CONSTRAINT [FK_ASIGNATURA_id_personal] FOREIGN KEY ([id_personal]) REFERENCES [PERSONAL]([id_personal]);
GO

ALTER TABLE [ASIGNATURA] ADD CONSTRAINT [FK_ASIGNATURA_id_anio] FOREIGN KEY ([id_anio]) REFERENCES [ANIO_ESCOLAR]([id_anio]);
GO

ALTER TABLE [MATRICULA] ADD CONSTRAINT [FK_MATRICULA_id_estudiante] FOREIGN KEY ([id_estudiante]) REFERENCES [ESTUDIANTE]([id_estudiante]);
GO

ALTER TABLE [MATRICULA] ADD CONSTRAINT [FK_MATRICULA_id_seccion] FOREIGN KEY ([id_seccion]) REFERENCES [SECCION]([id_seccion]);
GO

ALTER TABLE [APODERADO_ESTUDIANTE] ADD CONSTRAINT [FK_APODERADO_ESTUDIANTE_id_apoderado] FOREIGN KEY ([id_apoderado]) REFERENCES [APODERADO]([id_apoderado]);
GO

ALTER TABLE [APODERADO_ESTUDIANTE] ADD CONSTRAINT [FK_APODERADO_ESTUDIANTE_id_estudiante] FOREIGN KEY ([id_estudiante]) REFERENCES [ESTUDIANTE]([id_estudiante]);
GO

ALTER TABLE [HORARIO] ADD CONSTRAINT [FK_HORARIO_id_seccion] FOREIGN KEY ([id_seccion]) REFERENCES [SECCION]([id_seccion]);
GO

ALTER TABLE [HORARIO] ADD CONSTRAINT [FK_HORARIO_id_asignatura] FOREIGN KEY ([id_asignatura]) REFERENCES [ASIGNATURA]([id_asignatura]);
GO

ALTER TABLE [HORARIO] ADD CONSTRAINT [FK_HORARIO_id_personal] FOREIGN KEY ([id_personal]) REFERENCES [PERSONAL]([id_personal]);
GO

ALTER TABLE [USUARIO] ADD CONSTRAINT [FK_USUARIO_id_personal] FOREIGN KEY ([id_personal]) REFERENCES [PERSONAL]([id_personal]);
GO

ALTER TABLE [USUARIO] ADD CONSTRAINT [FK_USUARIO_id_apoderado] FOREIGN KEY ([id_apoderado]) REFERENCES [APODERADO]([id_apoderado]);
GO

ALTER TABLE [USUARIO] ADD CONSTRAINT [FK_USUARIO_id_estudiante] FOREIGN KEY ([id_estudiante]) REFERENCES [ESTUDIANTE]([id_estudiante]);
GO

ALTER TABLE [NOTA] ADD CONSTRAINT [FK_NOTA_id_matricula] FOREIGN KEY ([id_matricula]) REFERENCES [MATRICULA]([id_matricula]);
GO

ALTER TABLE [NOTA] ADD CONSTRAINT [FK_NOTA_id_asignatura] FOREIGN KEY ([id_asignatura]) REFERENCES [ASIGNATURA]([id_asignatura]);
GO

ALTER TABLE [NOTA] ADD CONSTRAINT [FK_NOTA_id_periodo] FOREIGN KEY ([id_periodo]) REFERENCES [PERIODO]([id_periodo]);
GO

ALTER TABLE [ASISTENCIA] ADD CONSTRAINT [FK_ASISTENCIA_id_matricula] FOREIGN KEY ([id_matricula]) REFERENCES [MATRICULA]([id_matricula]);
GO

-- Trigger: un estudiante no puede tener matricula en dos secciones
-- del mismo anio escolar (la regla no puede ser UNIQUE porque el anio
-- se obtiene por JOIN con SECCION).
CREATE TRIGGER [TRG_MATRICULA_unica_por_anio]
ON [MATRICULA]
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN [SECCION] s_new ON s_new.[id_seccion] = i.[id_seccion]
        JOIN [MATRICULA] m ON m.[id_estudiante] = i.[id_estudiante]
                           AND m.[id_matricula] <> i.[id_matricula]
        JOIN [SECCION] s_old ON s_old.[id_seccion] = m.[id_seccion]
        WHERE s_new.[id_anio] = s_old.[id_anio]
    )
    BEGIN
        RAISERROR('El estudiante ya tiene matricula en otra seccion del mismo anio escolar.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO
