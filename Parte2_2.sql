CREATE DATABASE IF NOT EXISTS personas; 
USE personas; 

CREATE TABLE IF NOT EXISTS Personas (
    PersonaID INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL, 
    fecha_nacimiento DATE NOT NULL 
);

INSERT INTO Personas (nombre, fecha_nacimiento) VALUES 
('Juan Pérez', '1990-05-15'), 
('María López', '1985-08-20'), 
('Carlos García', '2000-12-30');  


DELIMITER $$ -- Cambia el delimitador a $$
CREATE FUNCTION CalcularEdad(fecha_nacimiento DATE) -- Define la función con un parámetro de fecha
RETURNS INT -- Devuelve un entero (edad)
DETERMINISTIC -- Resultados consistentes para los mismos parámetros
BEGIN -- Inicio del bloque de la función

    DECLARE edad INT; -- Declara la variable edad
    SET edad = TIMESTAMPDIFF(YEAR, fecha_nacimiento, CURDATE()); -- Calcula la edad en años
    RETURN edad; -- Devuelve la edad calculada
END $$ -- Fin del bloque de la función
DELIMITER ; -- Restablece el delimitador a ;




SELECT nombre, CalcularEdad(fecha_nacimiento) AS Edad FROM Personas; 
