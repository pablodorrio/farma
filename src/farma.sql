/* __________________DROP_____________________ */

DROP TABLE CLIENTE CASCADE CONSTRAINTS;
DROP TABLE TLF_C CASCADE CONSTRAINTS;
DROP TABLE PERSONAL CASCADE CONSTRAINTS;
DROP TABLE CLIENTE_VIP CASCADE CONSTRAINTS;
DROP TABLE VENTA CASCADE CONSTRAINTS;
DROP TABLE ITEM CASCADE CONSTRAINTS;
DROP TABLE LINEA_VENTA CASCADE CONSTRAINTS;
DROP TABLE FARMACEUTICO CASCADE CONSTRAINTS;
DROP TABLE CAJERO CASCADE CONSTRAINTS;
DROP TABLE SUCURSAL CASCADE CONSTRAINTS;
DROP TABLE CEO CASCADE CONSTRAINTS;
DROP TABLE TLF_CEO CASCADE CONSTRAINTS;
DROP TABLE PRODUCTO CASCADE CONSTRAINTS;
DROP TABLE MEDICAMENTO CASCADE CONSTRAINTS;
DROP TABLE EMPRESA CASCADE CONSTRAINTS;
DROP TABLE TLF_EMP CASCADE CONSTRAINTS;
DROP TABLE LABORATORIO CASCADE CONSTRAINTS;
DROP TABLE PROVEEDOR CASCADE CONSTRAINTS;
DROP TABLE PROVEE CASCADE CONSTRAINTS;
DROP VIEW VistaProveedores CASCADE CONSTRAINTS;
DROP VIEW VistaItemDetallada CASCADE CONSTRAINTS;
DROP PROCEDURE ListaPersonal;
DROP PROCEDURE ACTUALIZAR_STOCK;
DROP PROCEDURE MostrarContenidoVenta;
DROP PROCEDURE BorrarProveedor;
DROP FUNCTION OBTENER_STOCK;
DROP FUNCTION calcularTotalVentasConCursor;

/* __________________TABLAS_____________________ */

-- Creación de la tabla CLIENTE
CREATE TABLE
    CLIENTE(
        CDNI VARCHAR(9) NOT NULL,
        CNAME VARCHAR(25),
        CDIR VARCHAR(255),
        CNSS VARCHAR(12),
        PUNTOS INT DEFAULT 0,
        PRIMARY KEY (CDNI)
    );

-- Creación de la tabla TLF_C
CREATE TABLE
    TLF_C(
        CDNI VARCHAR(9) NOT NULL,
        CTLF INT NOT NULL CHECK(
            CTLF >= 0
            AND CTLF <= 999999999
        ),
        PRIMARY KEY (CDNI, CTLF),
        FOREIGN KEY (CDNI) REFERENCES CLIENTE(CDNI)
    );

-- Creación de la tabla SUCURSAL
CREATE TABLE
    SUCURSAL(
        NUM_SUC INT NOT NULL,
        DIREC VARCHAR(255),
        PRIMARY KEY (NUM_SUC)
    );

-- Creación de la tabla CEO
CREATE TABLE
    CEO(
        DNI VARCHAR(9) NOT NULL,
        NOMBRE VARCHAR(25),
        PRIMARY KEY (DNI)
    );

-- Creación de la tabla PERSONAL
CREATE TABLE
    PERSONAL (
        CODIGO_EMP INT NOT NULL,
        DNI VARCHAR(9) NOT NULL,
        NOMBRE VARCHAR(25) NOT NULL,
        DIR VARCHAR(255) NOT NULL,
        NUM_SUC INT,
        DNI_CEO VARCHAR(9) NOT NULL,
        DNI_SUPERVISOR smallint,
        PRIMARY KEY (CODIGO_EMP),
        FOREIGN KEY (NUM_SUC) REFERENCES SUCURSAL(NUM_SUC),
        FOREIGN KEY (DNI_CEO) REFERENCES CEO(DNI),
        FOREIGN KEY (DNI_SUPERVISOR) REFERENCES PERSONAL(CODIGO_EMP)
    );

-- Creación de la tabla CLIENTE_VIP
CREATE TABLE
    CLIENTE_VIP (
        CDNI VARCHAR(9) NOT NULL,
        CODIGO_EMP INT NOT NULL CHECK (
            CODIGO_EMP >= 0
            AND CODIGO_EMP <= 999999999
        ),
        DESCUENTO INT,
        PRIMARY KEY (CDNI, CODIGO_EMP),
        FOREIGN KEY (CDNI) REFERENCES CLIENTE(CDNI),
        FOREIGN KEY (CODIGO_EMP) REFERENCES PERSONAL(CODIGO_EMP)
    );

-- Creación de la tabla VENTA
CREATE TABLE
    VENTA (
        CODIGO_VENTA INT NOT NULL,
        FECHA_V DATE,
        PRECIO_TOTAL FLOAT NOT NULL,
        DNI VARCHAR(9),
        CODIGO_EMP INT NOT NULL,
        PRIMARY KEY (CODIGO_VENTA),
        FOREIGN KEY (DNI) REFERENCES CLIENTE(CDNI),
        FOREIGN KEY (CODIGO_EMP) REFERENCES PERSONAL(CODIGO_EMP)
    );

-- Creación de la tabla ITEM
CREATE TABLE
    ITEM(
        CODIGO_ITEM INT NOT NULL,
        PRECIO FLOAT NOT NULL,
        NOMBRE VARCHAR(25) NOT NULL,
        STOCK INT NOT NULL,
        PRIMARY KEY (CODIGO_ITEM)
    );

-- Creación de la tabla LINEA_VENTA
CREATE TABLE
    LINEA_VENTA (
        N_SEC INT NOT NULL,
        CODIGO_VENTA INT NOT NULL,
        COD_ITEM INT NOT NULL,
        CANTIDAD INT NOT NULL,
        UNIQUE(CODIGO_VENTA, COD_ITEM),
        PRIMARY KEY (N_SEC, CODIGO_VENTA),
        FOREIGN KEY (CODIGO_VENTA) REFERENCES VENTA(CODIGO_VENTA),
        FOREIGN KEY (COD_ITEM) REFERENCES ITEM(CODIGO_ITEM)
    );

