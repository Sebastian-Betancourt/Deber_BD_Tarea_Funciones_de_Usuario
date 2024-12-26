CREATE DATABASE IF NOT EXISTS banco; 
USE banco;

CREATE TABLE IF NOT EXISTS Transacciones (
    transaccion_id INT AUTO_INCREMENT PRIMARY KEY, 
    cuenta_id INT NOT NULL, 
    tipo_transaccion ENUM('deposito', 'retiro') NOT NULL, 
    monto DECIMAL(10,2) NOT NULL, 
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP 
);

INSERT INTO Transacciones (cuenta_id, tipo_transaccion, monto) VALUES 
(1, 'deposito', 1000.00), 
(1, 'retiro', 200.00),    
(1, 'deposito', 500.00),  
(2, 'retiro', 300.00);     

DELIMITER $$
-- Eliminar la función si ya existe (para evitar errores)
DROP FUNCTION IF EXISTS CalcularSaldo;
-- Crear la función CalcularSaldo
CREATE FUNCTION CalcularSaldo(id_cuenta INT)
RETURNS DECIMAL(10,2) -- Devuelve un valor decimal (el saldo)
DETERMINISTIC -- La función produce siempre el mismo resultado para la misma entrada
BEGIN
    DECLARE saldo DECIMAL(10,2); -- Declara una variable para almacenar el saldo
    -- Calcula el saldo sumando depósitos y restando retiros
    SELECT SUM(CASE 
        WHEN tipo_transaccion = 'deposito' THEN monto -- Suma los depósitos
        WHEN tipo_transaccion = 'retiro' THEN -monto -- Resta los retiros
        ELSE 0 -- Devuelve 0 para cualquier otro caso (seguridad)
    END) INTO saldo
    FROM Transacciones
    WHERE cuenta_id = id_cuenta; -- Filtra las transacciones de la cuenta específica
    RETURN saldo; -- Devuelve el saldo calculado
END $$
-- Restablecer el delimitador a su valor original
DELIMITER ;

SELECT CalcularSaldo(1) AS SaldoCuenta1; 
SELECT CalcularSaldo(2) AS SaldoCuenta2;  