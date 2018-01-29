USE [master]
GO

 IF EXISTS (SELECT * FROM Sys.databases WHERE Name = 'Veterinary_DB') DROP DATABASE Veterinary_DB


		PRINT '[Veterinary_DB] DROPPED'


CREATE DATABASE [Veterinary_DB]
 GO

		PRINT '[Veterinary_DB] CREATED'
		PRINT ''

USE Veterinary_DB
GO

CREATE TABLE Clients
(		 ClientID INT IDENTITY NOT NULL,
		 FirstName VARCHAR(25) NOT NULL,
		 LastName VARCHAR(25) NOT NULL,
		 MiddleName VARCHAR(25) NULL,
		 CreateDate DATE NOT NULL DEFAULT GETDATE(),
		 PRIMARY KEY (ClientID)			)
GO

CREATE INDEX idx_Clients ON Clients (LastName, FirstName)

PRINT 'Clients Table 1'

CREATE TABLE ClientContacts
(		 AddressID INT IDENTITY NOT NULL,
		 ClientID INT NOT NULL,
		 AddressType INT  NOT NULL,
		 AddressLine1 VARCHAR(50) NOT NULL,
		 AddressLine2 VARCHAR(50) NOT NULL,
		 City VARCHAR(35) NOT NULL,
		 StateProvince VARCHAR(25) NOT NULL,
		 PostalCode VARCHAR(15) NOT NULL,
		 Phone VARCHAR(15) NOT NULL,
		 AltPhone VARCHAR(15) NOT NULL,
		 Email VARCHAR(35) NOT NULL
		 PRIMARY KEY (AddressID),
		 CONSTRAINT CK_AddressType CHECK (AddressType IN (1,2))			)
GO

CREATE INDEX idx_ClientContacts ON ClientContacts (AddressID, Phone, AltPhone)

ALTER TABLE ClientContacts ADD CONSTRAINT FK_ClientID FOREIGN KEY (ClientID)
REFERENCES Clients (ClientID)
GO

PRINT 'ClientContacts 2'

CREATE TABLE  Employees
(		 EmployeeID INT IDENTITY NOT NULL,
		 LastName VARCHAR(25) NOT NULL,
		 FistName VARCHAR(25) NOT NULL,
		 MiddleName VARCHAR(25) NOT NULL,
		 HireDate DATE NOT NULL DEFAULT GETDATE(),
		 Title VARCHAR(50),
		 PRIMARY KEY (EmployeeID)		)
GO
		
CREATE INDEX idx_Employees ON Employees (Title)



PRINT 'Employees Table 3'

CREATE TABLE EmployeeContactInfo
(		 AddressID INT IDENTITY NOT NULL,
		 AddressType INT NOT NULL,
		 AddressLine1 VARCHAR(50) NOT NULL,
		 AddressLine2 VARCHAR(50) NOT NULL,
		 City VARCHAR(35) NOT NULL,
		 StateProvince VARCHAR(25) NOT NULL,
		 PostalCode VARCHAR(15) NOT NULL,
		 Phone VARCHAR(15) NOT NULL,
		 AltPhone VARCHAR(15) NOT NULL,
		 EmployeeID INT NOT NULL,
		 PRIMARY KEY (AddressID),
		 CONSTRAINT Ck_EAddressType CHECK (Addresstype IN (1 , 2))		)
GO

CREATE INDEX idx_EmployeeContactInfo ON EmployeeContactInfo (Phone, EmployeeID)

ALTER TABLE EmployeeContactInfo ADD CONSTRAINT FK_EmployeeContactInfo_EmployeeID FOREIGN KEY (EmployeeID)
REFERENCES Employees (EmployeeID)
GO

PRINT 'EmployeeContactInfo Table 4'



CREATE TABLE Visits
(		 VisitID INT IDENTITY NOT NULL,
		 StartTime DATETIME NOT NULL,
		 EndTime DATETIME NOT NULL,
		 Appointment BIT NOT NULL,
		 DiagnosisCode VARCHAR(12) NOT NULL,
		 ProcedureCode VARCHAR(12) NOT NULL,
		 VisitNotes VARCHAR(2048) NOT NULL,
		 PatientID  BIGINT NOT NULL,
		 EmployeeID INT NOT NULL,
		 PRIMARY KEY (VisitID),
		 CONSTRAINT CK_StartVsEndTime CHECK (EndTime > StartTime)		)
GO

