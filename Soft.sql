connect / as sysdba
declare
	n int;
	command VARCHAR2(200);
begin
	command := 'drop user store cascade';
	select count(*) into n
	from DBA_USERS
	where username = 'store';
	if ( n = 1 ) then
		execute immediate command;
	end if;
end;
/

create user store identified by admin;
grant connect, resource to store;
connect store/admin

-- =============================================
-- Eliminar las tablas en caso existan
-- =============================================


-- =============================================
-- Creación de las Tablas
-- =============================================
CREATE TABLE producto (
codigo  char(5) NOT NULL,
nombre  VARCHAR2(50)  NOT NULL,
costo   NUMBER(10,2) NOT NULL,
stock   NUMBER(10,2) NOT NULL
);

CREATE TABLE Promocion (
       IdPromocion          int NOT NULL,
       MontoMin             numeric(10,2) NOT NULL,
       MontoMax             numeric(10,2) NOT NULL,
       Porcentaje           int NOT NULL,
       CONSTRAINT pkPromocion PRIMARY KEY(IdPromocion)
); 


CREATE TABLE Parametro (
       Campo                varchar2(20) NOT NULL,
       Valor                varchar2(20) NOT NULL,
       CONSTRAINT pkParametro PRIMARY KEY(Campo)
); 


CREATE TABLE Categoria (
       IdCategoria          int NOT NULL,
       NomCategoria         varchar2(25) NOT NULL,
       Prefijo              char(3) NOT NULL UNIQUE,
       ConCategoria         int NOT NULL,
       CONSTRAINT pkCategoria PRIMARY KEY(IdCategoria)
); 


CREATE TABLE Articulo (
       IdArticulo           char(8) NOT NULL,
       IdCategoria          int NOT NULL,
       NomArticulo          varchar2(50) NOT NULL,
       PreArticulo          numeric(10,2) NOT NULL,
       CONSTRAINT pkArticulo PRIMARY KEY(IdArticulo),
       CONSTRAINT fkArticuloCategoria
            FOREIGN KEY(IdCategoria)
            REFERENCES Categoria(IdCategoria)
); 


CREATE TABLE Cliente (
       IdCliente            char(6) NOT NULL,
       NomCliente           varchar2(50) NOT NULL,
       RUC                  char(11) NOT NULL,
       DirCliente           varchar2(60) NOT NULL,
       TelCliente           varchar2(20) NULL,
       Clave                varchar2(10) NULL,
       CONSTRAINT pkCliente PRIMARY KEY(IdCliente)
); 


CREATE TABLE Empleado (
       idEmpleado           char(6) NOT NULL,
       ApeEmpleado          varchar2(30) NOT NULL,
       NomEmpleado          varchar2(30) NOT NULL,
       DirEmpleado          varchar2(60) NULL,
       TelEmpleado          varchar2(20) NULL,
       Clave                varchar2(10) NOT NULL,
       CONSTRAINT pkEmpleado PRIMARY KEY(idEmpleado)
); 


CREATE TABLE Documento (
       IdDocumento          int NOT NULL,
       NomDocumento         varchar2(20) NULL,
       Serie                INT NOT NULL,
       ConDocumento         int NOT NULL,
       CONSTRAINT pkDocumento PRIMARY KEY(IdDocumento)
); 

CREATE TABLE Pedido (
       idPedido             int NOT NULL,
       IdDocumento          int NOT NULL,
       IdEmpleado           char(6) NOT NULL,
       NumDocumento         varchar2(15) NOT NULL,
       Fecha                date NOT NULL,
       IdCliente            char(6) NULL,
       NomCliente           varchar2(40) NULL,
       Importe              numeric(10,2) NOT NULL,
       Descuento            numeric(10,2) NOT NULL,
       Subtotal             numeric(10,2) NOT NULL,
       IGV                  numeric(10,2) NOT NULL,
       Total                numeric(10,2) NOT NULL,
        Delivery             int DEFAULT (0),
       Estado               int DEFAULT (0),
       CONSTRAINT pkPedido PRIMARY KEY(idPedido),
       CONSTRAINT fkPedidoDocumento
            FOREIGN KEY(IdDocumento)
            REFERENCES Documento(IdDocumento),
       CONSTRAINT fkPedidoEmpleado
            FOREIGN KEY(IdEmpleado)
            REFERENCES Empleado(IdEmpleado),
       CONSTRAINT fkPedidoCliente
            FOREIGN KEY(IdCliente)
            REFERENCES Cliente(IdCliente)
); 


