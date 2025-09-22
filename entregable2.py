import tkinter as tk
from tkinter import ttk
from tkinter import messagebox
import mysql.connector
from datetime import datetime
from reportlab.platypus import SimpleDocTemplate, Table
from reportlab.lib.pagesizes import A4, landscape
from tkcalendar import DateEntry
import customtkinter as ctk
from CTkMessagebox import CTkMessagebox
from tkinter import filedialog
from PIL import Image
from customtkinter import CTkImage
from reportlab.pdfgen import canvas
from PIL import Image, ImageTk
import pandas as pd
import os



# =================== CONFIGURACIÓN DE BASE DE DATOS ===================
class DatabaseConnection:
    def __init__(self):
        self.connection = None
        self.cursor = None

    def connect(self):
        try:
            self.connection = mysql.connector.connect(
                host='localhost',
                database='agrocontrol_sas_db',
                user='root',
                password='',
                autocommit=False
            )
            self.cursor = self.connection.cursor(buffered=True)
            return True
        except mysql.connector.Error as err:
            messagebox.showerror("Error de Conexión", f"Error conectando a la base de datos: {err}")
            return False

    def disconnect(self):
        if self.cursor:
            self.cursor.close()
        if self.connection:
            self.connection.close()

    def call_procedure(self, procedure_name, parameters=None):
        try:
            if parameters:
                self.cursor.callproc(procedure_name, parameters)
            else:
                self.cursor.callproc(procedure_name)

            # Obtener resultados
            results = []
            for result in self.cursor.stored_results():
                results.extend(result.fetchall())

            return True, results
        except mysql.connector.Error as err:
            self.connection.rollback()
            return False, str(err)


# Instancia global de conexión
db = DatabaseConnection()

import mysql.connector

def cargar_datos_fincas():
    # Limpiar el Treeview para no duplicar datos
    for item in products_tree.get_children():
        products_tree.delete(item)

    # Conectar a la base de datos (ajusta con tus datos)
    conexion = mysql.connector.connect(
        host='localhost',
        user='root',
        password='',
        database='agrocontrol_sas_db'
    )
    cursor = conexion.cursor()

    # Ejecutar consulta para obtener fincas
    consulta = """
        SELECT ID_FINCA, NOMBRE, latitud, longitud, EXTENSION_TOTAL_HECTAREAS,
               ALTITUD_METROS, TEMPERATURA_PROMEDIO_ANUAL_fg, TIPO_SUELO_PREDOMINANTE, region_ubicacion
        FROM FINCAS
    """
    cursor.execute(consulta)
    filas = cursor.fetchall()

    # Insertar filas en el Treeview
    for fila in filas:
        products_tree.insert('', 'end', values=fila)

    cursor.close()
    conexion.close()

def cargar_datos_parcelas():
    # Limpiar el Treeview para no duplicar datos
    for item in customers_tree.get_children():
        customers_tree.delete(item)

    # Conectar a la base de datos (ajusta con tus datos)
    conexion = mysql.connector.connect(
        host='localhost',
        user='root',
        password='',
        database='agrocontrol_sas_db'
    )
    cursor = conexion.cursor()

    # Ejecutar consulta para obtener fincas
    consulta = """
        SELECT id_parcela, AREA_HECTAREAS_PARCELAS, SISTEMA_RIEGO, HISTORIAL_DE_USO, id_finca
        FROM parcelas
    """
    cursor.execute(consulta)
    filas = cursor.fetchall()

    # Insertar filas en el Treeview
    for fila in filas:
        customers_tree.insert('', 'end', values=fila)

    cursor.close()
    conexion.close()

def cargar_datos_cultivos():
    # Limpiar el Treeview para no duplicar datos
    for item in cultivos_tree.get_children():
        cultivos_tree.delete(item)

    # Conectar a la base de datos (ajusta con tus datos)
    conexion = mysql.connector.connect(
        host='localhost',
        user='root',
        password='',
        database='agrocontrol_sas_db'
    )
    cursor = conexion.cursor()

    # Ejecutar consulta para obtener fincas
    consulta = """
        SELECT id_cultivo, nombre_cientifico, nombre_comun, tiempo_crecimiento_dias, temperaturas_optimas,requerimiento_agua_semanal
        FROM cultivos
    """
    cursor.execute(consulta)
    filas = cursor.fetchall()

    # Insertar filas en el Treeview
    for fila in filas:
        cultivos_tree.insert('', 'end', values=fila)

    cursor.close()
    conexion.close()

def cargar_datos_empleados():
    # Limpiar el Treeview para no duplicar datos
    for item in employees_tree.get_children():
        employees_tree.delete(item)

    # Conectar a la base de datos (ajusta con tus datos)
    conexion = mysql.connector.connect(
        host='localhost',
        user='root',
        password='',
        database='agrocontrol_sas_db'
    )
    cursor = conexion.cursor()

    # Ejecutar consulta para obtener fincas
    consulta = """
        SELECT id_empleado, DNI, nombre, apellido, fecha_nacimiento,telefono,direccion,especialidad,fecha_contratacion,salario,area_asignada,fecha_fin_contrato,photo
        FROM empleados
    """
    cursor.execute(consulta)
    filas = cursor.fetchall()

    # Insertar filas en el Treeview
    for fila in filas:
        employees_tree.insert('', 'end', values=fila)

    cursor.close()
    conexion.close()

# =================== FUNCIONES DE VALIDACIÓN ===================
def validate_numeric(value, field_name, force_int=False):
    if not value.strip():
        return False, None  # ID NO puede estar vacío

    try:
        val = int(value) if force_int else (float(value) if '.' in value else int(value))
        return True, val
    except ValueError:
        messagebox.showerror("Error de Validación", f"{field_name} debe ser un número válido")
        return False, None




def validate_required(value, field_name):
    if not value.strip():
        CTkMessagebox(title="Error de Validación", message=f"{field_name} es requerido")
        return False
    return True


def validate_date(date_string):
    if not date_string.strip():
        return True, None
    try:
        # Aceptar formato YYYY-MM-DD
        date_obj = datetime.strptime(date_string, "%Y-%m-%d")
        return True, date_obj
    except ValueError:
        messagebox.showerror("Error de Validación", "Fecha debe estar en formato YYYY-MM-DD")
        return False, None


# =================== FUNCIONES PARA FINCAS ===================
def save_finca():
    print("Botón 'Guardar' presionado")


    if not db.connection:
        if not db.connect():
            print("No se pudo conectar a la BD")
            return

        # Validación de nombre
    if not validate_required(nombre.get(), "Nombre de la finca"):
            return

        # Captura de valores
    nombre_val = nombre.get()
    latitud_val = latitud.get()
    longitud_val = longitud.get()
    hectareas_val = extension_total_hectareas.get()
    altitud_val = altitud.get()
    temperatura_val = temp_p_a.get()
    suelo_val = suelo.get()
    region_val = region.get()

    print("Valores capturados:")
    print("Nombre:", nombre_val)
    print("Latitud:", latitud_val)
    print("Longitud:", longitud_val)
    print("Hectáreas:", hectareas_val)
    print("Altitud:", altitud_val)
    print("Temperatura:", temperatura_val)
    print("Suelo:", suelo_val)
    print("Región:", region_val)

    parameters = (
        nombre_val,
        latitud_val,
        longitud_val,
        hectareas_val,
        altitud_val,
        temperatura_val,
        suelo_val,
        region_val
    )

        # Llamada al procedimiento
    success, result = db.call_procedure('sp_insertfinca', parameters)
    print("Resultado de call_procedure:", success, result)

    if success:
        messagebox.showinfo("Éxito", "Finca guardada correctamente")

    else:
        messagebox.showerror("Error", f"Error al guardar finca: {result}")


def buscar_finca_por_nombre():
    if not db.connection:
        if not db.connect():
            return

    nombre_buscado = nombre.get().strip()
    if not nombre_buscado:
        messagebox.showerror("Error", "Debe ingresar un nombre de finca")
        return

    success, result = db.call_procedure('sp_GetFincaByName', (nombre_buscado,))

    if success and result:
        finca = result[0]  # Solo tomamos la primera coincidencia

        # Importante: usar índices correctos
        nombre.delete(0, tk.END)
        nombre.insert(0, finca[1] or "")

        latitud.delete(0, tk.END)
        latitud.insert(0, str(finca[2]) if finca[2] is not None else "")

        longitud.delete(0, tk.END)
        longitud.insert(0, str(finca[3]) if finca[3] is not None else "")

        extension_total_hectareas.delete(0, tk.END)
        extension_total_hectareas.insert(0, str(finca[4]) if finca[4] is not None else "")

        altitud.delete(0, tk.END)
        altitud.insert(0, str(finca[5]) if finca[5] is not None else "")

        temp_p_a.delete(0, tk.END)
        temp_p_a.insert(0, str(finca[6]) if finca[6] is not None else "")

        suelo.set(finca[7] or suelo_tipo[0])

        region.delete(0, tk.END)
        region.insert(0, finca[8] or "")
    else:
        messagebox.showinfo("No encontrado", "No se encontró una finca con ese nombre.")

def limpiar_campos_fincas():
    nombre.delete(0, tk.END)
    latitud.delete(0, tk.END)
    longitud.delete(0, tk.END)
    extension_total_hectareas.delete(0, tk.END)
    altitud.delete(0, tk.END)
    temp_p_a.delete(0, tk.END)
    suelo.set(suelo_tipo[0])  # Valor por defecto del OptionMenu
    region.delete(0, tk.END)

