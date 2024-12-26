CREATE DATABASE IF NOT EXISTS tienda_3;
USE tienda_3;

CREATE TABLE IF NOT EXISTS Productos (
    ProductoID INT AUTO_INCREMENT PRIMARY KEY, 
    nombre VARCHAR(100) NOT NULL, 
    Existencia INT NOT NULL 
);

INSERT IGNORE INTO Productos (nombre, Existencia) VALUES 
('Producto A', 10), 
('Producto B', 0),  
('Producto C', 5);

DELIMITER $$ -- Cambia el delimitador a $$

DROP FUNCTION IF EXISTS VerificarStock; -- Elimina la función si existe

CREATE FUNCTION VerificarStock(producto_id INT) -- Define la función con un parámetro
RETURNS BOOLEAN -- Devuelve un valor booleano
DETERMINISTIC -- Resultados consistentes
BEGIN -- Inicio del bloque

    DECLARE stock INT; -- Declara la variable stock
    SELECT Existencia INTO stock -- Selecciona existencia y almacena en stock
    FROM Productos 
    WHERE ProductoID = producto_id; -- Filtra por ID del producto

    IF stock > 0 THEN -- Verifica si hay stock
        RETURN TRUE; -- Devuelve TRUE si hay stock
    ELSE 
        RETURN FALSE; -- Devuelve FALSE si no hay stock
    END IF; -- Fin de la condicional
END $$ -- Fin del bloque

DELIMITER ; -- Restablece el delimitador a ;




SELECT nombre, VerificarStock(ProductoID) AS StockDisponible FROM Productos;
