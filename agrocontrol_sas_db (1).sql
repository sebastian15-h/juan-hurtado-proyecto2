-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 22-09-2025 a las 16:54:22
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `agrocontrol_sas_db`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `actualizar_cultivo` (IN `p_id_cultivo` INT, IN `p_nombre_cientifico` VARCHAR(100), IN `p_nombre_comun` VARCHAR(100), IN `p_tiempo_crecimiento_dias` INT, IN `p_temperaturas_optimas` FLOAT, IN `p_requerimiento_agua_semanal` VARCHAR(225), IN `p_photo` VARCHAR(255))   BEGIN
    UPDATE cultivos
    SET
        nombre_cientifico = p_nombre_cientifico,
        nombre_comun = p_nombre_comun,
        tiempo_crecimiento_dias = p_tiempo_crecimiento_dias,
        temperaturas_optimas = p_temperaturas_optimas,
        requerimiento_agua_semanal = p_requerimiento_agua_semanal,
        photo = p_photo
    WHERE id_cultivo = p_id_cultivo;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `actualizar_empleado` (IN `p_id_empleado` INT, IN `p_DNI` VARCHAR(15), IN `p_nombre` VARCHAR(50), IN `p_apellido` VARCHAR(50), IN `p_fecha_nacimiento` DATE, IN `p_telefono` VARCHAR(20), IN `p_especialidad` VARCHAR(25), IN `p_fecha_contratacion` DATE, IN `p_salario` FLOAT, IN `p_area_asignada` VARCHAR(50), IN `p_fecha_fin_contrato` DATE, IN `p_photo` VARCHAR(255))   BEGIN
    UPDATE empleados
    SET 
        DNI = p_DNI,
        nombre = p_nombre,
        apellido = p_apellido,
        fecha_nacimiento = p_fecha_nacimiento,
        telefono = p_telefono,
        especialidad = p_especialidad,
        fecha_contratacion = p_fecha_contratacion,
        salario = p_salario,
        area_asignada = p_area_asignada,
        fecha_fin_contrato = p_fecha_fin_contrato,
        photo = p_photo
    WHERE id_empleado = p_id_empleado;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `actualizar_finca` (IN `p_id_finca` INT, IN `p_nombre` VARCHAR(100), IN `p_latitud` FLOAT, IN `p_longitud` FLOAT, IN `p_hectareas` FLOAT, IN `p_altitud` INT, IN `p_temperatura` FLOAT, IN `p_tipo_suelo` VARCHAR(50), IN `p_region` VARCHAR(100))   BEGIN
    UPDATE fincas
    SET nombre = p_nombre,
        latitud = p_latitud,
        longitud = p_longitud,
        extension_total_hectareas = p_hectareas,
        altitud_metros = p_altitud,
        temperatura_promedio_anual_fg = p_temperatura,
        tipo_suelo_predominante = p_tipo_suelo,
        region_ubicacion = p_region
    WHERE id_finca = p_id_finca;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `actualizar_parcela` (IN `p_id_parcela` INT, IN `p_area` FLOAT, IN `p_sistema_riego` VARCHAR(50), IN `p_historial_uso` VARCHAR(200), IN `p_id_finca` INT)   BEGIN
    UPDATE parcelas
    SET AREA_HECTAREAS_PARCELAS = p_area,
        SISTEMA_RIEGO = p_sistema_riego,
        HISTORIAL_DE_USO = p_historial_uso,
        id_finca = p_id_finca
    WHERE ID_PARCELA = p_id_parcela;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `BuscarCultivoPorID` (IN `_id_cultivo` INT)   BEGIN
    SELECT 
        id_cultivo,
        nombre_cientifico,
        nombre_comun,
        tiempo_crecimiento_dias,
        temperaturas_optimas,
        requerimiento_agua_semanal,
        photo
    FROM cultivos
    WHERE id_cultivo = _id_cultivo;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `eliminar_cultivo` (IN `p_id_cultivo` INT)   BEGIN
    DELETE FROM cultivos WHERE id_cultivo = p_id_cultivo;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `eliminar_empleado` (IN `p_id_empleado` INT)   BEGIN
    DELETE FROM empleados WHERE id_empleado = p_id_empleado;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `eliminar_finca` (IN `nombre_finca` VARCHAR(100))   BEGIN
    DELETE FROM fincas WHERE NOMBRE = nombre_finca;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `eliminar_parcela` (IN `p_id_parcela` INT)   BEGIN
    DELETE FROM PARCELAS WHERE ID_PARCELA = p_id_parcela;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_buscar_empleado_por_id` (IN `p_id_empleado` INT)   BEGIN
    SELECT 
        id_empleado,
        DNI,
        nombre,
        apellido,
        fecha_nacimiento,
        telefono,
        direccion,
        especialidad,
        fecha_contratacion,
        salario,
        area_asignada,
        fecha_fin_contrato,
        photo
    FROM empleados
    WHERE id_empleado = p_id_empleado;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_GetFincaByName` (IN `p_Nombre` VARCHAR(100))   BEGIN
    SELECT 
        ID_FINCA,
        NOMBRE,
        latitud,
        longitud,
        EXTENSION_TOTAL_HECTAREAS,
        ALTITUD_METROS,
        TEMPERATURA_PROMEDIO_ANUAL_fg,
        TIPO_SUELO_PREdOMINANTE,
        region_ubicacion
    FROM FINCAS
    WHERE LOWER(NOMBRE) LIKE LOWER(CONCAT('%', p_Nombre, '%'));
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_GetParcelaByID` (IN `p_ID` INT)   BEGIN
    SELECT 
        ID_PARCELA,
        AREA_HECTAREAS_PARCELAS,
        SISTEMA_RIEGO,
        HISTORIAL_DE_USO,
        id_finca
    FROM PARCELAS
    WHERE ID_PARCELA = p_ID;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_insertCultivo` (IN `p_nombre_cientifico` VARCHAR(100), IN `p_nombre_comun` VARCHAR(100), IN `p_tiempo_crecimiento_dias` INT, IN `p_temperaturas_optimas` FLOAT, IN `p_requerimiento_agua_semanal` VARCHAR(225), IN `p_photo` VARCHAR(255))   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    INSERT INTO cultivos (
        nombre_cientifico, 
        nombre_comun, 
        tiempo_crecimiento_dias, 
        temperaturas_optimas, 
        requerimiento_agua_semanal,
        photo
    )
    VALUES (
        p_nombre_cientifico, 
        p_nombre_comun, 
        p_tiempo_crecimiento_dias, 
        p_temperaturas_optimas, 
        p_requerimiento_agua_semanal,
        p_photo
    );

    COMMIT;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_insertEmpleado` (IN `p_DNI` VARCHAR(15), IN `p_nombre` VARCHAR(50), IN `p_apellido` VARCHAR(50), IN `p_fecha_nacimiento` DATE, IN `p_telefono` VARCHAR(20), IN `p_direccion` VARCHAR(100), IN `p_especialidad` VARCHAR(25), IN `p_fecha_contratacion` DATE, IN `p_salario` FLOAT, IN `p_area_asignada` VARCHAR(50), IN `p_fecha_fin_contrato` DATE, IN `p_photo` DATE)   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    INSERT INTO empleados (
        DNI,
        nombre,
        apellido,
        fecha_nacimiento,
        telefono,
        direccion,
        especialidad,
        fecha_contratacion,
        salario,
        area_asignada,
        fecha_fin_contrato,
        photo
    )
    VALUES (
        p_DNI,
        p_nombre,
        p_apellido,
        p_fecha_nacimiento,
        p_telefono,
        p_direccion,
        p_especialidad,
        p_fecha_contratacion,
        p_salario,
        p_area_asignada,
        p_fecha_fin_contrato,
        p_photo
    );

    COMMIT;

    SELECT LAST_INSERT_ID() AS id_empleado, 'Empleado insertado correctamente' AS Message;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_insertfinca` (IN `f_NOMBRE` VARCHAR(100), IN `f_LATITUD` FLOAT, IN `f_LONGITUD` FLOAT, IN `f_EXTENSION_TOTAL_HECTAREAS` FLOAT, IN `f_ALTITUD_METROS` INT, IN `f_TEMPERATURA_PROMEDIO_ANUAL_fg` INT, IN `f_TIPO_SUELO_PREDOMINANTE` VARCHAR(50), IN `f_region_ubicacion` VARCHAR(100))   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;
    
    INSERT INTO FINCAS(
        NOMBRE,
        LATITUD,
        LONGITUD,
        EXTENSION_TOTAL_HECTAREAS,
        ALTITUD_METROS,
        TEMPERATURA_PROMEDIO_ANUAL_fg,
        TIPO_SUELO_PREdOMINANTE,
        region_ubicacion
    )
    VALUES (
        f_NOMBRE,
        f_LATITUD,
        f_LONGITUD,
        f_EXTENSION_TOTAL_HECTAREAS,
        f_ALTITUD_METROS,
        f_TEMPERATURA_PROMEDIO_ANUAL_fg,
        f_TIPO_SUELO_PREDOMINANTE,
        f_region_ubicacion
    );
    
    COMMIT;

    SELECT LAST_INSERT_ID() AS ID_FINCA, 'Finca insertada correctamente' AS Message;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_insertparcela` (IN `p_AREA_HECTAREAS_PARCELAS` FLOAT, IN `p_SISTEMA_RIEGO` VARCHAR(50), IN `p_HISTORIAL_DE_USO` VARCHAR(200), IN `p_id_finca` INT)   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    INSERT INTO PARCELAS(AREA_HECTAREAS_PARCELAS, SISTEMA_RIEGO, HISTORIAL_DE_USO, id_finca)
    VALUES (p_AREA_HECTAREAS_PARCELAS, p_SISTEMA_RIEGO, p_HISTORIAL_DE_USO, p_id_finca);

    COMMIT;

    SELECT LAST_INSERT_ID() AS ID_PARCELA, 'Parcela insertada correctamente' AS Message;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_updatefincas` (IN `f_ID_FINCA` INT, IN `f_NOMBRE` VARCHAR(100), IN `f_LATITUD` FLOAT, IN `f_LONGITUD` FLOAT, IN `f_EXTENSION_TOTAL_HECTAREAS` FLOAT, IN `f_ALTITUD_METROS` INT, IN `f_TEMPERATURA_PROMEDIO_ANUAL_fg` INT, IN `f_TIPO_SUELO_PREDOMINANTE` VARCHAR(50), IN `f_region_ubicacion` VARCHAR(100))   BEGIN
    DECLARE v_count INT DEFAULT 0;

    -- Manejador de errores
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    -- Validar existencia de la finca
    SELECT COUNT(*) INTO v_count FROM fincas WHERE id_finca = f_ID_FINCA;

    IF v_count = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La finca no existe';
    ELSE
        -- Actualizar finca
        UPDATE fincas
        SET nombre = f_NOMBRE,
            latitud = f_LATITUD,
            longitud = f_LONGITUD,
            extension_total_hectareas = f_EXTENSION_TOTAL_HECTAREAS,
            altitud_metros = f_ALTITUD_METROS,
            temperatura_promedio_anual_fg = f_TEMPERATURA_PROMEDIO_ANUAL_fg,
            tipo_suelo_predominante = f_TIPO_SUELO_PREDOMINANTE,
            region_ubicacion = f_region_ubicacion
        WHERE id_finca = f_ID_FINCA;

        COMMIT;

        -- Mensaje de éxito
        SELECT 'Finca actualizada correctamente' AS Message;
    END IF;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `alertas_empleados`