def eliminar_finca(nombre_finca):
    if not nombre_finca.strip():
        messagebox.showerror("Error", "Debe ingresar un nombre válido.")
        return

    respuesta = messagebox.askyesno("Confirmar eliminación", f"¿Está seguro que desea eliminar la finca '{nombre_finca}'?")
    if respuesta:
        try:
            conexion = mysql.connector.connect(
                host='localhost',
                user='root',
                password='',
                database='agrocontrol_sas_db'
            )
            if conexion.is_connected():
                cursor = conexion.cursor()
                # Aquí usamos un procedimiento almacenado que recibe el nombre
                cursor.callproc('eliminar_finca', [nombre_finca])
                conexion.commit()
                messagebox.showinfo("Éxito", f"Finca '{nombre_finca}' eliminada correctamente.")
                cursor.close()
                conexion.close()
        except mysql.connector.Error as e:
            messagebox.showerror("Error", f"No se pudo eliminar la finca: {e}")

def actualizar_finca():
    try:
        sql = """
            UPDATE fincas SET
                latitud=%s,
                longitud=%s,
                EXTENSION_TOTAL_HECTAREAS=%s,
                ALTITUD_METROS=%s,
                TEMPERATURA_PROMEDIO_ANUAL_fg=%s,
                TIPO_SUELO_PREdOMINANTE=%s,
                region_ubicacion=%s
            WHERE NOMBRE=%s
        """
        values = (
            latitud.get().strip(),
            longitud.get().strip(),
            extension_total_hectareas.get().strip(),
            altitud.get().strip(),
            temp_p_a.get().strip(),
            suelo.get(),
            region.get().strip(),
            nombre.get().strip()  # Aquí usas el nombre para buscar
        )

        db.cursor.execute(sql, values)
        db.connection.commit()

        messagebox.showinfo("Éxito", "Finca actualizada correctamente")
        cargar_datos_fincas()
        limpiar_campos_fincas()
    except mysql.connector.Error as err:
        messagebox.showerror("Error", f"No se pudo actualizar la finca: {err}")


# =================== FUNCIONES PARA parcelas ===================
def save_parcelas():
    # Validar campos obligatorios
    if not area_hectareas.get().strip():
        messagebox.showerror("Error", "Debe ingresar el área en hectáreas")
        return
    if not idfinca.get().strip():
        messagebox.showerror("Error", "Debe ingresar el ID de la finca")
        return

    # Validar que área y idfinca sean números válidos
    valid_area, area_val = validate_numeric(area_hectareas.get(), "Área hectáreas")
    if not valid_area:
        return
    valid_finca, finca_val = validate_numeric(idfinca.get(), "ID finca")
    if not valid_finca:
        return

    # Obtener valores de otros campos
    sistema_riego_val = riego.get()  # opcion del OptionMenu
    historial_val = historial.get().strip() or None

    parameters = (
        area_val,
        sistema_riego_val,
        historial_val,
        finca_val
    )

    success, result = db.call_procedure('sp_insertparcela', parameters)

    if success:
        messagebox.showinfo("Éxito", "Parcela guardada correctamente")
    else:
        messagebox.showerror("Error", f"Error al guardar parcela: {result}")


import tkinter as tk
from tkinter import messagebox


def buscar_parcela_por_id():
    id_texto = idparcela.get().strip()
    if not id_texto.isdigit():
        messagebox.showerror("Error", "Debe ingresar un ID numérico válido")
        return

    id_valor = int(id_texto)

    try:
        cursor = db.connection.cursor()
        cursor.callproc('sp_GetParcelaByID', (id_valor,))

        # El resultado del callproc se obtiene con stored_results()
        resultado = []
        for result in cursor.stored_results():
            resultado = result.fetchall()

        cursor.close()

        if resultado:
            parcela = resultado[0]
            # Actualizar campos con datos recuperados
            idparcela.delete(0, tk.END)
            idparcela.insert(0, parcela[0])

            area_hectareas.delete(0, tk.END)
            area_hectareas.insert(0, str(parcela[1]) if parcela[1] is not None else "")

            # Asumiendo que 'riego' es CTkOptionMenu
            if parcela[2] in sistema_riego:
                riego.set(parcela[2])
            else:
                riego.set(sistema_riego[0])  # valor por defecto

            historial.delete(0, tk.END)
            historial.insert(0, parcela[3] or "")

            idfinca.delete(0, tk.END)
            idfinca.insert(0, str(parcela[4]) if parcela[4] is not None else "")

        else:
            messagebox.showinfo("No encontrado", f"No se encontró parcela con ID {id_valor}")

    except Exception as e:
        messagebox.showerror("Error", f"Error al buscar parcela: {e}")

def limpiar_campos_parcelas():
    idparcela.delete(0, tk.END)
    area_hectareas.delete(0, tk.END)
    historial.delete(0, tk.END)
    idfinca.delete(0, tk.END)
    riego.set(sistema_riego[0])  # Valor por defecto del OptionMenu


def eliminar_parcela(id_parcela):
    if not id_parcela:
        messagebox.showwarning("Advertencia", "Por favor, ingresa el ID de la parcela para eliminar.")
        return

    respuesta = messagebox.askyesno("Confirmar eliminación",
                                    f"¿Seguro que quieres eliminar la parcela con ID {id_parcela}?")
    if respuesta:
        try:
            conexion = mysql.connector.connect(
                host='localhost',
                user='root',
                password='',
                database='agrocontrol_sas_db'
            )
            cursor = conexion.cursor()
            cursor.callproc('eliminar_parcela', [id_parcela])
            conexion.commit()
            cursor.close()
            conexion.close()
            messagebox.showinfo("Éxito", "Parcela eliminada correctamente.")
            limpiar_campos_parcelas()  # Si tienes una función para limpiar campos en el formulario
            cargar_datos_parcelas()  # Si tienes una función para recargar la lista de parcelas
        except mysql.connector.Error as err:
            messagebox.showerror("Error", f"No se pudo eliminar la parcela: {err}")
    else:
        messagebox.showinfo("Cancelado", "Eliminación cancelada.")

def actualizar_parcela_sp():
    respuesta = messagebox.askyesno("Confirmar actualización", "¿Desea actualizar esta parcela?")
    if respuesta:
        try:
            id_val = int(idparcela.get().strip())
            area_val = float(area_hectareas.get().strip())
            riego_val = riego.get()
            historial_val = historial.get().strip()
            idfinca_val = int(idfinca.get().strip())

            conexion = mysql.connector.connect(
                host='localhost',
                user='root',
                password='',
                database='agrocontrol_sas_db'
            )
            cursor = conexion.cursor()

            cursor.callproc('actualizar_parcela', [id_val, area_val, riego_val, historial_val, idfinca_val])
            conexion.commit()

            messagebox.showinfo("Éxito", "Parcela actualizada correctamente.")
            cargar_datos_parcelas()
            limpiar_campos_parcelas()

            cursor.close()
            conexion.close()

        except ValueError:
            messagebox.showerror("Error", "Por favor ingresa valores numéricos válidos.")
        except mysql.connector.Error as err:
            messagebox.showerror("Error BD", f"Error en base de datos: {err}")
        except Exception as e:
            messagebox.showerror("Error", f"Ocurrió un error: {str(e)}")
    else:
        messagebox.showinfo("Cancelado", "Actualización cancelada.")



# =================== FUNCIONES PARA EMPLEADOS ===================
def save_empleados():
    # Validar campos obligatorios (ejemplo solo nombre y apellido)
    if not nombre_employee.get().strip():
        messagebox.showerror("Error", "Debe ingresar el nombre del empleado")
        return
    if not apellido_employee.get().strip():
        messagebox.showerror("Error", "Debe ingresar el apellido del empleado")
        return

    # Obtener los valores de los widgets
    dni = dni_employee.get().strip()
    nombre = nombre_employee.get().strip()
    apellido = apellido_employee.get().strip()

    # Para DateEntry, el método get_date() devuelve objeto datetime.date
    fecha_nacimiento_val = fecha_employee.get_date()
    telefono = tel_employee.get().strip()
    direccion = ""  # Aquí debes agregar widget o dato si tienes dirección
    especialidad = especialidad_employee.get()
    fecha_contratacion_val = contrato_employee.get_date()

    # Para salario, convertir a float (validar en tu función real)
    try:
        salario_val = float(salario_employee.get())
    except ValueError:
        messagebox.showerror("Error", "Salario debe ser un número válido")
        return

    area_asignada = area_asignada_e.get()
    fecha_fin_contrato_val = fin_employee.get_date()

    photo_val = Photo.get().strip()  # Si tienes ruta o nombre de archivo

    parameters = (
        dni,
        nombre,
        apellido,
        fecha_nacimiento_val,
        telefono,
        direccion,
        especialidad,
        fecha_contratacion_val,
        salario_val,
        area_asignada,
        fecha_fin_contrato_val,
        photo_val
    )

    success, result = db.call_procedure('sp_insertEmpleado', parameters)

    if success:
        messagebox.showinfo("Éxito", "Empleado guardado correctamente")
    else:
        messagebox.showerror("Error", f"Error al guardar empleado: {result}")


def buscar_empleado_por_id():
    id_emp = idempleado.get()
    if not id_emp.isdigit():
        messagebox.showerror("Error", "Ingrese un ID válido.")
        return

    try:
        db.cursor.callproc('sp_buscar_empleado_por_id', [int(id_emp)])
        for result in db.cursor.stored_results():
            empleado = result.fetchone()

        if empleado:
            # Rellenar los campos del formulario
            dni_employee.delete(0, 'end')
            dni_employee.insert(0, empleado[1])

            nombre_employee.delete(0, 'end')
            nombre_employee.insert(0, empleado[2])

            apellido_employee.delete(0, 'end')
            apellido_employee.insert(0, empleado[3])

            fecha_employee.set_date(empleado[4])  # DateEntry

            tel_employee.delete(0, 'end')
            tel_employee.insert(0, empleado[5])

            especialidad_employee.set(empleado[7])  # OptionMenu

            contrato_employee.set_date(empleado[8])  # DateEntry

            salario_employee.delete(0, 'end')
            salario_employee.insert(0, empleado[9])

            area_asignada_e.set(empleado[10])  # OptionMenu

            fin_employee.set_date(empleado[11])  # DateEntry

            Photo.delete(0, 'end')
            Photo.insert(0, empleado[12])

        else:
            messagebox.showinfo("No encontrado", f"No se encontró el empleado con ID {id_emp}")

    except mysql.connector.Error as err:
        messagebox.showerror("Error de base de datos", str(err))