CREATE INDEX idx_Visis ON Visits (VisitID, DiagnosisCode)

PRINT 'Visits Table 5'

CREATE TABLE Billing 
 (		 BillID INT IDENTITY NOT NULL,
		 BillDate DATE NOT NULL,
		 ClientID INT NOT NULL,
		 VisitID INT NOT NULL,
		 Amount DECIMAL NOT NULL,
		 PRIMARY KEY (BillID),
		 CONSTRAINT CK_BillDate CHECK (BillDate <= GETDATE())							)
GO

CREATE NONCLUSTERED INDEX idx_Billing ON Billing (BillID,ClientID,VisitID)

ALTER TABLE Billing ADD CONSTRAINT FK_Billing_ClientID FOREIGN KEY (ClientID)
REFERENCES Clients (ClientID)
GO

ALTER TABLE Billing ADD CONSTRAINT FK_Billing_VistID FOREIGN KEY (VisitID)
REFERENCES Visits (VisitID)
GO

PRINT 'Billing Table 6'



CREATE TABLE Payments
(		 PaymentID INT IDENTITY NOT NULL,
		 PaymentDate DATE NULL,
		 BillID INT NOT NULL,
		 NOTES VARCHAR(2048) NULL,
		 AMOUNT DECIMAL NOT NULL,
		 PRIMARY KEY (PaymentID),
		 CONSTRAINT CK_PaymentDate CHECK (PaymentDate <= GETDATE())		)									
GO

CREATE INDEX idx_Payments ON Payments (PaymentID, BillID)

ALTER TABLE Payments ADD CONSTRAINT FK_BillID FOREIGN KEY (BillID)
REFERENCES Billing (BillID)
GO

PRINT 'Payments Table 7'

CREATE TABLE AnimalTypeReference
(		 AnimalTypeID INT IDENTITY NOT NULL,
		 Species VARCHAR(35) NOT NULL,
		 Breed VARCHAR(35) NOT NULL,
		 PRIMARY KEY (AnimalTypeID)			)

CREATE INDEX idx_AnimalTypeReference ON AnimalTypeReference (Species, Breed)

PRINT 'AnimalTypeReference 8'

CREATE TABLE Patients
(		 PatientID INT IDENTITY NOT NULL,
		 ClientID INT NOT NULL,
		 PatName VARCHAR(35) NOT NULL,
		 AnimalTypeID INT NOT NULL,
		 Color VARCHAR(25) NULL,
		 Gender VARCHAR(2) NOT NULL,
		 BirthYear DATETIME NULL,
		 [Weight] NUMERIC(5,2) NOT NULL,
		 [Description] VARCHAR(MAX) NULL,
		 GeneralNotes VARCHAR(MAX) NOT NULL,
		 Chipped BIT NOT NULL,
		 RabiesVacc DATETIME NULL,
		 PRIMARY KEY (PatientID)			)
GO

CREATE INDEX idx_Patients ON Patients (AnimalTypeID, Gender, [Weight])
 
ALTER TABLE Patients ADD CONSTRAINT FK_Patients_ClientID FOREIGN KEY (ClientID)
REFERENCES Clients (ClientID)
GO

ALTER TABLE Patients ADD CONSTRAINT FK_Patients_AnmimalTypeID FOREIGN KEY (AnimalTypeID)
REFERENCES AnimalTypeReference (AnimalTypeID)
GO

PRINT 'Patients 9'

CREATE LOGIN VetManager
	WITH PASSWORD = 'Bazooka45' 
	
	GO

PRINT ''
PRINT 'Login VetManager'

CREATE LOGIN VetClerk
	WITH PASSWORD = 'BanjoKazoi7'

	GO

PRINT 'Login VetClerk'
GO

CREATE USER VetClerk FOR LOGIN VetClerk;
GO

CREATE USER VetManager FOR LOGIN VetManager;
GO

ALTER ROLE db_DataReader ADD MEMBER VetClerk;
GO

ALTER ROLE db_DataReader ADD MEMBER VetManager;
GO

ALTER ROLE db_datawriter ADD MEMBER VetManager;
GO

DENY ALTER ON OBJECT::
	ClientContacts
		TO VetClerk


DENY SELECT ON OBJECT::
	ClientContacts
		TO VetClerk
DENY UPDATE ON OBJECT::
	ClientContacts
		TO VetClerk
DENY INSERT ON OBJECT::
	ClientContacts
		TO VetClerk
