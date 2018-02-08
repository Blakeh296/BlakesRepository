USE [master]
GO

 IF EXISTS (SELECT * FROM Sys.databases WHERE Name = 'SeminarBusiness_Db') DROP DATABASE SeminarBusiness_Db


		PRINT '[SeminarBusiness_Db] DROPPED'


CREATE DATABASE SeminarBusiness_Db
 GO

		PRINT '[SeminarBusiness_Db] CREATED'


USE SeminarBusiness_Db
GO

--TBL 1 SubscriptionLvl
CREATE TABLE SubscriptionLvl
(		 SubscriptionID INT IDENTITY NOT NULL,
		 PaymentFrequency VARCHAR(30) NOT NULL,
		 Price SMALLMONEY NOT NULL,
		 PRIMARY KEY (SubscriptionID)			)
GO

PRINT'TBL 1 SubscriptionLvl'

--TBL 2 MemberAddress
CREATE TABLE MemberAddress
(		 AddressID INT IDENTITY NOT NULL,
		 MailingMatchBilling VARCHAR(4) NOT NULL,
		 AddressMailing VARCHAR(60) NOT NULL,
		 AddressBilling VARCHAR(60) NULL,
		 City VARCHAR(35),
		 [State] VARCHAR(10) NOT NULL,
		 PostalCode VARCHAR(10) NOT NULL,
		 ModifiedDate DATETIME DEFAULT GETDATE() NOT NULL,
	     PRIMARY KEY (AddressID),
		 CONSTRAINT MailingMatchBilling CHECK  (MailingMatchBilling IN( 'Yes', 'No' ))		)
GO

PRINT 'TBL 2 MemberAddress'

--TBL 3 Members
CREATE TABLE Members
(		 MemberID VARCHAR(15) NOT NULL,
		 FName VARCHAR(20) NOT NULL,
		 MName VARCHAR(20) NULL,
		 LName VARCHAR(20) NOT NULL,
		 Email VARCHAR(50) NULL,
		 SubscriptionID INT NOT NULL,
		 Gender VARCHAR(2) NOT NULL,
		 AddressID INT NOT NULL,
		 Phone VARCHAR(15) NOT NULL,
		 [Current] BIT NOT NULL,
		 Joined DATETIME NOT NULL,
		 BirthDate DATETIME NOT NULL,
		 Interest1 VARCHAR(30) NOT NULL,
		 Interest2 VARCHAR(30) NULL,
		 Interest3 VARCHAR(30) NULL,
		 PRIMARY KEY (MemberID) )
GO

PRINT 'TBL 3 Members'

--TBL 3 Members Foreign key (SubscriptionID)
ALTER TABLE Members ADD CONSTRAINT Fk_SubscriptionID FOREIGN KEY (SubscriptionID)
REFERENCES SubscriptionLvl (SubscriptionID)
GO

--TBL 3 Members Foreign key (AddressID)
ALTER TABLE Members ADD CONSTRAINT Fk_AddressID FOREIGN KEY (AddressID)
REFERENCES MemberAddress (AddressID)
GO

--TBL 4 MemberPayment Info
CREATE TABLE MemberPaymentInfo
( CardID INT IDENTITY NOT NULL,
  MemberID VARCHAR(15) NOT NULL,
  CardType VARCHAR(40) NOT NULL,
  CardNumber BIGINT NOT NULL,
  Expiration DATETIME NOT NULL,
  PRIMARY KEY (CardID))
  GO

  PRINT 'TBL 4 MemberPaymentInfo'

--TBL 4 MemberPaymentInfo Foreign key (MemberID)
ALTER TABLE MemberPaymentInfo ADD CONSTRAINT Fk_PaymentInfo_MemberID FOREIGN KEY (MemberID)
REFERENCES Members (MemberID)
GO