def limpiar_campos_empleados():
    idempleado.delete(0, tk.END)
    dni_employee.delete(0, tk.END)
    nombre_employee.delete(0, tk.END)
    apellido_employee.delete(0, tk.END)
    fecha_employee.set_date(datetime.now())
    tel_employee.delete(0, tk.END)
    especialidad_employee.set(especialidades[0])
    contrato_employee.set_date(datetime.now())
    salario_employee.delete(0, tk.END)
    area_asignada_e.set(areas[0])
    fin_employee.set_date(datetime.now())
    Photo.delete(0, tk.END)


def eliminar_empleado(id_empleado):
    if not id_empleado:
        messagebox.showwarning("Aviso", "Por favor, ingrese el ID del empleado.")
        return

    # Pregunta al usuario si realmente quiere eliminar el empleado
    respuesta = messagebox.askyesno("Confirmar eliminación", "¿Estás seguro de que quieres eliminar este empleado?")

    if respuesta:  # Si responde 'Sí'
        try:
            conexion = mysql.connector.connect(
                host='localhost',
                user='root',
                password='',
                database='agrocontrol_sas_db'
            )

            if conexion.is_connected():
                cursor = conexion.cursor()
                cursor.callproc('eliminar_empleado', [id_empleado])
                conexion.commit()
                messagebox.showinfo("Éxito", "Empleado eliminado correctamente.")
                cursor.close()
                conexion.close()

        except ValueError as e:
            messagebox.showerror("Error", f"No se pudo eliminar el empleado: {e}")
    else:
        messagebox.showinfo("Cancelado", "Eliminación cancelada por el usuario.")

def actualizar_empleado():
    # Obtener los valores del formulario
    id_valor = idempleado.get().strip()
    dni_val = dni_employee.get().strip()
    nombre_val = nombre_employee.get().strip()
    apellido_val = apellido_employee.get().strip()
    fecha_nac_val = fecha_employee.get_date()
    telefono_val = tel_employee.get().strip()
    especialidad_val = especialidad_employee.get().strip()
    fecha_contrato_val = contrato_employee.get_date()
    salario_val = salario_employee.get().strip()
    area_asignada_val = area_asignada_e.get().strip()
    fecha_fin_val = fin_employee.get_date()
    photo_val = Photo.get().strip()

    # Validaciones
    if not id_valor.isdigit():
        messagebox.showerror("Error", "El ID de empleado no es válido.")
        return
    if not nombre_val or not apellido_val:
        messagebox.showwarning("Error de datos", "Debe ingresar nombre y apellido.")
        return

    id_int = int(id_valor)

    # Confirmación
    respuesta = messagebox.askyesno("Confirmar actualización",
                                    f"¿Seguro que deseas actualizar al empleado con ID {id_int}?")
    if not respuesta:
        return

    try:
        conexion = mysql.connector.connect(
            host='localhost',
            user='root',
            password='',
            database='agrocontrol_sas_db'
        )
        if conexion.is_connected():
            cursor = conexion.cursor()
            cursor.callproc('actualizar_empleado', [
                id_int,
                dni_val,
                nombre_val,
                apellido_val,
                fecha_nac_val,
                telefono_val,
                especialidad_val,
                fecha_contrato_val,
                float(salario_val) if salario_val else 0.0,
                area_asignada_val,
                fecha_fin_val,
                photo_val
            ])
            conexion.commit()
            messagebox.showinfo("Éxito", f"Empleado con ID {id_int} actualizado correctamente.")
            cursor.close()
            conexion.close()

            cargar_datos_empleados()  # Refrescar lista en Treeview
            limpiar_campos_empleados()  # Limpiar los campos del formulario
    except Error as e:
        messagebox.showerror("Error MySQL", f"No se pudo actualizar el empleado: {e}")


def load_employees_list():
    if not db.connection:
        if not db.connect():
            return

    success, results = db.call_procedure('sp_GetAllEmployees')
    if success:
        for item in employees_tree.get_children():
            employees_tree.delete(item)

        for employee in results:
            # Formatear fecha para mostrar
            birth_date_str = employee[3].strftime("%Y-%m-%d") if employee[3] else ""
            display_data = (employee[0], employee[1], employee[2], birth_date_str, employee[4],
                            employee[5][:50] + "..." if employee[5] and len(employee[5]) > 50 else employee[5])
            employees_tree.insert('', 'end', values=display_data)


# ====================== FUNCIONES PARA CULTIVOS ============================

def save_cultivos():
    # Validar campos obligatorios
    if not nombre_cntfco.get().strip():
        messagebox.showerror("Error", "Debe ingresar el nombre científico")
        return
    if not nombre_comun.get().strip():
        messagebox.showerror("Error", "Debe ingresar el nombre común")
        return
    if not crecimientodd.get().strip():
        messagebox.showerror("Error", "Debe ingresar el tiempo de crecimiento (días)")
        return
    if not temp_cultivos.get().strip():
        messagebox.showerror("Error", "Debe ingresar la temperatura óptima")
        return

    # Validar que tiempo de crecimiento y temperatura sean números válidos
    try:
        tiempo_crecimiento_val = int(crecimientodd.get().strip())
    except ValueError:
        messagebox.showerror("Error", "Tiempo de crecimiento debe ser un número entero válido")
        return

    try:
        temperaturas_optimas_val = float(temp_cultivos.get().strip())
    except ValueError:
        messagebox.showerror("Error", "Temperatura óptima debe ser un número válido")
        return

    # Obtener valores de otros campos
    nombre_cientifico_val = nombre_cntfco.get().strip()
    nombre_comun_val = nombre_comun.get().strip()
    requerimiento_agua_val = requerimiento_agua.get().strip() or None
    photo_val = Photo_cultivo.get().strip() or None

    parameters = (
        nombre_cientifico_val,
        nombre_comun_val,
        tiempo_crecimiento_val,
        temperaturas_optimas_val,
        requerimiento_agua_val,
        photo_val
    )

    success, result = db.call_procedure('sp_insertCultivo', parameters)

    if success:
        messagebox.showinfo("Éxito", "Cultivo guardado correctamente")

    else:
        messagebox.showerror("Error", f"Error al guardar cultivo: {result}")


def buscar_cultivo_por_id():
    id_texto = idcultivo.get().strip()
    if not id_texto.isdigit():
        messagebox.showerror("Error", "Debe ingresar un ID numérico válido")
        return

    id_valor = int(id_texto)

    try:
        db = DatabaseConnection()
        if not db.connect():
            return

        cursor = db.connection.cursor()
        cursor.callproc('BuscarCultivoPorID', (id_valor,))

        resultado = []
        for result in cursor.stored_results():
            resultado = result.fetchall()

        cursor.close()
        db.connection.close()

        if resultado:
            cultivo = resultado[0]
            # Actualizar campos con datos recuperados
            idcultivo.delete(0, tk.END)
            idcultivo.insert(0, cultivo[0])

            nombre_cntfco.delete(0, tk.END)
            nombre_cntfco.insert(0, cultivo[1] or "")

            nombre_comun.delete(0, tk.END)
            nombre_comun.insert(0, cultivo[2] or "")

            crecimientodd.delete(0, tk.END)
            crecimientodd.insert(0, str(cultivo[3]) if cultivo[3] is not None else "")

            temp_cultivos.delete(0, tk.END)
            temp_cultivos.insert(0, str(cultivo[4]) if cultivo[4] is not None else "")

            requerimiento_agua.delete(0, tk.END)
            requerimiento_agua.insert(0, cultivo[5] or "")

            Photo_cultivo.delete(0, tk.END)
            Photo_cultivo.insert(0, cultivo[6] or "")

        else:
            messagebox.showinfo("No encontrado", f"No se encontró cultivo con ID {id_valor}")

    except Exception as e:
        messagebox.showerror("Error", f"Error al buscar cultivo: {e}")

def limpiar_campos_cultivos():
    idcultivo.delete(0, tk.END)
    nombre_cntfco.delete(0, tk.END)
    nombre_comun.delete(0, tk.END)
    crecimientodd.delete(0, tk.END)
    temp_cultivos.delete(0, tk.END)
    requerimiento_agua.delete(0, tk.END)
    Photo_cultivo.delete(0, tk.END)

    # Restablecer imagen
    label_imagen.configure(text="Sin imagen", image=None)

    # Resetear la variable global si la usás para la miniatura
    global imagen_miniatura
    imagen_miniatura = None


from tkinter import messagebox

def eliminar_cultivo(id_cultivo):
    if not id_cultivo:
        messagebox.showwarning("Advertencia", "Por favor, ingresa un ID de cultivo válido.")
        return

    respuesta = messagebox.askyesno("Confirmar eliminación", f"¿Estás seguro de eliminar el cultivo con ID {id_cultivo}?")
    if respuesta:
        try:
            conexion = mysql.connector.connect(
                host='localhost',
                user='root',
                password='',
                database='agrocontrol_sas_db'
            )

            if conexion.is_connected():
                cursor = conexion.cursor()
                cursor.callproc('eliminar_cultivo', [id_cultivo])
                conexion.commit()
                messagebox.showinfo("Éxito", f"Cultivo con ID {id_cultivo} eliminado correctamente.")
                # Aquí puedes agregar alguna función para refrescar la lista o limpiar campos
        except ValueError as e:
            messagebox.showerror("Error", f"No se pudo eliminar el cultivo: {e}")
        finally:
            if conexion.is_connected():
                cursor.close()
                conexion.close()
    else:
        # Si el usuario cancela la eliminación
        messagebox.showinfo("Cancelado", "Eliminación cancelada.")

import mysql.connector
from mysql.connector import Error
from tkinter import messagebox
from tkinter import simpledialog  # por si necesitás inputs extras después

