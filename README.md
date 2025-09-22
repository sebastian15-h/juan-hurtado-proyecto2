# Sistema de Gestión Agrícola AgroControl SAS

Sistema integral de gestión agrícola desarrollado en Python con interfaz gráfica moderna para administrar fincas, parcelas, empleados y cultivos.

## 🌾 Características Principales

- **Gestión de Fincas**: Administra información completa de fincas incluyendo ubicación, extensión, altitud, temperatura y tipo de suelo
- **Control de Parcelas**: Maneja parcelas con datos de área, sistema de riego e historial de uso
- **Administración de Empleados**: Gestiona personal con información completa, especialidades y fotografías
- **Manejo de Cultivos**: Controla cultivos con datos científicos, tiempos de crecimiento y requerimientos
- **Exportación de Datos**: Exporta información a PDF y Excel
- **Interfaz Moderna**: Diseño oscuro/claro con CustomTkinter

## 📋 Requisitos del Sistema

### Software Requerido
- Python 3.8 o superior
- MySQL Server 8.0 o superior
- Sistema operativo: Windows 10/11, macOS, Linux

### Base de Datos
- MySQL con base de datos `agrocontrol_sas_db`
- Servidor local (localhost) con usuario `root` sin contraseña
- Tablas: `FINCAS`, `parcelas`, `empleados`, `cultivos`

## 🚀 Instalación

### 1. Clonar el repositorio
```bash
git clone https://github.com/tu-usuario/agrocontrol-sas.git
cd agrocontrol-sas
```

### 2. Instalar dependencias
```bash
pip install -r requirements.txt
```

### 3. Configurar base de datos
- Instalar MySQL Server
- Crear base de datos `agrocontrol_sas_db`
- Ejecutar scripts de creación de tablas y procedimientos almacenados

### 4. Ejecutar la aplicación
```bash
python entregable2.py
```

## 📦 Dependencias

```
tkinter==8.6
customtkinter==5.2.0
mysql-connector-python==8.2.0
reportlab==4.0.4
tkcalendar==1.6.1
CTkMessagebox==2.5
Pillow==10.0.0
pandas==2.1.0
```

## 🏗️ Estructura del Proyecto

```
agrocontrol-sas/
├── entregable2.py          # Archivo principal de la aplicación
├── requirements.txt        # Dependencias del proyecto
├── favicon.ico            # Icono de la aplicación
├── imagenes_empleados/    # Carpeta para fotos de empleados
├── assets/               # Iconos y recursos gráficos
│   ├── guardar.png
│   ├── actualizar.png
│   ├── borrar.png
│   ├── limpiar.png
│   └── buscar.png
└── database/
    ├── schema.sql        # Esquema de base de datos
    └── procedures.sql    # Procedimientos almacenados
```

## 💾 Configuración de Base de Datos

### Tablas Principales

#### FINCAS
- `ID_FINCA` (INT, AUTO_INCREMENT, PRIMARY KEY)
- `NOMBRE` (VARCHAR(50))
- `latitud` (DECIMAL(10,6))
- `longitud` (DECIMAL(10,6))
- `EXTENSION_TOTAL_HECTAREAS` (DECIMAL(8,2))
- `ALTITUD_METROS` (INT)
- `TEMPERATURA_PROMEDIO_ANUAL_fg` (DECIMAL(4,2))
- `TIPO_SUELO_PREDOMINANTE` (ENUM)
- `region_ubicacion` (VARCHAR(100))

#### parcelas
- `id_parcela` (INT, AUTO_INCREMENT, PRIMARY KEY)
- `AREA_HECTAREAS_PARCELAS` (DECIMAL(6,2))
- `SISTEMA_RIEGO` (ENUM)
- `HISTORIAL_DE_USO` (TEXT)
- `id_finca` (INT, FOREIGN KEY)

#### empleados
- `id_empleado` (INT, AUTO_INCREMENT, PRIMARY KEY)
- `DNI` (VARCHAR(20))
- `nombre` (VARCHAR(50))
- `apellido` (VARCHAR(50))
- `fecha_nacimiento` (DATE)
- `telefono` (VARCHAR(15))
- `direccion` (TEXT)
- `especialidad` (ENUM)
- `fecha_contratacion` (DATE)
- `salario` (DECIMAL(10,2))
- `area_asignada` (ENUM)
- `fecha_fin_contrato` (DATE)
- `photo` (TEXT)