CREATE TABLE DetallePedido (
       IdPedido             int NOT NULL,
       IdArticulo           char(8) NOT NULL,
       Cantidad             int NOT NULL,
       PreVenta             numeric(10,2) NOT NULL,
       SubTotal             numeric(10,2) NOT NULL,
       CONSTRAINT pkDetallePedido 
            PRIMARY KEY(idPedido,IdArticulo),
       CONSTRAINT fkDetallePedidoPedido
            FOREIGN KEY(IdPedido)
            REFERENCES Pedido(IdPedido),
       CONSTRAINT fkDetallePedidoArticulo
            FOREIGN KEY(IdArticulo)
            REFERENCES Articulo(IdArticulo)
); 

-- =============================================
-- Cargar Datos de Prueba
-- =============================================

--tabla produtcto
Insert Into producto(codigo,nombre,costo,stock)
Values( 'P0001', 'Televisor', 300, 10);
Insert Into producto(codigo,nombre,costo,stock)
Values( 'P0002', 'DVD', 400, 5);

-- Tabla EMPLEADO

Insert Into Empleado Values( 'E00001', 'Paredes Rodriguez', 'Maria', 'Lince', '430-1222', 'java' );
Insert Into Empleado Values( 'E00002', 'Peña Olguín', 'Karol', 'Los Olivos', '456-5999', 'java' );
Insert Into Empleado Values( 'E00003', 'Rojas Rojas', 'Armando', 'Rimac', '459-4326', 'java' );
Insert Into Empleado Values( 'E00004', 'Manrique Tenorio', 'Maria', 'Miraflores', '843-3519', 'java' );
Insert Into Empleado Values( 'E00005', 'Pazos Saavedra', 'Juan', 'Lince', '870-3519', 'java' );
Insert Into Empleado Values( 'E00006', 'Vega Chávez', 'Karla', 'Rimac', 'None', 'java' );


-- Tabla DOCUMENTO

Insert Into Documento( IdDocumento, NomDocumento, Serie, ConDocumento) 
Values( 1, 'Boleta', 1, 31 );
Insert Into Documento( IdDocumento, NomDocumento, Serie, ConDocumento) 
Values( 2, 'Factura', 1, 31 );


-- Carga Datos a la tabla CLIENTE

INSERT INTO Cliente( IdCliente, NomCliente, RUC, DirCliente, TelCliente,Clave )
	VALUES( 'C00001', 'Pedro Ramiraz', '15437648', 'Lince', '472-2388','C00001' );
INSERT INTO Cliente( IdCliente, NomCliente, RUC, DirCliente, TelCliente,Clave )
	VALUES( 'C00002', 'Armando Valencia', '54788932', 'Magdalena', '456-3472','C00002' );
INSERT INTO Cliente( IdCliente, NomCliente, RUC, DirCliente, TelCliente,Clave )
	VALUES( 'C00003', 'Koky Bustamante', '36476284', 'San Martin de Porres', '381-0589','C00003' );
INSERT INTO Cliente( IdCliente, NomCliente, RUC, DirCliente, TelCliente,Clave )
	VALUES( 'C00004', 'Jorge Veramendi', '14667934', 'Callao', '265-5734','C00004' );
INSERT INTO Cliente( IdCliente, NomCliente, RUC, DirCliente, TelCliente,Clave )
	VALUES( 'C00005', 'Donisio Rosas', '14824794', 'Huacho', '512-4744','C00005' );
INSERT INTO Cliente( IdCliente, NomCliente, RUC, DirCliente, TelCliente,Clave )
	VALUES( 'C00006', 'Abraham Oceda', '67458712', 'Los Olivos', '525-6723','C00006' );
INSERT INTO Cliente( IdCliente, NomCliente, RUC, DirCliente, TelCliente,Clave )
	VALUES( 'C00007', 'Jorge Mori', '12349876', 'Lima', '345-1276','C00007' );
INSERT INTO Cliente( IdCliente, NomCliente, RUC, DirCliente, TelCliente,Clave )
	VALUES( 'C00008', 'Jose Apari', '76234562', 'Lima', '768-3782','C00008' );
INSERT INTO Cliente( IdCliente, NomCliente, RUC, DirCliente, TelCliente,Clave )
	VALUES( 'C00009', 'Richard Marcelo', '343-5533', 'Huacho', '456-9865','C00009' );
INSERT INTO Cliente( IdCliente, NomCliente, RUC, DirCliente, TelCliente,Clave )
	VALUES( 'C00010', 'Maria Carrion', '23946154', 'Lima', '223-7482','C00010' );


-- Tabla CATEGORIA