-- Creación de la tabla FARMACEUTICO
CREATE TABLE
    FARMACEUTICO(
        CODIGO_EMP INT NOT NULL,
        NUM_COLEGIADO INT NOT NULL,
        PRIMARY KEY (CODIGO_EMP),
        FOREIGN KEY (CODIGO_EMP) REFERENCES PERSONAL(CODIGO_EMP)
    );

-- Creación de la tabla CAJERO
CREATE TABLE
    CAJERO(
        CODIGO_EMP INT NOT NULL,
        NUM_CAJA INT NOT NULL,
        PRIMARY KEY (CODIGO_EMP),
        FOREIGN KEY (CODIGO_EMP) REFERENCES PERSONAL(CODIGO_EMP)
    );

-- Creación de la tabla TLF_CEO
CREATE TABLE
    TLF_CEO (
        DNI VARCHAR(9) NOT NULL,
        TLF INT NOT NULL CHECK(
            TLF >= 0
            AND TLF <= 999999999
        ),
        PRIMARY KEY (DNI, TLF),
        FOREIGN KEY (DNI) REFERENCES CEO(DNI)
    );

-- Creación de la tabla PRODUCTO
CREATE TABLE
    PRODUCTO (
        ID_PRODUCTO INT NOT NULL,
        CODIGO_ITEM INT NOT NULL,
        TIPO_P VARCHAR(50) NOT NULL,
        PRIMARY KEY (ID_PRODUCTO),
        FOREIGN KEY (CODIGO_ITEM) REFERENCES ITEM(CODIGO_ITEM)
    );

-- Creación de la tabla MEDICAMENTO
CREATE TABLE
    MEDICAMENTO (
        ID_MEDICAMENTO INT NOT NULL,
        CODIGO_ITEM INT NOT NULL,
        COD_NAC INT NOT NULL,
        TIPO_M VARCHAR(50) NOT NULL,
        FECHA_CAD DATE CHECK (FECHA_CAD >= TO_DATE('2023-01-01', 'YYYY-MM-DD')),
        PRIMARY KEY (ID_MEDICAMENTO),
        FOREIGN KEY (CODIGO_ITEM) REFERENCES ITEM(CODIGO_ITEM)
    );

-- Creación de la tabla EMPRESA
CREATE TABLE
    EMPRESA (
        ID_EMP INT NOT NULL,
        DIR VARCHAR(255) NOT NULL,
        NOMBRE VARCHAR(25) NOT NULL,
        PRIMARY KEY (ID_EMP)
    );

-- Creación de la tabla TLF_EMP
CREATE TABLE
    TLF_EMP (
        ID_EMP INT NOT NULL,
        TLF INT NOT NULL CHECK(
            TLF >= 0
            AND TLF <= 999999999
        ),
        PRIMARY KEY (ID_EMP, TLF),
        FOREIGN KEY (ID_EMP) REFERENCES EMPRESA (ID_EMP)
    );

-- Creación de la tabla LABORATORIO
CREATE TABLE
    LABORATORIO(
        CODIGO_EMP INT NOT NULL,
        CERTI_PRODUC INT NOT NULL,
        PRIMARY KEY (CODIGO_EMP),
        FOREIGN KEY (CODIGO_EMP) REFERENCES EMPRESA (ID_EMP)
    );

-- Creación de la tabla PROVEEDOR
CREATE TABLE
    PROVEEDOR (
        CODIGO_EMP INT NOT NULL,
        CERTI_PRODUCCION INT NOT NULL,
        PRIMARY KEY (CODIGO_EMP),
        FOREIGN KEY (CODIGO_EMP) REFERENCES EMPRESA (ID_EMP)
    );

-- Creación de la tabla PROVEE
CREATE TABLE
    PROVEE (
        CODIGO_ITEM INT NOT NULL,
        CODIGO_EMP INT NOT NULL,
        PRIMARY KEY (CODIGO_ITEM, CODIGO_EMP),
        FOREIGN KEY (CODIGO_ITEM) REFERENCES ITEM(CODIGO_ITEM),
        FOREIGN KEY (CODIGO_EMP) REFERENCES EMPRESA (ID_EMP)
    );

/* __________________VISTAS_____________________ */

CREATE VIEW VistaProveedores AS
SELECT 
    p.CODIGO_EMP,
    p.CODIGO_ITEM,
    MAX(i.STOCK) AS STOCK
FROM PROVEE p
LEFT JOIN ITEM i ON i.CODIGO_ITEM = p.CODIGO_ITEM
GROUP BY 
    p.CODIGO_EMP,
    p.CODIGO_ITEM;



CREATE VIEW VistaItemDetallada AS
SELECT
    i.CODIGO_ITEM,
    i.NOMBRE,
    i.STOCK,
    i.PRECIO,
    i.STOCK * i.PRECIO AS PRECIO_TOTAL,
    COUNT(lv.COD_ITEM) AS NumeroDeVentas
FROM ITEM i
LEFT JOIN LINEA_VENTA lv ON i.CODIGO_ITEM = lv.COD_ITEM
GROUP BY
    i.CODIGO_ITEM,
    i.NOMBRE,
    i.STOCK,
    i.PRECIO;

/* __________________ÍNDICES_____________________ */
CREATE INDEX idx_venta_dni_codigo_emp ON VENTA(DNI, CODIGO_EMP);

CREATE INDEX idx_lv_cod_item_cantidad ON LINEA_VENTA(COD_ITEM, CANTIDAD);

/* __________________SEED_____________________ */

/* TABLA - CLIENTE */