def actualizar_cultivo():
    # Obtener valores del formulario
    id_valor = idcultivo.get().strip()
    nombre_cientifico_val = nombre_cntfco.get().strip()
    nombre_comun_val = nombre_comun.get().strip()
    tiempo_crec_val = crecimientodd.get().strip()
    temp_opt_val = temp_cultivos.get().strip()
    agua_sem_val = requerimiento_agua.get().strip()
    photo_val = Photo_cultivo.get().strip()

    # Validaciones básicas
    if not id_valor.isdigit():
        messagebox.showerror("Error", "El ID del cultivo no es válido.")
        return
    if not nombre_cientifico_val or not nombre_comun_val:
        messagebox.showwarning("Campos requeridos", "Debe ingresar el nombre científico y el nombre común.")
        return

    id_int = int(id_valor)

    # Confirmación con askyesno
    confirmar = messagebox.askyesno("Confirmación", f"¿Desea actualizar el cultivo con ID {id_int}?")
    if not confirmar:
        return  # Si el usuario presiona "No", se cancela la actualización

    try:
        conexion = mysql.connector.connect(
            host='localhost',
            user='root',
            password='',
            database='agrocontrol_sas_db'
        )
        if conexion.is_connected():
            cursor = conexion.cursor()
            cursor.callproc('actualizar_cultivo', [
                id_int,
                nombre_cientifico_val,
                nombre_comun_val,
                int(tiempo_crec_val) if tiempo_crec_val.isdigit() else 0,
                float(temp_opt_val) if temp_opt_val else 0.0,
                agua_sem_val,
                photo_val
            ])
            conexion.commit()
            cursor.close()
            conexion.close()

            messagebox.showinfo("Éxito", f"Cultivo con ID {id_int} actualizado correctamente.")
            cargar_datos_cultivos()
            limpiar_campos_cultivos()

    except Error as e:
        messagebox.showerror("Error MySQL", f"No se pudo actualizar el cultivo: {e}")




#==============================================================

def on_click_photo_employees():
    global imagen_miniatura

    employee_id = idempleado.get().strip()
    if not employee_id:
        CTkMessagebox(title='error',message='ingresa primero el id del empleado ⚠️')
        return

    archivo = filedialog.askopenfilename(
        title="Selecciona una imagen",
        filetypes=[("Imágenes", "*.jpg *.jpeg *.png *.gif")]
    )

    if archivo:
        try:
            imagen = Image.open(archivo)
            imagen = imagen.resize((200, 200))

            nueva_ruta = os.path.join(ruta_imagenes, f"{employee_id}.png")
            imagen.save(nueva_ruta)

            # Mostrar la ruta en el Entry
            Photo.delete(0, "end")
            Photo.insert(0, nueva_ruta)

            # Mostrar miniatura en el CTkLabel
            imagen_miniatura = CTkImage(light_image=imagen, size=(200, 100))
            label_imagen.configure(image=imagen_miniatura, text="")  # Quita el texto

            print(f"✅ Imagen guardada y miniatura mostrada.")

        except Exception as e:
            print(f"❌ Error al procesar la imagen: {e}")

def on_click_photo_cultivos():
    global imagen_miniatura

    cultivo_id = idcultivo.get().strip()
    if not cultivo_id:
        messagebox.showerror("Error", "Ingresa primero el ID del cultivo ⚠️")
        return

    archivo = filedialog.askopenfilename(
        title="Selecciona una imagen",
        filetypes=[("Imágenes", "*.jpg *.jpeg *.png *.gif")]
    )

    if archivo:
        try:
            imagen = Image.open(archivo)
            imagen = imagen.resize((200, 200))

            if not os.path.exists(ruta_imagenes):
                os.makedirs(ruta_imagenes)

            nueva_ruta = os.path.join(ruta_imagenes, f"{cultivo_id}.png")
            imagen.save(nueva_ruta)

            Photo_cultivo.delete(0, "end")
            Photo_cultivo.insert(0, nueva_ruta)

            imagen_miniatura = CTkImage(light_image=imagen, size=(200, 200))
            label_imagen.configure(image=imagen_miniatura, text="")

        except Exception as e:
            messagebox.showerror("Error", f"Error al procesar la imagen: {e}")



# =================== FUNCIONES DE EVENTOS PARA LISTAS ===================

def on_product_select(event):
    selection = products_tree.selection()
    if selection:
        item = products_tree.item(selection[0])
        values = item['values']



def on_customer_select(event):
    selection = customers_tree.selection()
    if selection:
        item = customers_tree.item(selection[0])
        values = item['values']



def on_employee_select(event):
    selection = employees_tree.selection()
    if selection:
        item = employees_tree.item(selection[0])
        values = item['values']


#========================= pdf function====================

def exportar_pdf(datos, columnas, titulo, nombre_archivo):
    try:
        doc = SimpleDocTemplate(nombre_archivo, pagesize=landscape(A4))
        tabla_data = [columnas] + datos
        tabla = Table(tabla_data)

        doc.build([tabla])
        messagebox.showinfo("Éxito", "PDF exportado correctamente.")
    except Exception as e:
        messagebox.showerror("Error", f"No se pudo exportar PDF:\n{str(e)}")

#========================== excel export =====================


def exportar_fincas_excel():
    datos = []
    for row_id in products_tree.get_children():
        datos.append(products_tree.item(row_id)['values'])

    columnas = [col for col in products_tree["columns"]]
    df = pd.DataFrame(datos, columns=columnas)

    archivo = filedialog.asksaveasfilename(defaultextension=".xlsx", filetypes=[("Excel files", "*.xlsx")])
    if archivo:
        df.to_excel(archivo, index=False)
        messagebox.showinfo("Éxito", "Datos de fincas exportados a Excel correctamente.")


def exportar_parcelas_excel():
    datos = []
    for row_id in customers_tree.get_children():
        datos.append(customers_tree.item(row_id)['values'])

    columnas = [col for col in customers_tree["columns"]]
    df = pd.DataFrame(datos, columns=columnas)

    archivo = filedialog.asksaveasfilename(defaultextension=".xlsx", filetypes=[("Excel files", "*.xlsx")])
    if archivo:
        df.to_excel(archivo, index=False)
        messagebox.showinfo("Éxito", "Datos de parcelas exportados a Excel correctamente.")

def exportar_empleados_excel():
    try:
        archivo = filedialog.asksaveasfilename(
            defaultextension=".xlsx",
            filetypes=[("Archivos de Excel", "*.xlsx")]
        )
        if not archivo:
            return

        columnas = [
            'ID', 'DNI', 'Nombre', 'APELLIDO', 'BIRTHDAY', 'TEL',
            'DIRCC', 'ESPECIALIDAD', 'CONTRATACION', 'SALARIO',
            'AREA', 'FIN-CONTARTO', 'photo'
        ]

        datos = [employees_tree.item(i)['values'] for i in employees_tree.get_children()]

        df = pd.DataFrame(datos, columns=columnas)
        df.to_excel(archivo, index=False)
        messagebox.showinfo("Éxito", "Empleados exportados correctamente a Excel.")
    except Exception as e:
        messagebox.showerror("Error", f"No se pudo exportar a Excel: {str(e)}")

def exportar_cultivos_excel():
    try:
        archivo = filedialog.asksaveasfilename(defaultextension=".xlsx", filetypes=[("Excel files", "*.xlsx")])
        if not archivo:
            return

        columnas = ['ID', 'Nombre', 'Tipo', 'Inicio', 'Fin', 'Riego']
        datos = [cultivos_tree.item(i)['values'] for i in cultivos_tree.get_children()]
        df = pd.DataFrame(datos, columns=columnas)
        df.to_excel(archivo, index=False)
        messagebox.showinfo("Éxito", "Datos exportados correctamente a Excel.")
    except Exception as e:
        messagebox.showerror("Error", f"No se pudo exportar a Excel: {str(e)}")

#========================= pdf export =======================

def exportar_fincas_pdf():
    datos = []
    for row_id in products_tree.get_children():
        datos.append(products_tree.item(row_id)['values'])

    columnas = [col for col in products_tree["columns"]]
    archivo = filedialog.asksaveasfilename(defaultextension=".pdf", filetypes=[("PDF files", "*.pdf")])
    if archivo:
        exportar_pdf(datos, columnas, "Listado de Fincas", archivo)
        messagebox.showinfo("Éxito", "PDF de fincas generado correctamente.")


def exportar_parcelas_pdf():
    datos = []
    for row_id in customers_tree.get_children():
        datos.append(customers_tree.item(row_id)['values'])

    columnas = [col for col in customers_tree["columns"]]
    archivo = filedialog.asksaveasfilename(defaultextension=".pdf", filetypes=[("PDF files", "*.pdf")])
    if archivo:
        exportar_pdf(datos, columnas, "Listado de Parcelas", archivo)
        messagebox.showinfo("Éxito", "PDF de parcelas generado correctamente.")

def exportar_empleados_pdf():
    try:
        archivo = filedialog.asksaveasfilename(defaultextension=".pdf", filetypes=[("PDF files", "*.pdf")])
        if not archivo:
            return

        columnas = ['ID', 'Nombre', 'Edad', 'Cargo', 'Salario', 'Finca']
        datos = [employees_tree.item(i)['values'] for i in employees_tree.get_children()]
        exportar_pdf(datos, columnas, "Listado de Empleados", archivo)
    except Exception as e:
        messagebox.showerror("Error", f"No se pudo exportar empleados: {str(e)}")

def exportar_cultivos_pdf():
    try:
        archivo = filedialog.asksaveasfilename(defaultextension=".pdf", filetypes=[("PDF files", "*.pdf")])
        if not archivo:
            return

        columnas = ['ID', 'Nombre', 'Tipo', 'Inicio', 'Fin', 'Riego', 'Parcela']
        datos = [cultivos_tree.item(i)['values'] for i in cultivos_tree.get_children()]
        exportar_pdf(datos, columnas, "Listado de Cultivos", archivo)
    except Exception as e:
        messagebox.showerror("Error", f"No se pudo exportar cultivos: {str(e)}")


