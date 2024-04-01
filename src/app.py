from flask import Flask, render_template, jsonify
from flask_mysqldb import MySQL
from config import config
import random
from datetime import datetime
import requests
import time
from threading import Thread

app = Flask(__name__)
mysql = MySQL(app)

# Función para verificar si hay suficientes ingredientes disponibles para una orden
def verificar_ingredientes_disponibles(receta_id):
    try:
        with app.app_context():
            with mysql.connection.cursor() as cursor:
                cursor.execute("SELECT ingrediente, cantidad FROM ingrediente_receta "
                               "INNER JOIN ingredientes ON ingrediente_receta.ingredientes_id = ingredientes.id "
                               "WHERE recetas_id = %s", (receta_id,))
                ingredientes_receta = cursor.fetchall()

                for ingrediente, cantidad in ingredientes_receta:
                    cursor.execute("SELECT inventario FROM ingredientes WHERE ingrediente = %s", (ingrediente,))
                    row = cursor.fetchone()
                    if row is None or row[0] < cantidad:
                        return False
                return True
    except Exception as e:
        print(f"Error al verificar ingredientes disponibles: {e}")
        return False

# Función para manejar la cola de órdenes cuando no hay suficientes ingredientes disponibles
def manejar_cola():
    while True:
        try:
            with app.app_context():
                with mysql.connection.cursor() as cursor:
                    cursor.execute("SELECT id, recetas_id FROM orden WHERE estado_id = 2")
                    ordenes = cursor.fetchall()

                    for orden_id, receta_id in ordenes:
                        if verificar_ingredientes_disponibles(receta_id):
                            actualizacion = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
                            cursor.execute("UPDATE orden SET estado_id = 1, actualizacion = %s WHERE id = %s", (actualizacion, orden_id))
                            mysql.connection.commit()
                            print(f"Orden {orden_id} preparada.")
                        else:
                            print(f"No hay suficientes ingredientes para la orden {orden_id}.")
                            # Si no hay suficientes ingredientes, cambiar el estado de la orden a 2
                            actualizacion = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
                            cursor.execute("UPDATE orden SET estado_id = 2, actualizacion = %s WHERE id = %s", (actualizacion, orden_id))
                            mysql.connection.commit()
                            print(f"Orden {orden_id} enviada a la cola.")

            time.sleep(5)
        except Exception as e:
            print(f"Error al manejar la cola: {e}")
            time.sleep(5)

# Endpoint para obtener los platos en cola
@app.route('/platos_en_cola')
def platos_en_cola():
    try:
        with app.app_context():
            with mysql.connection.cursor() as cursor:
                cursor.execute("SELECT recetas_id FROM orden WHERE estado_id = 2")
                platos_en_cola = [row[0] for row in cursor.fetchall()]
        return jsonify({'platos_en_cola': platos_en_cola}), 200
    except Exception as e:
        print(f"Error al obtener los platos en cola: {e}")
        return jsonify({'message': 'Error al obtener los platos en cola.'}), 500

@app.route('/main')
def index():
    return render_template('main.html')

@app.route('/generate_dish', methods=['POST'])
def generate_dish():
    cursor = mysql.connection.cursor()


    # Seleccionar una receta aleatoria
    random_recipe_id = random.randint(1, 6)

    # Obtener el nombre de la receta generada
    cursor.execute("SELECT nombre FROM recetas WHERE id = %s", (random_recipe_id,))
    recipe_name = cursor.fetchone()[0]

    # Verificar si se tienen los ingredientes necesarios
    cursor.execute("SELECT ingrediente, cantidad FROM ingrediente_receta "
                   "INNER JOIN ingredientes ON ingrediente_receta.ingredientes_id = ingredientes.id "
                   "WHERE recetas_id = %s", (random_recipe_id,))
    ingredients_needed = cursor.fetchall()

    ingredients_available = True
    for ingredient, quantity_needed in ingredients_needed:
        cursor.execute("SELECT inventario FROM ingredientes WHERE ingrediente = %s", (ingredient,))
        row = cursor.fetchone()
        if row is None or row[0] < quantity_needed:
            ingredients_available = False
            break

    if ingredients_available:
        # Restar los ingredientes utilizados del inventario
        for ingredient, quantity_needed in ingredients_needed:
            cursor.execute("UPDATE ingredientes SET inventario = inventario - %s WHERE ingrediente = %s",
                           (quantity_needed, ingredient))
            mysql.connection.commit()

        # Guardar en la tabla de ordenes con estado 1
        cursor.execute("INSERT INTO orden (Actualizacion, recetas_id, estado_id) "
                       "VALUES (%s, %s, 1)", (datetime.now(), random_recipe_id))
        mysql.connection.commit()
        return jsonify({'message': f'Plato generado exitosamente: {recipe_name}'}), 200
    else:
        # Guardar en la tabla de ordenes con estado 2
        cursor.execute("INSERT INTO orden (Actualizacion, recetas_id, estado_id) "
                       "VALUES (%s, %s, 2)", (datetime.now(), random_recipe_id))
        mysql.connection.commit()
        return jsonify({'message': 'No se tienen los ingredientes necesarios.'}), 400


@app.route('/ultimas_ordenes')
def mostrar_ultimas_ordenes():
    try:
        with mysql.connection.cursor() as cursor:
            cursor.execute("SELECT id, recetas_id, estado_id FROM orden ORDER BY id DESC LIMIT 10")
            ordenes = cursor.fetchall()
            ordenes_data = [{'id': orden[0], 'recetas_id': orden[1], 'estado_id': orden[2]} for orden in ordenes]
            return jsonify(ordenes_data)
    except Exception as e:
        return jsonify({'error': f'Error al obtener las últimas órdenes: {e}'}), 500


if __name__ == '__main__':
    app.config.from_object(config['development'])
    cola_thread = Thread(target=manejar_cola)
    cola_thread.start()
    app.run()