DENY DELETE ON OBJECT::
	ClientContacts
		TO VetClerk
DENY ALTER ON OBJECT::
	EmployeeContactInfo
		TO VetClerk
DENY SELECT ON OBJECT::
	EmployeeContactInfo
		TO VetClerk


DENY UPDATE ON OBJECT::
	EmployeeContactInfo
		TO VetClerk
DENY INSERT ON OBJECT::
	EmployeeContactInfo
		TO VetClerk
DENY DELETE ON OBJECT::
	EmployeeContactInfo
		TO VetClerk
	




INSERT INTO Clients ( FirstName, LastName, MiddleName)
VALUES ('Bill', 'Murrey', NULL), ('Fred', 'Flinstone', NULL),
('Tom', 'Cat', NULL), ('Jerry', 'Mouse', NULL),
('Jimmy', 'Fallon', NULL)

INSERT INTO ClientContacts 
(ClientID, [AddressType], [AddressLine1], [AddressLine2], [City], [StateProvince], [PostalCode], [Phone], [AltPhone], [Email]) VALUES
(1, 1 , 'Bravo Lane', 'PO 55159', 'ChadsVille', 'KK', '59456', '666-523-569', '000-000-0000', 'Thisguysemail@gmail.com'),
(2, 1 , 'Red Road', '3254', 'TinkerTown', 'TC', '89542', '854-354-456', '123-456-7890', 'AnotherEmail@Yahoo.com'),
(3, 2 , 'Salty Springs St', 'PO 22', 'Brown Town', 'FJ', '44589', '352-968-1234', '123-987-4567', 'ThirdEmail@Aol.com'),
(4, 2, 'Haunted Drive', '6698', 'Haunted Hills', 'NW', '85214', '852-963-7412', '589-654-1234', 'ScaryGhost@Hotmail.com'),
(5, 1, 'Pleseant Road', '89654', 'Plesant Park', 'HD', '58954', '417-582-9852', '698-784-6698', 'MrMr@OutLook.com')

INSERT INTO AnimalTypeReference (Species, Breed)
VALUES ('Dog', 'GermanSheperd'), ('Cat', 'Persain'),('Horse', 'Mustang'), ('Chicken', 'LegHorn'), ('Pig', 'Duroc'), ('Bird', 'Caique')

INSERT INTO Patients ( ClientID , PatName, AnimalTypeID, Color, Gender, BirthYear, [Weight], [Description], GeneralNotes, Chipped, RabiesVacc) VALUES
( 1, 'Snickers', 1, 'Yellow', 'M', '01-16-2016', '85.50', NULL, 'Nothing', 1, '02-15-2017'),
(2, 'Bently', 1, 'White', 'M', '02-01-2017', '8.00', 'Small', 'Fluffy', 1, '06-04-2017'),
(3, 'Shadow', 1, 'Black', 'M',' 01-01-2005', '90.00', NULL, 'Black Lab', 1, '04-04-2005'),
(4, 'Clifferd', 6, 'Multi', 'F', '12-01-2014', '1.00', NULL, 'Red Yellow Blue Caique Bird', 0, NULL),
(5, 'Barney', 3, 'Brown', 'M', '06-15-2010', '850.50', NULL, 'Brown and Golden brown horse', 0, NULL),
(1, 'Pepper', 2, 'Multi', 'F', '08-05-2002', '4.00', NULL, 'Black Brown Gold', 0, NULL),
(2, 'Taffy', 1, 'White', 'F', '01-01-2005', '45.00', NULL, 'Nothing', 0, NULL)

INSERT INTO Employees ( LastName, FistName, MiddleName, HireDate, Title ) VALUES 
( 'Hoelle', 'Blake', 'Q', '02-27-1996', 'Vetenarian'),
('Cardenes', 'Alex', 'R', '12-12-2016', 'Vetenarian'),
('Phillip', 'Rex', 'C', '11-15-2016', 'Nurse'),
('Clayton', 'Taylor', 'D', '05-06-2017', 'Assosiate'),
('Jorden', 'Taylor', 'F', '01-01-2018', 'Janitor'),
('Ben', 'Gains', 'I', '10-20-2017', 'Owner'),
('Chris', 'Griffen', 'E', '06-15-2017', 'Overnight')

