CREATE TABLE estado (
    id     INTEGER NOT NULL,
    estado TEXT
);

ALTER TABLE estado ADD CONSTRAINT estado_pk PRIMARY KEY ( id );

CREATE TABLE ingrediente_receta (
    id              INTEGER NOT NULL,
    cantidad        INTEGER NOT NULL,
    ingredientes_id INTEGER NOT NULL,
    recetas_id      INTEGER NOT NULL
);

ALTER TABLE ingrediente_receta ADD CONSTRAINT ingrediente_receta_pk PRIMARY KEY ( id );

CREATE TABLE ingredientes (
    id          INTEGER NOT NULL,
    ingrediente TEXT,
    inventario  INTEGER NOT NULL
);

ALTER TABLE ingredientes ADD CONSTRAINT ingredientes_pk PRIMARY KEY ( id );

CREATE TABLE orden (
    id         INTEGER AUTO_INCREMENT PRIMARY KEY,
    Actualizacion  TIMESTAMP,
    recetas_id INTEGER NOT NULL,
    estado_id  INTEGER NOT NULL
);


CREATE TABLE recetas (
    id          INTEGER NOT NULL,
    nombre      TEXT,
    descripcion TEXT
);

ALTER TABLE recetas ADD CONSTRAINT recetas_pk PRIMARY KEY ( id );

ALTER TABLE ingrediente_receta
    ADD CONSTRAINT ingrediente_receta_ingredientes_fk FOREIGN KEY ( ingredientes_id )
        REFERENCES ingredientes ( id );

ALTER TABLE ingrediente_receta
    ADD CONSTRAINT ingrediente_receta_recetas_fk FOREIGN KEY ( recetas_id )
        REFERENCES recetas ( id );

ALTER TABLE orden
    ADD CONSTRAINT orden_estado_fk FOREIGN KEY ( estado_id )
        REFERENCES estado ( id );

ALTER TABLE orden
    ADD CONSTRAINT orden_recetas_fk FOREIGN KEY ( recetas_id )
        REFERENCES recetas ( id );
        
#Inserts         
INSERT INTO estado (id, estado) VALUES (1, 'Preparado');
INSERT INTO estado (id, estado) VALUES (2, 'En cola'); 

INSERT INTO ingredientes (id, ingrediente, inventario) VALUES (1, 'tomato', 5);
INSERT INTO ingredientes (id, ingrediente, inventario) VALUES (2, 'lemon', 5);
INSERT INTO ingredientes (id, ingrediente, inventario) VALUES (3, 'potato', 5);
INSERT INTO ingredientes (id, ingrediente, inventario) VALUES (4, 'rice', 5);
INSERT INTO ingredientes (id, ingrediente, inventario) VALUES (5, 'ketchup', 5);
INSERT INTO ingredientes (id, ingrediente, inventario) VALUES (6, 'lettuce', 5);
INSERT INTO ingredientes (id, ingrediente, inventario) VALUES (7, 'onion', 5);
INSERT INTO ingredientes (id, ingrediente, inventario) VALUES (8, 'cheese', 5);
INSERT INTO ingredientes (id, ingrediente, inventario) VALUES (9, 'meat', 5);
INSERT INTO ingredientes (id, ingrediente, inventario) VALUES (10, 'chicken', 5);

INSERT INTO recetas (id, nombre, descripcion) VALUES (1, 'Arroz con pollo', 'Deliciosa combinación de arroz y pollo con especias exóticas.');
INSERT INTO recetas (id, nombre, descripcion) VALUES (2, 'Ensalada', 'Refrescante ensalada con tomate, limón, lechuga y cebolla, aderezada con un toque de vinagreta.');
INSERT INTO recetas (id, nombre, descripcion) VALUES (3, 'Papas chorreadas', 'Papas doradas y cremosas cubiertas con una deliciosa salsa de queso.');
INSERT INTO recetas (id, nombre, descripcion) VALUES (4, 'Carne goulash', 'Sabroso estofado de carne con cebolla y tomate, sazonado con hierbas aromáticas.');
INSERT INTO recetas (id, nombre, descripcion) VALUES (5, 'Arroz mixto', 'Arroz salteado con pollo, carne, y un toque de salsa de tomate.');
INSERT INTO recetas (id, nombre, descripcion) VALUES (6, 'Supremo', 'Plato supremo con una mezcla de sabores: tomate, limón, papas, arroz, lechuga, cebolla, queso, carne y pollo.');

