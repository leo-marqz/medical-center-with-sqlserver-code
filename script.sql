
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
 
 --aun no se han ejecutado los siguientes comandos sql
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

 --creamos la tabla de historial medico
 create table MedicalHistory(
	Id int not null identity(1,1),
	Observations varchar(2000) null,

	constraint PK_MedicalHistory primary key(Id)
 );

-- Tabla relacional entre médico, paciente e historia médica
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

-- Ver tablas
SELECT name FROM sys.tables;

-- Ver columnas de DoctorPatientHistory
EXEC sp_columns DoctorPatientHistory;