INSERT INTO CLIENTE (CDNI, CNAME, CDIR, CNSS) VALUES ( '123456789', 'Juan Pérez', 'Calle 123', '123-45-6789' );
INSERT INTO CLIENTE (CDNI, CNAME, CDIR, CNSS) VALUES ( '987654321', 'María Rodríguez', 'Avenida 456', '987-65-4321' );
INSERT INTO CLIENTE (CDNI, CNAME, CDIR, CNSS) VALUES ( '111223344', 'Carlos González', 'Carrera 789', '111-22-3344' );
INSERT INTO CLIENTE (CDNI, CNAME, CDIR, CNSS) VALUES ( '495284723', 'Juana  Míguez', 'Calle del Barro 10', '800-22-3478' );
INSERT INTO CLIENTE (CDNI, CNAME, CDIR, CNSS) VALUES ( '294853135', 'Juan Lopez', 'Mil Horas 22', '094-14-7328' );

/* TABLA - TLF_C  */

INSERT INTO TLF_C (CDNI, CTLF) VALUES ('123456789', 123456789);
INSERT INTO TLF_C (CDNI, CTLF) VALUES ('987654321', 987654321);
INSERT INTO TLF_C (CDNI, CTLF) VALUES ('111223344', 555555555);
INSERT INTO TLF_C (CDNI, CTLF) VALUES ('495284723', 038592947);
INSERT INTO TLF_C (CDNI, CTLF) VALUES ('294853135', 672917483);

/* TABLA - SUCURSAL  */

INSERT INTO SUCURSAL (NUM_SUC, DIREC) VALUES (1, 'Dirección1');
INSERT INTO SUCURSAL (NUM_SUC, DIREC) VALUES (2, 'Dirección2');
INSERT INTO SUCURSAL (NUM_SUC, DIREC) VALUES (3, 'Dirección3');

/* TABLA - CEO  */

INSERT INTO CEO (DNI, NOMBRE) VALUES ( '123456789', 'María Asunción Fernández' );
INSERT INTO CEO (DNI, NOMBRE) VALUES ( '987654321', 'Raúl González Iglesias' );
INSERT INTO CEO (DNI, NOMBRE) VALUES ( '111223344', 'Mario Fernández Yáñez' );

/* TABLA - PERSONAL  */

INSERT INTO PERSONAL ( CODIGO_EMP, DNI, NOMBRE, DIR, NUM_SUC, DNI_CEO ) VALUES ( 1, '123456789', 'Juan Perez', 'Calle 123', 1, '123456789');
INSERT INTO PERSONAL ( CODIGO_EMP, DNI, NOMBRE, DIR, NUM_SUC, DNI_CEO ) VALUES ( 2, '987654321', 'Maria Rodriguez', 'Avenida 456', 2 , '123456789');
INSERT INTO PERSONAL ( CODIGO_EMP, DNI, NOMBRE, DIR, NUM_SUC, DNI_CEO ) VALUES ( 3, '111223344', 'Carlos Gonzalez', 'Carrera 789', 1 , '123456789');

/* TABLA - CLIENTE_VIP  */

INSERT INTO CLIENTE_VIP (CDNI, CODIGO_EMP, DESCUENTO) VALUES ('123456789', 1, 10);
INSERT INTO CLIENTE_VIP (CDNI, CODIGO_EMP, DESCUENTO) VALUES ('987654321', 2, 15);
INSERT INTO CLIENTE_VIP (CDNI, CODIGO_EMP, DESCUENTO) VALUES ('111223344', 3, 20);

/* TABLA - VENTA  */

INSERT INTO VENTA (CODIGO_VENTA, DNI, CODIGO_EMP, PRECIO_TOTAL) VALUES (1001, '123456789', 1, 25);
INSERT INTO VENTA (CODIGO_VENTA, DNI, CODIGO_EMP, PRECIO_TOTAL) VALUES (1002, '987654321', 2, 30);
INSERT INTO VENTA (CODIGO_VENTA, DNI, CODIGO_EMP, PRECIO_TOTAL) VALUES (1003, '111223344', 3, 15);

/* TABLA - ITEM  */

INSERT INTO ITEM ( CODIGO_ITEM, PRECIO, NOMBRE, STOCK ) VALUES (1, 19.99, 'Producto1', 50);
INSERT INTO ITEM ( CODIGO_ITEM, PRECIO, NOMBRE, STOCK ) VALUES (2, 29.99, 'Producto2', 30);
INSERT INTO ITEM ( CODIGO_ITEM, PRECIO, NOMBRE, STOCK ) VALUES (3, 9.99, 'Producto3', 75);

/* TABLA - LINEA_VENTA  */

INSERT INTO LINEA_VENTA ( N_SEC, CODIGO_VENTA, COD_ITEM, CANTIDAD ) VALUES (1, 1001, 1, 4);
INSERT INTO LINEA_VENTA ( N_SEC, CODIGO_VENTA, COD_ITEM, CANTIDAD ) VALUES (2, 1001, 2, 1);
INSERT INTO LINEA_VENTA ( N_SEC, CODIGO_VENTA, COD_ITEM, CANTIDAD ) VALUES (3, 1002, 3, 3);

/* TABLA - FARMACEUTICO  */

INSERT INTO FARMACEUTICO (CODIGO_EMP, NUM_COLEGIADO) VALUES (1, 12345);
INSERT INTO FARMACEUTICO (CODIGO_EMP, NUM_COLEGIADO) VALUES (2, 67890);
INSERT INTO FARMACEUTICO (CODIGO_EMP, NUM_COLEGIADO) VALUES (3, 54321);

/* TABLA - CAJERO  */

INSERT INTO CAJERO (CODIGO_EMP, NUM_CAJA) VALUES (1, 101);
INSERT INTO CAJERO (CODIGO_EMP, NUM_CAJA) VALUES (2, 102);
INSERT INTO CAJERO (CODIGO_EMP, NUM_CAJA) VALUES (3, 103);

/* TABLA - TLF_CEO  */

INSERT INTO TLF_CEO (DNI, TLF) VALUES ('123456789', 987654321);
INSERT INTO TLF_CEO (DNI, TLF) VALUES ('987654321', 123456789);
INSERT INTO TLF_CEO (DNI, TLF) VALUES ('111223344', 555555555);

/* TABLA - PRODUCTO  */

