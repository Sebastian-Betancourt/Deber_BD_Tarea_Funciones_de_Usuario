create database tienda_online;
use tienda_online;
CREATE TABLE Clientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    telefono VARCHAR(15),
    fecha_registro DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_email CHECK (email <> '')
);
CREATE TABLE Productos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    precio DECIMAL(10, 2) NOT NULL CHECK (precio > 0),
    stock INT NOT NULL CHECK (stock >= 0),
    descripcion TEXT
);
CREATE TABLE Pedidos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT NOT NULL,
    fecha_pedido DATETIME DEFAULT CURRENT_TIMESTAMP,
    total DECIMAL(10, 2) NOT NULL CHECK (total >= 0),
    FOREIGN KEY (cliente_id) REFERENCES Clientes(id)
);
CREATE TABLE Detalles_Pedido (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pedido_id INT NOT NULL,
    producto_id INT NOT NULL,
    cantidad INT NOT NULL CHECK (cantidad > 0),
    precio_unitario DECIMAL(10, 2) NOT NULL CHECK (precio_unitario > 0),
    FOREIGN KEY (pedido_id) REFERENCES Pedidos(id),
    FOREIGN KEY (producto_id) REFERENCES Productos(id)
);

INSERT INTO Clientes (nombre, apellido, email, telefono) VALUES
('Juan', 'Pérez', 'juan.perez@example.com', '555-1234'),
('María', 'Gómez', 'maria.gomez@example.com', '555-5678'),
('Carlos', 'López', 'carlos.lopez@example.com', '555-8765');


INSERT INTO Productos (nombre, precio, stock, descripcion) VALUES
('Laptop', 800.00, 10, 'Laptop con procesador i5 y 8GB de RAM.'),
('Smartphone', 300.00, 20, 'Smartphone con pantalla de 6.5 pulgadas.'),
('Auriculares', 50.00, 15, 'Auriculares inalámbricos con cancelación de ruido.');


INSERT INTO Pedidos (cliente_id, total) VALUES
(1, 850.00), 
(2, 300.00), 
(3, 100.00); 


INSERT INTO Detalles_Pedido (pedido_id, producto_id, cantidad, precio_unitario) VALUES
(1, 1, 1, 800.00), 
(2, 2, 1, 300.00), 
(3, 3, 2, 50.00); 

/* Función para obtener el nombre completo de un cliente:*/
DELIMITER //
CREATE FUNCTION obtener_nombre_completo(cliente_id INT)
RETURNS VARCHAR(255)
DETERMINISTIC
BEGIN
    DECLARE nombre_completo VARCHAR(255);
    SELECT CONCAT(nombre, ' ', apellido) INTO nombre_completo
    FROM Clientes
    WHERE id = cliente_id;
    RETURN nombre_completo;
END //
DELIMITER ;

/*Función para calcular el descuento de un producto:*/
DELIMITER //
CREATE FUNCTION calcular_precio_con_descuento(precio DECIMAL(10, 2), descuento DECIMAL(5, 2))
RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN
    DECLARE precio_final DECIMAL(10, 2);
    SET precio_final = precio - (precio * (descuento / 100));
    RETURN precio_final;
END //
DELIMITER ;

/*Función para calcular el total de un pedido:*/
DELIMITER //
CREATE FUNCTION calcular_total_pedido(pedido_id INT)
RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(10, 2);
    SELECT SUM(dp.cantidad * dp.precio_unitario) INTO total
    FROM Detalles_Pedido dp
    WHERE dp.pedido_id = pedido_id;
    IF total IS NULL THEN
        SET total = 0;
    END IF;
    RETURN total;
END //
DELIMITER ;
/*Función para verificar la disponibilidad de stock de un producto:*/
DELIMITER //
CREATE FUNCTION verificar_disponibilidad_stock(producto_id INT, cantidad INT)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE stock_disponible INT;
    SELECT stock INTO stock_disponible
    FROM Productos
    WHERE id = producto_id;
    IF stock_disponible IS NULL THEN
        RETURN FALSE; 
    ELSEIF stock_disponible >= cantidad THEN
        RETURN TRUE;  
    ELSE
        RETURN FALSE;  
    END IF;
END //
DELIMITER ;
/* Función para calcular la antigüedad de un cliente*/
DELIMITER //
CREATE FUNCTION calcular_antiguedad_cliente(cliente_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE fecha_registro DATETIME;
    DECLARE antiguedad INT;
    SELECT fecha_registro INTO fecha_registro
    FROM Clientes
    WHERE id = cliente_id;
    IF fecha_registro IS NULL THEN
        RETURN NULL; 
    ELSE
        SET antiguedad = TIMESTAMPDIFF(YEAR, fecha_registro, CURDATE());
        RETURN antiguedad;
    END IF;
END //

DELIMITER ;
/*Consultas de Uso de Funciones:*/
/*Consulta para obtener el nombre completo de un cliente dado su
cliente_id.
*/
SELECT CONCAT(nombre, ' ', apellido) AS NombreCompleto
FROM Clientes
WHERE id = 1;
/*Consulta para calcular el descuento de un producto dado su precio y
un descuento del 10%.*/
SELECT 
    precio AS PrecioOriginal,
    (precio * 0.10) AS Descuento,
    (precio - (precio * 0.10)) AS PrecioConDescuento
FROM 
    Productos
WHERE 
    id = 1;
/*■ Consulta para calcular el total de un pedido dado su pedido_id.
*/
SELECT 
    SUM(dp.cantidad * dp.precio_unitario) AS TotalPedido
FROM 
    Detalles_Pedido dp
WHERE 
    dp.pedido_id = 1;
/*Consulta para verificar si un producto tiene suficiente stock para una
cantidad solicitada.
*/
SELECT 
    CASE 
        WHEN stock >= 5 THEN TRUE 
        ELSE FALSE 
    END AS SuficienteStock
FROM 
    Productos
WHERE 
    id = 1;