# =================== INTERFAZ GRÁFICA ===================
# Crear la ventana principal
root = ctk.CTk()
root.geometry('1200x700')
root.title("PROYECTO #2")

root.iconbitmap("favicon.ico")

#================ imagenes para los botones ===================
imagen = Image.open("guardar.png")
imagen_redimensionada = imagen.resize((24, 24), Image.LANCZOS)
icono_guardar = ctk.CTkImage(light_image=imagen, dark_image=imagen, size=(24, 24))

imagen_actualizar=Image.open("actualizar.png")
imagen_redimensionada_a = imagen_actualizar.resize((24, 24), Image.LANCZOS)
icono_actualizar = ctk.CTkImage(light_image=imagen_actualizar, dark_image=imagen_actualizar, size=(24, 24))

imagen_borrar=Image.open("borrar.png")
imagen_redimensionada_b = imagen_borrar.resize((24, 24), Image.LANCZOS)
icono_borrar = ctk.CTkImage(light_image=imagen_borrar, dark_image=imagen_borrar, size=(24, 24))

imagen_limpiar=Image.open("limpiar.png")
imagen_redimensionada_l = imagen_limpiar.resize((24, 24), Image.LANCZOS)
icono_limpiar = ctk.CTkImage(light_image=imagen_limpiar, dark_image=imagen_limpiar, size=(24, 24))

imagen_buscar=Image.open("buscar.png")
imagen_redimensionada_bu = imagen_buscar.resize((24, 24), Image.LANCZOS)
icono_buscar = ctk.CTkImage(light_image=imagen_buscar, dark_image=imagen_buscar, size=(24, 24))





ctk.set_appearance_mode("dark")
ctk.set_default_color_theme("green")

# Conectar a la base de datos al iniciar
if not db.connect():
    root.destroy()
    exit()

# Crear el widget Notebook (pestañas)
notebook = ttk.Notebook(root)

# Crear los frames que irán dentro de las pestañas
tab1 = ctk.CTkFrame(notebook)
tab2 = ctk.CTkFrame(notebook)
tab3 = ctk.CTkFrame(notebook)
tab4 = ctk.CTkFrame(notebook)

# Añadir las pestañas al Notebook
notebook.add(tab1, text="FINCAS")
notebook.add(tab2, text="PARCELAS")
notebook.add(tab3, text="EMPLEADOS")
notebook.add(tab4, text="CULTIVOS")

# Empaquetar el Notebook para que se muestre en la ventana

notebook.pack(expand=True, fill="both")

# Crear carpeta para guardar las fotos
ruta_imagenes = "imagenes_empleados"
os.makedirs(ruta_imagenes, exist_ok=True)

#========= funcion para cambiar el color del fondo ===============

def cambiar_tema():
    modo_actual = ctk.get_appearance_mode()
    if modo_actual == "Light":
        ctk.set_appearance_mode("dark")
        root.configure(text="Tema actual: Oscuro")
        boton_fondo.configure(text="Cambiar fondo")
    else:
        ctk.set_appearance_mode("light")
        root.configure(text="Tema actual: Claro")
        boton_fondo.configure(text="Cambiar fondo")




# =================== PESTAÑA 1 (fincas) ===================
# Crear frame principal para fincas
main_frame_fincas = ctk.CTkFrame(tab1)
main_frame_fincas.pack(fill="both", expand=True, padx=10, pady=10)

# Frame izquierdo para formulario
left_frame_fincas = ctk.CTkFrame(main_frame_fincas)
left_frame_fincas.pack(side="left", fill="y", padx=(0, 10))

# Título
titulo = ctk.CTkLabel(left_frame_fincas, text="GESTIÓN DE FINCAS", font=("algerian", 20, "bold"))
titulo.pack(pady=20)

# Frame para contener el formulario
form_frame_fincas = ctk.CTkFrame(left_frame_fincas)
form_frame_fincas.pack(pady=20, anchor="w", padx=20)

#================== validacion solo digitos==============
def solo_digitos(P):
    return P.isdigit() or P == ""

vcmd = (form_frame_fincas.register(solo_digitos), '%P')

#======================== validacion maximo 15 caracteres=================
def max_15_caracteres(P):
    return len(P) <= 21 or len(P)<3

# Registrar función
vcmdmax = form_frame_fincas.register(max_15_caracteres)


ctk.CTkLabel(form_frame_fincas, text="NOMBRE:", font=("algerian", 18)).grid(row=2, column=0, sticky="w", padx=(0, 10), pady=10)
nombre = ctk.CTkEntry(form_frame_fincas, width=250, font=("algerian", 18),)
nombre.grid(row=2, column=1, sticky="w", pady=10)

ctk.CTkLabel(form_frame_fincas, text="latitud:", font=("algerian", 18)).grid(row=3, column=0, sticky="w", padx=(0, 10), pady=10)
latitud = ctk.CTkEntry(form_frame_fincas, width=250, font=("algerian", 18))
latitud.grid(row=3, column=1, sticky="w", pady=10)

ctk.CTkLabel(form_frame_fincas, text="longitud:", font=("algerian", 18)).grid(row=4, column=0, sticky="w", padx=(0, 10), pady=10)
longitud = ctk.CTkEntry(form_frame_fincas, width=250, font=("algerian", 18))
longitud.grid(row=4, column=1, sticky="w", pady=10)

ctk.CTkLabel(form_frame_fincas, text="HECTAREAS:", font=("algerian", 18)).grid(row=5, column=0, sticky="w", padx=(0, 10), pady=10)
extension_total_hectareas = ctk.CTkEntry(form_frame_fincas, width=250, font=("algerian", 18))
extension_total_hectareas.grid(row=5, column=1, sticky="w", pady=10)

ctk.CTkLabel(form_frame_fincas, text="ALTITUD :", font=("algerian", 18)).grid(row=6, column=0, sticky="w", padx=(0, 10), pady=10)
altitud = ctk.CTkEntry(form_frame_fincas, width=250, font=("algerian", 18),validate='key',validatecommand=vcmd)
altitud.grid(row=6, column=1, sticky="w", pady=10)

ctk.CTkLabel(form_frame_fincas, text="TEMPERATURA:", font=("algerian", 18)).grid(row=7, column=0, sticky="w", padx=(0, 10), pady=10)
temp_p_a = ctk.CTkEntry(form_frame_fincas, width=250, font=("algerian", 18),validate='key',validatecommand=vcmd)
temp_p_a.grid(row=7, column=1, sticky="w", pady=10)


suelo_tipo = ['suelo arenoso', 'suelo arcilloso', 'suelo limoso', 'otro']
ctk.CTkLabel(form_frame_fincas, text="tipo_suelo:",font=("algerian",18)).grid(row=8, column=0, sticky="w", pady=5)
suelo = ctk.CTkOptionMenu(form_frame_fincas, values=suelo_tipo)
suelo.grid(row=8, column=1, sticky="w", padx=5, pady=5)


ctk.CTkLabel(form_frame_fincas, text="ubicacion/region:", font=("algerian", 18)).grid(row=9, column=0, sticky="w", padx=(0, 10), pady=10)
region = ctk.CTkEntry(form_frame_fincas, width=250, font=("algerian", 18))
region.grid(row=9, column=1, sticky="w", pady=10)

# Frame para botones
button_frame_fincas = ctk.CTkFrame(left_frame_fincas)
button_frame_fincas.pack(pady=20)

btn_save_product = ctk.CTkButton(button_frame_fincas, text="Guardar",width=70,command=save_finca,image=icono_guardar,compound="left")
btn_save_product.pack(side=ctk.LEFT, padx=3)

btn_update_product = ctk.CTkButton(button_frame_fincas, text="Actualizar",width=70,image=icono_actualizar,compound="left",command=actualizar_finca)
btn_update_product.pack(side=ctk.LEFT, padx=3)

btn_delete_product = ctk.CTkButton(button_frame_fincas, text="Eliminar",width=70,image=icono_borrar,compound="left",command=lambda: eliminar_finca(nombre.get()))
btn_delete_product.pack(side=tk.LEFT, padx=3)

btn_search_product = ctk.CTkButton(button_frame_fincas, text="Buscar",width=70,image=icono_buscar,compound="left",command=buscar_finca_por_nombre)
btn_search_product.pack(side=ctk.LEFT, padx=3)

btn_clear_product = ctk.CTkButton(button_frame_fincas, text="Limpiar",width=70,command=limpiar_campos_fincas,image=icono_limpiar,compound="left")
btn_clear_product.pack(side=ctk.LEFT, padx=3)

boton_fondo = ctk.CTkButton(button_frame_fincas, text="Cambiar fondo", width=70,command=cambiar_tema)
boton_fondo.pack(pady=10)

btn_export_excel_fincas = ctk.CTkButton(button_frame_fincas, text="Exportar Excel", command=exportar_fincas_excel)
btn_export_excel_fincas.pack(side=ctk.LEFT, padx=3)

btn_export_pdf_fincas = ctk.CTkButton(button_frame_fincas, text="Exportar PDF", command=exportar_fincas_pdf)
btn_export_pdf_fincas.pack(side=ctk.LEFT, padx=3)



# Frame derecho para lista
right_frame_fincas = ctk.CTkFrame(main_frame_fincas)
right_frame_fincas.pack(side="right", fill="both", expand=True)

ctk.CTkLabel(right_frame_fincas, text="LISTA DE FINCAS", font=("algerian", 20, "bold")).pack(pady=10)

style = ttk.Style()
style.theme_use("default")

style.configure("Treeview",
                background="black",
                foreground="white",
                rowheight=25,
                font=('calibri', 11))

# Encabezados
style.configure("Treeview.Heading",
                background="black",
                foreground="green",
                font=('Arial', 12, 'bold'))