INSERT INTO PRODUCTO (ID_PRODUCTO, CODIGO_ITEM, TIPO_P) VALUES (3, 1, 'Crema');
INSERT INTO PRODUCTO (ID_PRODUCTO, CODIGO_ITEM, TIPO_P) VALUES (2, 2, 'Higiene');
INSERT INTO PRODUCTO (ID_PRODUCTO, CODIGO_ITEM, TIPO_P) VALUES (1, 3, 'Cosmética');

-- TABLA - MEDICAMENTO

INSERT INTO MEDICAMENTO (ID_MEDICAMENTO, CODIGO_ITEM, COD_NAC, TIPO_M, FECHA_CAD) VALUES (11, 1, 12345, 'Analgésico', TO_DATE('2023-12-31', 'YYYY-MM-DD'));
INSERT INTO MEDICAMENTO (ID_MEDICAMENTO, CODIGO_ITEM, COD_NAC, TIPO_M, FECHA_CAD) VALUES (12, 2, 67890, 'Antibiótico', TO_DATE('2024-06-30', 'YYYY-MM-DD'));
INSERT INTO MEDICAMENTO (ID_MEDICAMENTO, CODIGO_ITEM, COD_NAC, TIPO_M, FECHA_CAD) VALUES (13, 3, 54321, 'Antiinflamatorio', TO_DATE('2023-09-15', 'YYYY-MM-DD'));


/* TABLA - EMPRESA  */

INSERT INTO EMPRESA (ID_EMP, DIR, NOMBRE) VALUES (1, 'Direccion1', 'Empresa1');
INSERT INTO EMPRESA (ID_EMP, DIR, NOMBRE) VALUES (2, 'Direccion2', 'Empresa2');
INSERT INTO EMPRESA (ID_EMP, DIR, NOMBRE) VALUES (3, 'Direccion3', 'Empresa3');

/* TABLA - TLF_EMP  */

INSERT INTO TLF_EMP (ID_EMP, TLF) VALUES (1, 123456789);
INSERT INTO TLF_EMP (ID_EMP, TLF) VALUES (2, 987654321);
INSERT INTO TLF_EMP (ID_EMP, TLF) VALUES (3, 555555555);

/* TABLA - LABORATORIO  */

INSERT INTO LABORATORIO (CODIGO_EMP, CERTI_PRODUC) VALUES (1, 98765);
INSERT INTO LABORATORIO (CODIGO_EMP, CERTI_PRODUC) VALUES (2, 54321);
INSERT INTO LABORATORIO (CODIGO_EMP, CERTI_PRODUC) VALUES (3, 12345);

/* TABLA - PROVEEDOR  */

INSERT INTO PROVEEDOR (CODIGO_EMP, CERTI_PRODUCCION) VALUES (1, 123456);
INSERT INTO PROVEEDOR (CODIGO_EMP, CERTI_PRODUCCION) VALUES (2, 789012);
INSERT INTO PROVEEDOR (CODIGO_EMP, CERTI_PRODUCCION) VALUES (3, 345678);


/* __________________CONSULTAS_____________________ */

-- SELECT CDNI, CNAME, CDIR, CNSS FROM CLIENTE WHERE CDNI = '123456789';

-- SELECT CDNI, CTLF FROM TLF_C WHERE CDNI = '123456789';

-- SELECT CDNI, CODIGO_EMP, DESC
-- FROM CLIENTE_VIP
-- WHERE CDNI = '123456789';

-- SELECT
--     CODIGO_VENTA,
--     DNI,
--     CODIGO_EMP
-- FROM VENTA
-- WHERE CODIGO_VENTA = 1001;

-- SELECT
--     N_SEC,
--     CODIGO_VENTA,
--     COD_ITEM,
--     CANTIDAD
-- FROM LINEA_VENTA
-- WHERE CODIGO_VENTA = 1001;

-- SELECT
--     CODIGO_EMP,
--     DNI,
--     NOMBRE,
--     DIR,
--     DNI_SUPERVISOR,
--     NUM_SUC
-- FROM PERSONAL
-- WHERE CODIGO_EMP = 1;

-- SELECT
--     CODIGO_EMP,
--     NUM_COLEGIADO
-- FROM FARMACEUTICO
-- WHERE CODIGO_EMP = 1;

-- SELECT CODIGO_EMP, NUM_CAJA FROM CAJERO WHERE CODIGO_EMP = 1;

-- SELECT NUM_SUC, DIREC FROM SUCURSAL WHERE NUM_SUC = 1;

-- SELECT DNI, NOMBRE FROM CEO WHERE DNI = '123456789';

-- SELECT
--     CODIGO_ITEM,
--     PRECIO,
--     NOMBRE,
--     STOCK
-- FROM ITEM
-- WHERE CODIGO_ITEM = 1;

-- SELECT CODIGO_ITEM, TIPO_P FROM PRODUCTO WHERE CODIGO_ITEM = 1;

-- SELECT
--     CODIGO_ITEM,
--     COD_NAC,
--     TIPO_M,
--     FECHA_CAD
-- FROM MEDICAMENTO
-- WHERE CODIGO_ITEM = 1;

-- SELECT ID_EMP, DIR, NOMBRE FROM EMPRESA WHERE ID_EMP = 1;

-- SELECT
--     CODIGO_EMP,
--     CERTI_PRODUC
-- FROM LABORATORIO
-- WHERE CODIGO_EMP = 1;

-- UPDATE CLIENTE

-- SET

--     CNAME = 'Manolo Perez Ribao',

--     CDIR = 'Calle de la Azucena 30',

--     CNSS = '123456789012'

-- WHERE CDNI = '123456789';

-- UPDATE TLF_C SET CTLF = 987654321 WHERE CDNI = '123456789';

-- UPDATE CLIENTE_VIP SET DESC = 15 WHERE CDNI = '123456789';

-- UPDATE VENTA

-- SET

--     DNI = '123456789',

--     CODIGO_EMP = 4

-- WHERE CODIGO_VENTA = 1001;

-- UPDATE LINEA_VENTA SET CANTIDAD = 5 WHERE CODIGO_VENTA = 1001;

-- UPDATE PERSONAL

-- SET

--     NOMBRE = 'Paulina Rubio',

--     DIR = 'La Alameda Brillante'

