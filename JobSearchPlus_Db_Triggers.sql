--START BY TESTING LEADS DELETE TRIGGER
USE [master]
GO
		PRINT ''
BEGIN
	DROP DATABASE JobSearchPlus
END

		PRINT 'JobSearchPlus DROPPED'

CREATE DATABASE [JobSearchPlus]
 GO

		PRINT 'JobSearchPlus CREATED'

		PRINT ''

USE JobSearchPlus

GO

/****** Object:  [SOURCES]    DATABASE TABLE : ********** *:**:** PM ******DTPLAPTOP09*/
CREATE TABLE Sources (

			 SourceID bigint IDENTITY NOT NULL,
			 SourceName VARCHAR(75) NOT NULL,
			 SourceType VARCHAR(35) NULL,
			 SourceLink VARCHAR(255) NULL,
			 [Description] VARCHAR(255)
			 PRIMARY KEY (SourceID)
			 )

			 PRINT '1 Sources'
			 GO

CREATE INDEX idx_SourceID on Sources (SourceID)


CREATE INDEX idx_SourceName on Sources (SourceName)


CREATE INDEX idx_SourceType on Sources (SourceType)


/****** Object:  [BUSINESS TYPES]    DATABASE TABLE : ******** *:**:** PM ******DTPLAPTOP09*/
CREATE TABLE BusinessTypes (

			 BusinessType VARCHAR(50) NOT NULL,
			 PRIMARY KEY (BusinessType)
			 
			 )

			 PRINT '2 BusinessTypes'
			 GO

CREATE INDEX idx_BusinessType on BusinessTypes (BusinessType)

PRINT ''

/****** Object:  [COMPANIES]    DATABASE TABLE : ******** *:**:** PM ******DTPLAPTOP09*/
CREATE TABLE Companies (

			 CompanyID int Identity NOT NULL,
			 CompanyName VARCHAR(75) NOT NULL,
			 Address1 VARCHAR(75) NULL,
			 Address2 VARCHAR(75) NULL,
			 City VARCHAR(50) NULL,
			 [State] VARCHAR(2) NULL,
			 Zip VARCHAR(10) NULL,
			 Phone VARCHAR(14) NULL,
			 Fax VARCHAR(14) NULL,
			 Email VARCHAR(50) NULL,
			 Website VARCHAR(50) NULL,
			 [Description] VARCHAR(255) NULL,
			 BusinessType VARCHAR(50) NULL,
			 Agency BIT DEFAULT (0) NULL ,
			 PRIMARY KEY (CompanyID)
			 
			 )

			 PRINT '3 Companies' 

CREATE INDEX idx_CompanyID on Companies (CompanyID)


CREATE INDEX idx_CompanyName on Companies (CompanyName)


CREATE INDEX idx_PostalCode on Companies (Zip)


CREATE INDEX idx_City on Companies (City)


CREATE INDEX idx_State on Companies ([State])
GO

/****** Object:  [CONTACTS]    DATABASE TABLE : ******** *:**:** PM ******DTPLAPTOP09*/

CREATE TABLE Contacts (

			 ContactID INT IDENTITY NOT NULL,
			 CompanyID INT NULL,
			 CourtesyTitle VARCHAR(25) NULL,
			 ContactFirstName VARCHAR(50) NULL,
			 ContactLastName VARCHAR(50) NULL,
			 Title VARCHAR(50) NULL,
			 Phone VARCHAR(14) NULL,
			 Extension VARCHAR(10) NULL,
			 Fax VARCHAR(14) NULL,
			 Email VARCHAR(50) NULL,
			 Comments VARCHAR(255) NULL,
			 Active BIT DEFAULT(1) NULL
			 PRIMARY KEY (ContactID)

			 )

			 PRINT '4 Contacts'



CREATE INDEX idx_ContactID on Contacts (ContactID)
			

CREATE INDEX idx_CompanyID on Contacts (CompanyID)


