/* __________________DROP_____________________ */
DROP TABLE cliente CASCADE CONSTRAINTS;

DROP TABLE telefono CASCADE CONSTRAINTS;

DROP TABLE cliente_vip CASCADE CONSTRAINTS;

DROP TABLE venta CASCADE CONSTRAINTS;

DROP TABLE linea_venta CASCADE CONSTRAINTS;

DROP TABLE personal CASCADE CONSTRAINTS;

DROP TABLE telefono_personal CASCADE CONSTRAINTS;

DROP TABLE farmaceutico CASCADE CONSTRAINTS;

DROP TABLE cajero CASCADE CONSTRAINTS;

DROP TABLE sucursal CASCADE CONSTRAINTS;

DROP TABLE ceo CASCADE CONSTRAINTS;

DROP TABLE telefono_ceo CASCADE CONSTRAINTS;

DROP TABLE item CASCADE CONSTRAINTS;

DROP TABLE producto CASCADE CONSTRAINTS;

DROP TABLE medicamento CASCADE CONSTRAINTS;

DROP TABLE empresa CASCADE CONSTRAINTS;

DROP TABLE telefono_empresa CASCADE CONSTRAINTS;

DROP TABLE laboratorio CASCADE CONSTRAINTS;

DROP TABLE proveedor CASCADE CONSTRAINTS;

DROP VIEW VistaCliente CASCADE CONSTRAINTS;

DROP VIEW VistaItemDetallada CASCADE CONSTRAINTS:

/* __________________TABLAS_____________________ */

CREATE TABLE CLIENTE(
	CDNI		VARCHAR(9) NOT NULL,
	CNAME		VARCHAR(25),
	CDIR		VARCHAR(255),
	CNSS		VARCHAR(12),
		PRIMARY KEY (CDNI)
);

CREATE TABLE TLF_C(
	CDNI		VARCHAR(9) NOT NULL,
	CTLF		INT NOT NULL (CTLF >= 0 AND CTLF <= 999999999),
		PRIMARY KEY (CDNI, CTLF),
		FOREIGN KEY (CDNI) REFERENCES CLIENTE(CDNI)
);

CREATE TABLE CLIENTE_VIP (
    CDNI VARCHAR(9) NOT NULL,
    CODIGO_EMP INT NOT NULL (CODIGO_EMP >= 0 AND CODIGO_EMP <= 999999999),
    DESC INT,
    PRIMARY KEY (CDNI, CODIGO_EMP),
    FOREIGN KEY (CDNI) REFERENCES CLIENTE(DNI),
    FOREIGN KEY (CODIGO_EMP) REFERENCES PERSONAL(CODIGO_EMP)
);

CREATE TABLE VENTA (
    CODIGO_VENTA INT NOT NULL,
    DNI VARCHAR(9) NOT NULL,
    CODIGO_EMP INT NOT NULL,
    PRIMARY KEY (CODIGO_VENTA),
    FOREIGN KEY (DNI) REFERENCES CLIENTE(DNI),
    FOREIGN KEY (CODIGO_EMP) REFERENCES PERSONAL(CODIGO_EMP)
);

CREATE TABLE LINEA_VENTA (
    N_SEC INT NOT NULL,
    CODIGO_VENTA INT NOT NULL,
    COD_ITEM INT NOT NULL,
    CANTIDAD INT NOT NULL,
    PRIMARY KEY (N_SEC, CODIGO_VENTA),
    FOREIGN KEY (CODIGO_VENTA) REFERENCES VENTA(CODIGO_VENTA),
    FOREIGN KEY (COD_ITEM) REFERENCES ITEM(CODIGO_ITEM)
);

CREATE TABLE PERSONAL (
    CODIGO_EMP INT NOT NULL,
    DNI VARCHAR(9) NOT NULL,
    NOMBRE VARCHAR(25) NOT NULL,
    DIR VARCHAR(255) NOT NULL,
    DNI_SUPERVISOR VARCHAR(9) NOT NULL,
    NUM_SUC INT NOT NULL,
    PRIMARY KEY (CODIGO_EMP),
    FOREIGN KEY (DNI_SUPERVISOR) REFERENCES PERSONAL(DNI),
    FOREIGN KEY (NUM_SUC) REFERENCES SUCURSAL(NUM_SUC)
);

