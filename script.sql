
-- ------------------------------------------
-- Microsoft SQL Server ---------------------
-- ------------------------------------------

--crea la base datos
create database MedicalCenter;

--llamamos al contexto de la base de datos con la que vamos a trabajar
use MedicalCenter;

--creamos tabla que representa los paises
create table Countries(
	ISO3 char(3) not null,
	Name varchar(50) not null,

	constraint PK_Countries primary key(ISO3)
);

--hacemos una insersion de prueba en la tabla paises
insert into Countries(ISO3, Name) values('SLV', 'El Salvador');
insert into Countries(ISO3, Name) values('GTM', 'Guatemala');
insert into Countries(ISO3, Name) values('HND', 'Honduras');

--verificamos
select ISO3, Name from Countries;

--creamos la tabla de pacientes (desicion personal si dejarla en singular o plural el nombre de la tabla)
create table Patients(
	 Id int not null identity(1,1),
	 Name varchar(50) not null,
	 Lastname varchar(50) not null,
	 BirthDate date not null, --fecha de nacimiento
	 Address varchar(100) not null,
	 ISO3 char(3) not null, --codigo pais formato ISO3 -> SLV: El Salvador
	 Phone varchar(20) null,
	 Email varchar(100) not null,
	 Observations varchar(1000) null,
	 RegistrationDate datetime not null default getdate(),

	 constraint PK_Patients primary key(Id),
	 constraint FK_Patients_Countries foreign key(ISO3) references Countries(ISO3)

 );

 --insertamos un paciente
 insert into Patients(Name, Lastname, BirthDate, Address, ISO3, Phone, Email) 
	values('Leonel', 'Marquez', '1999-03-24', 'San Salvador', 'SLV', '+50368479859', 'leomarqz2020@gmail.com');

--verificamos la insercion
select * from Patients;
 
 
 --creamos la tabla de doctor
 create table Doctors(
	Id int not null identity(1,1),
	Name varchar(50) not null,
	Lastname varchar(50) not null,
	Specialty varchar(100) not null,
	Email varchar(100) not null,
	Phone varchar(20) not null,
	RegistrationDate datetime not null default getdate(),

	constraint PK_Doctors primary key(Id)
 );

 INSERT INTO Doctors (Name, Lastname, Specialty, Email, Phone)
VALUES 
('Ana', 'Ramírez', 'Cardiología', 'ana.ramirez@medcenter.com', '7722-3344'),
('Carlos', 'Gómez', 'Neurología', 'carlos.gomez@medcenter.com', '7555-1122'),
('María', 'López', 'Pediatría', 'maria.lopez@medcenter.com', '7688-9911'),
('Luis', 'Martínez', 'Dermatología', 'luis.martinez@medcenter.com', '7233-5566'),
('Gabriela', 'Castro', 'Ginecología', 'gabriela.castro@medcenter.com', '7890-1122');

--comprobamos que se cargasen los datos
SELECT Id, Name, Lastname, Specialty, Email, Phone, RegistrationDate
FROM Doctors;

 --creamos la tabla de historial medico
 create table MedicalHistory(
	Id int not null identity(1,1),
	Observations varchar(2000) null,

	constraint PK_MedicalHistory primary key(Id)
 );

-- Tabla relacional entre m�dico, paciente e historia m�dica
 create table DoctorPatientHistory(
	MedicalHistoryId int not null,
	PatientId int not null,
	DoctorId int not null,

	--lave compuesta
	constraint PK_DoctorPatientHistoryId primary key(MedicalHistoryId, PatientId, DoctorId),

	--llaves foreaneas - relaciones entre tablas
	constraint FK_MedicalHistory foreign key(MedicalHistoryId) references MedicalHistory(Id),
	constraint FK_DoctorPatientHistory_Patients foreign key(PatientId) references Patients(Id),
	constraint FK_DoctorPatientHistory_Doctors foreign key(DoctorId) references Doctors(Id)

 );

 --creamos la tabla de citas la cual en otra tabla aparte se relacionada con el paciente y el doctor
 create table Appointments (
    Id int not null identity(1,1),
    AppointmentDate datetime not null,
    Status smallint not null, -- Ej: Pendiente = 1, Confirmada = 2, Cancelada = 3, Atendida = 4
    Observations varchar(1000) NULL,
    CreatedAt datetime not null default getdate(),

    constraint PK_Appointments primary key(Id)
);

--aun no se hace el insert
insert into Appointments (AppointmentDate, Status, Observations)
	values ('2025-06-20 09:30', 1, 'Consulta por dolor de cabeza');

--creamos tabla de relacion entre citas, paciente y doctor
create table DoctorPatientAppointments(
	DoctorId int not null,
	PatientId int not null,
	AppointmentId int not null,

	constraint PK_DoctorPatientAppointments primary key(DoctorId, PatientId, AppointmentId),
	constraint FK_PK_DoctorPatientAppointments_Doctors foreign key(DoctorId) references Doctors(Id),
	constraint FK_PK_DoctorPatientAppointments_Patients foreign key(PatientId) references Patients(Id),
	constraint FK_PK_DoctorPatientAppointments_Appointments foreign key(AppointmentId) references Appointments(Id)

);

-- Ver tablas
select name from sys.tables;

-- Ver columnas de DoctorPatientHistory
exec sp_columns DoctorPatientHistory;