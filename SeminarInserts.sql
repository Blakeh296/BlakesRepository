use SeminarBusiness_Db

INSERT INTO [Events] (EventName, EventDate, Speaker) VALUES
('The History of Human Emotions', '01-22-2017', 'Tiffany Watt Smith'),
('How Great Leaders Inspire Action', '02-22-2017', 'Simon Sinek'),
('The Puzzle of Motivation', '03-05-2017', 'Dan Pink'),
('Your Elusive Creative Genius', '04-16-2017', 'Elizabeth Gilbert'),
('Why are Programmers So Smart?', '05-01-2017', 'Andrew Comeau')

INSERT INTO SubscriptionLvl (PaymentFrequency, Price) VALUES
('Bi Annually', '189.99'),
('Annually', '99.99'),
('Quarterly', '27.99'),
('Monthly', '9.99')

INSERT INTO MemberAddress (MailingMatchBilling, AddressMailing, AddressBilling, City, [State], PostalCode) VALUES
('Yes', '020 New Castle Way', NULL, 'Port Washington', 'NY', '11054'),
('No', '8 Corry Parkway', 'PO Box 7088', 'Newton',	'MS',	'2458'),
('Yes' , '39426 Stone Corner Drive', NULL ,	'Peoria', 'IL', '61605'),
('Yes', '921 Granby Junction',	'Peoria', NULL,	'IL',	'61605'),
('Yes', '77 Butternut Parkway', NULL,	'Oklahoma City',	'OK',	'73173'),
('Yes', '821 Ilene Drive', NULL,	'Saint Paul',	'MN',	'55146'),
('Yes', '1110 Johnson Court', NULL,	'Odessa',	'TX',	'79764'),
('No', '6 Canary Hill', 'PO BOX 255',	'Rochester',	'NY',	'14624'),
('Yes', '9 Buhler Lane', NULL,	'Tallahassee',	'FL',	'32309'),
('Yes', '99 Northwestern Pass', NULL,	'Bismarck',	'ND',	'58505'),
('Yes', '69 Spenser Hill', NULL,	'Midland',	'TX',	'79710'),
('No', '3234 Kings Court', 'PO Box 1233',	'Provo',	'UT',	'84605'),
('Yes', '3 Lakewood Gardens Circle', NULL,	'Tacoma',	'WA',	'98424'),
('Yes', '198 Muir Parkway',	NULL, 'Columbia',	'SC',	'29225'),
('Yes', '258 Jenna Drive', NULL,	'Fairfax',	'VA',	'22036')

INSERT INTO Members (MemberID, FName, MName, LName, SubscriptionID, Gender, AddressID, Email, ContactNumber, [Current], Joined, BirthDate,
Interest1, Interest2, Interest3) VALUES
('M0001',	'Otis',	'Brooke',	'Fallon', '4',	'M ', '1',	'bfallon0@artisteer.com',	'818-873-3863', '1', '4-7-2017', '6-29-1971',
'Acting',	'Video Games',	'Crossword Puzzles')
, ('M0002',	'Katee',	'Virgie',	'Gepp', '4',	'F ', '2',	'vgepp1@nih.gov',	'503-689-8066', '1', '11-29-2017', '4-3-1972'
, 'Calligraphy', NULL, NULL ),
('M0003',	'Lilla',	'Charmion',	'Eatttok','3','F ', '3', 'ceatttok2@google.com.br',	'503-689-8066',	'1', '2-26-2017', '12-13-1975',
 'Movies',	'Restaurants',	'Woodworking'),
 ('M0004',	'Ddene',	'Shelba',	'Clapperton', '3', 'F', '4',	'sclapperton3@mapquest.com',	'716-674-1640',	'1', '11-05-2017', '2/19/1997',
 'Juggling',	'Quilting', NULL),
 ('M0005',	'Audrye',	'Agathe',	'Dawks', '4', 'F', '5', 'adawks4@mlb.com',	'305-415-9419', '1', '1-15-2016', '2-07-1989',
 'Electronics', NULL, NULL),
 ('M0006',	'Fredi',	'Melisandra',	'Burgyn', '2', 'F', '6',	'mburgyn5@cbslocal.com',	'214-650-9837',	'1', '3-13-2017', '5-31-1956',
 'Sewing',	'Cooking',	'Movies'),
 ('M0007',	'Dimitri',	'Francisco',	'Bellino', '4', 'M', '7', 'fbellino6@devhub.com',	'937-971-1026', '1', '8-09-2017', '10-12-1976',
 'Botany',	'Skating', NULL),
 ('M0008',	'Enrico',	'Cleve',	'Seeney', '2', 'M', '8',	'cseeney7@macromedia.com',	'407-445-6895', '1', '9-09-2016', '2/29/1988',
 'Dancing',	'Coffee',	'Foreign Languages'),
 ('M0009',	'Marylinda',	'Jenine',	'O Siaghail', '2', 'F', '9', 'josiaghail8@tuttocitta.it', '206-484-6850', '1', '11-21-2016', '2-06-1965',
 'Fashion', NULL, NULL	),
 ('M0010',	'Luce',	'Codi',	'Kovalski', '4', 'M', '10', 'ckovalski9@facebook.com',	'253-159-6773',	'1', '12-22-2017', '3-31-1978',
 'Woodworking', NULL, NULL),
 ('M0011',	'Claiborn',	'Shadow',	'Baldinotti', '4', 'M', '11', 'sbaldinottia@discuz.net',	'253-141-4314',	'1', '3-19-2017', '12-26-1991',
 'Homebrewing',	'Geneology',	'Scrapbooking'),