Insert Into Categoria( IdCategoria, NomCategoria, Prefijo, ConCategoria ) Values( 1, 'Bebidas', 'BEB', 4 );
Insert Into Categoria( IdCategoria, NomCategoria, Prefijo, ConCategoria ) Values( 2, 'Carnes', 'CAR', 0 );
Insert Into Categoria( IdCategoria, NomCategoria, Prefijo, ConCategoria ) Values( 3, 'Pollo', 'POL', 0 );
Insert Into Categoria( IdCategoria, NomCategoria, Prefijo, ConCategoria ) Values( 4, 'Postres', 'POS', 0 );
Insert Into Categoria( IdCategoria, NomCategoria, Prefijo, ConCategoria ) Values( 5, 'Combos', 'COM', 5 );


-- Tabla ARTICULO

Insert Into Articulo Values( 'BEB00001', 1, 'Gaseosa (Mediana)', 2.0 );
Insert Into Articulo Values( 'BEB00002', 1, 'Gaseosa ( 1 Litro)', 3.5 );
Insert Into Articulo Values( 'BEB00003', 1, 'Gaseosa (1.5 Litro)', 4.5 );
Insert Into Articulo Values( 'BEB00004', 1, 'Cerveza Cristal (Chica)', 5.0 );
Insert Into Articulo Values( 'COM00001', 5, 'Combo Económico', 7.99 );
Insert Into Articulo Values( 'COM00002', 5, 'Combo Personal', 10.99 );
Insert Into Articulo Values( 'COM00003', 5, 'Combo Especial', 13.99 );
Insert Into Articulo Values( 'COM00004', 5, 'Combo Familiar', 28.99 );
Insert Into Articulo Values( 'COM00005', 5, 'Combo para dos', 16.99 );


-- Tabla PARAMETRO

Insert Into Parametro Values( 'Delivery', '10.0' );
Insert Into Parametro Values( 'IGV', '0.19' );
Insert Into Parametro Values( 'Empleado', '6' );
Insert Into Parametro Values( 'Pedido', '60' );
Insert Into Parametro Values( 'Cliente', '10' );


-- Tabla PROMOCION

Insert Into Promocion(IdPromocion, MontoMin, MontoMax, Porcentaje ) Values( 1,    0.1,    30.0,  0 );
Insert Into Promocion(IdPromocion, MontoMin, MontoMax, Porcentaje ) Values( 2,   30.1,    50.0,  2 );
Insert Into Promocion(IdPromocion, MontoMin, MontoMax, Porcentaje ) Values( 3,   50.1,   100.0,  4 );
Insert Into Promocion(IdPromocion, MontoMin, MontoMax, Porcentaje ) Values( 4,  100.1,   500.0,  6 );
Insert Into Promocion(IdPromocion, MontoMin, MontoMax, Porcentaje ) Values( 5,  500.1,  1000.0,  8 );
Insert Into Promocion(IdPromocion, MontoMin, MontoMax, Porcentaje ) Values( 6, 1000.1, 10000.0, 10 );


