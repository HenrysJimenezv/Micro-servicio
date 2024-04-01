Instrucciones:
1. Correr mysql y correr el script del archivo "Base_de_datos_Microservicios.sql"
2. Correr la app de micro-servicios
3. Instalar "requirements.txt"
4. Correr app.py
5. Ingresar a la URL que indique el programa con el endpoint /main
6. Correr la app supermercado
7. Instalar "requirements.txt"
8. Correr app1.py

Funcionamiento:
Cuandos se corre la app micro-servicios, la url genera un botón, cada vez que se presiona se genera una orden con un plato aleatorio, y si se tienen los ingredientes 
se genera la orden correctamente, sino se manda a la cola hasta que se tengan los ingredientes para generar el plato, de igual manera, en la url tambien se muestran 
las ultimas 10 ordenes, y si se encuentran ya preparadas o en cola, la app de supermercado se encarga de comprar los ingredientes que menos cantidad tengan en su inventario,
cada 5 segundos se mira cual es el ingrediente con m