-- WHERE CODIGO_EMP = 1;

-- UPDATE FARMACEUTICO SET NUM_COLEGIADO = 54321 WHERE CODIGO_EMP = 1;

-- UPDATE CAJERO SET NUM_CAJA = 105 WHERE CODIGO_EMP = 1;

-- UPDATE SUCURSAL SET DIREC = 'Los Olmos cantarines' WHERE NUM_SUC = 1;

-- UPDATE CEO

-- SET

--     NOMBRE = 'Pandy Alvarez Fernandez'

-- WHERE DNI = '123456789';
-- ############################################
-- 7.- Procedimientos y Funciones PL/SQL ######
-- ############################################
-- 1. Calcular las ventas totales de un Cliente.
CREATE OR REPLACE FUNCTION calcularTotalVentasConCursor(p_CDNI IN VARCHAR2) RETURN NUMBER IS
  v_totalVentas NUMBER := 0;
BEGIN
  -- Declaración del cursor
  FOR venta_rec IN (SELECT PRECIO_TOTAL FROM VENTA WHERE DNI = p_CDNI) LOOP
    -- Lógica de acumulación
    v_totalVentas := v_totalVentas + venta_rec.PRECIO_TOTAL;
  END LOOP;

  RETURN v_totalVentas;
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error en calcularTotalVentasConCursor: ' || SQLERRM);
    RETURN NULL;
END calcularTotalVentasConCursor;
/

-- 2. Mostrar el personal de una sucursal.
CREATE OR REPLACE PROCEDURE ListaPersonal(
    numSucursal IN SUCURSAL.NUM_SUC%TYPE,
    numPersonal OUT NUMBER
)
IS
    regPersonal PERSONAL%ROWTYPE;
    v_totalVentas NUMBER := 0;
    E_NO_PERSONAL EXCEPTION;

    CURSOR C_PERSONAL IS
        SELECT *  -- Cambia aquí para seleccionar todos los campos
        FROM PERSONAL P
        WHERE P.NUM_SUC = numSucursal;

BEGIN
    -- Abrir el cursor y mostrar el personal de la sucursal
    OPEN C_PERSONAL;
    DBMS_OUTPUT.PUT_LINE('Personal de la sucursal número ' || numSucursal || ':');
    
    LOOP
        FETCH C_PERSONAL INTO regPersonal;
        EXIT WHEN C_PERSONAL%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE('Código: ' || regPersonal.CODIGO_EMP ||
                             ', DNI: ' || regPersonal.DNI ||
                             ', Nombre: ' || regPersonal.NOMBRE ||
                             ', Dirección: ' || regPersonal.DIR ||
                             ', Supervisor: ' || regPersonal.DNI_SUPERVISOR);
    END LOOP;

    -- Calcular el total de ventas fuera del bucle
    SELECT NVL(SUM(PRECIO_TOTAL), 0)
    INTO v_totalVentas
    FROM VENTA
    WHERE DNI IN (SELECT P.DNI FROM PERSONAL P WHERE P.NUM_SUC = numSucursal);

    numPersonal := C_PERSONAL%ROWCOUNT;

    IF (numPersonal = 0) THEN
        RAISE E_NO_PERSONAL;
    END IF;

    CLOSE C_PERSONAL;

    DBMS_OUTPUT.PUT_LINE('Total de ventas del personal en la sucursal: ' || v_totalVentas);

EXCEPTION
    WHEN E_NO_PERSONAL THEN
        DBMS_OUTPUT.PUT_LINE('No hay personal registrado en la sucursal seleccionada.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error en ListaPersonal: ' || SQLERRM);
END ListaPersonal;
/


-- 3. Función para obtener el stock de un producto
CREATE OR REPLACE FUNCTION OBTENER_STOCK(
    p_codigo_item INT
) RETURN INT AS
    v_stock INT;

    CURSOR C_Stock IS
        SELECT STOCK
        FROM ITEM
        WHERE CODIGO_ITEM = p_codigo_item;

BEGIN
    -- Abrir el cursor y obtener el stock
    OPEN C_Stock;
    FETCH C_Stock INTO v_stock;
    CLOSE C_Stock;

    RETURN v_stock;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('El producto con código ' || p_codigo_item || ' no existe.');
        RETURN NULL;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error en OBTENER_STOCK: ' || SQLERRM);
        RETURN NULL;
END OBTENER_STOCK;
/


-- 4. Procedimiento para actualizar el stock de un producto
CREATE OR REPLACE PROCEDURE ACTUALIZAR_STOCK(
    p_codigo_item INT,
    p_cantidad INT
)
IS
    v_stock_actual INT;

    CURSOR C_StockActual IS
        SELECT OBTENER_STOCK(p_codigo_item) AS STOCK_ACTUAL
        FROM DUAL;