INSERT INTO EmployeeContactInfo (AddressType, AddressLine1, AddressLine2, City, StateProvince, PostalCode, Phone, AltPhone, EmployeeID) VALUES
('1', '225 Fake address', 'PO 122', 'Charllete', 'FL' , '34491', '352-654-55555', '352-666-9999', '1'),
('1', '3654 Road Road', 'PO 352', 'Jacksonville', 'FL', '65478', '654-987-9632', '258-987-7412', '2'),
('2', '123 Forest Hills', 'Drive', 'Tampa', 'FL', '36987', '352-654-3698', '352-698-7456', '3'),
('2', '658 Sample Address', 'Nothing', 'Ocala', 'FL', '34491', '365-987-8523', '352-951-7536', '4'),
('1', '15 red Road', 'PO 155', 'GainsVille', 'FL', '36541', '352-654-8523', '352-147-3698', '5'),
('1', '655 Rally Ct', '3564', 'Mount Dora', 'FL', '56987', '352-697-8317', '352-624-7568', '6'),
('2', '7195 SE 136th Ct', 'Nothing', 'Summerfield', 'FL', '34491', '352-621-6874', '352-123-47896', '7')

INSERT INTO Visits (StartTime, EndTime, Appointment, DiagnosisCode, ProcedureCode, VisitNotes, PatientID, EmployeeID) VALUES
('01-01-2016', '01-02-2016', 1, 'VK254', 'VV254' ,'Nothing' , 1, 1)

INSERT INTO Billing (BillDate, ClientID, VisitID, Amount) VALUES ('01-05-2016', 1, 1, '50.00')

INSERT INTO Payments (PaymentDate, BillID,  AMOUNT) VALUES ('01-06-2016', 1, '25.00')
GO



/* Write stored procedures to return the following results and grant the VetClerk user EXECUTE permissions on them.

- All patients of a specific species return client name and contact information and patient name. */

CREATE PROC [Sp_SpeciesToClientInformation] 
 (
		 @Species VARCHAR(MAX)
 )
AS

	BEGIN
		SELECT  P.PatName, CONCAT(C.LastName + ', ' + C.FirstName, '') AS [LnameFname],
		CC.Phone, CC.AltPhone, CC.AddressLine1 FROM Patients P
		INNER JOIN  Clients C
		ON P.ClientID = C.ClientID
		INNER JOIN  ClientContacts CC
		ON C.ClientID = CC.ClientID
		INNER JOIN AnimalTypeReference ATR
		ON ATR.AnimalTypeID = P.AnimalTypeID
		WHERE ATR.Species = @Species
	END
GO




--EXEC Sp_PetToClientInformation   @Species = 'Bird'

/*
- All patients of a specific breed return client name and contact information and patient name. */

CREATE PROC [Sp_BreedtoPatientContactInfo] 
 (
		 @Breed VARCHAR(50)
 )
AS

	BEGIN
		SELECT P.PatName, CONCAT(C.LastName + ', ' + C.FirstName, + ' ') AS [Contact_LnameFname],
		CC.Phone, CC.AltPhone, CC.AddressLine1 FROM AnimalTypeReference ATR
		INNER JOIN	Patients P
		ON ATR.AnimalTypeID = P.AnimalTypeID
		INNER JOIN Clients C
		ON P.ClientID = C.ClientID
		INNER JOIN ClientContacts CC
		ON C.ClientID = CC.ClientID
		WHERE ATR.Breed = @Breed
	END

GO

--EXEC Sp_BreedtoPatientContactInfo @Breed = 'Caique'

/*
- All billing and payment information for a client by ClientID. Return BillDate or PaymentDate, Date of visit from VisitDate and amount.
 */

CREATE PROC [Sp_ClientIDtoVisitDateAmount] 
 (
		 @ClientID int
 )
AS

	BEGIN
		SELECT P.PaymentDate, B.Amount, V.StartTime [VisitDay] FROM Clients C
		INNER JOIN  Billing B
		ON C.ClientID = B.ClientID
		INNER JOIN Payments P
		ON P.BillID = B.BillID
		INNER JOIN Visits V
		ON V.VisitID = B.VisitID
		WHERE C.ClientID = @ClientID
	END

GO

--EXEC Sp_ClientIDtoVisitDateAmount @ClientID =  1

--- A mailing list for all employees with primary phone number.

CREATE PROC [Sp_EmployeeContact] 
 
AS

	BEGIN
		SELECT E.LastName + ', ' + E.FistName AS [LnameFname],  E.Title, EC.AddressLine1, EC.PostalCode ,EC.City, EC.StateProvince, EC.Phone
		FROM EmployeeContactInfo EC
		INNER JOIN Employees E
		ON EC.EmployeeID = E.EmployeeID
		
	END

