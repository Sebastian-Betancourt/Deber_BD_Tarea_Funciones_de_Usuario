CREATE DATABASE  tiendaaa;
USE tiendaaa;

CREATE TABLE  Productos (
    ProductoID INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    precio DECIMAL(10,2) NOT NULL
);

CREATE TABLE  Ordenes (
    OrdenID INT AUTO_INCREMENT PRIMARY KEY,
    producto_id INT NOT NULL,
    cantidad INT NOT NULL,
    FOREIGN KEY (producto_id) REFERENCES Productos(ProductoID)
);
INSERT INTO Productos (nombre, precio) VALUES 
('Producto A', 10.00),
('Producto B', 20.00),
('Producto C', 15.50);

INSERT INTO Ordenes (producto_id, cantidad) VALUES 
(1, 2),  
(2, 1),  
(3, 3);  

DELIMITER $$ -- Cambia el delimitador a $$ para la función

CREATE FUNCTION CalcularTotalOrden(id_orden INT) -- Define la función con un parámetro id_orden
RETURNS DECIMAL(10,2) -- Devuelve un valor decimal (10 dígitos, 2 decimales)
DETERMINISTIC -- Asegura resultados consistentes para los mismos parámetros
BEGIN -- Inicio del bloque de código

    DECLARE total DECIMAL(10,2); -- Variable para almacenar el total
    DECLARE iva DECIMAL(10,2); -- Variable para almacenar el IVA
    
    SET iva = 0.15; -- Asigna el valor del IVA (15%)

    -- Calcula el total de la orden
    SELECT SUM(P.precio * O.cantidad) INTO total 
    FROM Ordenes O 
    JOIN Productos P ON O.producto_id = P.ProductoID 
    WHERE O.OrdenID = id_orden; -- Filtra por el ID de la orden

    -- Establece total a 0 si no hay productos
    IF total IS NULL THEN 
        SET total = 0; 
    END IF; 

    SET total = total + (total * iva); -- Suma el IVA al total

    RETURN total; -- Devuelve el total final
END $$ -- Fin del bloque de código

DELIMITER ; -- Restablece el delimitador a ;



SELECT CalcularTotalOrden(1) AS TotalOrden; 