CREATE TABLE FARMACEUTICO(
	CODIGO_EMP	INT(9) NOT NULL,
	NUM_COLEGIADO	INT NOT NULL,
		PRIMARY KEY (CODIGO_EMP),
		FOREIGN KEY (CODIGO_EMP) REFERENCES PERSONAL(CODIGO_EMP)
);

CREATE TABLE CAJERO(
	CODIGO_EMP	INT(9) NOT NULL,
	NUM_CAJA	INT NOT NULL,
		PRIMARY KEY (CODIGO_EMP),
		FOREIGN KEY (CODIGO_EMP) REFERENCES PERSONAL(CODIGO_EMP)
);

CREATE TABLE SUCURSAL(
	NUM_SUC		INT NOT NULL,
	DIREC		VARCHAR(255),
		PRIMARY KEY (NUM_SUC),
);

CREATE TABLE CEO(
	DNI		VARCHAR(9) NOT NULL,
	NOMBRE		VARCHAR(25),
		PRIMARY KEY (DNI),
);

CREATE TABLE TLF_CEO (
    DNI VARCHAR(9) NOT NULL,
    TLF INT NOT NULL CHECK (TLF >= 0 AND TLF <= 999999999), -- Restricción de tamaño 9
    PRIMARY KEY (DNI, TLF),
    FOREIGN KEY (DNI) REFERENCES CEO(DNI)
);

CREATE TABLE ITEM(
	CODIGO_ITEM	INT NOT NULL,
	PRECIO		FLOAT NOT NULL,
	NOMBRE		VARCHAR(25) NOT NULL,
	STOCK		INT NOT NULL,
		PRIMARY KEY (CODIGO_ITEM),
);

CREATE TABLE PRODUCTO (
    CODIGO_ITEM INT NOT NULL,
    TIPO_P VARCHAR(50) NOT NULL, 
    PRIMARY KEY (CODIGO_ITEM),
    FOREIGN KEY (CODIGO_ITEM) REFERENCES ITEM (CODIGO_ITEM)
);

CREATE TABLE MEDICAMENTO (
    CODIGO_ITEM INT NOT NULL,
    COD_NAC INT NOT NULL,
    TIPO_M VARCHAR(50) NOT NULL, 
    FECHA_CAD DATE CHECK (FECHA_CAD >= CURRENT_DATE),
    PRIMARY KEY (CODIGO_ITEM),
    FOREIGN KEY (CODIGO_ITEM) REFERENCES ITEM (CODIGO_ITEM)
);

CREATE TABLE EMPRESA (
    ID_EMP INT NOT NULL,
    DIR VARCHAR(255) NOT NULL,
    NOMBRE VARCHAR(25) NOT NULL,
    PRIMARY KEY (ID_EMP)
);

CREATE TABLE TLF_EMP (
    ID_EMP INT NOT NULL,
    TLF INT NOT NULL CHECK (TLF >= 0 AND TLF <= 999999999), -- Restricción de tamaño 9
    PRIMARY KEY (ID_EMP, TLF),
    FOREIGN KEY (ID_EMP) REFERENCES EMPRESA (ID_EMP)
);

CREATE TABLE LABORATORIO(
	CODIGO_EMP	INT NOT NULL,
	CERTI_PRODUC    INT NOT NULL,
		PRIMARY KEY (CODIGO_EMP),
		FOREIGN KEY (CODIGO_EMP) REFERENCES EMPRESA
);

CREATE TABLE PROVEEDOR (
    CODIGO_EMP INT NOT NULL,
    CERTI_PRODUCCION INT NOT NULL,
    PRIMARY KEY (CODIGO_EMP),
    FOREIGN KEY (CODIGO_EMP) REFERENCES EMPRESA
);

/* __________________VISTAS_____________________ */

/*Vista no actualizable-> item-> muestra los productos en stock, no es necesario que se actualice 
ya que entrarán pocos productos nuevos a la farma una vez estabilizado el flujo de personal*/
CREATE VIEW VistaCliente AS
	SELECT
		DNI, NOMBRE, DIR, NSS, TLF
	FROM 
		cliente;