BEGIN
    -- Abrir el cursor y obtener el stock actual
    OPEN C_StockActual;
    FETCH C_StockActual INTO v_stock_actual;
    CLOSE C_StockActual;

    IF v_stock_actual IS NOT NULL THEN
        -- Actualizar el stock
        UPDATE ITEM
        SET STOCK = v_stock_actual + p_cantidad
        WHERE CODIGO_ITEM = p_codigo_item;

        DBMS_OUTPUT.PUT_LINE('Stock actualizado correctamente.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('No se pudo obtener el stock actual.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error en ACTUALIZAR_STOCK: ' || SQLERRM);
END ACTUALIZAR_STOCK;
/

-- 5. Borrar un proveedor y los items asociados a ese proveedor.
CREATE OR REPLACE PROCEDURE BorrarProveedor(
    codigoProveedor IN PROVEEDOR.CODIGO_EMP%TYPE
)
IS
    E_NO_PROVEEDOR EXCEPTION;
    PRAGMA EXCEPTION_INIT(E_NO_PROVEEDOR, -2292); -- ORA-02292: integrity constraint violation

    CURSOR C_ItemsProveedor IS
        SELECT CODIGO_ITEM
        FROM PROVEE
        WHERE CODIGO_EMP = codigoProveedor;

    v_codigoItem PROVEE.CODIGO_ITEM%TYPE;

BEGIN
    -- Abrir el cursor y borrar los elementos asociados
    OPEN C_ItemsProveedor;
    LOOP
        FETCH C_ItemsProveedor INTO v_codigoItem;
        EXIT WHEN C_ItemsProveedor%NOTFOUND;

        -- Borrar el item asociado
        DELETE FROM ITEM
        WHERE CODIGO_ITEM = v_codigoItem;
    END LOOP;
    CLOSE C_ItemsProveedor;

    -- Borrar la relación entre el proveedor y los items
    DELETE FROM PROVEE WHERE CODIGO_EMP = codigoProveedor;

    -- Borrar al proveedor
    DELETE FROM PROVEEDOR WHERE CODIGO_EMP = codigoProveedor;

    DBMS_OUTPUT.PUT_LINE('Proveedor y elementos asociados eliminados exitosamente.');
EXCEPTION
    WHEN E_NO_PROVEEDOR THEN
        DBMS_OUTPUT.PUT_LINE('No se encuentra el proveedor especificado o hay elementos asociados que no se pueden eliminar.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error en BorrarProveedor: ' || SQLERRM);
END BorrarProveedor;
/

-- 6. Mostrar los items de una linea de venta
CREATE OR REPLACE PROCEDURE MostrarContenidoVenta(
    codigoVenta IN VENTA.CODIGO_VENTA%TYPE
)
IS
    v_fecha_venta VENTA.FECHA_V%TYPE;
    v_precio_total VENTA.PRECIO_TOTAL%TYPE;

    -- Cursor para obtener información general de la venta
    CURSOR C_VENTA IS
        SELECT FECHA_V, PRECIO_TOTAL
        FROM VENTA
        WHERE CODIGO_VENTA = codigoVenta;

    -- Variables para los items asociados a la venta
    v_nombre_item ITEM.NOMBRE%TYPE;
    v_cantidad LINEA_VENTA.CANTIDAD%TYPE;
    v_precio_item ITEM.PRECIO%TYPE;

    -- Excepción para verificar si la venta existe
    E_NO_VENTA EXCEPTION;
    PRAGMA EXCEPTION_INIT(E_NO_VENTA, -2292); -- ORA-02292: integrity constraint violation

    -- Cursor para obtener los items asociados a la venta
    CURSOR C_ITEMS IS
        SELECT i.NOMBRE, lv.CANTIDAD, i.PRECIO
        FROM ITEM i
        JOIN LINEA_VENTA lv ON i.CODIGO_ITEM = lv.COD_ITEM
        WHERE lv.CODIGO_VENTA = codigoVenta;

BEGIN
    -- Mostrar información general de la venta
    BEGIN
        OPEN C_VENTA;
        FETCH C_VENTA INTO v_fecha_venta, v_precio_total;
        CLOSE C_VENTA;

        -- Mostrar los items asociados a la venta
        DBMS_OUTPUT.PUT_LINE('Información de la Venta - Código: ' || codigoVenta || ', Fecha: ' || TO_CHAR(v_fecha_venta, 'DD-MON-YYYY') || ', Precio Total: ' || v_precio_total);
        DBMS_OUTPUT.PUT_LINE('Items de la Venta:');

        OPEN C_ITEMS;
        LOOP
            FETCH C_ITEMS INTO v_nombre_item, v_cantidad, v_precio_item;
            EXIT WHEN C_ITEMS%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE('Item: ' || v_nombre_item || ', Cantidad: ' || v_cantidad || ', Precio: ' || v_precio_item);
        END LOOP;
        CLOSE C_ITEMS;
    EXCEPTION
        WHEN E_NO_VENTA THEN
            DBMS_OUTPUT.PUT_LINE('No se encontró la venta especificada.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error en MostrarContenidoVenta: ' || SQLERRM);
    END;

END MostrarContenidoVenta;
/

-- ##################################
-- 8. Declaración de Triggers #######
-- ##################################
CREATE OR REPLACE TRIGGER actualizar_stock_venta
AFTER INSERT ON LINEA_VENTA
FOR EACH ROW
DECLARE
    v_precio_item ITEM.PRECIO%TYPE;
BEGIN
    -- Obtener el precio del producto
    SELECT PRECIO
    INTO v_precio_item
    FROM ITEM
    WHERE CODIGO_ITEM = :NEW.COD_ITEM;

    -- Actualizar el stock del producto
    UPDATE ITEM
    SET STOCK = STOCK - :NEW.CANTIDAD
    WHERE CODIGO_ITEM = :NEW.COD_ITEM;

    -- Actualizar el precio total de la venta
    UPDATE VENTA
    SET PRECIO_TOTAL = PRECIO_TOTAL + (v_precio_item * :NEW.CANTIDAD)
    WHERE CODIGO_VENTA = :NEW.CODIGO_VENTA;
END actualizar_stock_venta;
/

-- 2. Actualizar supervisor en personal
CREATE OR REPLACE TRIGGER actualizar_supervisor
BEFORE UPDATE ON PERSONAL
FOR EACH ROW
DECLARE
    v_supervisor_dni VARCHAR(9);
BEGIN
    -- Obtener el DNI del supervisor del nuevo empleado
    SELECT DNI_SUPERVISOR
    INTO v_supervisor_dni
    FROM PERSONAL
    WHERE CODIGO_EMP = :NEW.CODIGO_EMP;

    -- Actualizar el DNI del supervisor
    :NEW.DNI_SUPERVISOR := v_supervisor_dni;
END;
/

-- 3. Aplicar descuento cliente VIP
CREATE OR REPLACE TRIGGER aplicar_descuento_cliente_vip
BEFORE INSERT OR UPDATE ON VENTA
FOR EACH ROW
DECLARE
    v_descuento_cliente NUMBER;
BEGIN
    -- Obtener el descuento del cliente VIP
    SELECT DESCUENTO
    INTO v_descuento_cliente
    FROM CLIENTE_VIP
    WHERE CDNI = :NEW.DNI;

    -- Aplicar descuento si es un cliente VIP
    IF v_descuento_cliente IS NOT NULL THEN
        :NEW.PRECIO_TOTAL := :NEW.PRECIO_TOTAL - (:NEW.PRECIO_TOTAL * (v_descuento_cliente / 100));
    END IF;
END;
/

-- 4. Verificar stock antes de venta
CREATE OR REPLACE TRIGGER verificar_stock_before_venta
BEFORE INSERT ON LINEA_VENTA
FOR EACH ROW
DECLARE
    v_stock_actual NUMBER;
BEGIN
    SELECT STOCK INTO v_stock_actual
    FROM ITEM
    WHERE CODIGO_ITEM = :NEW.COD_ITEM;

    IF v_stock_actual < :NEW.CANTIDAD THEN
        RAISE_APPLICATION_ERROR(-20001, 'No hay suficiente stock para realizar la venta.');
    END IF;
END;
/

-- 5. Actualizar puntos venta
CREATE OR REPLACE TRIGGER actualizar_puntos_venta
AFTER INSERT ON VENTA
FOR EACH ROW
DECLARE
    v_puntos_ganados INT;
BEGIN
    -- Calcular los puntos ganados en esta venta (ajusta la lógica según sea necesario)
    v_puntos_ganados := :NEW.PRECIO_TOTAL / 10; -- Por ejemplo, 1 punto por cada $10 de compra

    -- Actualizar los puntos del cliente
    UPDATE CLIENTE
    SET PUNTOS = PUNTOS + v_puntos_ganados
    WHERE CDNI = :NEW.DNI;
END actualizar_puntos_venta;
/

-- ###########################################################
-- 9. Bloque para prueba de Procedimientos y Funciones #######
-- ###########################################################
SET SERVEROUTPUT ON

DECLARE
   totalVentas NUMBER(10, 2);
   numPersonalSucursal NUMBER;
   stockProducto NUMBER;
   v_codigoVenta NUMBER;

BEGIN
   DBMS_OUTPUT.NEW_LINE;

   BEGIN
      -- 1. Calcular las ventas totales de un Cliente.
      DBMS_OUTPUT.PUT_LINE('======>INICIO FUNCIÓN: CalcularTotalVentasCliente');
      totalVentas := calcularTotalVentasConCursor('1'); -- Supongamos que el cliente_id es 1
      DBMS_OUTPUT.PUT_LINE('Ventas totales del Cliente: ' || totalVentas);
      DBMS_OUTPUT.PUT_LINE('======>FIN FUNCIÓN: CalcularTotalVentasCliente');
      DBMS_OUTPUT.NEW_LINE;
   EXCEPTION
      WHEN OTHERS THEN
         DBMS_OUTPUT.PUT_LINE('[EXCEPCIÓN]');
         DBMS_OUTPUT.PUT_LINE('[Código]: ' || SQLCODE);
         DBMS_OUTPUT.PUT_LINE('[Mensaje]: ' || SQLERRM);
   END;

   BEGIN
      -- 2. Mostrar el personal de una sucursal.
      DBMS_OUTPUT.PUT_LINE('======>INICIO PROCEDIMIENTO: ListaPersonal');
      ListaPersonal(1, numPersonalSucursal); -- Supongamos que el numSucursal es 1
      DBMS_OUTPUT.PUT_LINE('Número de personal en la sucursal: ' || numPersonalSucursal);
      DBMS_OUTPUT.PUT_LINE('======>FIN PROCEDIMIENTO: ListaPersonal');
      DBMS_OUTPUT.NEW_LINE;
   EXCEPTION
      WHEN OTHERS THEN
         DBMS_OUTPUT.PUT_LINE('[EXCEPCIÓN]');
         DBMS_OUTPUT.PUT_LINE('[Código]: ' || SQLCODE);
         DBMS_OUTPUT.PUT_LINE('[Mensaje]: ' || SQLERRM);
   END;

   BEGIN
      -- 3. Función para obtener el stock de un producto.
      DBMS_OUTPUT.PUT_LINE('======>INICIO FUNCIÓN: OBTENER_STOCK');
      stockProducto := OBTENER_STOCK(1); -- Supongamos que el p_codigo_item es 1
      DBMS_OUTPUT.PUT_LINE('Stock del producto: ' || stockProducto);
      DBMS_OUTPUT.PUT_LINE('======>FIN FUNCIÓN: OBTENER_STOCK');
      DBMS_OUTPUT.NEW_LINE;
   EXCEPTION
      WHEN OTHERS THEN
         DBMS_OUTPUT.PUT_LINE('[EXCEPCIÓN]');
         DBMS_OUTPUT.PUT_LINE('[Código]: ' || SQLCODE);
         DBMS_OUTPUT.PUT_LINE('[Mensaje]: ' || SQLERRM);
   END;

   BEGIN
      -- 4. Procedimiento para actualizar el stock de un producto.
      DBMS_OUTPUT.PUT_LINE('======>INICIO PROCEDIMIENTO: ACTUALIZAR_STOCK');
      ACTUALIZAR_STOCK(1, 5); -- Supongamos que el p_codigo_item es 1 y p_cantidad es 5
      DBMS_OUTPUT.PUT_LINE('======>FIN PROCEDIMIENTO: ACTUALIZAR_STOCK');
      DBMS_OUTPUT.NEW_LINE;
   EXCEPTION
      WHEN OTHERS THEN
         DBMS_OUTPUT.PUT_LINE('[EXCEPCIÓN]');
         DBMS_OUTPUT.PUT_LINE('[Código]: ' || SQLCODE);
         DBMS_OUTPUT.PUT_LINE('[Mensaje]: ' || SQLERRM);
   END;

   BEGIN
      -- 5. Borrar un proveedor y los items asociados a ese proveedor.
      DBMS_OUTPUT.PUT_LINE('======>INICIO PROCEDIMIENTO: BorrarProveedor');
      BorrarProveedor(1); -- Supongamos que el codigoProveedor es 1
      DBMS_OUTPUT.PUT_LINE('======>FIN PROCEDIMIENTO: BorrarProveedor');
      DBMS_OUTPUT.NEW_LINE;
   EXCEPTION
      WHEN OTHERS THEN
         DBMS_OUTPUT.PUT_LINE('[EXCEPCIÓN]');
         DBMS_OUTPUT.PUT_LINE('[Código]: ' || SQLCODE);
         DBMS_OUTPUT.PUT_LINE('[Mensaje]: ' || SQLERRM);
   END;

   BEGIN
      -- 6. Mostrar los items de una línea de venta.
      DBMS_OUTPUT.PUT_LINE('======>INICIO PROCEDIMIENTO: MostrarContenidoVenta');
      MostrarContenidoVenta(v_codigoVenta); -- Supongamos que el codigoVenta es 1
      DBMS_OUTPUT.PUT_LINE('======>FIN PROCEDIMIENTO: MostrarContenidoVenta');
      DBMS_OUTPUT.NEW_LINE;
   EXCEPTION
      WHEN OTHERS THEN
         DBMS_OUTPUT.PUT_LINE('[EXCEPCIÓN]');
         DBMS_OUTPUT.PUT_LINE('[Código]: ' || SQLCODE);
         DBMS_OUTPUT.PUT_LINE('[Mensaje]: ' || SQLERRM);
   END;

EXCEPTION
   WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('[EXCEPCIÓN NO TRATADA EN EL BLOQUE PRINCIPAL]');
      DBMS_OUTPUT.PUT_LINE('[Código]: ' || SQLCODE);
      DBMS_OUTPUT.PUT_LINE('[Mensaje]: ' || SQLERRM);
END;
/

-- ###########################################################
-- 10. Bloque para prueba de Triggers ########################
-- ###########################################################
-- Trigger 1: actualizar_stock_venta
SET SERVEROUTPUT ON
BEGIN
   DBMS_OUTPUT.NEW_LINE;

   DBMS_OUTPUT.PUT_LINE('======>PRUEBA DEL TRIGGER actualizar_stock_venta (ANTES)');
   INSERT INTO LINEA_VENTA (CODIGO_VENTA, COD_ITEM, CANTIDAD) VALUES (1, 'A1', 2);
   DBMS_OUTPUT.PUT_LINE('======>PRUEBA DEL TRIGGER actualizar_stock_venta (DESPU…S)');

EXCEPTION
   WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('[EXCEPCIÓN]');
      DBMS_OUTPUT.PUT_LINE('[Código]: ' || SQLCODE);
      DBMS_OUTPUT.PUT_LINE('[Mensaje]: ' || SUBSTR(SQLERRM, 11, 100));
END;
/

-- Trigger 2: actualizar_supervisor
SET SERVEROUTPUT ON
BEGIN
   DBMS_OUTPUT.NEW_LINE;

   DBMS_OUTPUT.PUT_LINE('======>PRUEBA DEL TRIGGER actualizar_supervisor (ANTES)');
   UPDATE PERSONAL SET CODIGO_EMP = 'B2' WHERE CODIGO_EMP = 'A1';
   DBMS_OUTPUT.PUT_LINE('======>PRUEBA DEL TRIGGER actualizar_supervisor (DESPU…S)');

EXCEPTION
   WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('[EXCEPCIÓN]');
      DBMS_OUTPUT.PUT_LINE('[Código]: ' || SQLCODE);
      DBMS_OUTPUT.PUT_LINE('[Mensaje]: ' || SUBSTR(SQLERRM, 11, 100));
END;
/

-- Trigger 3: aplicar_descuento_cliente_vip
SET SERVEROUTPUT ON
BEGIN
   DBMS_OUTPUT.NEW_LINE;

   DBMS_OUTPUT.PUT_LINE('======>PRUEBA DEL TRIGGER aplicar_descuento_cliente_vip (ANTES)');
   INSERT INTO VENTA (CODIGO_VENTA, DNI, PRECIO_TOTAL) VALUES (2, '12345678X', 1000);
   DBMS_OUTPUT.PUT_LINE('======>PRUEBA DEL TRIGGER aplicar_descuento_cliente_vip (DESPU…S)');

EXCEPTION
   WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('[EXCEPCIÓN]');
      DBMS_OUTPUT.PUT_LINE('[Código]: ' || SQLCODE);
      DBMS_OUTPUT.PUT_LINE('[Mensaje]: ' || SUBSTR(SQLERRM, 11, 100));
END;
/

-- Trigger 4: verificar_stock_before_venta
SET SERVEROUTPUT ON
BEGIN
   DBMS_OUTPUT.NEW_LINE;

   DBMS_OUTPUT.PUT_LINE('======>PRUEBA DEL TRIGGER verificar_stock_before_venta (ANTES)');
   INSERT INTO LINEA_VENTA (CODIGO_VENTA, COD_ITEM, CANTIDAD) VALUES (3, 'A1', 1000);
   DBMS_OUTPUT.PUT_LINE('======>PRUEBA DEL TRIGGER verificar_stock_before_venta (DESPU…S)');

EXCEPTION
   WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('[EXCEPCIÓN]');
      DBMS_OUTPUT.PUT_LINE('[Código]: ' || SQLCODE);
      DBMS_OUTPUT.PUT_LINE('[Mensaje]: ' || SUBSTR(SQLERRM, 11, 100));
END;
/

-- Trigger 5: actualizar_puntos_venta
SET SERVEROUTPUT ON
BEGIN
   DBMS_OUTPUT.NEW_LINE;

   DBMS_OUTPUT.PUT_LINE('======>PRUEBA DEL TRIGGER actualizar_puntos_venta (ANTES)');
   INSERT INTO VENTA (CODIGO_VENTA, DNI, PRECIO_TOTAL) VALUES (4, '12345678X', 500);
   DBMS_OUTPUT.PUT_LINE('======>PRUEBA DEL TRIGGER actualizar_puntos_venta (DESPU…S)');

EXCEPTION
   WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('[EXCEPCIÓN]');
      DBMS_OUTPUT.PUT_LINE('[Código]: ' || SQLCODE);
      DBMS_OUTPUT.PUT_LINE('[Mensaje]: ' || SUBSTR(SQLERRM, 11, 100));
END;
/