--TBL 5 MemberSubscriptionTransacitons
CREATE TABLE MemberSubscriptionTransactions
( TransactionID INT IDENTITY NOT NULL,
  MemberID VARCHAR(15) NOT NULL,
  Amount SMALLMONEY NOT NULL,
  CardID INT NOT NULL,
  TransactionDate DATETIME NOT NULL DEFAULT GETDATE(),
  Result VARCHAR(12) NOT NULL,
  PRIMARY KEY ( TransactionID ),
  CONSTRAINT Result CHECK (Result IN ('Approved', 'Declined', 'InvalidCard'))        )
  GO

  PRINT 'TBL 5 MemberSubscriptionTransactions'

--TBL 5 Foreign Key (MemberID)
ALTER TABLE MemberSubscriptionTransactions ADD CONSTRAINT Fk_TblMemSubTrans_MemberID FOREIGN KEY (MemberID)
REFERENCES Members (MemberID)
GO

--TBL 5 Foreign Key (CardID)
ALTER TABLE MemberSubscriptionTransactions ADD CONSTRAINT Fk_TblMemSubTrans_CardID FOREIGN KEY (CardID)
REFERENCES MemberPaymentInfo (CardID)
GO

--TBL 6 Events
CREATE TABLE [Events]
( EvntID INT IDENTITY NOT NULL,
  EventName VARCHAR(50) NOT NULL,
  EventDate DATETIME NOT NULL,
  Speaker VARCHAR(30),
  Primary Key (EvntID )       )
GO

PRINT 'TBL 6 Events'

--TBL 7 EventAttendence
CREATE TABLE EventAttendence
( EvntID INT IDENTITY NOT NULL,
  MemberID VARCHAR(15) NOT NULL,
  Attendence BIT NOT NULL,
  MemberNotes VARCHAR(100) NULL,
  PRIMARY KEY (EvntID, MemberID ))
  GO

PRINT 'TBL 7 EventAttendence'

--TBL 7 Foreign Key (EvntID)
ALTER TABLE EventAttendence ADD CONSTRAINT Fk_Evnt_EventID FOREIGN KEY (EvntID)
REFERENCES [Events] (EvntID)
GO

--TBL 7 Foreign Key (MemberID)
ALTER TABLE EventAttendence ADD CONSTRAINT Fk_Evnt_MemberID FOREIGN KEY (MemberID)
REFERENCES Members (MemberID)
GO

CREATE TABLE MemberPasswords (

	  MemberID VARCHAR(15) NOT NULL,
	  [PassWord] VARCHAR(75) NOT NULL,
	  ModifiedDate DATETIME NOT NULL DEFAULT GETDATE(),
	  PRIMARY KEY (MemberID)

)
	PRINT 'TBL 8 MemberPasswords'

--TBL 8 Foreign key (MemberID)
ALTER TABLE MemberPasswords ADD CONSTRAINT Fk_MemberPasswords_MemberID FOREIGN KEY (MemberID)
REFERENCES Members (MemberID)
GO

--Displays Member Passwords with HASHBYTES
CREATE VIEW EmpMemberPasswordView AS
SELECT MemberID, HASHBYTES('MD4', [Password]) AS [Password], ModifiedDate  FROM MemberPasswords
GO

--SELECT * FROM EmpMemberPasswordView

PRINT 'VIEW EmpMemberPasswordView'
GO
--A complete contact list for current members with name, physical mailing address, phone number and e-mail
CREATE VIEW MemberContactlist AS

SELECT M.MemberID, M.FName + ', ' + M.LName  AS [FnameLname], MA.AddressMailing, MA.AddressBilling, MA.MailingMatchBilling, M.Phone, M.Email FROM Members M
INNER JOIN MemberAddress MA
ON M.AddressID = MA.AddressID
GO

PRINT 'VIEW MemberContactList'
GO

--SELECT * FROM MemberContactList


--An e-mail list with the member name and e-mail.
CREATE VIEW MemberEmaillist AS

	SELECT FName + ', ' + LName AS [FnameLame], Email FROM Members

GO

PRINT 'VIEW MemberEmailList'
GO

--SELECT * FROM MemberEmailList


--A list of members who are celebrating their birthday this month
CREATE VIEW MemberBirthday AS
	SELECT FName + ', ' + LName AS [FnameLame], BirthDate FROM Members
	WHERE DATEPART(MONTH, BirthDate) = DATEPART(MONTH, GETDATE())