# Treeview para mostrar productos
products_tree = ttk.Treeview(right_frame_fincas, columns=('ID_finca', 'NOMBRE', 'latitud', 'longitud', 'EXTENSION_TOTAL_HECTAREAS', 'ALTITUD_METROS','TEMPERARTURA_PROMEDIO_ANUAL_fg','TIPO_SUELO_PREdOMINANTE','region_ubicacion'),show='headings', height=20)
products_tree.heading('ID_finca', text='ID')
products_tree.heading('NOMBRE', text='Nombre')
products_tree.heading('latitud', text='latitud')
products_tree.heading('longitud', text='longitud')
products_tree.heading('EXTENSION_TOTAL_HECTAREAS', text='hectareas')
products_tree.heading('ALTITUD_METROS', text='altitud')
products_tree.heading('TEMPERARTURA_PROMEDIO_ANUAL_fg', text='temperatura')
products_tree.heading('TIPO_SUELO_PREdOMINANTE', text='suelo')
products_tree.heading('region_ubicacion', text='region')


products_tree.column('ID_finca', width=50)
products_tree.column('NOMBRE', width=70)
products_tree.column('latitud', width=70)
products_tree.column('longitud', width=70)
products_tree.column('EXTENSION_TOTAL_HECTAREAS', width=70)
products_tree.column('ALTITUD_METROS', width=70)
products_tree.column('TEMPERARTURA_PROMEDIO_ANUAL_fg', width=70)
products_tree.column('TIPO_SUELO_PREdOMINANTE', width=70)
products_tree.column('region_ubicacion', width=70)

products_tree.bind('<<TreeviewSelect>>', on_product_select)
products_tree.pack(fill="both", expand=True, padx=10, pady=10)
cargar_datos_fincas()

# Crear Scrollbar vertical personalizada con CTk
scrollbar_products = ctk.CTkScrollbar(products_tree, orientation="vertical", command=products_tree.yview)
products_tree.configure(yscrollcommand=scrollbar_products.set)

# Empaquetar ambos: Treeview a la izquierda, scrollbar a la derecha
products_tree.pack(side="left", fill="both", expand=True)
scrollbar_products.pack(side="right", fill="y")

scrollbar_products.configure(
    fg_color="#2b2b2b",         # Fondo gris oscuro
    button_color="#2ecc71",     # Verde igual que los botones
    button_hover_color="#27ae60"
)



# =================== PESTAÑA 2 (parcelas) ===================
main_frame_parcelas = ctk.CTkFrame(tab2)
main_frame_parcelas.pack(fill="both", expand=True, padx=10, pady=10)

left_frame_parcelas = ctk.CTkFrame(main_frame_parcelas)
left_frame_parcelas.pack(side="left", fill="y", padx=(0, 10))

titulo2 = ctk.CTkLabel(left_frame_parcelas, text="GESTIÓN DE PARCELAS", font=("algerian", 20, "bold"))
titulo2.pack(pady=20)

form_frame_parcelas = ctk.CTkFrame(left_frame_parcelas)
form_frame_parcelas.pack(pady=20, anchor="w", padx=20)

ctk.CTkLabel(form_frame_parcelas, text="ID_PARCELA:", font=("algerian", 18)).grid(row=1, column=0, sticky="w", padx=(0, 10), pady=10)
idparcela = ctk.CTkEntry(form_frame_parcelas, width=250, font=("algerian", 18),validate='key',validatecommand=vcmd)
idparcela.grid(row=1, column=1, sticky="w", pady=10)

ctk.CTkLabel(form_frame_parcelas, text="hectareas:", font=("algerian", 18)).grid(row=2, column=0, sticky="w", padx=(0, 10), pady=10)
area_hectareas = ctk.CTkEntry(form_frame_parcelas, width=250, font=("algerian", 18))
area_hectareas.grid(row=2, column=1, sticky="w", pady=10)


sistema_riego = ['goteo', 'subterraneo', 'aspercion', 'gravedad','otro']
ctk.CTkLabel(form_frame_parcelas, text="SISTEMA_RIEGO:",font=("algerian",18)).grid(row=3, column=0, sticky="w", pady=5)
riego = ctk.CTkOptionMenu(form_frame_parcelas, values=sistema_riego)
riego.grid(row=3, column=1, sticky="w", padx=5, pady=5)

ctk.CTkLabel(form_frame_parcelas, text="historial_uso:", font=("algerian", 18)).grid(row=4, column=0, sticky="w", padx=(0, 10), pady=10)
historial = ctk.CTkEntry(form_frame_parcelas, width=250, font=("algerian", 12))
historial.grid(row=4, column=1, sticky="w", pady=10)

ctk.CTkLabel(form_frame_parcelas, text="ID_FINCA:", font=("algerian", 18)).grid(row=5, column=0, sticky="w", padx=(0, 10), pady=10)
idfinca = ctk.CTkEntry(form_frame_parcelas, width=250, font=("algerian", 18),validate='key',validatecommand=vcmd)
idfinca.grid(row=5, column=1, sticky="w", pady=10)


# Frame para botones de customers
button_frame_parcelas = ctk.CTkFrame(left_frame_parcelas)
button_frame_parcelas.pack(pady=20)

btn_save_customer = ctk.CTkButton(button_frame_parcelas, text="Guardar",width=70, command=save_parcelas,image=icono_guardar,compound="left")
btn_save_customer.pack(side=ctk.LEFT, padx=3)

btn_update_customer = ctk.CTkButton(button_frame_parcelas, text="Actualizar",width=70,image=icono_actualizar,compound="left",command=actualizar_parcela_sp)
btn_update_customer.pack(side=ctk.LEFT, padx=3)

btn_delete_customer = ctk.CTkButton (button_frame_parcelas, text="Eliminar", width=70,image=icono_borrar,compound="left",command=lambda: eliminar_parcela(idparcela.get()))
btn_delete_customer.pack(side=ctk.LEFT, padx=3)

btn_search_customer = ctk.CTkButton(button_frame_parcelas, text="Buscar",width=70,command=buscar_parcela_por_id,image=icono_buscar,compound="left")
btn_search_customer.pack(side=ctk.LEFT, padx=3)

btn_clear_customer = ctk.CTkButton(button_frame_parcelas, text="Limpiar",width=70,command=limpiar_campos_parcelas,image=icono_limpiar,compound="left")
btn_clear_customer.pack(side=tk.LEFT, padx=3)

boton_fondo = ctk.CTkButton(button_frame_parcelas, text="Cambiar fondo",width=70, command=cambiar_tema)
boton_fondo.pack(pady=10)

btn_export_excel_parcelas = ctk.CTkButton(button_frame_parcelas, text="Exportar Excel", command=exportar_parcelas_excel)
btn_export_excel_parcelas.pack(side=ctk.LEFT, padx=3)

btn_export_pdf_parcelas = ctk.CTkButton(button_frame_parcelas, text="Exportar PDF", command=exportar_parcelas_pdf)
btn_export_pdf_parcelas.pack(side=ctk.LEFT, padx=3)

# Frame derecho para lista de customers
right_frame_parcelas = ctk.CTkFrame(main_frame_parcelas)
right_frame_parcelas.pack(side="right", fill="both", expand=True)

ctk.CTkLabel(right_frame_parcelas, text="LISTA DE PARCELAS", font=("algerian", 20, "bold")).pack(pady=10)

style = ttk.Style()
style.theme_use("default")

style.configure("Treeview",
                background="#2b2b2b",     # Fondo gris oscuro
                foreground="white",       # Texto blanco
                rowheight=25,
                fieldbackground="#2b2b2b",  # Asegura que el fondo interno también sea gris
                font=('Arial', 11))

# Encabezados
style.configure("Treeview.Heading",
                background="#2ecc71",  # Mismo verde que los botones
                foreground="white",
                font=('Arial', 12, 'bold'))



# Treeview para mostrar customers
customers_tree = ttk.Treeview(right_frame_parcelas,
                              columns=('ID_PARCELA', 'AREA_HECTAREAS_PARCELA', 'SISTEMA_RIEGO', 'HISTORIAL_DE_USO', 'id_finca'),
                              show='headings', height=20)
customers_tree.heading('ID_PARCELA', text='ID')
customers_tree.heading('AREA_HECTAREAS_PARCELA', text='hectareas')
customers_tree.heading('SISTEMA_RIEGO', text='riego')
customers_tree.heading('HISTORIAL_DE_USO', text='historial')
customers_tree.heading('id_finca', text='finca')


customers_tree.column('ID_PARCELA', width=10)
customers_tree.column('AREA_HECTAREAS_PARCELA', width=10)
customers_tree.column('SISTEMA_RIEGO', width=10)
customers_tree.column('HISTORIAL_DE_USO', width=400)
customers_tree.column('id_finca', width=10)


customers_tree.bind('<<TreeviewSelect>>', on_customer_select)
customers_tree.pack(fill="both", expand=True, padx=10, pady=10)






# Crear Scrollbar vertical personalizada con CTk
scrollbar_customers = ctk.CTkScrollbar(customers_tree, orientation="vertical", command=customers_tree.yview)
customers_tree.configure(yscrollcommand=scrollbar_customers.set)
cargar_datos_parcelas()

# Empaquetar ambos: Treeview a la izquierda, scrollbar a la derecha
customers_tree.pack(side="left", fill="both", expand=True)
scrollbar_customers.pack(side="right", fill="y")

scrollbar_customers.configure(
    fg_color="#2b2b2b",
    button_color="#2ecc71",
    button_hover_color="#27ae60"
)


# =================== PESTAÑA 3 (empleados) ===================
main_frame_employees = ctk.CTkFrame (tab3)
main_frame_employees.pack(fill="both", expand=True, padx=10, pady=10)

left_frame_employees = ctk.CTkFrame(main_frame_employees)
left_frame_employees.pack(side="left", fill="y", padx=(0, 10))

titulo3 = ctk.CTkLabel(left_frame_employees, text="GESTIÓN DE EMPLEADOS", font=("algerian", 20, "bold"))
titulo3.pack(pady=20)