-- Tabla PEDIDO
Insert Into Pedido Values( 001,  1, 'E00001', '001-000001', '20080105', NULL,     'Pedro',      50,     0,   50,    9,      59,     0, 0 );
Insert Into Pedido Values( 002,  2, 'E00001', '001-000001', '20080105', 'C00002', NULL,         80,     0,   80,    14.4,   94.4,   0, 0 );
Insert Into Pedido Values( 003,  1, 'E00002', '001-000002', '20080106', NULL,     'Magaly',     100,    0,   100,   18,     118,    0, 0 );
Insert Into Pedido Values( 004,  2, 'E00002', '001-000002', '20080106', 'C00008', NULL,         90,     0,   90,    16.2,   106.2,  0, 0 );
Insert Into Pedido Values( 005,  1, 'E00003', '001-000003', '20080107', NULL,     'Doris',      200,    0,   200,   36,     236,    0, 0 );
Insert Into Pedido Values( 006,  2, 'E00003', '001-000003', '20080107', 'C00004', NULL,         300,    0,   300,   54,     354,    0, 0 );
Insert Into Pedido Values( 007,  1, 'E00004', '001-000004', '20080108', NULL,     'Claudia',    100,    0,   100,   18,     118,    0, 0 );
Insert Into Pedido Values( 008,  2, 'E00004', '001-000004', '20080108', 'C00005', NULL,         90,     0,   90,    16.2,   106.2,  0, 0 );
Insert Into Pedido Values( 009,  1, 'E00005', '001-000005', '20080109', NULL,     'Patricia',   150,    0,   150,   27,     177,    0, 0 );
Insert Into Pedido Values( 010,  2, 'E00005', '001-000005', '20080109', 'C00004', NULL,         90,     0,   90,    16.2,   106.2,  0, 0 );
Insert Into Pedido Values( 011,  1, 'E00006', '001-000006', '20080110', NULL,     'Edgard',     100,    0,   100,   18,     118,    0, 0 );
Insert Into Pedido Values( 012,  2, 'E00006', '001-000006', '20080110', 'C00007', NULL,         166,    0,   166,   29.88,  195.88, 0, 0 );
Insert Into Pedido Values( 013,  1, 'E00001', '001-000007', '20080111', NULL,     'Carlos',     55,     0,   55,    9.9,    64.9,   0, 0 );
Insert Into Pedido Values( 014,  2, 'E00001', '001-000007', '20080111', 'C00008', NULL,         166,    0,   166,   29.88,  195.88, 0, 0 );
Insert Into Pedido Values( 015,  1, 'E00002', '001-000008', '20080112', NULL,     'César',      55,     0,   55,    9.9,    64.9,   0, 0 );
Insert Into Pedido Values( 016,  2, 'E00002', '001-000008', '20080112', 'C00004', NULL,         120,    0,   120,   21.6,   141.6,  0, 0 );
Insert Into Pedido Values( 017,  1, 'E00003', '001-000009', '20080113', NULL,     'Manuel',     144,    0,   144,   25.92,  169.92, 0, 0 );
Insert Into Pedido Values( 018,  2, 'E00003', '001-000009', '20080113', 'C00003', NULL,         120,    0,   120,   21.6,   141.6,  0, 0 );
Insert Into Pedido Values( 019,  1, 'E00004', '001-000010', '20080114', NULL,     'José',       144,    0,   144,   25.92,  169.92, 0, 0 );
Insert Into Pedido Values( 020,  2, 'E00004', '001-000010', '20080114', 'C00005', NULL,         135,    0,   135,   24.3,   159.3,  0, 0 );


-- Febreroo 2008

Insert Into Pedido Values( 021,  1, 'E00001', '001-000011', '20080205', NULL,     'Pedro',      50,     0,   50,    9,      59,     0, 0 );
Insert Into Pedido Values( 022,  2, 'E00001', '001-000011', '20080205', 'C00002', NULL,         80,     0,   80,    14.4,   94.4,   0, 0 );
Insert Into Pedido Values( 023,  1, 'E00002', '001-000012', '20080206', NULL,     'Magaly',     100,    0,   100,   18,     118,    0, 0 );
Insert Into Pedido Values( 024,  2, 'E00002', '001-000012', '20080206', 'C00008', NULL,         90,     0,   90,    16.2,   106.2,  0, 0 );
Insert Into Pedido Values( 025,  1, 'E00003', '001-000013', '20080207', NULL,     'Doris',      200,    0,   200,   36,     236,    0, 0 );
Insert Into Pedido Values( 026,  2, 'E00003', '001-000013', '20080207', 'C00004', NULL,         300,    0,   300,   54,     354,    0, 0 );
Insert Into Pedido Values( 027,  1, 'E00004', '001-000014', '20080208', NULL,     'Claudia',    100,    0,   100,   18,     118,    0, 0 );
Insert Into Pedido Values( 028,  2, 'E00004', '001-000014', '20080208', 'C00005', NULL,         90,     0,   90,    16.2,   106.2,  0, 0 );
Insert Into Pedido Values( 029,  1, 'E00005', '001-000015', '20080209', NULL,     'Martha',     150,    0,   150,   27,     177,    0, 0 );
Insert Into Pedido Values( 030,  2, 'E00005', '001-000015', '20080209', 'C00004', NULL,         90,     0,   90,    16.2,   106.2,  0, 0 );
Insert Into Pedido Values( 031,  1, 'E00006', '001-000016', '20080210', NULL,     'Edgard',     100,    0,   100,   18,     118,    0, 0 );
Insert Into Pedido Values( 032,  2, 'E00006', '001-000016', '20080210', 'C00007', NULL,         166,    0,   166,   29.88,  195.88, 0, 0 );
Insert Into Pedido Values( 033,  1, 'E00001', '001-000017', '20080211', NULL,     'Carlos',     55,     0,   55,    9.9,    64.9,   0, 0 );
Insert Into Pedido Values( 034,  2, 'E00001', '001-000017', '20080211', 'C00008', NULL,         166,    0,   166,   29.88,  195.88, 0, 0 );
Insert Into Pedido Values( 035,  1, 'E00002', '001-000018', '20080212', NULL,     'César',      55,     0,   55,    9.9,    64.9,   0, 0 );
Insert Into Pedido Values( 036,  2, 'E00002', '001-000018', '20080212', 'C00004', NULL,         120,    0,   120,   21.6,   141.6,  0, 0 );
Insert Into Pedido Values( 037,  1, 'E00003', '001-000019', '20080213', NULL,     'Ricardo',    144,    0,   144,   25.92,  169.92, 0, 0 );
Insert Into Pedido Values( 038,  2, 'E00003', '001-000019', '20080213', 'C00003', NULL,         120,    0,   120,   21.6,   141.6,  0, 0 );
Insert Into Pedido Values( 039,  1, 'E00004', '001-000020', '20080214', NULL,     'José',       144,    0,   144,   25.92,  169.92, 0, 0 );
Insert Into Pedido Values( 040,  2, 'E00004', '001-000020', '20080214', 'C00005', NULL,         135,    0,   135,   24.3,   159.3,  0, 0 );