GO

--EXEC [Sp_EmployeeContact]

GRANT EXECUTE ON OBJECT::
	[dbo].[Sp_BreedtoPatientContactInfo]
		TO VetClerk
GRANT EXECUTE ON OBJECT::
	[dbo].[Sp_SpeciesToClientInformation]
		TO VetClerk
GRANT EXECUTE ON OBJECT::
	[dbo].[Sp_ClientIDtoVisitDateAmount]
		TO VetClerk
GRANT EXECUTE ON OBJECT::
	[dbo].[Sp_EmployeeContact]
		TO VetClerk
GO


 
/*Write stored procedures to perform the following tasks:

- Accept all required information for a new Client, including contact information, insert the new client and return the new ClientID as an output variable. (Remember SCOPE_IDENTITY()).
*/
CREATE PROC [Sp_NewClient] (
			
			@FirstName VARCHAR(25),
			@LastName VARCHAR(25),
			@AddressType INT,
			@AddressLine1 VARCHAR(50),
			@AddressLine2 VARCHAR(50),
			@City VARCHAR(35),
			@StateProvince VARCHAR(25),
			@PostalCode VARCHAR(15),
			@Phone VARCHAR(15),
			@AltPhone VARCHAR(15),
			@Email VARCHAR(35)


) 
AS
	
	

	BEGIN
		INSERT INTO Clients (FirstName, LastName) VALUES
		(@FirstName, @LastName)
		
		DECLARE @SCOPE_IDENTITY INT = (SELECT SCOPE_IDENTITY())

		INSERT INTO ClientContacts (ClientID, AddressType, AddressLine1, AddressLine2, City, [StateProvince], PostalCode, Phone, AltPhone, Email)
		VALUES(@SCOPE_IDENTITY, @AddressType, @AddressLine1, @AddressLine2, @City, @StateProvince, @PostalCode, @Phone, @AltPhone, @Email )

		PRINT @SCOPE_IDENTITY
	END

GO

--EXECUTE [dbo].[Sp_NewClient] @FirstName = 'Bill' , @LastName = 'Clintion', @AddressType = '1', @AddressLine1 = '123 Test', @AddressLine2 = 'Testing',
--@City = 'Italy', @StateProvince = 'France', @PostalCode = '32159', @Phone = '123456789', @AltPhone = '987654321', @Email = 'TestEmail@Email.com'


/*- Accept all required information for a new Employee, including contact information, insert the new Employee and return the new EmployeeID as an output variable.
*/
CREATE PROC [Sp_NewEmployee] (
			
			@FirstName VARCHAR(25),
			@LastName VARCHAR(25),
			@MiddleName VARCHAR(25),
			@Title VARCHAR(50),
			@AddressType INT,
			@AddressLine1 VARCHAR(50),
			@AddressLine2 VARCHAR(50),
			@City VARCHAR(35),
			@StateProvince VARCHAR(25),
			@PostalCode VARCHAR(15),
			@Phone VARCHAR(15),
			@AltPhone VARCHAR(15)
			

) 
AS
	BEGIN
		INSERT INTO [dbo].[Employees] (LastName, FistName, MiddleName, Title) VALUES
		(@FirstName, @LastName, @MiddleName, @Title)
		
		DECLARE @SCOPE_IDENTITY INT = (SELECT SCOPE_IDENTITY())

		INSERT INTO EmployeeContactInfo ( AddressType, AddressLine1, AddressLine2, City, [StateProvince], PostalCode, Phone, AltPhone, EmployeeID)
		VALUES( @AddressType, @AddressLine1, @AddressLine2, @City, @StateProvince, @PostalCode, @Phone, @AltPhone, @SCOPE_IDENTITY)

		PRINT @SCOPE_IDENTITY
	END

GO

/*
EXECUTE [dbo].[Sp_NewEmployee] @FirstName = 'Bob' ,@MiddleName = 'Q', @LastName = 'Saggot', @AddressType = '1', @AddressLine1 = '123 Test', @AddressLine2 = 'Testing',
@City = 'Italy', @StateProvince = 'France', @PostalCode = '32159', @Phone = '123456789', @AltPhone = '987654321', @Title = 'Boss' */


--SELECT * FROM Patients

--SELECT * FROM ClientContacts


--SELECT * FROM AnimalTypeReference


