form_frame_employees = ctk.CTkFrame(left_frame_employees)
form_frame_employees.pack(pady=20, anchor="w", padx=20)

ctk.CTkLabel(form_frame_employees, text="id_empleado:", font=("algerian", 18)).grid(row=1, column=0, sticky="w", padx=(0, 10), pady=10)
idempleado = ctk.CTkEntry(form_frame_employees, width=250, font=("algerian", 18),validate='key',validatecommand=vcmd)
idempleado.grid(row=1, column=1, sticky="w", pady=10)

ctk.CTkLabel(form_frame_employees, text="DNI:", font=("algerian", 18)).grid(row=2, column=0, sticky="w", padx=(0, 10), pady=10)
dni_employee = ctk.CTkEntry(form_frame_employees, width=250, font=("algerian", 18),validate='key',validatecommand=vcmd)
dni_employee.grid(row=2, column=1, sticky="w", pady=10)

ctk.CTkLabel(form_frame_employees, text="nombre:", font=("algerian", 18)).grid(row=3, column=0, sticky="w", padx=(0, 10), pady=10)
nombre_employee = ctk.CTkEntry(form_frame_employees, width=250, font=("algerian", 18),validate="key",validatecommand=(vcmdmax,"%P"),placeholder_text="maximo 20 caracteres")
nombre_employee.grid(row=3, column=1, sticky="w", pady=10)

ctk.CTkLabel(form_frame_employees, text="apellido:", font=("algerian", 18)).grid(row=4, column=0, sticky="w", padx=(0, 10), pady=10)
apellido_employee = ctk.CTkEntry(form_frame_employees, width=250, font=("algerian", 18),validate="key",validatecommand=(vcmdmax,"%P"),placeholder_text="maximo 20 caracteres")
apellido_employee.grid(row=4, column=1, sticky="w", pady=10)


ctk.CTkLabel(form_frame_employees, text="fecha_nacimiento:",font=('algerian',18)).grid(row=5,column=0,sticky="w", padx=(0, 10), pady=10)
fecha_employee = DateEntry(form_frame_employees, width=18, background='green', borderwidth=2, date_pattern='dd/mm/yyyy')
fecha_employee.grid(row=5, column=1, sticky="w", pady=10)

ctk.CTkLabel(form_frame_employees, text="telefono :", font=("algerian", 18)).grid(row=6, column=0, sticky="w", padx=(0, 10), pady=10)
tel_employee = ctk.CTkEntry(form_frame_employees, width=250, font=("algerian", 18))
tel_employee.grid(row=6, column=1, sticky="w", pady=10)


especialidades = ['agronomo', 'tecnico en riego', 'fumigador', 'contador agricola']
ctk.CTkLabel(form_frame_employees, text="especialidad:",font=("algerian",18)).grid(row=7, column=0, sticky="w", pady=5)
especialidad_employee = ctk.CTkOptionMenu(form_frame_employees, values=especialidades)
especialidad_employee.grid(row=7, column=1, sticky="w", padx=5, pady=5)


ctk.CTkLabel(form_frame_employees, text="fecha_contrato:",font=('algerian',18)).grid(row=8,column=0,sticky="w", padx=(0, 10), pady=10)
contrato_employee = DateEntry(form_frame_employees, width=18, background='green', borderwidth=2, date_pattern='dd/mm/yyyy')
contrato_employee.grid(row=8, column=1, sticky="w", pady=10)

ctk.CTkLabel(form_frame_employees, text="salario:", font=("algerian", 18)).grid(row=9, column=0, sticky="w", padx=(0, 10), pady=10)
salario_employee = ctk.CTkEntry(form_frame_employees, width=250, font=("algerian", 12))
salario_employee.grid(row=9, column=1, sticky="w", pady=10)


areas = ['produccion', 'calidad y control', 'finanzas']
ctk.CTkLabel(form_frame_employees, text="area_asignada:",font=("algerian",18)).grid(row=10, column=0, sticky="w", pady=5)
area_asignada_e = ctk.CTkOptionMenu(form_frame_employees, values=areas)
area_asignada_e.grid(row=10, column=1, sticky="w", padx=5, pady=5)


ctk.CTkLabel(form_frame_employees, text="fecha_fin_contrato:",font=('algerian',18)).grid(row=11,column=0,sticky="w", padx=(0, 10), pady=10)
fin_employee = DateEntry(form_frame_employees, width=18, background='green', borderwidth=2, date_pattern='dd/mm/yyyy')
fin_employee.grid(row=11, column=1, sticky="w", pady=10)


ctk.CTkLabel(form_frame_employees, text="Photo:", font=("algerian", 16)).grid(row=13, column=0, sticky="w", padx=(0, 10),
                                                            pady=8)
Photo = ctk.CTkEntry(form_frame_employees, width=240, font=("algerian", 16))
Photo.grid(row=13, column=1, sticky="w", pady=8)
boton_seleccionar_foto = ctk.CTkButton(form_frame_employees, text="Seleccionar Foto", command=on_click_photo_employees)
boton_seleccionar_foto.grid(row=13, column=2, padx=5, pady=8, sticky="w")




# Frame para botones de employees
button_frame_employees = ctk.CTkFrame(left_frame_employees)
button_frame_employees.pack(pady=20)

btn_save_employee = ctk.CTkButton(button_frame_employees, text="Guardar",width=70,command=save_empleados,image=icono_guardar,compound="left")
btn_save_employee.pack(side=tk.LEFT, padx=3)

btn_update_employee = ctk.CTkButton(button_frame_employees, text="Actualizar", width=70,image=icono_actualizar,compound="left",command=actualizar_empleado)
btn_update_employee.pack(side=tk.LEFT, padx=3)

btn_delete_employee = ctk.CTkButton(button_frame_employees, text="Eliminar",width=70,image=icono_borrar,compound="left",command=lambda: eliminar_empleado(idempleado.get()))
btn_delete_employee.pack(side=tk.LEFT, padx=3)

btn_search_employee = ctk.CTkButton(button_frame_employees, text="Buscar",width=70,command=buscar_empleado_por_id,image=icono_buscar,compound="left")
btn_search_employee.pack(side=tk.LEFT, padx=3)

btn_clear_employee = ctk.CTkButton(button_frame_employees, text="Limpiar",command=limpiar_campos_empleados,width=70,image=icono_limpiar,compound="left")
btn_clear_employee.pack(side=tk.LEFT, padx=3)


boton_fondo = ctk.CTkButton(button_frame_employees, text="Cambiar fondo",width=70 ,command=cambiar_tema)
boton_fondo.pack(pady=10)

btn_exportar_empleados_pdf = ctk.CTkButton(button_frame_employees, text="Exportar PDF", command=exportar_empleados_pdf)
btn_exportar_empleados_pdf.pack(side=tk.LEFT, padx=3)

btn_exportar_empleados_excel = ctk.CTkButton(button_frame_employees, text="Exportar Excel", command=exportar_empleados_excel)
btn_exportar_empleados_excel.pack(side=tk.LEFT, padx=3)







# Frame derecho para lista de employees
# Frame derecho para lista de empleados
right_frame_employees = ctk.CTkFrame(main_frame_employees)
right_frame_employees.pack(side="right", fill="both", expand=True)

# Título
ctk.CTkLabel(right_frame_employees, text="LISTA DE EMPLEADOS", font=("Algerian", 20, "bold")).pack(pady=10)

# Frame contenedor para Treeview y Scrollbar
tree_container = ctk.CTkFrame(right_frame_employees)
tree_container.pack(fill="both", expand=True, padx=10, pady=10)

# Estilo para Treeview
style = ttk.Style()
style.theme_use("default")

style.configure("Treeview",
                background="#2b2b2b",
                foreground="white",
                rowheight=25,
                fieldbackground="#2b2b2b",
                font=('Arial', 11))

style.configure("Treeview.Heading",
                background="#2ecc71",
                foreground="white",
                font=('Arial', 12, 'bold'))

# Crear el Treeview
employees_tree = ttk.Treeview(tree_container,
                              columns=('id_empleados', 'DNI', 'nombre', 'apellido', 'fecha_nacimiento', 'telefono','direccion','especialidad','fecha_contratacion','salario','area_asignada','fecha_fin_contaro','photo'),
                              show='headings', height=20)

employees_tree.heading('id_empleados', text='ID')
employees_tree.heading('DNI', text='DNI')
employees_tree.heading('nombre', text='Nombre')
employees_tree.heading('apellido', text=' APELLIDO')
employees_tree.heading('fecha_nacimiento', text='BIRTHDAY')
employees_tree.heading('telefono', text='TEL')
employees_tree.heading('direccion', text='DIRCC')
employees_tree.heading('especialidad', text='ESPECIALIDAD')
employees_tree.heading('fecha_contratacion', text='CONTRATACION')
employees_tree.heading('salario', text='SALARIO')
employees_tree.heading('area_asignada', text='AREA')
employees_tree.heading('fecha_fin_contaro', text='FIN-CONTARTO')
employees_tree.heading('photo', text='photo')


employees_tree.column('id_empleados', width=50)
employees_tree.column('DNI', width=90)
employees_tree.column('nombre', width=80)
employees_tree.column('apellido', width=80)
employees_tree.column('fecha_nacimiento', width=100)
employees_tree.column('telefono', width=80)
employees_tree.column('direccion', width=150)
employees_tree.column('especialidad', width=60)
employees_tree.column('fecha_contratacion', width=80)
employees_tree.column('salario', width=100)
employees_tree.column('area_asignada', width=60)
employees_tree.column('fecha_fin_contaro', width=120)
employees_tree.column('photo', width=40)

employees_tree.bind('<<TreeviewSelect>>', on_employee_select)

# Crear Scrollbar vertical personalizada con CTk
scrollbar_employees = ctk.CTkScrollbar(tree_container, orientation="vertical", command=employees_tree.yview)
employees_tree.configure(yscrollcommand=scrollbar_employees.set)