GO

	PRINT 'VIEW MemberBirthday'
	GO

--SELECT * FROM MemberBirthday

CREATE VIEW ExpiredCards AS
	SELECT * FROM MemberPaymentInfo MPI
	WHERE GETDATE() > Expiration
GO

PRINT 'VIEW ExpiredCards' 
GO

--INPUT Start date through get date to get recent income
CREATE PROC [RecentIncome]
		(
			@DATE DATETIME 
		)
		AS 
		BEGIN
			SELECT * FROM MemberSubscriptionTransactions	
			WHERE TransactionDate BETWEEN @DATE AND GETDATE()
		END
		GO

		PRINT 'PROC [RecentIncome]' 
		GO
	--	EXEC dbo.RecentIncome @DATE = '02-15-2016'

	--INPUT Full date, will count members per month for date parameters set
   CREATE PROC [NewMembersPerMonth]
		(
			@DATE DATETIME 
		)
		AS 
		BEGIN
			SELECT DATEPART(MONTH,Joined) AS [Month], COUNT(MemberID) AS [CountofNewMembers] FROM Members	
			WHERE Joined BETWEEN @DATE AND GETDATE()
			GROUP BY DATEPART(MONTH,Joined)
		END
		GO

		 PRINT 'PROC [NewMembersPerMonth]' 
		 GO

		--EXEC dbo.NewMembersPerMonth @DATE = '10-10-2016'

		--Attendence per event 
		 CREATE PROC AddendencePerEvent
		(
			@DATE DATETIME 
		)
		AS 
		BEGIN
			SELECT * FROM EventAttendence EA
			INNER JOIN [Events] E	
			ON E.EvntID = EA.EvntID 
			WHERE  Attendence <>0 AND E.EventDate BETWEEN @DATE AND GETDATE()
		END
		GO
		PRINT 'PROC AddendencePerEvent' 
		GO
		
		--EXEC dbo.AddendencePerEvent @DATE = '04-12-2017'
		
		
		--PROC Chanrges members, accepts 2 input paramaters but only works 1 member at a time 
		CREATE PROC Sp_SubscriptionRenewal ( @SubscriptionID INT, @MemberID VARCHAR(15) )
		AS
		BEGIN
				
				DECLARE @Amount SMALLMONEY = (SELECT Price FROM SubscriptionLvl WHERE SubscriptionID = @SubscriptionID)
				DECLARE @CardID INT = (SELECT CardID FROM MemberPaymentInfo MPI INNER JOIN Members M
				ON M.MemberID = MPI.MemberID WHERE MPI.MemberID = @MemberID )
				DECLARE @RecentTransaction DATETIME = (SELECT MAX(TransactionDate) FROM MemberSubscriptionTransactions
				WHERE MemberID = @MemberID)

			IF @SubscriptionID = 2 
				BEGIN
					INSERT INTO [dbo].[MemberSubscriptionTransactions] (MemberID, Amount, CardID, TransactionDate, Result) VALUES
					(@MemberID, @Amount, @CardID, DATEADD(YEAR, 1, @RecentTransaction), 'Approved')
				END
			ELSE IF @SubscriptionID = 3
				BEGIN
					INSERT INTO [dbo].[MemberSubscriptionTransactions] (MemberID, Amount, CardID, TransactionDate, Result) VALUES
					(@MemberID, @Amount, @CardID, DATEADD(MONTH, 3, @RecentTransaction), 'Approved')
				END	
			ELSE IF @SubscriptionID = 4
				BEGIN
					INSERT INTO [dbo].[MemberSubscriptionTransactions] (MemberID, Amount, CardID, TransactionDate, Result) VALUES
					(@MemberID, @Amount, @CardID, DATEADD(MONTH, 1, @RecentTransaction), 'Approved')
				END
		END
		
		EXEC Sp_SubscriptionRenewal @subscriptionID = 2 , @MemberID = 'M0006'
		SELECT * FROM Members
		SELECT * FROM MemberSubscriptionTransactions