-- Marzo 2008

Insert Into Pedido Values( 041,  1, 'E00001', '001-000021', '20080305', NULL,     'Pero',       50,     0,   50,    9,     59,     0, 0 );
Insert Into Pedido Values( 042,  2, 'E00001', '001-000021', '20080305', 'C00002', NULL,         80,     0,   80,    14.4,  94.4,   0, 0 );
Insert Into Pedido Values( 043,  1, 'E00002', '001-000022', '20080306', NULL,     'Delia',     100,     0,   100,   18,    118,    0, 0 );
Insert Into Pedido Values( 044,  2, 'E00002', '001-000022', '20080306', 'C00008', NULL,         90,     0,   90,    16.2,  106.2,  0, 0 );
Insert Into Pedido Values( 045,  1, 'E00003', '001-000023', '20080307', NULL,     'Doris',      200,    0,   200,   36,    236,    0, 0 );
Insert Into Pedido Values( 046,  2, 'E00003', '001-000023', '20080307', 'C00004', NULL,         300,    0,   300,   54,    354,    0, 0 );
Insert Into Pedido Values( 047,  1, 'E00004', '001-000024', '20080308', NULL,     'Claudia',    100,    0,   100,   18,    118,    0, 0 );
Insert Into Pedido Values( 048,  2, 'E00004', '001-000024', '20080308', 'C00005', NULL,         90,     0,   90,    16.2,  106.2,  0, 0 );
Insert Into Pedido Values( 049,  1, 'E00005', '001-000025', '20080309', NULL,     'Martha',     150,    0,   150,   27,    177,    0, 0 );
Insert Into Pedido Values( 050,  2, 'E00005', '001-000025', '20080309', 'C00004', NULL,         90,     0,   90,    16.2,  106.2,  0, 0 );
Insert Into Pedido Values( 051,  1, 'E00006', '001-000026', '20080310', NULL,     'Edgard',     100,    0,   100,   18,    118,    0, 0 );
Insert Into Pedido Values( 052,  2, 'E00006', '001-000026', '20080310', 'C00007', NULL,         166,    0,   166,   29.88, 195.88, 0, 0 );
Insert Into Pedido Values( 053,  1, 'E00001', '001-000027', '20080311', NULL,     'Carlos',     55,     0,   55,    9.9,   64.9,   0, 0 );
Insert Into Pedido Values( 054,  2, 'E00001', '001-000027', '20080311', 'C00008', NULL,         166,    0,   166,   29.88, 195.88, 0, 0 );
Insert Into Pedido Values( 055,  1, 'E00002', '001-000028', '20080312', NULL,     'César',      55,     0,   55,    9.9,   64.9,   0, 0 );
Insert Into Pedido Values( 056,  2, 'E00002', '001-000028', '20080312', 'C00004', NULL,         120,    0,   120,   21.6,  141.6,  0, 0 );
Insert Into Pedido Values( 057,  1, 'E00003', '001-000029', '20080313', NULL,     'Ricardo',    144,    0,   144,   25.92, 169.92, 0, 0 );
Insert Into Pedido Values( 058,  2, 'E00003', '001-000029', '20080313', 'C00003', NULL,         120,    0,   120,   21.6,  141.6,  0, 0 );
Insert Into Pedido Values( 059,  1, 'E00004', '001-000030', '20080314', NULL,     'José',       144,    0,   144,   25.92, 169.92, 0, 0 );
Insert Into Pedido Values( 060,  2, 'E00004', '001-000030', '20080314', 'C00005', NULL,         135,    0,   135,   24.3,  159.3,  0, 0 );