/*Vista actualizable -> cliente -> muestra y añade nuevos clientes, es necesario que se actualice 
ya que cada vez que venga un nuevo cliente este se debe añadir a la base de datos y a veces habrá 
que modificar datos de clientes habituales.*/
CREATE VIEW VistaItemDetallada AS
	SELECT i.COD_ITEM, i.NOMBRE, i.PRECIO, COUNT(lv.COD_ITEM) AS NumeroDeVentas
	FROM Item i
	LEFT JOIN LineaDeVenta lv ON i.CODIGO_ITEM = lv.CODIGO_ITEM
	GROUP BY i.COD_ITEM, i.NOMBRE, i.PRECIO;

/* __________________ÍNDICES_____________________ */
CREATE INDEX idx_cliente_cdni ON CLIENTE(CDNI);

CREATE INDEX idx_tlf_c_cdni_ctlf ON TLF_C(CDNI, CTLF);

CREATE INDEX idx_cliente_vip_cdni_codigo_emp ON CLIENTE_VIP(CDNI, CODIGO_EMP);

CREATE INDEX idx_venta_dni_codigo_emp ON VENTA(DNI, CODIGO_EMP);

CREATE INDEX idx_linea_venta_codigo_venta_cod_item ON LINEA_VENTA(CODIGO_VENTA, COD_ITEM);

/* __________________SEED_____________________ */
/* TABLA - CLIENTE */
INSERT INTO CLIENTE (CDNI, CNAME, CDIR, CNSS) VALUES ('123456789', 'Juan Pérez', 'Calle 123', '123-45-6789');
INSERT INTO CLIENTE (CDNI, CNAME, CDIR, CNSS) VALUES ('987654321', 'María Rodríguez', 'Avenida 456', '987-65-4321');
INSERT INTO CLIENTE (CDNI, CNAME, CDIR, CNSS) VALUES ('111223344', 'Carlos González', 'Carrera 789', '111-22-3344');
INSERT INTO CLIENTE (CDNI, CNAME, CDIR, CNSS) VALUES ('495284723', 'Juana  Míguez', 'Calle del Barro 10', '800-22-3478');
INSERT INTO CLIENTE (CDNI, CNAME, CDIR, CNSS) VALUES ('294853135', 'Juan Lopez', 'Mil Horas 22', '094-14-7328');

/* TABLA - TLF_C  */
INSERT INTO TLF_C (CDNI, CTLF) VALUES ('123456789', 123456789);
INSERT INTO TLF_C (CDNI, CTLF) VALUES ('987654321', 987654321);
INSERT INTO TLF_C (CDNI, CTLF) VALUES ('111223344', 555555555);
INSERT INTO TLF_C (CDNI, CTLF) VALUES ('495284723', 038592947);
INSERT INTO TLF_C (CDNI, CTLF) VALUES ('294853135', 672917483);

/* TABLA - CLIENTE_VIP  */
INSERT INTO CLIENTE_VIP (CDNI, CODIGO_EMP, DESC) VALUES ('123456789', 1, 10);
INSERT INTO CLIENTE_VIP (CDNI, CODIGO_EMP, DESC) VALUES ('987654321', 2, 15);
INSERT INTO CLIENTE_VIP (CDNI, CODIGO_EMP, DESC) VALUES ('111223344', 3, 20);

/* TABLA - VENTA  */
INSERT INTO VENTA (CODIGO_VENTA, DNI, CODIGO_EMP) VALUES (1001, '123456789', 1);
INSERT INTO VENTA (CODIGO_VENTA, DNI, CODIGO_EMP) VALUES (1002, '987654321', 2);
INSERT INTO VENTA (CODIGO_VENTA, DNI, CODIGO_EMP) VALUES (1003, '111223344', 3);

/* TABLA - LINEA_VENTA  */
INSERT INTO LINEA_VENTA (N_SEC, CODIGO_VENTA, COD_ITEM, CANTIDAD) VALUES (1, 1001, 1, 4);
INSERT INTO LINEA_VENTA (N_SEC, CODIGO_VENTA, COD_ITEM, CANTIDAD) VALUES (2, 1001, 2, 1);
INSERT INTO LINEA_VENTA (N_SEC, CODIGO_VENTA, COD_ITEM, CANTIDAD) VALUES (3, 1002, 3, 3);