#### cultivos
- `id_cultivo` (INT, AUTO_INCREMENT, PRIMARY KEY)
- `nombre_cientifico` (VARCHAR(100))
- `nombre_comun` (VARCHAR(50))
- `tiempo_crecimiento_dias` (INT)
- `temperaturas_optimas` (DECIMAL(4,2))
- `requerimiento_agua_semanal` (TEXT)
- `photo` (TEXT)

### Procedimientos Almacenados Requeridos
- `sp_insertfinca()`
- `sp_GetFincaByName()`
- `sp_insertparcela()`
- `sp_GetParcelaByID()`
- `sp_insertEmpleado()`
- `sp_buscar_empleado_por_id()`
- `sp_insertCultivo()`
- `BuscarCultivoPorID()`
- `eliminar_finca()`
- `eliminar_parcela()`
- `eliminar_empleado()`
- `eliminar_cultivo()`
- `actualizar_parcela()`
- `actualizar_empleado()`
- `actualizar_cultivo()`

## 🖥️ Uso de la Aplicación

### Interfaz Principal
La aplicación cuenta con 4 pestañas principales:

1. **FINCAS**: Gestión completa de fincas
2. **PARCELAS**: Administración de parcelas por finca
3. **EMPLEADOS**: Control de personal con fotografías
4. **CULTIVOS**: Manejo de cultivos con datos científicos

### Funcionalidades por Módulo

#### Gestión de Fincas
- Crear nuevas fincas con datos geográficos
- Buscar fincas por nombre
- Actualizar información existente
- Eliminar fincas (con confirmación)
- Exportar listados a PDF/Excel

#### Control de Parcelas
- Registrar parcelas asociadas a fincas
- Definir sistemas de riego
- Mantener historial de uso
- Buscar por ID de parcela

#### Administración de Empleados
- Registro completo con fotografía
- Especialidades y áreas de trabajo
- Control de fechas de contrato
- Gestión salarial

#### Manejo de Cultivos
- Datos científicos y comunes
- Tiempos de crecimiento
- Requerimientos ambientales
- Fotografías de cultivos

## 🎨 Personalización

### Cambio de Tema
- Botón "Cambiar fondo" para alternar entre tema oscuro y claro
- Colores personalizables en el código

### Validaciones
- Campos numéricos con validación automática
- Límites de caracteres en nombres
- Fechas con calendario visual

## 📊 Exportación de Datos

### Formatos Soportados
- **PDF**: Listados tabulares con ReportLab
- **Excel**: Archivos .xlsx con pandas

### Datos Exportables
- Listados completos de fincas
- Información de parcelas
- Directorio de empleados
- Catálogo de cultivos

## 🔧 Configuración Avanzada

### Conexión a Base de Datos
```python
# Modificar en la clase DatabaseConnection
host='localhost'        # Servidor MySQL
database='agrocontrol_sas_db'  # Nombre de BD
user='root'            # Usuario
password=''            # Contraseña
```

### Carpeta de Imágenes
```python
ruta_imagenes = "imagenes_empleados"  # Carpeta para fotos
```

## ⚠️ Solución de Problemas

### Error de Conexión MySQL
- Verificar que MySQL esté ejecutándose
- Confirmar credenciales de acceso
- Revisar que la base de datos exista

### Error de Dependencias
```bash
pip install --upgrade pip
pip install -r requirements.txt
```

### Problemas con Imágenes
- Verificar permisos de escritura en carpeta
- Formatos soportados: JPG, JPEG, PNG, GIF

## 📈 Mejoras Futuras

- [ ] Integración con APIs de clima
- [ ] Sistema de reportes avanzados
- [ ] Dashboard con gráficos
- [ ] Autenticación de usuarios
- [ ] Backup automático de datos
- [ ] Aplicación móvil

## 🤝 Contribución

1. Fork del proyecto
2. Crear rama para feature (`git checkout -b feature/nueva-funcionalidad`)
3. Commit de cambios (`git commit -am 'Agregar nueva funcionalidad'`)
4. Push a la rama (`git push origin feature/nueva-funcionalidad`)
5. Crear Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia MIT - ver archivo [LICENSE.md](LICENSE.md) para detalles.

## 📞 Soporte

Para soporte técnico o consultas:
- Email: soporte@agrocontrol-sas.com
- GitHub Issues: [Crear issue](https://github.com/tu-usuario/agrocontrol-sas/issues)

## 👥 Autores

- **Tu Nombre** - *Desarrollo inicial* - [TuGitHub](https://github.com/tu-usuario)

## 🙏 Agradecimientos

- CustomTkinter por la interfaz moderna
- ReportLab por generación de PDFs
- Comunidad MySQL por la base de datos
- Contribuidores del proyecto

---
⭐ **¡Dale una estrella al proyecto si te fue útil!**
