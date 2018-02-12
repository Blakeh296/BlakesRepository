USE [master]
GO

 IF EXISTS (SELECT * FROM Sys.databases WHERE Name = 'SeminarBusiness_Db') DROP DATABASE SeminarBusiness_Db


		PRINT '[SeminarBusiness_Db] DROPPED'


CREATE DATABASE SeminarBusiness_Db
 GO

		PRINT '[SeminarBusiness_Db] CREATED'


USE SeminarBusiness_Db
GO

--TBL 1 SubscriptionLvl FREE LEVEL INCLUDED IN INSERTS
CREATE TABLE SubscriptionLvl
(		 SubscriptionID INT IDENTITY NOT NULL,
		 PaymentFrequency VARCHAR(30) NOT NULL,
		 Price SMALLMONEY NOT NULL,
		 PRIMARY KEY (SubscriptionID)			)
GO

PRINT'TBL 1 SubscriptionLvl'

--TBL 2 MemberAddress / / / / / DEFAULT ModifiedDate field, CHECK CONSTRAINT on MailingMatchBilling field
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
		 Interests VARCHAR(100) NOT NULL,
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

--TBL 5 MemberSubscriptionTransacitons / / / / DEFAULT TransactionDate, CHECK CONSTRAINT on Result Column
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

--TBL 8 MemberPasswords Passwords dispaly with HASHBYTES AND CONTAINS MODIFIED DATE to show when the password was changed
CREATE TABLE MemberPasswords (

	  MemberID VARCHAR(15) NOT NULL,
	  [PassWord] NVARCHAR(MAX) NOT NULL,
	  ModifiedDate DATETIME NOT NULL DEFAULT GETDATE(),
	  PRIMARY KEY (MemberID)

)
	PRINT 'TBL 8 MemberPasswords'

--TBL 8 Foreign key (MemberID)
	ALTER TABLE MemberPasswords ADD CONSTRAINT Fk_MemberPasswords_MemberID FOREIGN KEY (MemberID)
	REFERENCES Members (MemberID)
	GO



--A complete contact list for current members with name, physical mailing address, phone number and e-mail
	CREATE VIEW VwMemberContactlist AS

	SELECT M.MemberID, M.FName + ', ' + M.LName  AS [FnameLname], MA.AddressMailing, MA.AddressBilling, MA.MailingMatchBilling, M.Phone, M.Email FROM Members M
	INNER JOIN MemberAddress MA
	ON M.AddressID = MA.AddressID
	GO

	PRINT 'VIEW VwMemberContactList'
	GO
			--SELECT * FROM MemberContactList
-- VIEW Strores passwords in HASHBYTES, and the user will be given access to the view
CREATE VIEW VwMemberPw AS
	SELECT M.MemberID, HASHBYTES('MD4',[PassWord]) AS [Password], ModifiedDate, Email FROM MemberPasswords PW INNER JOIN Members M ON M.MemberID = PW.MemberID

	GO

	PRINT 'VwMemberPw in HASHBYTES'
	GO
	-- SELECT * FROM Vwmemberpw
--An e-mail list with the member name and e-mail.
	CREATE VIEW VwMemberEmaillist AS
		SELECT FName + ', ' + LName AS [FnameLame], Email FROM Members
	GO

	PRINT 'VIEW VwMemberEmailList'
	GO	
			--SELECT * FROM MemberEmailList



--A list of members who are celebrating their birthday this month
	CREATE VIEW VwMemberBirthday AS
		SELECT FName + ', ' + LName AS [FnameLame], BirthDate FROM Members
		WHERE DATEPART(MONTH, BirthDate) = DATEPART(MONTH, GETDATE())
	GO

		PRINT 'VIEW VwMemberBirthday'
		GO
				--SELECT * FROM VwMemberBirthday


		/* The database should identify expired credit cards before it tries to bill to them. */
		--View Expired Credit Cards
	CREATE VIEW VwExpiredCC AS

		SELECT MPI.MemberID, M.LName + ', ' + M.FName AS [LName_FName], CardType, CardNumber, Expiration FROM MemberPaymentInfo MPI
		INNER JOIN Members M
		ON M.MemberID = MPI.MemberID WHERE DATEPART(MONTH,Expiration) < DATEPART(MONTH,GETDATE()) AND DATEPART(YEAR, Expiration) <= DATEPART(YEAR,GETDATE())
		GO
		
		PRINT 'VIEW VwExpiredCC'
		GO	
		
		/* Run this update then run the VwExpiredCC view BELOW
		UPDATE MemberPaymentInfo
		SET Expiration = '01-27-1996'
		WHERE MemberID = 'M0001'*/

	--SELECT * FROM VwExpiredCC



	/* We need to see the company's monthly income from member payments over a given time frame. */
--INPUT Start date through get date to get recent income
	CREATE PROC [RecentIncome]
		(
			@DATE DATETIME 
		)
		AS 
		BEGIN
			SELECT DATEPART(MONTH,TransactionDate) AS [MonthlyIncome], SUM(Amount) AS [Amount]  FROM MemberSubscriptionTransactions	
			WHERE TransactionDate BETWEEN @DATE AND GETDATE()
			GROUP BY DATEPART(MONTH,TransactionDate)
		END
		GO

		PRINT 'PROC [RecentIncome]' 
		GO
				--EXEC dbo.RecentIncome @DATE = '02-15-2016'



	/* INPUT Full date, will count members per month up until today */
	/* New member sign-ups per month over a given time frame */
   CREATE PROC [NewMembersPerMonth]
		(
			@DATE DATETIME 
		)
		AS 
		BEGIN
			SELECT COUNT(MemberID) AS [CountofNewMembers], DATEPART(MONTH,Joined) AS [Month], (SELECT MAX(DATEPART(YEAR, Joined)) FROM Members) AS [Year]
			FROM Members	
			WHERE Joined BETWEEN @DATE AND GETDATE()
			GROUP BY DATEPART(MONTH,Joined)
		END
		GO

		 PRINT 'PROC [NewMembersPerMonth]' 
		 GO
				
				--Executes Proc above
				--EXEC dbo.NewMembersPerMonth @DATE = '10-10-2016'

				

		/* Attendence per event : Displays the Event and which members attended
	Attendance per event over a given time frame. (Number of members at each event.)	*/
CREATE PROC Sp_AddendencePerEvent
(
	@DATE DATETIME 
)
AS 
BEGIN
	SELECT * FROM EventAttendence EA
	INNER JOIN [Events] E	
	ON E.EvntID = EA.EvntID 
	WHERE  Attendence <>0 AND E.EventDate BETWEEN @DATE AND GETDATE()
	ORDER BY EA.EvntID DESC
END
GO
PRINT 'PROC [Sp_AddendencePerEvent]' 
PRINT 'PROC [Sp_SubscriptionRenewal]'
		
GO
		--EXEC dbo.AddendencePerEvent @DATE = '04-12-2017'
		
		
		--PROC Charges members,  only works 1 member at a time 

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
			GO
		
		--EXEC Sp_SubscriptionRenewal @subscriptionID = 2 , @MemberID = 'M0006'
		

	/* Secure storage of member passwords. */ --CURRENTLY DOESNT WORK, Worked when i had the HASHBYTES in a view
	--INPUT Member Password, IF password matches, OUTPUT Member Email associated with password
		CREATE PROC dbo.PasswordVerification (@Password VARCHAR(50))
		AS
			BEGIN
					SELECT Email FROM VwMemberPw 
					WHERE @Password =  [Password]
				
			END

			EXEC dbo.PasswordVerification @Password = 'Password123' /*This Password is correct*/

		PRINT 'PROC Password Check'
	