('M0012',	'Isabelle',	'Betty',	'Glossop', '3', 'F', '12',	'bglossopb@msu.edu',	'412-646-5145', '1', '4-25-2016', '2-17-1965',
'Surfing',	'Amateur Radio', NULL	 ),
('M0013',	'Davina',	'Lira',	'Wither', '2', 'F', '13',	'lwitherc@smugmug.com',	'404-495-3676', '1', '3-21-2016', '12-16-1957',
'Computers', NULL, NULL	),
('M0014',	'Panchito',	'Hashim',	'De Gregorio', '4','M', '14',	'hdegregoriod@a8.net',	'484-717-6750', '1', '1-27-2017', '10-14-1964',
'Writing',	'Singing', NULL	), 
('M0015',	'Rowen',	'Arvin',	'Birdfield', '4', 'M', '15', 'abirdfielde@over-blog.com',	'915-299-3451', '1'	, '10-06-2017', '1-09-1983',
'Reading',	'Pottery', NULL)

--LAST INSERT GIVING ERROR FIX VARCHAR FIELD 
INSERT INTO MemberPaymentInfo (MemberID, CardType, CardNumber, Expiration) VALUES
('M0001',	'americanexpress',	'337941553240515',	'2019-09-01'),
('M0002',	'visa',	'4041372553875903',	'2020-01-01'),
('M0003',	'visa',	'4041593962566',	'2019-03-01'),
('M0004',	'jcb',	'3559478087149594',	'2019-04-01'),
('M0005',	'jcb',	'3571066026049076',	'2018-07-01'),
('M0006',	'diners-club-carte-blanche',	'30423652701879',	'2018-05-01'),
('M0007',	'jcb',	'3532950215393858',	'2019-02-01'),
('M0008',	'jcb',	'3569709859937370',	'2019-03-01'),
('M0009',	'jcb',	'3529188090740670',	'2019-05-01'),
('M0010',	'jcb',	'3530142576111598',	'2019-11-01'),
('M0011',	'mastercard',	'5108756299877313',	'2018-07-01'),
('M0012',	'jcb',	'3543168150106220',	'2018-06-01'),
('M0013',	'jcb',	'3559166521684728',	'2019-10-01'),
('M0014',	'diners-club-carte-blanche',	'30414677064054',	'2018-06-01'),
('M0015',	'jcb',	'3542828093985763',	'2020-03-01')


--INSERT INTO MemberSubscriptionTransactions (MemberID, Amount, CardID, TransactionDate, Result) VALUES

SET IDENTITY_INSERT EventAttendence ON

INSERT INTO EventAttendence (EvntID, MemberID, Attendence, MemberNotes) VALUES
(1, 'M0002', 1, NULL), (1, 'M0003', 1, NULL), (1, 'M0004', 1, NULL),
(1, 'M0005', 1, NULL), (1, 'M0006', 1, NULL), (1, 'M0008', 1, NULL),
(1, 'M0010', 1, NULL), (1, 'M0011', 1, NULL), (1, 'M0012', 1, NULL),
(1, 'M0013', 1, NULL), (1, 'M0015', 1, NULL), (2, 'M0003', 1, NULL),
(2, 'M0004', 1, NULL), (2, 'M0005', 1, NULL), (2, 'M0007', 1, NULL),
(2, 'M0008', 1, NULL), (2, 'M0010', 1, NULL), (2, 'M0011', 1, NULL),
(2, 'M0013', 1, NULL), (2, 'M0014', 1, NULL), (2, 'M0015', 1, NULL),
(3, 'M0001', 1, NULL), (3, 'M0002', 1, NULL), (3, 'M0003', 1, NULL),
(3, 'M0004', 1, NULL), (3, 'M0005', 1, NULL), (3, 'M0006', 1, NULL),
(3, 'M0007', 1, NULL), (3, 'M0008', 1, NULL), (3, 'M0009', 1, NULL),
(3, 'M0012', 1, NULL), (3, 'M0014', 1, NULL), (3, 'M0015', 1, NULL),
(4, 'M0001', 1, NULL), (4, 'M0002', 1, NULL), (4, 'M0004', 1, NULL),
(4, 'M0005', 1, NULL), (4, 'M0006', 1, NULL), (4, 'M0007', 1, NULL),
(4, 'M0008', 1, NULL), (4, 'M0009', 1, NULL), (4, 'M0012', 1, NULL),
(4, 'M0014', 1, NULL), (4, 'M0015', 1, NULL), (5, 'M0001', 1, NULL),
(5, 'M0003', 1, NULL), (5, 'M0004', 1, NULL), (5, 'M0012', 1, NULL),
(5, 'M0013', 1, NULL)
--=CONCATENATE("('",B1,"'),")

--NEED RENEWAL DATE IN members table
SELECT * FROM EventAttendence