# Empaquetar Treeview y Scrollbar correctamente
employees_tree.pack(side="left", fill="both", expand=True)
scrollbar_employees.pack(side="right", fill="y")

cargar_datos_empleados()

# Estilizar scrollbar
scrollbar_employees.configure(
    fg_color="#2b2b2b",         # Fondo gris oscuro
    button_color="#2ecc71",     # Verde botón
    button_hover_color="#27ae60"
)


#==================== pestaña #4 (cultivos)=====================
main_frame_cultivos = ctk.CTkFrame (tab4)
main_frame_cultivos.pack(fill="both", expand=True, padx=10, pady=10)

left_frame_cultivos = ctk.CTkFrame(main_frame_cultivos)
left_frame_cultivos.pack(side="left", fill="y", padx=(0, 10))

titulo4 = ctk.CTkLabel(left_frame_cultivos, text="GESTIÓN DE CULTIVOS", font=("algerian", 20, "bold"))
titulo4.pack(pady=20)

form_frame_cultivos = ctk.CTkFrame(left_frame_cultivos)
form_frame_cultivos.pack(pady=20, anchor="w", padx=20)

ctk.CTkLabel(form_frame_cultivos, text="id_cultivo:", font=("algerian", 18)).grid(row=1, column=0, sticky="w", padx=(0, 10), pady=10)
idcultivo = ctk.CTkEntry(form_frame_cultivos, width=250, font=("algerian", 18),validate='key',validatecommand=vcmd)
idcultivo.grid(row=1, column=1, sticky="w", pady=10)

ctk.CTkLabel(form_frame_cultivos, text="nombre_cientifico:", font=("algerian", 18)).grid(row=2, column=0, sticky="w", padx=(0, 10), pady=10)
nombre_cntfco = ctk.CTkEntry(form_frame_cultivos, width=250, font=("algerian", 18),validate="key",validatecommand=(vcmdmax,"%P"),placeholder_text="maximo 20 caracteres")
nombre_cntfco.grid(row=2, column=1, sticky="w", pady=10)

ctk.CTkLabel(form_frame_cultivos, text="nombre_comun:", font=("algerian", 18)).grid(row=3, column=0, sticky="w", padx=(0, 10), pady=10)
nombre_comun = ctk.CTkEntry(form_frame_cultivos, width=250, font=("algerian", 18),validate="key",validatecommand=(vcmdmax,"%P"),placeholder_text="maximo 20 caracteres")
nombre_comun.grid(row=3, column=1, sticky="w", pady=10)


ctk.CTkLabel(form_frame_cultivos, text="tiempo_crecimiento(dd):", font=("algerian", 18)).grid(row=5, column=0, sticky="w", padx=(0, 10), pady=10)
crecimientodd = ctk.CTkEntry(form_frame_cultivos, width=250, font=("algerian", 18),validate='key',validatecommand=vcmd)
crecimientodd.grid(row=5, column=1, sticky="w", pady=10)

ctk.CTkLabel(form_frame_cultivos, text="temperaturas_optimas :", font=("algerian", 18)).grid(row=6, column=0, sticky="w", padx=(0, 10), pady=10)
temp_cultivos = ctk.CTkEntry(form_frame_cultivos, width=250, font=("algerian", 18))
temp_cultivos.grid(row=6, column=1, sticky="w", pady=10)

ctk.CTkLabel(form_frame_cultivos, text="requerimiento_agua:", font=("algerian", 18)).grid(row=7, column=0, sticky="w", padx=(0, 10), pady=10)
requerimiento_agua = ctk.CTkEntry(form_frame_cultivos, width=250, font=("algerian", 18))
requerimiento_agua.grid(row=7, column=1, sticky="w", pady=10)

ctk.CTkLabel(form_frame_cultivos, text="Photo:", font=("algerian", 18)).grid(row=8, column=0, sticky="w", padx=(0, 10),
                                                                       pady=8)

Photo_cultivo = ctk.CTkEntry(form_frame_cultivos, width=240, font=("algerian", 16))
Photo_cultivo.grid(row=8, column=1, sticky="w", pady=8)
boton_seleccionar_foto = ctk.CTkButton(form_frame_cultivos, text="Seleccionar Foto", command=on_click_photo_cultivos)
boton_seleccionar_foto.grid(row=8, column=2, padx=5, pady=8, sticky="w")

imagen_miniatura = None

label_imagen = ctk.CTkLabel(form_frame_cultivos, text="Sin imagen")
label_imagen.grid(row=9, column=1, columnspan=2, pady=10)


# Frame para botones de employees
button_frame_cultivos = ctk.CTkFrame(left_frame_cultivos)
button_frame_cultivos.pack(pady=20)

btn_save_cultivos = ctk.CTkButton(button_frame_cultivos, text="Guardar",width=70,command=save_cultivos,image=icono_guardar,compound="left")
btn_save_cultivos.pack(side=tk.LEFT, padx=3)

btn_update_cultivos = ctk.CTkButton(button_frame_cultivos, text="Actualizar", width=70,image=icono_actualizar,compound="left",command=actualizar_cultivo)
btn_update_cultivos.pack(side=tk.LEFT, padx=3)

btn_delete_cultivos = ctk.CTkButton(button_frame_cultivos, text="Eliminar",width=70,command=lambda: eliminar_cultivo(idcultivo.get()),image=icono_borrar,compound="left")
btn_delete_cultivos.pack(side=tk.LEFT, padx=3)

btn_search_cultivos = ctk.CTkButton(button_frame_cultivos, text="Buscar",width=70,command=buscar_cultivo_por_id,image=icono_buscar,compound="left")
btn_search_cultivos.pack(side=tk.LEFT, padx=3)

btn_clear_cultivos = ctk.CTkButton(button_frame_cultivos, text="Limpiar",command=limpiar_campos_cultivos,width=70,image=icono_limpiar,compound="left")
btn_clear_cultivos.pack(side=tk.LEFT, padx=3)

boton_fondo = ctk.CTkButton(button_frame_cultivos, text="Cambiar fondo",width=70 ,command=cambiar_tema)
boton_fondo.pack(pady=10)

btn_exportar_cultivos_pdf = ctk.CTkButton(button_frame_cultivos, text="Exportar PDF", command=exportar_cultivos_pdf)
btn_exportar_cultivos_pdf.pack(side=tk.LEFT, padx=3)

btn_exportar_cultivos_excel = ctk.CTkButton(button_frame_cultivos, text="Exportar Excel", command=exportar_cultivos_excel)
btn_exportar_cultivos_excel.pack(side=tk.LEFT, padx=3)


# frame para cultivos
right_frame_cultivos = ctk.CTkFrame(main_frame_cultivos)
right_frame_cultivos.pack(side="right", fill="both", expand=True)

# Título
ctk.CTkLabel(right_frame_cultivos, text="LISTA DE CULTIVOS", font=("Algerian", 20, "bold")).pack(pady=10)

# Frame contenedor para Treeview y Scrollbar
tree_container = ctk.CTkFrame(right_frame_cultivos)
tree_container.pack(fill="both", expand=True, padx=10, pady=10)

# Estilo para Treeview
style = ttk.Style()
style.theme_use("default")

style.configure("Treeview",
                background="#2b2b2b",
                foreground="white",
                rowheight=25,
                fieldbackground="#2b2b2b",
                font=('Arial', 11))

style.configure("Treeview.Heading",
                background="#2ecc71",
                foreground="white",
                font=('Arial', 12, 'bold'))

# Crear el Treeview
cultivos_tree = ttk.Treeview(tree_container,
                              columns=('id_cultivo', 'nombre_cientifico', 'nombre_comun', 'tiempo_crecimiento_dias', 'temperaturas_optimas', 'requerimiento_agua_semanal','photo'),
                              show='headings', height=20)

cultivos_tree.heading('id_cultivo', text='ID')
cultivos_tree.heading('nombre_cientifico', text='NOMBRE_CIENTIFICO')
cultivos_tree.heading('nombre_comun', text='NOMBRE')
cultivos_tree.heading('tiempo_crecimiento_dias', text=' TIEMP_CRECIMIENTO')
cultivos_tree.heading('temperaturas_optimas', text='TEMP_OPTIMA')
cultivos_tree.heading('requerimiento_agua_semanal', text='REQUERIMIENTO_AGUA')
cultivos_tree.heading('photo',text='PHOTO')


cultivos_tree.column('id_cultivo', width=50)
cultivos_tree.column('nombre_cientifico', width=90)
cultivos_tree.column('nombre_comun', width=80)
cultivos_tree.column('tiempo_crecimiento_dias', width=80)
cultivos_tree.column('temperaturas_optimas', width=100)
cultivos_tree.column('requerimiento_agua_semanal', width=80)
cultivos_tree.column('photo',width=70)


cultivos_tree.bind('<<TreeviewSelect>>', on_employee_select)

# Crear Scrollbar vertical personalizada con CTk
scrollbar_cultivos = ctk.CTkScrollbar(tree_container, orientation="vertical", command=cultivos_tree.yview)
cultivos_tree.configure(yscrollcommand=scrollbar_cultivos.set)


# Empaquetar Treeview y Scrollbar correctamente
cultivos_tree.pack(side="left", fill="both", expand=True)
scrollbar_cultivos.pack(side="right", fill="y")

cargar_datos_cultivos()

# Estilizar scrollbar
scrollbar_cultivos.configure(
    fg_color="#2b2b2b",         # Fondo gris oscuro
    button_color="#2ecc71",     # Verde botón
    button_hover_color="#27ae60"
)











# =================== CARGAR DATOS INICIALES ===================
def load_initial_data():
    pass


# Cargar datos al iniciar
root.after(1000, load_initial_data)  # Cargar después de 1 segundo


# =================== FUNCIÓN DE CIERRE ===================
def on_closing():
    db.disconnect()
    root.destroy()


root.protocol("WM_DELETE_WINDOW", on_closing)

# Ejecutar la aplicación
root.mainloop()