/* TABLA - PERSONAL  */
INSERT INTO PERSONAL (CODIGO_EMP, DNI, NOMBRE, DIR, DNI_SUPERVISOR, NUM_SUC) VALUES (1, '123456789', 'Juan Perez', 'Calle 123', '987654321', 1);
INSERT INTO PERSONAL (CODIGO_EMP, DNI, NOMBRE, DIR, DNI_SUPERVISOR, NUM_SUC) VALUES (2, '987654321', 'Maria Rodriguez', 'Avenida 456', '111223344', 2);
INSERT INTO PERSONAL (CODIGO_EMP, DNI, NOMBRE, DIR, DNI_SUPERVISOR, NUM_SUC) VALUES (3, '111223344', 'Carlos Gonzalez', 'Carrera 789', '987654321', 1);

/* TABLA - FARMACEUTICO  */
INSERT INTO FARMACEUTICO (CODIGO_EMP, NUM_COLEGIADO) VALUES (1, 12345);
INSERT INTO FARMACEUTICO (CODIGO_EMP, NUM_COLEGIADO) VALUES (2, 67890);
INSERT INTO FARMACEUTICO (CODIGO_EMP, NUM_COLEGIADO) VALUES (3, 54321);

/* TABLA - CAJERO  */
INSERT INTO CAJERO (CODIGO_EMP, NUM_CAJA) VALUES (1, 101);
INSERT INTO CAJERO (CODIGO_EMP, NUM_CAJA) VALUES (2, 102);
INSERT INTO CAJERO (CODIGO_EMP, NUM_CAJA) VALUES (3, 103);

/* TABLA - SUCURSAL  */
INSERT INTO SUCURSAL (NUM_SUC, DIREC) VALUES (1, 'Dirección1');
INSERT INTO SUCURSAL (NUM_SUC, DIREC) VALUES (2, 'Dirección2');
INSERT INTO SUCURSAL (NUM_SUC, DIREC) VALUES (3, 'Dirección3');

/* TABLA - CEO  */
INSERT INTO CEO (DNI, NOMBRE) VALUES ('123456789', 'María Asunción Fernández');
INSERT INTO CEO (DNI, NOMBRE) VALUES ('987654321', 'Raúl González Iglesias');
INSERT INTO CEO (DNI, NOMBRE) VALUES ('111223344', 'Mario Fernández Yáñez');

/* TABLA - TLF_CEO  */
INSERT INTO TLF_CEO (DNI, TLF) VALUES ('123456789', 987654321);
INSERT INTO TLF_CEO (DNI, TLF) VALUES ('987654321', 123456789);
INSERT INTO TLF_CEO (DNI, TLF) VALUES ('111223344', 555555555);

/* TABLA - ITEM  */
INSERT INTO ITEM (CODIGO_ITEM, PRECIO, NOMBRE, STOCK) VALUES (1, 19.99, 'Producto1', 50);
INSERT INTO ITEM (CODIGO_ITEM, PRECIO, NOMBRE, STOCK) VALUES (2, 29.99, 'Producto2', 30);
INSERT INTO ITEM (CODIGO_ITEM, PRECIO, NOMBRE, STOCK) VALUES (3, 9.99, 'Producto3', 75);

/* TABLA - PRODUCTO  */
INSERT INTO PRODUCTO (CODIGO_ITEM, TIPO_P) VALUES (1, 'Crema');
INSERT INTO PRODUCTO (CODIGO_ITEM, TIPO_P) VALUES (2, 'Higiene');
INSERT INTO PRODUCTO (CODIGO_ITEM, TIPO_P) VALUES (3, 'Cosmética');

/* TABLA - MEDICAMENTO  */
INSERT INTO MEDICAMENTO (CODIGO_ITEM, COD_NAC, TIPO_M, FECHA_CAD) VALUES (1, 12345, 'Analgésico', '2023-12-31');
INSERT INTO MEDICAMENTO (CODIGO_ITEM, COD_NAC, TIPO_M, FECHA_CAD) VALUES (2, 67890, 'Antibiótico', '2024-06-30');
INSERT INTO MEDICAMENTO (CODIGO_ITEM, COD_NAC, TIPO_M, FECHA_CAD) VALUES (3, 54321, 'Antiinflamatorio', '2023-09-15');

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
INSERT INTO PROVEEDOR (CODIGO_EMP, CERTI_PRODUCCION) VALUES (4, 024759);
INSERT INTO PROVEEDOR (CODIGO_EMP, CERTI_PRODUCCION) VALUES (5, 284739);
INSERT INTO PROVEEDOR (CODIGO_EMP, CERTI_PRODUCCION) VALUES (6, 343427);