-- Arroz con pollo: 2 rice, 1 chicken
INSERT INTO ingrediente_receta (id, ingredientes_id, recetas_id, cantidad) VALUES (1, 4, 1, 2);
INSERT INTO ingrediente_receta (id, ingredientes_id, recetas_id, cantidad) VALUES (2, 10, 1, 1);

-- Ensalada: 1 tomato, 1 lemon, 2 lettuce, 1 onion
INSERT INTO ingrediente_receta (id, ingredientes_id, recetas_id, cantidad) VALUES (3, 1, 2, 1);
INSERT INTO ingrediente_receta (id, ingredientes_id, recetas_id, cantidad) VALUES (4, 2, 2, 1);
INSERT INTO ingrediente_receta (id, ingredientes_id, recetas_id, cantidad) VALUES (5, 6, 2, 2);
INSERT INTO ingrediente_receta (id, ingredientes_id, recetas_id, cantidad) VALUES (6, 7, 2, 1);

-- Papas chorreadas: 3 potato, 2 cheese
INSERT INTO ingrediente_receta (id, ingredientes_id, recetas_id, cantidad) VALUES (7, 3, 3, 3);
INSERT INTO ingrediente_receta (id, ingredientes_id, recetas_id, cantidad) VALUES (8, 8, 3, 2);

-- Carne goulash: 2 meat, 1 onion, 1 tomato
INSERT INTO ingrediente_receta (id, ingredientes_id, recetas_id, cantidad) VALUES (9, 9, 4, 2);
INSERT INTO ingrediente_receta (id, ingredientes_id, recetas_id, cantidad) VALUES (10, 7, 4, 1);
INSERT INTO ingrediente_receta (id, ingredientes_id, recetas_id, cantidad) VALUES (11, 1, 4, 1);

-- Arroz mixto: 1 rice, 1 chicken, 1 meat, 1 ketchup
INSERT INTO ingrediente_receta (id, ingredientes_id, recetas_id, cantidad) VALUES (12, 4, 5, 1);
INSERT INTO ingrediente_receta (id, ingredientes_id, recetas_id, cantidad) VALUES (13, 10, 5, 1);
INSERT INTO ingrediente_receta (id, ingredientes_id, recetas_id, cantidad) VALUES (14, 9, 5, 1);
INSERT INTO ingrediente_receta (id, ingredientes_id, recetas_id, cantidad) VALUES (15, 5, 5, 1);

-- Supremo: 1 tomato, 1 lemon, 1 potato, 1 rice, 1 ketchup, 1 lettuce, 1 onion, 1 cheese, 1 meat, 1 chicken
INSERT INTO ingrediente_receta (id, ingredientes_id, recetas_id, cantidad) VALUES (16, 1, 6, 1);
INSERT INTO ingrediente_receta (id, ingredientes_id, recetas_id, cantidad) VALUES (17, 2, 6, 1);
INSERT INTO ingrediente_receta (id, ingredientes_id, recetas_id, cantidad) VALUES (18, 3, 6, 1);
INSERT INTO ingrediente_receta (id, ingredientes_id, recetas_id, cantidad) VALUES (19, 4, 6, 1);
INSERT INTO ingrediente_receta (id, ingredientes_id, recetas_id, cantidad) VALUES (20, 5, 6, 1);
INSERT INTO ingrediente_receta (id, ingredientes_id, recetas_id, cantidad) VALUES (21, 6, 6, 1);
INSERT INTO ingrediente_receta (id, ingredientes_id, recetas_id, cantidad) VALUES (22, 7, 6, 1);
INSERT INTO ingrediente_receta (id, ingredientes_id, recetas_id, cantidad) VALUES (23, 8, 6, 1);
INSERT INTO ingrediente_receta (id, ingredientes_id, recetas_id, cantidad) VALUES (24, 9, 6, 1);
INSERT INTO ingrediente_receta (id, ingredientes_id, recetas_id, cantidad) VALUES (25, 10, 6, 1);