--

CREATE TABLE `alertas_empleados` (
  `id_alerta` int(11) NOT NULL,
  `id_empleado` int(11) NOT NULL,
  `mensaje` varchar(255) DEFAULT NULL,
  `fecha_alerta` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `alertas_insumos`
--

CREATE TABLE `alertas_insumos` (
  `id_alerta` int(11) NOT NULL,
  `id_insumos` int(10) NOT NULL,
  `fecha_alerta` date NOT NULL DEFAULT curdate(),
  `fecha_caducidad` date NOT NULL,
  `dias_restantes` int(11) NOT NULL,
  `estado` varchar(20) DEFAULT 'Pendiente'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `alertas_maquinaria`
--

CREATE TABLE `alertas_maquinaria` (
  `id_alerta` int(11) NOT NULL,
  `id_maquinaria` int(10) NOT NULL,
  `alertas` text NOT NULL,
  `fecha_alerta` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `analisis_de_suelos`
--

CREATE TABLE `analisis_de_suelos` (
  `ID_NALISIS_DE_SUELOS` int(10) NOT NULL,
  `FECHA_DE_MUESTREO` date NOT NULL,
  `ID_PARCELA` int(10) NOT NULL,
  `PH` float DEFAULT NULL,
  `nutrientes_n` float DEFAULT NULL,
  `nutrientes_p` float DEFAULT NULL,
  `nutrientes_k` float DEFAULT NULL,
  `MATERIA_ORGANICA` float DEFAULT NULL,
  `CONDUCTIVIDAD_ELECTRICA` float DEFAULT NULL,
  `LABORATORIO` varchar(100) DEFAULT NULL,
  `RECOMENDACIONES` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `analisis_de_suelos`
--

INSERT INTO `analisis_de_suelos` (`ID_NALISIS_DE_SUELOS`, `FECHA_DE_MUESTREO`, `ID_PARCELA`, `PH`, `nutrientes_n`, `nutrientes_p`, `nutrientes_k`, `MATERIA_ORGANICA`, `CONDUCTIVIDAD_ELECTRICA`, `LABORATORIO`, `RECOMENDACIONES`) VALUES
(1, '2025-02-12', 1, 6.2, 30.8, 12.56, 34.67, 3.2, 0.8, 'laboratorio agrotest', 'mal estado agregar cal para mejorar ph'),
(2, '2024-01-23', 2, 7, 13.89, 45, 55.11, 4.3, 1, 'analisuelo', 'buena cantidad de cal mantener cantidad'),
(3, '2024-02-15', 3, 9, 78.9, 34.56, 12.56, 2.9, 0.5, 'laboratorio agriola sur', 'buen estado sin recomendaciones'),
(4, '2024-03-28', 4, 10, 32.34, 67.32, 10.1, 3.8, 0.6, 'test phlab', 'buen estado sin recomendaciones');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `asignacion_de_trabajo`
--

CREATE TABLE `asignacion_de_trabajo` (
  `id_asignacion_de_trabajo` int(11) NOT NULL,
  `id_empleado` int(10) DEFAULT NULL,
  `tarea_empleado` varchar(50) DEFAULT NULL,
  `id_parcela` int(10) DEFAULT NULL,
  `fecha_de_asignacion` date NOT NULL,
  `horas_trabajadas` int(11) DEFAULT NULL,
  `observaciones` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `asignacion_de_trabajo`
--

INSERT INTO `asignacion_de_trabajo` (`id_asignacion_de_trabajo`, `id_empleado`, `tarea_empleado`, `id_parcela`, `fecha_de_asignacion`, `horas_trabajadas`, `observaciones`) VALUES
(111, 1, 'inspeccion de cultivo', 1, '2025-03-22', 6, 'se recomienda utilizar fertilizante fk'),
(222, 2, 'mantenimiento del sistema de riego', 2, '2025-03-12', 7, 'funcionando correctamente'),
(333, 3, 'fumigacion con insecticida', 3, '2025-04-11', 4, 'apliacion de plaguicidas'),
(444, 4, 'elaborador del reporte financiero', 4, '2025-05-26', 8, 'registros de ingreos y egresos');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `asignacion_empleado`
--

CREATE TABLE `asignacion_empleado` (
  `id_asig_empleado` int(10) NOT NULL,
  `id_empleado` int(10) NOT NULL,
  `id_asignacion_de_trabajo` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `asignacion_empleado`
--

INSERT INTO `asignacion_empleado` (`id_asig_empleado`, `id_empleado`, `id_asignacion_de_trabajo`) VALUES
(1, 1, 111),
(2, 2, 222),
(3, 3, 333),
(4, 4, 444);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `clientes`
--

CREATE TABLE `clientes` (
  `id_cliente` int(10) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `apellido` varchar(50) NOT NULL,
  `DNI` int(10) NOT NULL,
  `direccion_fiscal` varchar(100) DEFAULT NULL,
  `telefono` int(15) DEFAULT NULL,
  `CORREO` varchar(100) DEFAULT NULL,
  `LINEA_CREDITO` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `clientes`
--

INSERT INTO `clientes` (`id_cliente`, `nombre`, `apellido`, `DNI`, `direccion_fiscal`, `telefono`, `CORREO`, `LINEA_CREDITO`) VALUES
(101101, 'carlos', 'londoño', 19785964, 'calle-12 #05-77', 67349456, 'carloslondo@gmail.com', 500),
(202202, 'juan', 'castrillon', 37906543, 'calle-62 #98-07', 30158757, 'juannn123@gmail.com', 700),
(303303, 'david', 'herrera', 1267890541, 'calle-78 #65-12', 311005643, 'herreradavid12@gmail.com', 123),
(404404, 'faber', 'ramos', 10869263, 'calle-90 #40-34', 39871567, 'fabertakaramos@gmail.com', 100);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cosechas`
--

CREATE TABLE `cosechas` (
  `id_cosecha` int(10) NOT NULL,
  `id_parcela` int(10) NOT NULL,
  `id_cultivo` int(10) NOT NULL,
  `fecha_inicio_cosecha` date NOT NULL,
  `fecha_fin_cosecha` date DEFAULT NULL,
  `cantidad_recolectada` float DEFAULT NULL,
  `calidad_del_producto` varchar(50) DEFAULT NULL,
  `metodo_de_cosecha` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `cosechas`
--

INSERT INTO `cosechas` (`id_cosecha`, `id_parcela`, `id_cultivo`, `fecha_inicio_cosecha`, `fecha_fin_cosecha`, `cantidad_recolectada`, `calidad_del_producto`, `metodo_de_cosecha`) VALUES
(11, 1, 101, '2024-01-01', '2025-03-01', 200, 'apto para exportacion', 'mecanizada'),
(22, 2, 102, '2024-02-11', '2025-03-29', 150, 'primera calidad', 'manual'),
(33, 3, 103, '2025-04-13', '2025-05-01', 300, 'segunda calidad', 'manual'),
(44, 4, 104, '2025-01-09', '2025-01-31', 243, 'primera calidad', 'manual');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `costos_por_parcela`
--

CREATE TABLE `costos_por_parcela` (
  `id_parcela` int(11) NOT NULL,
  `id_finca` int(11) NOT NULL,
  `costo_laboral` float DEFAULT 0,
  `costo_insumos` float DEFAULT 0,
  `costo_total` float DEFAULT 0,
  `fecha_actualizacion` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cultivos`
--

CREATE TABLE `cultivos` (
  `id_cultivo` int(10) NOT NULL,
  `nombre_cientifico` varchar(100) NOT NULL,
  `nombre_comun` varchar(100) NOT NULL,
  `tiempo_crecimiento_dias` int(11) NOT NULL,
  `temperaturas_optimas` float DEFAULT NULL,
  `requerimiento_agua_semanal` varchar(225) DEFAULT NULL,
  `photo` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `cultivos`
--

INSERT INTO `cultivos` (`id_cultivo`, `nombre_cientifico`, `nombre_comun`, `tiempo_crecimiento_dias`, `temperaturas_optimas`, `requerimiento_agua_semanal`, `photo`) VALUES
(101, 'zea mays', 'maiz', 120, 25.5, '550-800 mm/ciclo', NULL),
(102, 'Fragaria', 'fresa', 40, 20.12, '600-700mm/ciclo', NULL),
(103, 'Musa paradisiaca', 'platano', 273, 21.23, '25-40mm/ciclo', NULL),
(104, 'Cocos nucifera', 'coco', 365, 23.43, '25-40mm/ciclo', NULL),
(109, 'CIRUELALA', 'CIRUELA', 45, 34, '12121', '0000-00-00');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `empleados`
--

CREATE TABLE `empleados` (
  `id_empleado` int(10) NOT NULL,
  `DNI` varchar(15) DEFAULT NULL,
  `nombre` varchar(50) NOT NULL,
  `apellido` varchar(50) NOT NULL,
  `fecha_nacimiento` date DEFAULT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `direccion` varchar(100) DEFAULT NULL,
  `especialidad` varchar(25) DEFAULT NULL,
  `fecha_contratacion` date DEFAULT NULL,
  `salario` float DEFAULT NULL,
  `area_asignada` varchar(50) DEFAULT NULL,
  `fecha_fin_contrato` date DEFAULT NULL,
  `photo` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `empleados`
--

INSERT INTO `empleados` (`id_empleado`, `DNI`, `nombre`, `apellido`, `fecha_nacimiento`, `telefono`, `direccion`, `especialidad`, `fecha_contratacion`, `salario`, `area_asignada`, `fecha_fin_contrato`, `photo`) VALUES
(1, '1039764589', 'juan', 'hurtado', '1998-03-12', '3087645812', 'transversal 34 DD sur·80-45', 'agronomo', '2023-12-03', 3456450, 'produccion', NULL, NULL),
(2, '3789065421', 'ramiro', 'marin', '1979-09-15', '9037653241', 'transversal 89 PP sur·23-40', 'tenico en riego', '2024-01-10', 1234570, 'produccion', NULL, NULL),
(3, '1078653421', 'roberto', 'santana', '1989-11-11', '398765498', 'transversal 31 JJ sur·78-95', 'fumigador', '2025-01-10', 7654770, 'calidad y control', NULL, NULL),
(4, '8907654327', 'camilo', 'manrique', '2000-12-24', '3015326289', 'transversal 12 ÑÑ sur·19-65', 'contador agricola', '2024-12-13', 1698470, 'finanzas', NULL, NULL),
(5, '12121', 'dsdsdsds', 'dsfdsfdsf', '2025-09-01', '2333232', '', 'contador agricola', '2025-09-12', 34324300000, 'finanzas', '2025-09-08', '0000-00-00'),
(6, '11111111111', 'mabel', 'hurtado', '2025-09-09', '3423423', '', 'contador agricola', '2023-09-20', 342343000000, 'finanzas', '2025-09-02', '0000-00-00'),
(7, '121331', 'sisas', 'huratdo', '2025-09-09', '4234324', '', 'tecnico en riego', '2020-09-10', 342342000, 'finanzas', '2018-09-05', '0000-00-00'),
(8, '121331', 'sisas', 'huratdo', '2025-09-09', '4234324', '', 'tecnico en riego', '2020-09-10', 342342000, 'finanzas', '2018-09-05', '0000-00-00'),
(9, '343243432', 'juan', 'hurtado', '2025-09-20', '55545', '', 'agronomo', '2025-09-20', 3333330, 'finanzas', '2025-09-20', '0000-00-00');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `fincas`
--

CREATE TABLE `fincas` (
  `ID_FINCA` int(10) NOT NULL,
  `NOMBRE` varchar(100) NOT NULL,
  `latitud` float DEFAULT NULL,
  `longitud` float DEFAULT NULL,
  `EXTENSION_TOTAL_HECTAREAS` float DEFAULT NULL,
  `ALTITUD_METROS` int(11) DEFAULT NULL,
  `TEMPERATURA_PROMEDIO_ANUAL_fg` int(11) DEFAULT NULL,
  `TIPO_SUELO_PREdOMINANTE` varchar(50) DEFAULT NULL,
  `region_ubicacion` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `fincas`
--

INSERT INTO `fincas` (`ID_FINCA`, `NOMBRE`, `latitud`, `longitud`, `EXTENSION_TOTAL_HECTAREAS`, `ALTITUD_METROS`, `TEMPERATURA_PROMEDIO_ANUAL_fg`, `TIPO_SUELO_PREdOMINANTE`, `region_ubicacion`) VALUES
(1, 'agualda', -12.0908, -56.9899, 123, 1300, 25, 'suelo arenoso', 'mi casa '),
(2, 'bellavista', -9.0078, -34.6667, 100, 1000, 17, 'suelo arcilloso', 'zona norte '),
(3, 'margaritas', -10.6578, -44.8876, 79, 900, 16, 'suelo limoso', 'valle central'),
(4, 'perlas', -15.3369, -30.7777, 140, 1500, 28, 'suelo arenoso', 'zona sur '),
(5, 'culo', 43545, 5454, 544, 54354, 5454, 'sapo', 'azul'),
(6, 'arturo', 4545, 54435, 544, 45354, 53454, 'oscuro', 'aqui'),
(7, 'atl nacional', 43435, 4544, 33, 4535, 544554, 'suelo arcilloso', 'atanasio'),
(8, 'rosario', 54645700, 5464560, 55, 456546, 465465, 'suelo limoso', 'oriente medio'),
(9, 'epaaa', 11111, 11111, 111, 1433243, 343434, 'otro', 'ahhhhhhh'),
(10, 'juan', 4454540, 444, 54555, 54544, 5454, 'suelo arcilloso', 'ahsuahshu'),
(11, 'eeeee', 545454, 545454, 545454, 5454, 545454, 'otro', '544554'),
(12, 'gggg', 43443, 434343, 434343, 434343, 43434, 'suelo limoso', '43433443'),
(13, 'nooooo', 5545, 5654560, 54654, 64645654, 646454654, 'otro', 'rrrtrtr'),
(17, 'nooooo0', 5545, 5654560, 54654, 64645654, 646454654, 'otro', 'rrrtrtr');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `historial_parcela`
--

CREATE TABLE `historial_parcela` (
  `id_historial` int(11) NOT NULL,
  `id_parcela` int(11) NOT NULL,
  `fecha` date NOT NULL,
  `actividad` varchar(50) DEFAULT NULL,
  `detalle` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `inventario_insumos`
--

CREATE TABLE `inventario_insumos` (
  `id_insumos` int(10) NOT NULL,
  `nombre_generico` varchar(50) NOT NULL,
  `nombre_comercial` varchar(50) NOT NULL,
  `tipo` varchar(50) DEFAULT NULL,
  `unidad_de_medida` varchar(100) DEFAULT NULL,
  `stock` int(11) NOT NULL DEFAULT 0,
  `ubicacion_almacen` varchar(100) DEFAULT NULL,
  `fecha_caducidad` date DEFAULT NULL,
  `precio_unitario` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `inventario_insumos`
--

INSERT INTO `inventario_insumos` (`id_insumos`, `nombre_generico`, `nombre_comercial`, `tipo`, `unidad_de_medida`, `stock`, `ubicacion_almacen`, `fecha_caducidad`, `precio_unitario`) VALUES
(1234, 'herbicida glifosato', 'roundup', 'herbicida', 'litro', 100, 'transversal#89-80', '2027-10-23', 12.5),
(5890, 'clorpirifos 48% EC', 'lorsban 48 EC', 'insecticida', 'litro', 200, 'transversal897,89-09, calle 12', '2028-06-27', 7.5),
(6734, 'urea 46% N', 'urea granulada nutrimax', 'fertilizante', 'kilogramo', 500, 'transversal#86-12', '2026-12-05', 5.89),
(9034, 'mancozeb 80% wp', 'dithane m-45', 'fungicida', 'kilogramo', 300, 'calle-12 ruta 10', '2028-02-10', 7.32);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `mantenimiento_maquinas`
--

CREATE TABLE `mantenimiento_maquinas` (
  `id_mantenimiento` int(10) NOT NULL,
  `id_maquinaria` int(11) NOT NULL,
  `fecha_mantenimiento` date NOT NULL,
  `tipo_de_mantenimiento` varchar(100) DEFAULT NULL,
  `descripcion_trabajos` varchar(200) DEFAULT NULL,
  `piezas_remplazadas` varchar(200) DEFAULT NULL,
  `costo` float DEFAULT NULL,
  `tecnico_responsable` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `mantenimiento_maquinas`
--

INSERT INTO `mantenimiento_maquinas` (`id_mantenimiento`, `id_maquinaria`, `fecha_mantenimiento`, `tipo_de_mantenimiento`, `descripcion_trabajos`, `piezas_remplazadas`, `costo`, `tecnico_responsable`) VALUES
(10001, 1001, '0000-00-00', '', '', '', 0, 'jorge bermudez'),
(10002, 1002, '2025-05-12', 'preventivo', 'cambio de aceite', 'aceite y filtro de aceite', 300, 'alejandro pinilla'),
(10003, 1003, '2025-06-04', 'correctivo', 'cambio de aceite y filtros del motor', 'aceite,filtro de aceite y filtro del motor', 500, 'samuel bedoya'),
(10004, 1004, '2025-08-09', 'preventivo', 'mantenimiento del motor', 'cambio del aceite', 200, 'james mosquera');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `maquinaria`
--

CREATE TABLE `maquinaria` (
  `id_maquinaria` int(10) NOT NULL,
  `marca` varchar(50) DEFAULT NULL,
  `modelo` varchar(50) DEFAULT NULL,
  `año_fabricacion` int(11) DEFAULT NULL,
  `potencia` int(11) DEFAULT NULL,
  `tipo_combustible` varchar(50) DEFAULT NULL,
  `horometro_actual` float DEFAULT NULL,
  `estado_operativo` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `maquinaria`
--

INSERT INTO `maquinaria` (`id_maquinaria`, `marca`, `modelo`, `año_fabricacion`, `potencia`, `tipo_combustible`, `horometro_actual`, `estado_operativo`) VALUES
(1001, 'jhon deere', '5050D', 2020, 50, 'diesel', 1200, 'operativo'),
(1002, 'new holland', 't7.190', 2021, 190, 'diesel', 2500, 'En mantenimiento'),
(1003, 'jhon deere', '6125m', 2020, 125, 'diesel', 3200, 'en mantenimiento'),
(1004, 'case ih', 'axial flow 8250', 2018, 480, 'diesel', 4500, 'en mantenimiento');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `movimientos_maquinaria`
--

CREATE TABLE `movimientos_maquinaria` (
  `id_movimiento` int(11) NOT NULL,
  `id_maquinaria` int(11) NOT NULL,
  `fecha_movimiento` date NOT NULL,
  `horas_trabajadas` float DEFAULT NULL,
  `combustible_consumido` float DEFAULT NULL,
  `descripcion` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `movimiento_insumos`
--

CREATE TABLE `movimiento_insumos` (
  `id_movimiento_insumos` int(10) NOT NULL,
  `fecha_movimiento` date NOT NULL,
  `tipo_de_movimiento` varchar(25) NOT NULL,
  `cantidad` int(11) NOT NULL,
  `responsable` varchar(100) NOT NULL,
  `destino` varchar(100) DEFAULT NULL,
  `id_finca` int(10) NOT NULL,
  `id_insumos` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `movimiento_insumos`
--

INSERT INTO `movimiento_insumos` (`id_movimiento_insumos`, `fecha_movimiento`, `tipo_de_movimiento`, `cantidad`, `responsable`, `destino`, `id_finca`, `id_insumos`) VALUES
(10, '2025-04-01', 'salida', 50, 'juan gomez', 'agualda', 1, 1234),
(20, '2025-06-04', 'salida', 25, 'raul cardona', 'bellavista', 2, 6734),
(30, '2025-10-23', 'entrada', 60, 'mateo cardenas', 'margaritas', 3, 5890),
(40, '2025-08-21', 'salida', 45, 'julian vergara', 'perlas', 4, 9034);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `movimiento_inventario_insumos`
--

CREATE TABLE `movimiento_inventario_insumos` (
  `id_movimiento_inv_insumos` int(10) NOT NULL,
  `id_insumos` int(10) NOT NULL,
  `id_movimiento_insumos` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `movimiento_inventario_insumos`
--

INSERT INTO `movimiento_inventario_insumos` (`id_movimiento_inv_insumos`, `id_insumos`, `id_movimiento_insumos`) VALUES
(1, 1234, 10),
(2, 6734, 20),
(3, 5890, 30),
(4, 9034, 40);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `parcelas`
--

CREATE TABLE `parcelas` (
  `ID_PARCELA` int(10) NOT NULL,
  `AREA_HECTAREAS_PARCELAS` float NOT NULL,
  `SISTEMA_RIEGO` varchar(50) DEFAULT NULL,
  `HISTORIAL_DE_USO` varchar(200) DEFAULT NULL,
  `id_finca` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `parcelas`
--

INSERT INTO `parcelas` (`ID_PARCELA`, `AREA_HECTAREAS_PARCELAS`, `SISTEMA_RIEGO`, `HISTORIAL_DE_USO`, `id_finca`) VALUES
(1, 7, 'goteo', 'maiz(2023),trigo(2022),lechuga(2024), fertilizacion con npk en marzo(2023), analisis del suelo en enero 2025:pH 6.2,bajo en fosforo', 1),
(2, 6, 'subterraneo', 'papa(2022),zanahoria(2023),remolacha(2024), fertilizacion con npk en diciembre(2024), analisis del suelo en enero 2025: pH 7, suelo neutro', 2),
(3, 8, 'aspercion', 'platano(2023),cafe(2024), fertilizacion con npk en octubre(2024),analisis del suelo en diciembre(2024) : pH 9,suelo alcalino', 3),
(4, 6, 'gravedad', '', 4),
(5, 33, 'aspercion', 'dfddfdffdfd', 5),
(7, 44444, 'goteo', 'hggffggf', 10);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `productos`
--

CREATE TABLE `productos` (
  `id_producto` int(10) NOT NULL,
  `NOMBRE` varchar(100) NOT NULL,
  `TIPO` varchar(100) NOT NULL,
  `UNIDAD_MEDIDA` varchar(50) NOT NULL,
  `PRECIO_PRODUCTO` float NOT NULL,
  `IMPUESTOS_VENTAS` float NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `productos`
--

INSERT INTO `productos` (`id_producto`, `NOMBRE`, `TIPO`, `UNIDAD_MEDIDA`, `PRECIO_PRODUCTO`, `IMPUESTOS_VENTAS`) VALUES
(10110, 'fertilizante npk15', 'fertilizante', 'kilogramos', 10.5, 1.1),
(20220, 'semillas de maiz hibrido', 'semilla', 'bolsa de 10kg', 7.35, 1.1),
(30330, 'herbicida glisofato 1L', 'herbicida', 'litros', 13.99, 3),
(40440, 'tractor agricola modelo txt100', 'maquinaria', 'unidad', 29800, 15);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `proveedores`
--

CREATE TABLE `proveedores` (
  `ID_PROVEEDOR` int(11) NOT NULL,
  `NOMBRE` varchar(100) NOT NULL,
  `dni_provee` int(10) NOT NULL,
  `TELEFONO` int(12) DEFAULT NULL,
  `CORREO` varchar(100) DEFAULT NULL,
  `DIRECCION` varchar(50) DEFAULT NULL,
  `ESPECIALIDAD` varchar(50) DEFAULT NULL,
  `CONDICIONES_DE_PAGO` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `proveedores`
--

INSERT INTO `proveedores` (`ID_PROVEEDOR`, `NOMBRE`, `dni_provee`, `TELEFONO`, `CORREO`, `DIRECCION`, `ESPECIALIDAD`, `CONDICIONES_DE_PAGO`) VALUES
(101011001, 'agroinsumos S.A', 2147483647, 367890455, 'agroinsu@gmail.com', 'plaza mercado sur 34', 'Proporciona una amplia gama de insumos agrícolas, ', 'credito a 30 dias'),
(202022002, 'fertilizantes del norte', 48957271, 2012332, 'fertinorte@gmail.com', 'atlanta 12 calle-34', 'productos de alta calidad', 'contra entrega'),
(303033003, 'semilas y cultivos', 1890564367, 123456789, 'semillascalidad@gmail.com', 'NOPUEDOMAS calle-34', 'especialistas en semillas y abonacion', 'contra entrega'),
(404044004, 'herramientas agricolas y maquinarias', 87956743, 2147483647, 'maquinariagricola@gmail.com', 'grindol av34 # 12', 'expertos en todo tipo de maquinaria agricola', 'credito a 60 dias');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `proveedor_insumos`
--

CREATE TABLE `proveedor_insumos` (
  `id_prove_insu` int(10) NOT NULL,
  `id_insumos` int(10) NOT NULL,
  `ID_PROVEEDOR` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `proveedor_insumos`
--

INSERT INTO `proveedor_insumos` (`id_prove_insu`, `id_insumos`, `ID_PROVEEDOR`) VALUES
(1, 1234, 101011001),
(2, 6734, 202022002),
(3, 5890, 303033003),
(4, 9034, 404044004);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `temporada_cosecha`
--

CREATE TABLE `temporada_cosecha` (
  `id_tempocosecha` int(11) NOT NULL,
  `ID_PARCELA` int(10) NOT NULL,
  `ID_CULTIVO` int(10) NOT NULL,
  `fecha_siembra` date DEFAULT NULL,
  `densidad_siembra_m2` float DEFAULT NULL,
  `fecha_estimada_cosecha` date DEFAULT NULL,
  `rendimiento_esperado` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `temporada_cosecha`
--

INSERT INTO `temporada_cosecha` (`id_tempocosecha`, `ID_PARCELA`, `ID_CULTIVO`, `fecha_siembra`, `densidad_siembra_m2`, `fecha_estimada_cosecha`, `rendimiento_esperado`) VALUES
(1, 1, 101, '2025-01-15', 50000, '2025-03-12', 8.5),
(2, 2, 102, '2024-12-21', 35000, '2025-02-01', 7),
(3, 3, 103, '2024-11-11', 40000, '2025-02-23', 7.8),
(4, 4, 104, '2025-03-23', 45000, '2025-05-24', 8.2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ventas`
--

CREATE TABLE `ventas` (
  `id_ventas` int(10) NOT NULL,
  `fecha` date NOT NULL,
  `id_cliente` int(10) NOT NULL,
  `id_producto` int(10) NOT NULL,
  `cantidades` int(11) DEFAULT NULL,
  `precios_unitarios` float DEFAULT NULL,
  `descuentos_aplicados` float DEFAULT NULL,
  `impuestos` float DEFAULT NULL,
  `forma_de_pago` varchar(50) DEFAULT NULL,
  `total_facturado` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `ventas`
--

INSERT INTO `ventas` (`id_ventas`, `fecha`, `id_cliente`, `id_producto`, `cantidades`, `precios_unitarios`, `descuentos_aplicados`, `impuestos`, `forma_de_pago`, `total_facturado`) VALUES
(1010, '2025-01-13', 101101, 10110, 10, 10.5, 10, 1.1, 'efectivo', 9),
(2020, '2024-02-12', 202202, 20220, 5, 7.35, 5, 1.1, 'efectivo', 6.99),
(3030, '2024-05-23', 303303, 30330, 15, 13.99, 10, 3, 'credito', 12.59),
(4040, '2025-02-27', 404404, 40440, 10, 29800, 5, 15, 'credito', 28.31);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `alertas_empleados`
--
ALTER TABLE `alertas_empleados`
  ADD PRIMARY KEY (`id_alerta`),
  ADD KEY `id_empleado` (`id_empleado`);

--
-- Indices de la tabla `alertas_insumos`
--
ALTER TABLE `alertas_insumos`
  ADD PRIMARY KEY (`id_alerta`),
  ADD KEY `id_insumos` (`id_insumos`);

--
-- Indices de la tabla `alertas_maquinaria`
--
ALTER TABLE `alertas_maquinaria`
  ADD PRIMARY KEY (`id_alerta`),
  ADD KEY `id_maquinaria` (`id_maquinaria`);

--
-- Indices de la tabla `analisis_de_suelos`
--
ALTER TABLE `analisis_de_suelos`
  ADD PRIMARY KEY (`ID_NALISIS_DE_SUELOS`),
  ADD KEY `ID_PARCELA` (`ID_PARCELA`);

--
-- Indices de la tabla `asignacion_de_trabajo`
--
ALTER TABLE `asignacion_de_trabajo`
  ADD PRIMARY KEY (`id_asignacion_de_trabajo`),
  ADD KEY `idx_asignacion_trabajo_empleado` (`id_empleado`),
  ADD KEY `idx_asignacion_trabajo_parcela` (`id_parcela`);

--
-- Indices de la tabla `asignacion_empleado`
--
ALTER TABLE `asignacion_empleado`
  ADD PRIMARY KEY (`id_asig_empleado`),
  ADD KEY `id_empleado` (`id_empleado`),
  ADD KEY `id_asignacion_de_trabajo` (`id_asignacion_de_trabajo`);

--
-- Indices de la tabla `clientes`
--
ALTER TABLE `clientes`
  ADD PRIMARY KEY (`id_cliente`),
  ADD UNIQUE KEY `DNI` (`DNI`);

--
-- Indices de la tabla `cosechas`
--
ALTER TABLE `cosechas`
  ADD PRIMARY KEY (`id_cosecha`),
  ADD KEY `idx_cosechas_parcela` (`id_parcela`),
  ADD KEY `idx_cosechas_cultivo` (`id_cultivo`);

--
-- Indices de la tabla `costos_por_parcela`
--
ALTER TABLE `costos_por_parcela`
  ADD PRIMARY KEY (`id_parcela`),
  ADD KEY `id_finca` (`id_finca`);

--
-- Indices de la tabla `cultivos`
--
ALTER TABLE `cultivos`
  ADD PRIMARY KEY (`id_cultivo`);

--
-- Indices de la tabla `empleados`
--
ALTER TABLE `empleados`
  ADD PRIMARY KEY (`id_empleado`);

--
-- Indices de la tabla `fincas`
--
ALTER TABLE `fincas`
  ADD PRIMARY KEY (`ID_FINCA`);

--
-- Indices de la tabla `historial_parcela`
--
ALTER TABLE `historial_parcela`
  ADD PRIMARY KEY (`id_historial`),
  ADD KEY `id_parcela` (`id_parcela`);

--
-- Indices de la tabla `inventario_insumos`
--
ALTER TABLE `inventario_insumos`
  ADD PRIMARY KEY (`id_insumos`);

--
-- Indices de la tabla `mantenimiento_maquinas`
--
ALTER TABLE `mantenimiento_maquinas`
  ADD PRIMARY KEY (`id_mantenimiento`),
  ADD KEY `idx_mantenimiento_maquinas_maquinaria` (`id_maquinaria`);

--
-- Indices de la tabla `maquinaria`
--
ALTER TABLE `maquinaria`
  ADD PRIMARY KEY (`id_maquinaria`);

--
-- Indices de la tabla `movimientos_maquinaria`
--
ALTER TABLE `movimientos_maquinaria`
  ADD PRIMARY KEY (`id_movimiento`),
  ADD KEY `id_maquinaria` (`id_maquinaria`);

--
-- Indices de la tabla `movimiento_insumos`
--
ALTER TABLE `movimiento_insumos`
  ADD PRIMARY KEY (`id_movimiento_insumos`),
  ADD KEY `idx_movimiento_insumos_finca` (`id_finca`),
  ADD KEY `idx_movimiento_insumos_insumo` (`id_insumos`);

--
-- Indices de la tabla `movimiento_inventario_insumos`
--
ALTER TABLE `movimiento_inventario_insumos`
  ADD PRIMARY KEY (`id_movimiento_inv_insumos`),
  ADD KEY `id_insumos` (`id_insumos`),
  ADD KEY `id_movimiento_insumos` (`id_movimiento_insumos`);

--
-- Indices de la tabla `parcelas`
--
ALTER TABLE `parcelas`
  ADD PRIMARY KEY (`ID_PARCELA`),
  ADD KEY `idx_parcelas_finca` (`id_finca`);

--
-- Indices de la tabla `productos`
--
ALTER TABLE `productos`
  ADD PRIMARY KEY (`id_producto`);

--
-- Indices de la tabla `proveedores`
--
ALTER TABLE `proveedores`
  ADD PRIMARY KEY (`ID_PROVEEDOR`),
  ADD UNIQUE KEY `dni_provee` (`dni_provee`);

--
-- Indices de la tabla `proveedor_insumos`
--
ALTER TABLE `proveedor_insumos`
  ADD PRIMARY KEY (`id_prove_insu`),
  ADD KEY `id_insumos` (`id_insumos`),
  ADD KEY `ID_PROVEEDOR` (`ID_PROVEEDOR`);

--
-- Indices de la tabla `temporada_cosecha`
--
ALTER TABLE `temporada_cosecha`
  ADD PRIMARY KEY (`id_tempocosecha`),
  ADD KEY `idx_temporada_cosecha_parcela` (`ID_PARCELA`),
  ADD KEY `idx_temporada_cosecha_cultivo` (`ID_CULTIVO`);

--
-- Indices de la tabla `ventas`
--
ALTER TABLE `ventas`
  ADD PRIMARY KEY (`id_ventas`),
  ADD KEY `id_cliente` (`id_cliente`),
  ADD KEY `id_producto` (`id_producto`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `alertas_empleados`
--
ALTER TABLE `alertas_empleados`
  MODIFY `id_alerta` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `alertas_insumos`
--
ALTER TABLE `alertas_insumos`
  MODIFY `id_alerta` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `alertas_maquinaria`
--
ALTER TABLE `alertas_maquinaria`
  MODIFY `id_alerta` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `analisis_de_suelos`
--
ALTER TABLE `analisis_de_suelos`
  MODIFY `ID_NALISIS_DE_SUELOS` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `asignacion_de_trabajo`
--
ALTER TABLE `asignacion_de_trabajo`
  MODIFY `id_asignacion_de_trabajo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=445;

--
-- AUTO_INCREMENT de la tabla `asignacion_empleado`
--
ALTER TABLE `asignacion_empleado`
  MODIFY `id_asig_empleado` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `clientes`
--
ALTER TABLE `clientes`
  MODIFY `id_cliente` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=404405;

--
-- AUTO_INCREMENT de la tabla `cosechas`
--
ALTER TABLE `cosechas`
  MODIFY `id_cosecha` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=45;

--
-- AUTO_INCREMENT de la tabla `cultivos`
--
ALTER TABLE `cultivos`
  MODIFY `id_cultivo` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=113;

--
-- AUTO_INCREMENT de la tabla `empleados`
--
ALTER TABLE `empleados`
  MODIFY `id_empleado` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT de la tabla `fincas`
--
ALTER TABLE `fincas`
  MODIFY `ID_FINCA` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT de la tabla `historial_parcela`
--
ALTER TABLE `historial_parcela`
  MODIFY `id_historial` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `mantenimiento_maquinas`
--
ALTER TABLE `mantenimiento_maquinas`
  MODIFY `id_mantenimiento` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10005;

--
-- AUTO_INCREMENT de la tabla `maquinaria`
--
ALTER TABLE `maquinaria`
  MODIFY `id_maquinaria` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1005;

--
-- AUTO_INCREMENT de la tabla `movimientos_maquinaria`
--
ALTER TABLE `movimientos_maquinaria`
  MODIFY `id_movimiento` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `movimiento_insumos`
--
ALTER TABLE `movimiento_insumos`
  MODIFY `id_movimiento_insumos` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;

--
-- AUTO_INCREMENT de la tabla `movimiento_inventario_insumos`
--
ALTER TABLE `movimiento_inventario_insumos`
  MODIFY `id_movimiento_inv_insumos` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `parcelas`
--
ALTER TABLE `parcelas`
  MODIFY `ID_PARCELA` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT de la tabla `proveedores`
--
ALTER TABLE `proveedores`
  MODIFY `ID_PROVEEDOR` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=404044005;

--
-- AUTO_INCREMENT de la tabla `proveedor_insumos`
--
ALTER TABLE `proveedor_insumos`
  MODIFY `id_prove_insu` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `temporada_cosecha`
--
ALTER TABLE `temporada_cosecha`
  MODIFY `id_tempocosecha` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `ventas`
--
ALTER TABLE `ventas`
  MODIFY `id_ventas` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4041;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `alertas_empleados`
--
ALTER TABLE `alertas_empleados`
  ADD CONSTRAINT `alertas_empleados_ibfk_1` FOREIGN KEY (`id_empleado`) REFERENCES `empleados` (`id_empleado`) ON DELETE CASCADE;

--
-- Filtros para la tabla `alertas_insumos`
--
ALTER TABLE `alertas_insumos`
  ADD CONSTRAINT `alertas_insumos_ibfk_1` FOREIGN KEY (`id_insumos`) REFERENCES `inventario_insumos` (`id_insumos`);

--
-- Filtros para la tabla `alertas_maquinaria`
--
ALTER TABLE `alertas_maquinaria`
  ADD CONSTRAINT `alertas_maquinaria_ibfk_1` FOREIGN KEY (`id_maquinaria`) REFERENCES `maquinaria` (`id_maquinaria`);

--
-- Filtros para la tabla `analisis_de_suelos`
--
ALTER TABLE `analisis_de_suelos`
  ADD CONSTRAINT `analisis_de_suelos_ibfk_1` FOREIGN KEY (`ID_PARCELA`) REFERENCES `parcelas` (`ID_PARCELA`) ON DELETE CASCADE;

--
-- Filtros para la tabla `asignacion_de_trabajo`
--
ALTER TABLE `asignacion_de_trabajo`
  ADD CONSTRAINT `asignacion_de_trabajo_ibfk_1` FOREIGN KEY (`id_empleado`) REFERENCES `empleados` (`id_empleado`) ON DELETE CASCADE,
  ADD CONSTRAINT `asignacion_de_trabajo_ibfk_2` FOREIGN KEY (`id_parcela`) REFERENCES `parcelas` (`ID_PARCELA`);

--
-- Filtros para la tabla `asignacion_empleado`
--
ALTER TABLE `asignacion_empleado`
  ADD CONSTRAINT `asignacion_empleado_ibfk_1` FOREIGN KEY (`id_empleado`) REFERENCES `empleados` (`id_empleado`) ON DELETE CASCADE,
  ADD CONSTRAINT `asignacion_empleado_ibfk_2` FOREIGN KEY (`id_asignacion_de_trabajo`) REFERENCES `asignacion_de_trabajo` (`id_asignacion_de_trabajo`) ON DELETE CASCADE;

--
-- Filtros para la tabla `cosechas`
--
ALTER TABLE `cosechas`
  ADD CONSTRAINT `cosechas_ibfk_1` FOREIGN KEY (`id_parcela`) REFERENCES `parcelas` (`ID_PARCELA`) ON DELETE CASCADE,
  ADD CONSTRAINT `cosechas_ibfk_2` FOREIGN KEY (`id_cultivo`) REFERENCES `cultivos` (`id_cultivo`);

--
-- Filtros para la tabla `costos_por_parcela`
--
ALTER TABLE `costos_por_parcela`
  ADD CONSTRAINT `costos_por_parcela_ibfk_1` FOREIGN KEY (`id_parcela`) REFERENCES `parcelas` (`ID_PARCELA`),
  ADD CONSTRAINT `costos_por_parcela_ibfk_2` FOREIGN KEY (`id_finca`) REFERENCES `fincas` (`ID_FINCA`);

--
-- Filtros para la tabla `historial_parcela`
--
ALTER TABLE `historial_parcela`
  ADD CONSTRAINT `historial_parcela_ibfk_1` FOREIGN KEY (`id_parcela`) REFERENCES `parcelas` (`ID_PARCELA`);

--
-- Filtros para la tabla `mantenimiento_maquinas`
--
ALTER TABLE `mantenimiento_maquinas`
  ADD CONSTRAINT `mantenimiento_maquinas_ibfk_1` FOREIGN KEY (`id_maquinaria`) REFERENCES `maquinaria` (`id_maquinaria`) ON DELETE CASCADE;

--
-- Filtros para la tabla `movimientos_maquinaria`
--
ALTER TABLE `movimientos_maquinaria`
  ADD CONSTRAINT `movimientos_maquinaria_ibfk_1` FOREIGN KEY (`id_maquinaria`) REFERENCES `maquinaria` (`id_maquinaria`) ON DELETE CASCADE;

--
-- Filtros para la tabla `movimiento_insumos`
--
ALTER TABLE `movimiento_insumos`
  ADD CONSTRAINT `movimiento_insumos_ibfk_1` FOREIGN KEY (`id_insumos`) REFERENCES `inventario_insumos` (`id_insumos`) ON DELETE CASCADE,
  ADD CONSTRAINT `movimiento_insumos_ibfk_2` FOREIGN KEY (`id_finca`) REFERENCES `fincas` (`ID_FINCA`);

--
-- Filtros para la tabla `movimiento_inventario_insumos`
--
ALTER TABLE `movimiento_inventario_insumos`
  ADD CONSTRAINT `movimiento_inventario_insumos_ibfk_1` FOREIGN KEY (`id_insumos`) REFERENCES `inventario_insumos` (`id_insumos`) ON DELETE CASCADE,
  ADD CONSTRAINT `movimiento_inventario_insumos_ibfk_2` FOREIGN KEY (`id_movimiento_insumos`) REFERENCES `movimiento_insumos` (`id_movimiento_insumos`) ON DELETE CASCADE;

--
-- Filtros para la tabla `parcelas`
--
ALTER TABLE `parcelas`
  ADD CONSTRAINT `parcelas_ibfk_1` FOREIGN KEY (`id_finca`) REFERENCES `fincas` (`ID_FINCA`) ON DELETE CASCADE;

--
-- Filtros para la tabla `proveedor_insumos`
--
ALTER TABLE `proveedor_insumos`
  ADD CONSTRAINT `proveedor_insumos_ibfk_1` FOREIGN KEY (`id_insumos`) REFERENCES `inventario_insumos` (`id_insumos`) ON DELETE CASCADE,
  ADD CONSTRAINT `proveedor_insumos_ibfk_2` FOREIGN KEY (`ID_PROVEEDOR`) REFERENCES `proveedores` (`ID_PROVEEDOR`) ON DELETE CASCADE;

--
-- Filtros para la tabla `temporada_cosecha`
--
ALTER TABLE `temporada_cosecha`
  ADD CONSTRAINT `temporada_cosecha_ibfk_1` FOREIGN KEY (`ID_PARCELA`) REFERENCES `parcelas` (`ID_PARCELA`),
  ADD CONSTRAINT `temporada_cosecha_ibfk_2` FOREIGN KEY (`ID_CULTIVO`) REFERENCES `cultivos` (`id_cultivo`);

--
-- Filtros para la tabla `ventas`
--
ALTER TABLE `ventas`
  ADD CONSTRAINT `ventas_ibfk_1` FOREIGN KEY (`id_cliente`) REFERENCES `clientes` (`id_cliente`) ON DELETE CASCADE,
  ADD CONSTRAINT `ventas_ibfk_2` FOREIGN KEY (`id_producto`) REFERENCES `productos` (`id_producto`);
COMMIT;



# funciones guardar para los 4 modulos


DELIMITER //

CREATE PROCEDURE sp_insertfinca(
     IN f_NOMBRE VARCHAR(100),
     IN f_LATITUD FLOAT,
     IN f_LONGITUD FLOAT,
     IN f_EXTENSION_TOTAL_HECTAREAS FLOAT,
     IN f_ALTITUD_METROS INT,
     IN f_TEMPERATURA_PROMEDIO_ANUAL_fg INT,
     IN f_TIPO_SUELO_PREDOMINANTE VARCHAR(50),
     IN f_region_ubicacion VARCHAR(100)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;
    
    INSERT INTO FINCAS(
        NOMBRE,
        LATITUD,
        LONGITUD,
        EXTENSION_TOTAL_HECTAREAS,
        ALTITUD_METROS,
        TEMPERATURA_PROMEDIO_ANUAL_fg,
        TIPO_SUELO_PREdOMINANTE,
        region_ubicacion
    )
    VALUES (
        f_NOMBRE,
        f_LATITUD,
        f_LONGITUD,
        f_EXTENSION_TOTAL_HECTAREAS,
        f_ALTITUD_METROS,
        f_TEMPERATURA_PROMEDIO_ANUAL_fg,
        f_TIPO_SUELO_PREDOMINANTE,
        f_region_ubicacion
    );
    
    COMMIT;

    SELECT LAST_INSERT_ID() AS ID_FINCA, 'Finca insertada correctamente' AS Message;
END//

DELIMITER ;


DELIMITER //

CREATE PROCEDURE sp_insertparcela(
    IN p_AREA_HECTAREAS_PARCELAS FLOAT,
    IN p_SISTEMA_RIEGO VARCHAR(50),
    IN p_HISTORIAL_DE_USO VARCHAR(200),
    IN p_id_finca INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    INSERT INTO PARCELAS(AREA_HECTAREAS_PARCELAS, SISTEMA_RIEGO, HISTORIAL_DE_USO, id_finca)
    VALUES (p_AREA_HECTAREAS_PARCELAS, p_SISTEMA_RIEGO, p_HISTORIAL_DE_USO, p_id_finca);

    COMMIT;

    SELECT LAST_INSERT_ID() AS ID_PARCELA, 'Parcela insertada correctamente' AS Message;
END//

DELIMITER ;


DELIMITER //

CREATE PROCEDURE sp_insertEmpleado(
    IN p_DNI VARCHAR(15),
    IN p_nombre VARCHAR(50),
    IN p_apellido VARCHAR(50),
    IN p_fecha_nacimiento DATE,
    IN p_telefono VARCHAR(20),
    IN p_direccion VARCHAR(100),
    IN p_especialidad VARCHAR(25),
    IN p_fecha_contratacion DATE,
    IN p_salario FLOAT,
    IN p_area_asignada VARCHAR(50),
    IN p_fecha_fin_contrato DATE,
    IN p_photo DATE -- O cambia el tipo si decides otro tipo para la foto
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    INSERT INTO empleados (
        DNI,
        nombre,
        apellido,
        fecha_nacimiento,
        telefono,
        direccion,
        especialidad,
        fecha_contratacion,
        salario,
        area_asignada,
        fecha_fin_contrato,
        photo
    )
    VALUES (
        p_DNI,
        p_nombre,
        p_apellido,
        p_fecha_nacimiento,
        p_telefono,
        p_direccion,
        p_especialidad,
        p_fecha_contratacion,
        p_salario,
        p_area_asignada,
        p_fecha_fin_contrato,
        p_photo
    );

    COMMIT;

    SELECT LAST_INSERT_ID() AS id_empleado, 'Empleado insertado correctamente' AS Message;
END //

DELIMITER ;


DELIMITER //

CREATE PROCEDURE sp_insertCultivo(
    IN p_nombre_cientifico VARCHAR(100),
    IN p_nombre_comun VARCHAR(100),
    IN p_tiempo_crecimiento_dias INT,
    IN p_temperaturas_optimas FLOAT,
    IN p_requerimiento_agua_semanal VARCHAR(225),
    IN p_photo VARCHAR(255)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    INSERT INTO cultivos (
        nombre_cientifico, 
        nombre_comun, 
        tiempo_crecimiento_dias, 
        temperaturas_optimas, 
        requerimiento_agua_semanal,
        photo
    )
    VALUES (
        p_nombre_cientifico, 
        p_nombre_comun, 
        p_tiempo_crecimiento_dias, 
        p_temperaturas_optimas, 
        p_requerimiento_agua_semanal,
        p_photo
    );

    COMMIT;
END //

DELIMITER ;

#==================== buscar para todas las tablas ================

DELIMITER $$

CREATE PROCEDURE sp_GetFincaByName(IN p_Nombre VARCHAR(100))
BEGIN
    SELECT 
        ID_FINCA,
        NOMBRE,
        latitud,
        longitud,
        EXTENSION_TOTAL_HECTAREAS,
        ALTITUD_METROS,
        TEMPERATURA_PROMEDIO_ANUAL_fg,
        TIPO_SUELO_PREdOMINANTE,
        region_ubicacion
    FROM FINCAS
    WHERE LOWER(NOMBRE) LIKE LOWER(CONCAT('%', p_Nombre, '%'));
END $$

DELIMITER ;


DELIMITER $$

CREATE PROCEDURE sp_GetParcelaByID(IN p_ID INT)
BEGIN
    SELECT 
        ID_PARCELA,
        AREA_HECTAREAS_PARCELAS,
        SISTEMA_RIEGO,
        HISTORIAL_DE_USO,
        id_finca
    FROM PARCELAS
    WHERE ID_PARCELA = p_ID;
END $$

DELIMITER ;


DELIMITER $$

CREATE PROCEDURE sp_buscar_empleado_por_id(
    IN p_id_empleado INT
)
BEGIN
    SELECT 
        id_empleado,
        DNI,
        nombre,
        apellido,
        fecha_nacimiento,
        telefono,
        direccion,
        especialidad,
        fecha_contratacion,
        salario,
        area_asignada,
        fecha_fin_contrato,
        photo
    FROM empleados
    WHERE id_empleado = p_id_empleado;
END $$

DELIMITER ;


DELIMITER //

CREATE PROCEDURE BuscarCultivoPorID (
    IN _id_cultivo INT
)
BEGIN
    SELECT 
        id_cultivo,
        nombre_cientifico,
        nombre_comun,
        tiempo_crecimiento_dias,
        temperaturas_optimas,
        requerimiento_agua_semanal,
        photo
    FROM cultivos
    WHERE id_cultivo = _id_cultivo;
END //

DELIMITER ;

#======================= eliminar para todas las tablas =====================

DELIMITER $$

CREATE PROCEDURE eliminar_cultivo(IN p_id_cultivo INT)
BEGIN
    DELETE FROM cultivos WHERE id_cultivo = p_id_cultivo;
END $$

DELIMITER ;

DELIMITER //

CREATE PROCEDURE eliminar_empleado(IN p_id_empleado INT)
BEGIN
    DELETE FROM empleados WHERE id_empleado = p_id_empleado;
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE eliminar_parcela(IN p_id_parcela INT)
BEGIN
    DELETE FROM PARCELAS WHERE ID_PARCELA = p_id_parcela;
END //

DELIMITER ;


DELIMITER $$

CREATE PROCEDURE eliminar_finca(IN nombre_finca VARCHAR(100))
BEGIN
    DELETE FROM fincas WHERE NOMBRE = nombre_finca;
END $$

DELIMITER ;


#===================== ACTUALIZAR TODAS LAS TABLAS ===================

DELIMITER //

CREATE PROCEDURE actualizar_cultivo(
    IN p_id_cultivo INT,
    IN p_nombre_cientifico VARCHAR(100),
    IN p_nombre_comun VARCHAR(100),
    IN p_tiempo_crecimiento_dias INT,
    IN p_temperaturas_optimas FLOAT,
    IN p_requerimiento_agua_semanal VARCHAR(225),
    IN p_photo VARCHAR(255)
)
BEGIN
    UPDATE cultivos
    SET
        nombre_cientifico = p_nombre_cientifico,
        nombre_comun = p_nombre_comun,
        tiempo_crecimiento_dias = p_tiempo_crecimiento_dias,
        temperaturas_optimas = p_temperaturas_optimas,
        requerimiento_agua_semanal = p_requerimiento_agua_semanal,
        photo = p_photo
    WHERE id_cultivo = p_id_cultivo;
END //

DELIMITER ;


DELIMITER $$

CREATE PROCEDURE actualizar_empleado(
    IN p_id_empleado INT,
    IN p_DNI VARCHAR(15),
    IN p_nombre VARCHAR(50),
    IN p_apellido VARCHAR(50),
    IN p_fecha_nacimiento DATE,
    IN p_telefono VARCHAR(20),
    IN p_especialidad VARCHAR(25),
    IN p_fecha_contratacion DATE,
    IN p_salario FLOAT,
    IN p_area_asignada VARCHAR(50),
    IN p_fecha_fin_contrato DATE,
    IN p_photo VARCHAR(255)
)
BEGIN
    UPDATE empleados
    SET 
        DNI = p_DNI,
        nombre = p_nombre,
        apellido = p_apellido,
        fecha_nacimiento = p_fecha_nacimiento,
        telefono = p_telefono,
        especialidad = p_especialidad,
        fecha_contratacion = p_fecha_contratacion,
        salario = p_salario,
        area_asignada = p_area_asignada,
        fecha_fin_contrato = p_fecha_fin_contrato,
        photo = p_photo
    WHERE id_empleado = p_id_empleado;
END $$

DELIMITER ;



DELIMITER //

CREATE PROCEDURE actualizar_parcela(
    IN p_id_parcela INT,
    IN p_area FLOAT,
    IN p_sistema_riego VARCHAR(50),
    IN p_historial_uso VARCHAR(200),
    IN p_id_finca INT
)
BEGIN
    UPDATE parcelas
    SET AREA_HECTAREAS_PARCELAS = p_area,
        SISTEMA_RIEGO = p_sistema_riego,
        HISTORIAL_DE_USO = p_historial_uso,
        id_finca = p_id_finca
    WHERE ID_PARCELA = p_id_parcela;
END //

DELIMITER ;


DELIMITER //

CREATE PROCEDURE actualizar_finca(
    IN p_id_finca INT,
    IN p_nombre VARCHAR(100),
    IN p_latitud FLOAT,
    IN p_longitud FLOAT,
    IN p_hectareas FLOAT,
    IN p_altitud INT,
    IN p_temperatura FLOAT,
    IN p_tipo_suelo VARCHAR(50),
    IN p_region VARCHAR(100)
)
BEGIN
    UPDATE fincas
    SET nombre = p_nombre,
        latitud = p_latitud,
        longitud = p_longitud,
        extension_total_hectareas = p_hectareas,
        altitud_metros = p_altitud,
        temperatura_promedio_anual_fg = p_temperatura,
        tipo_suelo_predominante = p_tipo_suelo,
        region_ubicacion = p_region
    WHERE id_finca = p_id_finca;
END //

DELIMITER ;





/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