CREATE INDEX idx_ContactLastName on Contacts (ContactLastName)


CREATE INDEX idx_Title on Contacts (Title) 
GO


/****** Object:  [LEADS]    DATABASE TABLE : ********** *:**:** PM ******DTPLAPTOP09*/

--INSERT INTO Leads (JobTitle, [Description], EmploymentType, Location, Active VALUES ('HTML Expert')

CREATE TABLE Leads (

			 LeadID int identity NOT NULL,
			 RecordDate DATETIME DEFAULT GETDATE() NOT NULL,
			 JobTitle VARCHAR (75) NOT NULL,
			 [Description] VARCHAR (255) NULL,
			 EmploymentType VARCHAR(25) NULL,
			 Location VARCHAR(50) NULL,
			 Active BIT DEFAULT(1) NULL,
			 CompanyID INT NULL,
			 AgencyID INT NULL,
			 ContactID INT NULL,
			 SourceID BIGINT NULL,
			 Selected BIT DEFAULT(0) NULL,
			 ModifiedDate DATETIME NULL,
			 PRIMARY KEY (LeadID),
			 CONSTRAINT CK_EmploymentType CHECK (EmploymentType IN ('Full-Time' , 'Part-Time' , 'Salary')) 
			
			 )

			 PRINT '5 Leads'
			 GO
	    
/****** Object:  [ACTIVITES]    DATABASE TABLE : ********** *:**:** PM ******DTPLAPTOP09*/

CREATE TABLE Activities (

			 ActivityID int identity NOT NULL,
			 LeadID int NOT NULL,
			 ActivityDate DATETIME NOT NULL,
			 ActivityType VARCHAR(25) NOT NULL,
			 ActivityDetails VARCHAR(255) NULL,
			 Complete BIT DEFAULT(0) NULL,
			 ReferenceLink VARCHAR(255) NULL,
			 ModifiedDate DATETIME NOT NULL,
			 PRIMARY KEY (ActivityID)
 ) ;

			 PRINT '6 Activites'
			 GO

 CREATE INDEX idx_ActivityID on Activities (ActivityID) ;

				
 CREATE INDEX idx_LeadID on Activities (LeadID) ;
		

 CREATE INDEX idx_ActivityDate on Activities (ActivityDate) ;


 CREATE INDEX idx_ActivityType on Activities (ActivityType) ;
 		

CREATE INDEX idx_LeadID on Leads (LeadID)


CREATE INDEX idx_RecordDate on Leads (RecordDate)


CREATE INDEX idx_EmploymentType on Leads (EmploymentType)


CREATE INDEX idx_Location on Leads (Location)


CREATE INDEX idx_CompanyID on Leads (CompanyID)


CREATE INDEX idx_AgencyID on Leads (AgencyID)


CREATE INDEX idx_SourceID on Leads (SourceID)


CREATE INDEX idx_ContactID on Leads (ContactID) ;
GO

--TRIGGERS

CREATE TRIGGER TGGR_CompanyID_ContactID_SourceIDtoLeads
ON				Leads
AFTER			INSERT, UPDATE
AS
BEGIN
		IF EXISTS(SELECT CompanyID FROM inserted
					GROUP BY CompanyID HAVING CompanyID NOT IN (SELECT CompanyID FROM Companies
																				 GROUP BY CompanyID))
		BEGIN
				RAISERROR ('***********TGGR_CompanyIDtoLeads BLOCKING because CompanyID not in database********', 16, 1)
				ROLLBACK TRANSACTION
END
	END
		IF EXISTS(SELECT ContactID FROM inserted
				  GROUP BY ContactID HAVING ContactID NOT IN(SELECT ContactID FROM Contacts 
																			  GROUP BY ContactID))
		BEGIN
				RAISERROR ('**********TGGR_ContactID_toLeads BLOCKING because ContactID not in database**********', 16, 1)
				ROLLBACK TRANSACTION
END
		IF EXISTS(SELECT SourceID FROM inserted
				  GROUP BY SourceID HAVING SourceID NOT IN(SELECT SourceID FROM Sources
																		   GROUP BY SourceID))
		BEGIN
				RAISERROR ('*******TGGR_SourceID_toLeads BLOCKING because SourceID not in Database**********', 16, 1)
				ROLLBACK TRANSACTION
END
GO

--IF a business type is inserted into companies and it doesn't match in BusinessTypes then ROLLBACK TRANSACTION and RAISERROR
  CREATE TRIGGER TGGR_BusinessTypeINCompanies
			 ON				Companies
			 AFTER			INSERT, UPDATE
			 AS
				BEGIN
						IF  EXISTS(SELECT BusinessType FROM inserted
								   GROUP BY BusinessType HAVING BusinessType NOT IN (SELECT BusinessType FROM BusinessTypes
																					 GROUP BY BusinessType))
						BEGIN	
								RAISERROR ('*********TGGR_BusinessTypeINCompanies BLOCKING because Businesstype not in database**********', 16, 1)
								ROLLBACK TRANSACTION
				END
					END 
					GO

--IF CompanyID inserted into TABLE Contacts doesn't match a companyID in Companies, ROLLBACK TRANSACTION, RAISERROR
CREATE TRIGGER TGGR_CompanyIDinContacts
			 ON				Contacts
			 AFTER			INSERT, UPDATE
			 AS
				BEGIN
						IF  EXISTS(SELECT CompanyID FROM inserted
								   GROUP BY CompanyID HAVING CompanyID NOT IN (SELECT CompanyID FROM Companies
																					 GROUP BY CompanyID))
								
						BEGIN
								RAISERROR ('*********TGGR_CompanyIDtoContacts BLOCKING because CompanyID not in database**********', 16, 1)
								ROLLBACK TRANSACTION
				
				END
					END 
					GO


CREATE TRIGGER TGGR_LeadIDtoActivities
ON			   Activities
AFTER INSERT, UPDATE
AS
	BEGIN
		IF EXISTS(SELECT LeadID FROM inserted
				  GROUP BY LeadID HAVING LeadID NOT IN(SELECT LeadID FROM Leads
													   GROUP BY LeadID))
		BEGIN
				  RAISERROR ('*******TGGR_LeadIDtoActivities BLOCKING because LeadID NOT IN Leads*********', 16, 1)
	END
		END
	GO



CREATE TRIGGER  Trggr_Activities_ModifiedDate
ON				Activities
AFTER  INSERT , UPDATE
AS
	BEGIN
		UPDATE Activities
		SET ModifiedDate = GETDATE()
		PRINT 'Modified Date Changed by Activities_ModifiedDate TRIGGER'  
	END
GO	

CREATE TRIGGER  Trggr_Leads_ModifiedDate
ON				Leads
AFTER  INSERT , UPDATE
AS
	BEGIN
		UPDATE Leads
		SET ModifiedDate = GETDATE()
		PRINT 'Modified Date Changed by Leads_ModifiedDate TRIGGER' 
	END
GO

 CREATE TRIGGER TGGR_DeleteBusinessType 
ON			    BusinessTypes
AFTER	        DELETE
AS
	BEGIN
			   IF EXISTS(SELECT BusinessType FROM deleted
			   GROUP BY BusinessType HAVING BusinessType IN(SELECT C.BusinessType FROM Companies C GROUP BY C.BusinessType))

			   BEGIN
						RAISERROR ('*****TGGR_DeleteBusinessType BLOCKING because BusinessType IN Companies Table*****', 16, 1)
						ROLLBACK TRANSACTION
	END
		END
	GO 

--IF Lead ID exists in leads, you can'not delete an activity
CREATE TRIGGER TGGR_DeleteLeadID
ON			   Activities
AFTER		   DELETE
AS
	BEGIN
			IF EXISTS(SELECT LeadID FROM deleted
			GROUP BY LeadID HAVING LeadID IN(SELECT A.Leadid FROM Leads A GROUP BY A.LeadID))

			BEGIN
					RAISERROR ('*****LeadID Can not be deleted because it EXISTS in the Leads Table*****', 16, 1)
					ROLLBACK TRANSACTION
	END
		END
			
	GO

--When deleting a source, if SourceID EXISTS in Leads it will not delete
CREATE TRIGGER TGGR_DeleteSourceID
ON			   Sources
AFTER		   DELETE
AS
	BEGIN
			   IF EXISTS(SELECT SourceID FROM deleted
			   GROUP BY SourceID HAVING SourceID IN(SELECT L.SourceID FROM Leads L GROUP BY L.SourceID))

			   BEGIN
						RAISERROR ('CAN NOT DELETE SourceID! EXISTS in [TABLE] "Leads"', 16, 1)
						ROLLBACK TRANSACTION
	END
	END
	GO

--IF a company ID EXISTS in a lead, then it wont delete
CREATE TRIGGER TGGR_DeleteCompanyIDfromLeads
ON			   Companies
AFTER		   DELETE
AS
	BEGIN
			   IF EXISTS(SELECT CompanyID FROM deleted
			   GROUP BY CompanyID HAVING CompanyID IN(SELECT L.CompanyID FROM Leads L GROUP BY L.CompanyID))
	
			   BEGIN
						RAISERROR ('CAN NOT DELETE CompanyID! EXISTS in [TABLE] "Leads"', 16, 1)
						ROLLBACK TRANSACTION
	END
	END
			
	GO




-- IF ContactID in Leads, Must Delete the lead first. Can not delete a companyID record from 
CREATE TRIGGER TGGR_DeleteContactIDfromLeads
ON			   Contacts
AFTER		   DELETE
AS
	BEGIN
			   IF EXISTS(SELECT ContactID FROM deleted
			   GROUP BY ContactID HAVING ContactID IN(SELECT L.ContactID FROM Leads L GROUP BY L.ContactID))

	BEGIN

						RAISERROR ('CAN NOT DELETE ContactID! EXISTS in [TABLE] "Leads"', 16, 1)
						ROLLBACK TRANSACTION
	END
	END

				IF EXISTS(SELECT CompanyID FROM deleted
				GROUP BY CompanyID HAVING CompanyID IN(SELECT C.CompanyID FROM Companies C GROUP BY C.CompanyID))

	BEGIN
						RAISERROR ('CAN NOT DELETE CompanyID! EXISTS in [TABLE] "Companies"', 16, 1)
						ROLLBACK TRANSACTION
	END

				
	GO


	--INSERTS

INSERT INTO Sources (SourceName, SourceType, SourceLink, [Description]) VALUES 
('Monster' , 'Online', 'http://www.monster.com', 'Test'),
('Indeed', 'Online' , 'http://www.indeed.com', 'Test'),
('HireMe', 'Online' , 'http://www.higherme.com', 'Test'),
('Snag a Job', 'Online', 'http://www.snagajob.com', 'Test'),
('Zip Recruiter', 'Online', 'http://www.ziprecriter.com', 'Test'),
('Career Source' , 'Location', 'http://careersource.com', 'Test'),
('Hiringnearyou' , 'Online' , 'http://hiringnearyou.com', 'Test'),
('Linkedin', 'Online', 'http://linkedin.com', 'Test')


INSERT INTO BusinessTypes (BusinessType) VALUES
('Accounting'), ('Advertising/Marketing'), ('Agriculture'), ('Architecture'),
('Arts/Entertainment'), ('Aviation'), ('Beauty/Fitness'), ('Business Services'), ('Communications'),
('Computer/Hardware'), ('Compute/Services'), ('Computer/Software'), ('Computer/Training'), ('Construction'),
('Consulting'), ('Crafts/Hobbies'), ('Education'), ('Electrical'), ('Electronics'), ('Emplyment'), ('Engineering'),
('Enviormental'), ('Fashion'), ('Finacial'), ('Food/Beverage'), ('Government'), ('Health/Medicine'), ('Home & Garden'),
('Immigration'), ('Import/Export'), ('Industrial'), ('Industrial Medicine'), ('Information Services '), ('Insurance'),
('Internet'), ('Legal & Law'), ('Logistics'), ('Manufacturing'), ('Mapping/Surveying'), ('Marine/Maritime'),
('Motor Vehicle'), ('Multimedia'), ('Network Marketing'), ('News & Weather'), ('Non-Profit'), ('Petrochemical'),
('Pharmacutical'), ('Printing/Publishing'), ('Real Estate'), ('Restaurants'), ('Restaurants Services'),
('Service Clubs'), ('Service Industry'), ('Shopping/Retail'), ('Spiritual/Religious'), ('Sports/Recreation'),
('Storage/Warehousing'), ('Technologies'), ('Transportation'), ('Travel'), ('Utilities'), ('Venture Capital'), ('Wholesale')


INSERT INTO Companies (CompanyName)VALUES ('Drewslair'), ('AndrewComeau'), ('Microsoft'), ('Vinergys inc'), ('LibertySoftware')
INSERT INTO Companies (CompanyName, Address1, City, [State], Zip, Phone, Fax, Email, Website, [Description], Agency)
VALUES ('Exeter Employment', '123 Test Lane', 'Orlando', 'FL', '33321', '904-555-5555', '904-555-5555', 'drone@vinergys.com', 'Google.com', 'Test', '1'),
('Zwerl', NULL, 'Ocala', 'FL', NULL, NULL, NULL, NULL, 'http://zwerl.com', 'They want an HTML expert', '0' ),
('Moy Media' , NULL, 'Ocala' , 'FL', NULL, NULL, NULL, NULL, 'http://moymedia.com', 'Ocala Developers', '1'),
('IBM' , 'Armonk, NorthCastle' , NULL, 'NY' , NULL, NULL, NULL, NULL, 'http://idb.com/us', 'Sr. Developer Needed' , '1'),
('RealTruck', NULL, 'Ocala', 'FL', NULL, NULL, NULL, NULL, 'http://realtruck.com', 'Developers' , '1')


INSERT INTO Contacts (CompanyID, CourtesyTitle, ContactFirstName, ContactLastName) 
VALUES ('1', 'Mr', 'John', 'Smith'), ('2', 'Ms', 'Jane', 'Doe'), ('3', 'Mr', 'Bill', 'Hunt')


INSERT INTO LEADS ( JobTitle, [Description], EmploymentType, Location)
VALUES ('Html Expert', 'Help People with HTML', 'Part-Time', '7195 Se' ) , 
	   ('Front End Developer' , 'Develop with HTML/CSS for trucks and jeeps' , 'Full-Time', NULL) ,
	   ('Wordpress Developer' , 'Designing and implementing new features and functionality' , 'Full-Time' , 'Ocala'),
	   ('SEO Analyst' , 'Implement full SEO' , 'Full-Time' , 'Ocala'),
	   ('Website Developer' , 'Build Websites for people', 'Full-Time', 'LadyLake'),
	   ('Quality Assurance Engineer', 'HTML, CSS, Java, PHP', 'Full-Time', 'Ocala')


INSERT INTO Activities (LeadID, ActivityDate, ActivityType, ActivityDetails, Complete, ModifiedDate) VALUES 
((SELECT LeadID from Leads where LeadID = 1) , GETDATE(), 'walkin', NULL, '1', GETDATE())
GO

--VIEWS

CREATE VIEW [Number_of_leads_Per_day] AS
SELECT COUNT(LeadID) [Number of leads entered], DATEPART(Day, RecordDate) [Per day of the month]FROM Leads GROUP BY DATEPART(Day, RecordDate)
GO