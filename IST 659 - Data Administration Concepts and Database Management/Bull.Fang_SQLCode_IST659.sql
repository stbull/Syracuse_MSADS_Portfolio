-- Drop Table Statements --
DROP TABLE Impressions;
DROP TABLE SyracuseGame;
DROP TABLE Sponsor;
DROP TABLE SubscriptionPlan;
DROP TABLE CarriageAgreement;
DROP TABLE AdAgreement;
DROP TABLE Advertisement;
DROP TABLE AdContract;
DROP TABLE Device;
DROP TABLE Network;
DROP TABLE Business;
DROP TABLE AdvertisingAgency;
DROP TABLE NetworkProvider;
DROP TABLE Customer;

-- Customer Table Creation --
CREATE TABLE Customer
(
	Cust_ID VARCHAR(10) NOT NULL,
	Cust_FName VARCHAR(15) NOT NULL,
	Cust_LName VARCHAR(15) NOT NULL,
	Cust_Address1 VARCHAR(50) NOT NULL,
	Cust_Address2 VARCHAR(25),
	Cust_City VARCHAR(15) NOT NULL,
	Cust_State VARCHAR(15),
	Cust_Country VARCHAR(20) NOT NULL,
	Cust_ZipCode VARCHAR(6) NOT NULL,
	Cust_PhoneNum VARCHAR(30),

CONSTRAINT CustomerPK PRIMARY KEY (Cust_ID)
);

-- Network Provider Table Creation --
CREATE TABLE NetworkProvider
(
	Provider_ID VARCHAR(10) NOT NULL,
	Provider_Name VARCHAR(20) NOT NULL CHECK (Provider_Name IN('Verizon Fios', 'Spectrum', 'AT&T Now', 'Hulu TV', 'YouTube TV', 'Playstation Vue', 'Cuse TV')),
	Provider_Type VARCHAR(20) NOT NULL CHECK (Provider_Type IN('Cable Provider', 'Streaming Service')),

CONSTRAINT ProviderPK PRIMARY KEY (Provider_ID)
);

-- Network Table Creation --
CREATE TABLE Network
(
	Network_ID VARCHAR(10) NOT NULL,
	Network_Name VARCHAR(15) NOT NULL,
	AVG_Num_of_Adslots VARCHAR(5) NOT NULL,

CONSTRAINT NetworkPK PRIMARY KEY (Network_ID)
);

-- Advertising Agency Table Creation --
CREATE TABLE AdvertisingAgency
(
	Agency_ID VARCHAR(10) NOT NULL,
	Agency_Name VARCHAR(25) NOT NULL,
	Agency_Type VARCHAR(8) NOT NULL CHECK (Agency_Type IN('Local','National')),
	Number_of_Clients VARCHAR(5),

CONSTRAINT AgencyPK PRIMARY KEY (Agency_ID)
);

-- Business Table Creation --
CREATE TABLE Business
(
	Business_ID VARCHAR(10) NOT NULL,
	Business_Name VARCHAR(30) NOT NULL,
	Business_Type VARCHAR(15) NOT NULL,
	Ad_Budget VARCHAR(20) NOT NULL,
	AVG_Weekly_Revenue VARCHAR(20),

CONSTRAINT BusinessPK PRIMARY KEY (Business_ID)
);

-- Subscription Plan Table Creation --
CREATE TABLE SubscriptionPlan
(
	Cust_ID VARCHAR(10) NOT NULL,
	Provider_ID VARCHAR(10) NOT NULL,
	Subscription_Type VARCHAR(25) NOT NULL CHECK (Subscription_Type IN('7-Day Free Trial', 'Basic', 'Premium', 'Other')),

CONSTRAINT SubPK PRIMARY KEY (Cust_ID,Provider_ID),
CONSTRAINT CustSubFK FOREIGN KEY (Cust_ID) REFERENCES Customer (Cust_ID),
CONSTRAINT ProviderSubFK FOREIGN KEY (Provider_ID) REFERENCES NetworkProvider (Provider_ID)
);

-- Device Table Creation --
CREATE TABLE Device
(
	Device_ID VARCHAR(10) NOT NULL,
	Cust_ID VARCHAR(10) NOT NULL,
	Device_Type VARCHAR(12) NOT NULL CHECK (Device_Type IN('Television', 'Smartphone', 'Tablet', 'Laptop', 'Desktop', 'Other')),
	IP_Address CHAR(32) NOT NULL,

CONSTRAINT DevicePK PRIMARY KEY (Device_ID, Cust_ID),
CONSTRAINT CustDeviceFK FOREIGN KEY (Cust_ID) REFERENCES Customer (Cust_ID)
);

-- Carriage Agreement Table Creation --
CREATE TABLE CarriageAgreement
(
	Network_ID VARCHAR(10) NOT NULL,
	Provider_ID VARCHAR(10) NOT NULL,

CONSTRAINT CarriagePK PRIMARY KEY (Network_ID, Provider_ID),
CONSTRAINT ProviderCarriageFK FOREIGN KEY (Provider_ID) REFERENCES NetworkProvider (Provider_ID),
CONSTRAINT NetworkCarriageFK FOREIGN KEY (Network_ID) REFERENCES Network (Network_ID)
);

-- Ad Agency Agreement Table Creation --
CREATE TABLE AdAgreement
(
	Network_ID VARCHAR(10) NOT NULL,
	Agency_ID VARCHAR(10) NOT NULL,
	Agreement_Date DATE NOT NULL

CONSTRAINT AgreementPK PRIMARY KEY (Agreement_Date, Network_ID, Agency_ID),
CONSTRAINT NetworkAgreementFK FOREIGN KEY (Network_ID) REFERENCES Network (Network_ID),
CONSTRAINT AgencyAgreementFK FOREIGN KEY (Agency_ID) REFERENCES AdvertisingAgency (Agency_ID)
);

-- Ad Business Contract Table Creation --
CREATE TABLE AdContract
(
	Agency_ID VARCHAR(10) NOT NULL,
	Business_ID VARCHAR(10) NOT NULL,
	Contract_SignDate DATE NOT NULL,
	Contract_Amount VARCHAR(6),

CONSTRAINT ContractPK PRIMARY KEY (Agency_ID, Business_ID, Contract_SignDate),
CONSTRAINT AgencyContractFK FOREIGN KEY (Agency_ID) REFERENCES AdvertisingAgency (Agency_ID),
CONSTRAINT BusinessContractFK FOREIGN KEY (Business_ID) REFERENCES Business (Business_ID)
);

-- Advertisements Table Creation --
CREATE TABLE Advertisement
(
	Ad_ID VARCHAR(10) NOT NULL,
	Agency_ID VARCHAR(10) NOT NULL,
	Business_ID VARCHAR(10) NOT NULL,
	Contract_SignDate DATE NOT NULL,
	Ad_Title VARCHAR(40) NOT NULL,
	Ad_Type VARCHAR(30) NOT NULL CHECK (Ad_Type IN ('Ad read by Commentators', 'Commercial', 'Graphic w/ QR Code')),
	Ad_Duration VARCHAR(15) NOT NULL CHECK (Ad_Duration IN ('15 Sec', '30 Sec', '45 Sec', '60 Sec')),
	Ad_TargetAgeDemo VARCHAR(50) NOT NULL CHECK (Ad_TargetAgeDemo IN ('Under 18', '18-24', '25-39', '40-55', '56-74', '75+')),

CONSTRAINT AdPK PRIMARY KEY (Ad_ID),
CONSTRAINT ContractAdFK FOREIGN KEY (Agency_ID, Business_ID, Contract_SignDate) REFERENCES AdContract (Agency_ID, Business_ID, Contract_SignDate)
);


-- Sponsor Table Creation --
CREATE TABLE Sponsor
(
	Sponsor_ID VARCHAR(10) NOT NULL,
	Sponsor_Name VARCHAR(30) NOT NULL,

CONSTRAINT SponsorPK PRIMARY KEY (Sponsor_ID),
);

-- Syracuse Game Table Craetion --
CREATE TABLE SyracuseGame
(
	Game_ID VARCHAR(10) NOT NULL,
	Game_Date DATETIME NOT NULL,
	Game_Location VARCHAR(30) NOT NULL CHECK (Game_Location IN('HOME','AWAY')),
	Oppossing_Team VARCHAR(25) NOT NULL,
	Syracuse_Score VARCHAR(3),
	Oppossing_Score VARCHAR(3),
	Game_Duration VARCHAR(10) NOT NULL,
	Network_ID VARCHAR(10) NOT NULL,
	Sponsor_ID VARCHAR(10) NOT NULL,

CONSTRAINT GamePK PRIMARY KEY (Game_ID, Game_Date),
CONSTRAINT NetworkGameFK FOREIGN KEY (Network_ID) REFERENCES Network (Network_ID),
CONSTRAINT SponsorGameFK FOREIGN KEY (Sponsor_ID) REFERENCES Sponsor (Sponsor_ID),
);

-- Ad Impressions Table Creation --
CREATE TABLE Impressions
(
	Game_ID VARCHAR(10) NOT NULL,
	Game_Date DATETIME NOT NULL,
	Ad_ID VARCHAR(10) NOT NULL,
	Placement_in_Game VARCHAR(20) NOT NULL CHECK (Placement_in_Game IN('Pre-Game', 'First Quarter', 'Second Quarter', 'Halftime', 'Third Quarter', 'Fourth Quarter', 'Post-Game')),
	Est_Num_of_Impressions VARCHAR(10) NOT NULL,
	Percent_Engagement VARCHAR(3) NOT NULL,
	
CONSTRAINT ImpressionPK PRIMARY KEY (Game_ID, Game_Date, Ad_ID),
CONSTRAINT GameImpressionFK FOREIGN KEY (Game_ID, Game_Date) REFERENCES SyracuseGame (Game_ID, Game_Date),
CONSTRAINT AdImpressionFK FOREIGN KEY (Ad_ID) REFERENCES Advertisement (Ad_ID)
);


GO

-- Customer Table Insertion Statements --
INSERT INTO Customer (Cust_ID,Cust_FName,Cust_LName,Cust_Address1, Cust_City, Cust_State, Cust_Country, Cust_ZipCode, Cust_PhoneNum) VALUES
	('1','Kole','Conley','4690 Hidden Pond Road','Nashville','Tennessee', 'United States','37219','615-727-2796');
INSERT INTO Customer (Cust_ID,Cust_FName,Cust_LName,Cust_Address1, Cust_City, Cust_State, Cust_Country, Cust_ZipCode, Cust_PhoneNum) VALUES
	('2','Ammara','Sargent','1088 Red Maple Drive','Cedar Hill','Tennessee', 'United States','37032','323-444-8450');
INSERT INTO Customer (Cust_ID,Cust_FName,Cust_LName,Cust_Address1, Cust_City, Cust_State, Cust_Country, Cust_ZipCode, Cust_PhoneNum) VALUES
	('3','Otto','Rennie','2570 Joy Lane','Irvine','California', 'United States','92619','818-568-1788');
INSERT INTO Customer (Cust_ID,Cust_FName,Cust_LName,Cust_Address1, Cust_City, Cust_State, Cust_Country, Cust_ZipCode, Cust_PhoneNum) VALUES
	('4','Polly','Rodriquez','1738 Norman Street','Cicero','New York', 'United States','13029','315-286-5315');
INSERT INTO Customer (Cust_ID,Cust_FName,Cust_LName,Cust_Address1, Cust_City, Cust_State, Cust_Country, Cust_ZipCode, Cust_PhoneNum) VALUES
	('5','Anwar','Levy','607 Daylene Drive','Southfield','Michigan', 'United States','48075','734-638-5573');
INSERT INTO Customer (Cust_ID,Cust_FName,Cust_LName,Cust_Address1, Cust_City, Cust_State, Cust_Country, Cust_ZipCode, Cust_PhoneNum) VALUES
	('6','Corey','Alexander','5001 Capitol Avenue','Richmond','Indiana', 'United States','47374','765-530-3340');
INSERT INTO Customer (Cust_ID,Cust_FName,Cust_LName,Cust_Address1, Cust_City, Cust_State, Cust_Country, Cust_ZipCode, Cust_PhoneNum) VALUES
	('7','Mathilde','Ball','4010 Saint Clair Street','Syracuse','New York', 'United States','13210','315-588-5084');
INSERT INTO Customer (Cust_ID,Cust_FName,Cust_LName,Cust_Address1, Cust_City, Cust_State, Cust_Country, Cust_ZipCode, Cust_PhoneNum) VALUES
	('8','Carrie','Crossley','1436 Perine Street','Rapids City','Illinois', 'United States','61278','703-740-6612');
INSERT INTO Customer (Cust_ID,Cust_FName,Cust_LName,Cust_Address1, Cust_City, Cust_State, Cust_Country, Cust_ZipCode, Cust_PhoneNum) VALUES
	('9','Cienna','Rose','946 Essex Road','Baldwinsville','New York', 'United States','13027','315-322-9036');
INSERT INTO Customer (Cust_ID,Cust_FName,Cust_LName,Cust_Address1, Cust_City, Cust_State, Cust_Country, Cust_ZipCode, Cust_PhoneNum) VALUES
	('10','Imogen','Zhang','3991 West 64th Street','New York','New York', 'United States','10023','808-565-5796');
INSERT INTO Customer (Cust_ID,Cust_FName,Cust_LName,Cust_Address1, Cust_City, Cust_State, Cust_Country, Cust_ZipCode, Cust_PhoneNum) VALUES
	('11','Sharna','Glover','1634 Laurent-Hubert Road','Contrecoeur','Quebec', 'Canada','J011C0','450-573-6321');
INSERT INTO Customer (Cust_ID,Cust_FName,Cust_LName,Cust_Address1, Cust_City, Cust_Country, Cust_ZipCode, Cust_PhoneNum) VALUES
	('12','Arnav','Peel','54 Islington Park Street','London', 'United Kingdom','N1 1PX','0201-359-9070');
INSERT INTO Customer (Cust_ID,Cust_FName,Cust_LName,Cust_Address1, Cust_Address2, Cust_City, Cust_Country, Cust_ZipCode, Cust_PhoneNum) VALUES
	('13','Codey','Orozoco','82 Wood Street','Unit 223','Liverpool', 'United Kingdom','L1 4DQ','0151-708-0807');
INSERT INTO Customer (Cust_ID,Cust_FName,Cust_LName,Cust_Address1, Cust_City, Cust_Country, Cust_ZipCode, Cust_PhoneNum) VALUES
	('14','Eshal','Bevan','83 Upper Street','London', 'United Kingdom','N1 0NU','8711-906-0060');
INSERT INTO Customer (Cust_ID,Cust_FName,Cust_LName,Cust_Address1, Cust_Address2, Cust_City, Cust_Country, Cust_ZipCode, Cust_PhoneNum) VALUES
	('15','Kristie','Daniel','112 Bold Street','Office 6','Liverpool', 'United Kingdom','L1 4JN','0151-708-6345');
INSERT INTO Customer (Cust_ID,Cust_FName,Cust_LName,Cust_Address1, Cust_City, Cust_State, Cust_Country, Cust_ZipCode, Cust_PhoneNum) VALUES
	('16','Heena','Hudson','8362 Breadner Crest','Toronto','Ontario', 'Canada','L2G6N5','905-295-3014');
INSERT INTO Customer (Cust_ID,Cust_FName,Cust_LName,Cust_Address1, Cust_City, Cust_State, Cust_Country, Cust_ZipCode, Cust_PhoneNum) VALUES
	('17','Katarina','Trujillo','283 St. Laurent Crest','Woodstock','Ontario', 'Canada','N4S7T8','519-537-7440');
INSERT INTO Customer (Cust_ID,Cust_FName,Cust_LName,Cust_Address1, Cust_City, Cust_State, Cust_Country, Cust_ZipCode, Cust_PhoneNum) VALUES
	('18','Zayn','Gill','493 Yorkshire Circle','San Francisco','California', 'United States','94108','252-286-3763');
INSERT INTO Customer (Cust_ID,Cust_FName,Cust_LName,Cust_Address1, Cust_City, Cust_State, Cust_Country, Cust_ZipCode, Cust_PhoneNum) VALUES
	('19','Kobi','Brook','634 Barcovan Avenue','Liverpool','New York', 'United States','13088','315-777-6827');

-- Network Table Insertion Statements --
INSERT INTO Network VALUES ('1','ESPN', '120');
INSERT INTO Network VALUES ('2','Fox Sports','150');
INSERT INTO Network VALUES ('3','NBC Sports','125');
INSERT INTO Network VALUES ('4','ABC Sports','100');
INSERT INTO Network VALUES ('5','YES Network','120');
INSERT INTO Network VALUES ('6','ACC NEtwork','130');
INSERT INTO Network VALUES ('7','ESPN 2','120');
INSERT INTO Network VALUES ('8','ESPN 3','70');

-- Network Provider Table Insertion Statements --
INSERT INTO NetworkProvider VALUES ('1','Verizon Fios','Cable Provider');
INSERT INTO NetworkProvider VALUES ('2','Spectrum','Cable Provider');
INSERT INTO NetworkProvider VALUES ('3','AT&T Now','Streaming Service');
INSERT INTO NetworkProvider VALUES ('4','Hulu TV','Streaming Service');
INSERT INTO NetworkProvider VALUES ('5','YouTube TV','Streaming Service');
INSERT INTO NetworkProvider VALUES ('6','Playstation Vue','Streaming Service');
INSERT INTO NetworkProvider VALUES ('7','Cuse TV','Streaming Service');

-- Advertising Agency Insertion Statements --
INSERT INTO AdvertisingAgency VALUES ('1','The Martin Agency','National','115');
INSERT INTO AdvertisingAgency VALUES ('2','CINSYR','Local','60');
INSERT INTO AdvertisingAgency VALUES ('3','TBWA Worldwide','National','200');
INSERT INTO AdvertisingAgency VALUES ('4','EP + Co','National','100');
INSERT INTO AdvertisingAgency VALUES ('5','Solo Quinn Studios','Local','75');

-- Business Table Insertion Statements --
INSERT INTO Business (Business_ID,Business_Name,Business_Type,Ad_Budget) VALUES ('1', 'Progressive Corporation','Insurance','200,000');
INSERT INTO Business (Business_ID,Business_Name,Business_Type,Ad_Budget,AVG_Weekly_Revenue) VALUES ('2','Upstate Orthopedics','Healthcare','1,000','20,000');
INSERT INTO Business (Business_ID,Business_Name,Business_Type,Ad_Budget) VALUES ('3','Chick-fil-A','Restaurant','100,000');
INSERT INTO Business (Business_ID,Business_Name,Business_Type,Ad_Budget) VALUES ('4','Syracuse University','High Education','100,000');
INSERT INTO Business (Business_ID,Business_Name,Business_Type,Ad_Budget) VALUES ('5','Best Buy','Retailer','90,000');
INSERT INTO Business (Business_ID,Business_Name,Business_Type,Ad_Budget,AVG_Weekly_Revenue) VALUES ('6','CourseHero','EdTech','20,000','2,082,000');
INSERT INTO Business (Business_ID,Business_Name,Business_Type,Ad_Budget,AVG_Weekly_Revenue) VALUES ('7','Dinosaur Bar-B-Que','Restaurant','5,000','10,000');

-- Subscription Plan Table Insertion Statements --
INSERT INTO SubscriptionPlan VALUES ('1','4','Basic');
INSERT INTO SubscriptionPlan VALUES ('2','3','Premium');
INSERT INTO SubscriptionPlan VALUES ('3','1','Basic');
INSERT INTO SubscriptionPlan VALUES ('4','2','Basic');
INSERT INTO SubscriptionPlan VALUES ('5','7','Basic');
INSERT INTO SubscriptionPlan VALUES ('6','4','Basic');
INSERT INTO SubscriptionPlan VALUES ('7','3','Premium');
INSERT INTO SubscriptionPlan VALUES ('8','5','Basic');
INSERT INTO SubscriptionPlan VALUES ('9','5','Basic');
INSERT INTO SubscriptionPlan VALUES ('10','7','Premium');
INSERT INTO SubscriptionPlan VALUES ('11','1','Basic');
INSERT INTO SubscriptionPlan VALUES ('12','2','Premium');
INSERT INTO SubscriptionPlan VALUES ('13','4','7-Day Free Trial');
INSERT INTO SubscriptionPlan VALUES ('14','5','7-Day Free Trial');
INSERT INTO SubscriptionPlan VALUES ('15','3','7-Day Free Trial');
INSERT INTO SubscriptionPlan VALUES ('16','2','7-Day Free Trial');
INSERT INTO SubscriptionPlan VALUES ('17','6','Premium');
INSERT INTO SubscriptionPlan VALUES ('18','3','Premium');
INSERT INTO SubscriptionPlan VALUES ('19','2','Premium');

-- Device Table Insertion Statements -- 
INSERT INTO Device (Device_ID,Cust_ID,Device_Type,IP_Address) VALUES ('1','1','Smartphone','182.244.145.71');
INSERT INTO Device (Device_ID,Cust_ID,Device_Type,IP_Address) VALUES ('2','1','Television','102.11.112.71');
INSERT INTO Device (Device_ID,Cust_ID,Device_Type,IP_Address) VALUES ('3','2','Smartphone','135.36.252.253');
INSERT INTO Device (Device_ID,Cust_ID,Device_Type,IP_Address) VALUES ('4','2','Tablet','110.131.105.176');
INSERT INTO Device (Device_ID,Cust_ID,Device_Type,IP_Address) VALUES ('5','3','Desktop','237.108.14.31');
INSERT INTO Device (Device_ID,Cust_ID,Device_Type,IP_Address) VALUES ('6','3','Laptop','134.54.167.107');
INSERT INTO Device (Device_ID,Cust_ID,Device_Type,IP_Address) VALUES ('7','4','Smartphone','239.183.141.27');
INSERT INTO Device (Device_ID,Cust_ID,Device_Type,IP_Address) VALUES ('8','4','Laptop','63.227.120.103');
INSERT INTO Device (Device_ID,Cust_ID,Device_Type,IP_Address) VALUES ('9','5','Smartphone','78.58.29.253');
INSERT INTO Device (Device_ID,Cust_ID,Device_Type,IP_Address) VALUES ('10','6','Desktop','197.178.201.113');
INSERT INTO Device (Device_ID,Cust_ID,Device_Type,IP_Address) VALUES ('11','7','Tablet','63.15.205.26');
INSERT INTO Device (Device_ID,Cust_ID,Device_Type,IP_Address) VALUES ('12','8','Smartphone','220.172.176.11');
INSERT INTO Device (Device_ID,Cust_ID,Device_Type,IP_Address) VALUES ('13','9','Television','84.220.174.88');
INSERT INTO Device (Device_ID,Cust_ID,Device_Type,IP_Address) VALUES ('14','10','Smartphone','66.176.183.84');
INSERT INTO Device (Device_ID,Cust_ID,Device_Type,IP_Address) VALUES ('15','10','Laptop','75.220.73.108');
INSERT INTO Device (Device_ID,Cust_ID,Device_Type,IP_Address) VALUES ('16','11','Desktop','75.211.238.226');
INSERT INTO Device (Device_ID,Cust_ID,Device_Type,IP_Address) VALUES ('17','11','Tablet','115.75.238.226');
INSERT INTO Device (Device_ID,Cust_ID,Device_Type,IP_Address) VALUES ('18','12','Smartphone','45.57.197.95');
INSERT INTO Device (Device_ID,Cust_ID,Device_Type,IP_Address) VALUES ('19','13','Desktop','223.18.247.62');
INSERT INTO Device (Device_ID,Cust_ID,Device_Type,IP_Address) VALUES ('20','14','Television','33.148.19.2');
INSERT INTO Device (Device_ID,Cust_ID,Device_Type,IP_Address) VALUES ('21','15','Smartphone','81.22.239.1');
INSERT INTO Device (Device_ID,Cust_ID,Device_Type,IP_Address) VALUES ('22','15','Desktop','210.156.236.176');
INSERT INTO Device (Device_ID,Cust_ID,Device_Type,IP_Address) VALUES ('23','16','Laptop','207.23.34.37');
INSERT INTO Device (Device_ID,Cust_ID,Device_Type,IP_Address) VALUES ('24','17','Laptop','69.173.20.110');
INSERT INTO Device (Device_ID,Cust_ID,Device_Type,IP_Address) VALUES ('25','17','Smartphone','188.191.149.165');
INSERT INTO Device (Device_ID,Cust_ID,Device_Type,IP_Address) VALUES ('26','17','Television','250.96.12.196');
INSERT INTO Device (Device_ID,Cust_ID,Device_Type,IP_Address) VALUES ('27','18','Tablet','200.124.25.29');
INSERT INTO Device (Device_ID,Cust_ID,Device_Type,IP_Address) VALUES ('28','19','Smartphone','237.180.45.0');
INSERT INTO Device (Device_ID,Cust_ID,Device_Type,IP_Address) VALUES ('29','19','Tablet','255.221.225.98');
INSERT INTO Device (Device_ID,Cust_ID,Device_Type,IP_Address) VALUES ('30','19','Desktop','133.60.142.146');

-- Carriage Agreements Table Insertion Statements --
INSERT INTO CarriageAgreement VALUES ('1','2');
INSERT INTO CarriageAgreement VALUES ('1','1');
INSERT INTO CarriageAgreement VALUES ('1','3');
INSERT INTO CarriageAgreement VALUES ('2','6');
INSERT INTO CarriageAgreement VALUES ('2','3');
INSERT INTO CarriageAgreement VALUES ('3','4');
INSERT INTO CarriageAgreement VALUES ('4','5');
INSERT INTO CarriageAgreement VALUES ('4','6');
INSERT INTO CarriageAgreement VALUES ('4','7');
INSERT INTO CarriageAgreement VALUES ('5','3');
INSERT INTO CarriageAgreement VALUES ('5','7');
INSERT INTO CarriageAgreement VALUES ('6','7');
INSERT INTO CarriageAgreement VALUES ('6','4');
INSERT INTO CarriageAgreement VALUES ('7','1');
INSERT INTO CarriageAgreement VALUES ('8','1');
INSERT INTO CarriageAgreement VALUES ('8','2');
INSERT INTO CarriageAgreement VALUES ('8','4');

-- Ad Agency Agreement Insertion Statements --
INSERT INTO AdAgreement VALUES ('1','1','2005-10-13');
INSERT INTO AdAgreement VALUES ('1','2','2019-11-12');
INSERT INTO AdAgreement VALUES ('1','3','2009-03-06');
INSERT INTO AdAgreement VALUES ('2','4','2019-01-21');
INSERT INTO AdAgreement VALUES ('2','5','2020-03-20');
INSERT INTO AdAgreement VALUES ('3','3','2003-08-03');
INSERT INTO AdAgreement VALUES ('3','2','2015-12-21');
INSERT INTO AdAgreement VALUES ('4','3','2018-10-31');
INSERT INTO AdAgreement VALUES ('4','5','2014-05-20');
INSERT INTO AdAgreement VALUES ('5','4','2018-06-23');
INSERT INTO AdAgreement VALUES ('5','3','2018-12-20');
INSERT INTO AdAgreement VALUES ('5','4','2020-04-03');
INSERT INTO AdAgreement VALUES ('6','2','2018-04-19');
INSERT INTO AdAgreement VALUES ('7','1','2005-10-20');
INSERT INTO AdAgreement VALUES ('7','2','2020-05-20');
INSERT INTO AdAgreement VALUES ('8','3','2016-08-10');
INSERT INTO AdAgreement VALUES ('8','3','2017-04-09');

-- Ad Business Contract Table Insertion Statements --
INSERT INTO AdContract VALUES ('1','1','2018-08-18','80,000');
INSERT INTO AdContract VALUES ('2','2','2014-04-04','500');
INSERT INTO AdContract VALUES ('3','3','2019-12-18','40,000');
INSERT INTO AdContract VALUES ('3','4','2019-01-08','20,000');
INSERT INTO AdContract VALUES ('4','5','2020-05-20','50,000');
INSERT INTO AdContract VALUES ('5','6','2018-12-02','20,000');
INSERT INTO AdContract VALUES ('5','7','2018-03-04','500');

-- Advertisements Table Insertion Statements --
INSERT INTO Advertisement VALUES ('1','1','1','2018-08-18','Group Outing','Commercial','30 Sec','25-39');
INSERT INTO Advertisement VALUES ('2','1','1','2018-08-18','The End','Commercial','60 Sec','40-55');
INSERT INTO Advertisement VALUES ('3','1','1','2018-08-18','Family Ties','Commercial','15 Sec','18-24');
INSERT INTO Advertisement VALUES ('4','2','2','2014-04-04','You need a Crane?','Commercial','30 Sec','75+');
INSERT INTO Advertisement VALUES ('5','2','2','2014-04-04','Thew My Back out','Ad read by Commentators','15 Sec','56-74');
INSERT INTO Advertisement VALUES ('6','3','3','2019-12-18','Got a Nugget?','Commercial','60 Sec','25-39');
INSERT INTO Advertisement VALUES ('7','3','3','2019-12-18','Little Things','Commercial','60 Sec','40-55');
INSERT INTO Advertisement VALUES ('8','3','3','2019-12-18','Proudly Served','Graphic w/ QR Code','15 Sec','18-24');
INSERT INTO Advertisement VALUES ('9','3','4','2019-01-08','Proud to be Orange','Commercial','30 Sec','Under 18');
INSERT INTO Advertisement VALUES ('10','3','4','2019-01-08','Be you. Be Orange.','Commercial','60 Sec','18-24');
INSERT INTO Advertisement VALUES ('11','4','5','2020-05-20','Holiday','Commercial','45 Sec','25-39');
INSERT INTO Advertisement VALUES ('12','4','5','2020-05-20','Black Friday','Graphic w/ QR Code','15 Sec','18-24');
INSERT INTO Advertisement VALUES ('13','4','5','2020-05-20','Cyber Moday','Graphic w/ QR Code','15 Sec','25-39');
INSERT INTO Advertisement VALUES ('14','5','6','2018-12-02','Ace College','Commercial','60 Sec','18-24');
INSERT INTO Advertisement VALUES ('15','5','6','2018-12-02','Learn New Things','Ad read by Commentators','15 Sec','56-74');
INSERT INTO Advertisement VALUES ('16','5','6','2018-12-02','A Little Help','Graphic w/ QR Code','15 Sec','25-39');
INSERT INTO Advertisement VALUES ('17','5','6','2018-12-02','Helppppppp','Commercial','30 Sec','40-55');
INSERT INTO Advertisement VALUES ('18','5','7','2018-03-04','Perfect Plate','Commercial','60 Sec','40-55');
INSERT INTO Advertisement VALUES ('19','5','7','2018-03-04','Nice and Tender','Graphic w/ QR Code','15 Sec','56-74');

-- Sponsor Table Insertion Statements --
INSERT INTO Sponsor VALUES ('1','Pepsi');
INSERT INTO Sponsor VALUES ('2','Bojangles');
INSERT INTO Sponsor VALUES ('3','Dunkin Donuts');
INSERT INTO Sponsor VALUES ('4','Americu Federal Credit Union');
INSERT INTO Sponsor VALUES ('5','Muscle Milk');

-- Syracuse Game Table Insertion Statements --
INSERT INTO SyracuseGame VALUES ('1','2020-09-12 12:00 PM','AWAY','North Carolina','6','31','2.5 hours','6','2');
INSERT INTO SyracuseGame VALUES ('2','2020-09-19 12:00 PM','AWAY','Pittsburgh','10','21','3 hours','6','3');
INSERT INTO SyracuseGame VALUES ('3','2020-09-26 12:00 PM','HOME','Georgia Tech','37','20','3.5 hours','8','4');
INSERT INTO SyracuseGame VALUES ('4','2020-10-10 12:30 PM','HOME','Duke','24','38','3 hours','5','4');
INSERT INTO SyracuseGame VALUES ('5','2020-10-17 12:00 PM','HOME','Liberty','21','38','2.5 hours','5','3');
INSERT INTO SyracuseGame VALUES ('6','2020-10-24 12:00 PM','AWAY','Clemson','21','47','3.5 hours','6','1');
INSERT INTO SyracuseGame VALUES ('7','2020-10-31 12:00 PM','HOME','Wake Forest','14','38','3.5 hours','6','5');
INSERT INTO SyracuseGame VALUES ('8','2020-11-07 2:00 PM','HOME','Boston College','13','16','3 hours','5','3');

-- Impressions Table Insertion Statements --
INSERT INTO Impressions VALUES ('1','2020-09-12 12:00 PM','1','Pre-Game','84,003','12');
INSERT INTO Impressions VALUES ('1','2020-09-12 12:00 PM','2','First Quarter','84,729','20');
INSERT INTO Impressions VALUES ('1','2020-09-12 12:00 PM','3','Second Quarter','92,836','14');
INSERT INTO Impressions VALUES ('1','2020-09-12 12:00 PM','5','Halftime','92,742','30');
INSERT INTO Impressions VALUES ('1','2020-09-12 12:00 PM','8','Third Quarter','87,242','17');
INSERT INTO Impressions VALUES ('1','2020-09-12 12:00 PM','10','Fourth Quarter','68,923','23');
INSERT INTO Impressions VALUES ('1','2020-09-12 12:00 PM','13','Post-Game','10,024','27');
INSERT INTO Impressions VALUES ('2','2020-09-19 12:00 PM','15','Pre-Game','91,238','15');
INSERT INTO Impressions VALUES ('2','2020-09-19 12:00 PM','16','First Quarter','98,271','44');
INSERT INTO Impressions VALUES ('2','2020-09-19 12:00 PM','12','Second Quarter','87,362','20');
INSERT INTO Impressions VALUES ('2','2020-09-19 12:00 PM','17','Halftime','82,415','23');
INSERT INTO Impressions VALUES ('2','2020-09-19 12:00 PM','19','Post-Game','40,291','20');
INSERT INTO Impressions VALUES ('3','2020-09-26 12:00 PM','3','Pre-Game','21,289','20');
INSERT INTO Impressions VALUES ('3','2020-09-26 12:00 PM','5','First Quarter','21,900','20');
INSERT INTO Impressions VALUES ('3','2020-09-26 12:00 PM','4','Second Quarter','39,123','23');
INSERT INTO Impressions VALUES ('3','2020-09-26 12:00 PM','2','Halftime','40,290','20');
INSERT INTO Impressions VALUES ('3','2020-09-26 12:00 PM','7','Third Quarter','59,023','20');
INSERT INTO Impressions VALUES ('3','2020-09-26 12:00 PM','9','Fourth Quarter','59,289','25');
INSERT INTO Impressions VALUES ('3','2020-09-26 12:00 PM','1','Post-Game','29,384','4');
INSERT INTO Impressions VALUES ('3','2020-09-26 12:00 PM','8','Post-Game','28,910','3');
INSERT INTO Impressions VALUES ('4','2020-10-10 12:30 PM','2','Pre-Game','23,981','3');
INSERT INTO Impressions VALUES ('4','2020-10-10 12:30 PM','6','First Quarter','23,456','4');
INSERT INTO Impressions VALUES ('4','2020-10-10 12:30 PM','14','Second Quarter','45,734','16');
INSERT INTO Impressions VALUES ('4','2020-10-10 12:30 PM','9','Halftime','43,475','16');
INSERT INTO Impressions VALUES ('4','2020-10-10 12:30 PM','7','Fourth Quarter','64,245','16');
INSERT INTO Impressions VALUES ('4','2020-10-10 12:30 PM','4','Post-Game','64,342','19');
INSERT INTO Impressions VALUES ('5','2020-10-17 12:00 PM','2','Pre-Game','74,567','17');
INSERT INTO Impressions VALUES ('5','2020-10-17 12:00 PM','1','First Quarter','86,456','19');
INSERT INTO Impressions VALUES ('5','2020-10-17 12:00 PM','9','Second Quarter','87,456','23');
INSERT INTO Impressions VALUES ('5','2020-10-17 12:00 PM','3','Halftime','87,954','9');
INSERT INTO Impressions VALUES ('5','2020-10-17 12:00 PM','8','Third Quarter','76,884','17');
INSERT INTO Impressions VALUES ('5','2020-10-17 12:00 PM','11','Fourth Quarter','87,456','12');
INSERT INTO Impressions VALUES ('6','2020-10-24 12:00 PM','6','Pre-Game','21,145','20');
INSERT INTO Impressions VALUES ('6','2020-10-24 12:00 PM','8','First Quarter','78,456','8');
INSERT INTO Impressions VALUES ('6','2020-10-24 12:00 PM','2','Second Quarter','87,635','30');
INSERT INTO Impressions VALUES ('6','2020-10-24 12:00 PM','10','Halftime','56,345','18');
INSERT INTO Impressions VALUES ('7','2020-10-31 12:00 PM','19','Pre-Game','53,422','9');
INSERT INTO Impressions VALUES ('7','2020-10-31 12:00 PM','14','First Quarter','54,275','27');
INSERT INTO Impressions VALUES ('7','2020-10-31 12:00 PM','16','Second Quarter','64,254','19');
INSERT INTO Impressions VALUES ('7','2020-10-31 12:00 PM','17','Halftime','65,342','20');
INSERT INTO Impressions VALUES ('7','2020-10-31 12:00 PM','13','Third Quarter','56,423','20');
INSERT INTO Impressions VALUES ('7','2020-10-31 12:00 PM','2','Post-Game','23,452','3');
INSERT INTO Impressions VALUES ('8','2020-11-07 2:00 PM','15','Pre-Game','12,374','8');
INSERT INTO Impressions VALUES ('8','2020-11-07 2:00 PM','12','First Quarter','13,432','23');
INSERT INTO Impressions VALUES ('8','2020-11-07 2:00 PM','11','Second Quarter','56,543','9');
INSERT INTO Impressions VALUES ('8','2020-11-07 2:00 PM','14','Third Quarter','34,521','19');
INSERT INTO Impressions VALUES ('8','2020-11-07 2:00 PM','10','Fourth Quarter','12,364','20');
INSERT INTO Impressions VALUES ('8','2020-11-07 2:00 PM','6','Post-Game','12,353','3');
INSERT INTO Impressions VALUES ('8','2020-11-07 2:00 PM','3','Post-Game','10,322','3');

GO

CREATE VIEW Customer_Subs AS (
	SELECT C.Cust_ID, C.Cust_FName, C.Cust_LName, SP.Subscription_Type, NP.Provider_ID
	FROM Customer C
	JOIN SubscriptionPlan SP ON C.Cust_ID=SP.Cust_ID
	JOIN NetworkProvider NP ON SP.Provider_ID=NP.Provider_ID
)
GO

CREATE VIEW Ad_by_Business AS (
	SELECT A.Ad_ID,A.Ad_Title,A.Ad_Type,B.Business_ID,B.Business_Name,B.Business_Type,A.Ad_Duration,A.Ad_TargetAgeDemo
	FROM Advertisement A
	JOIN Business B ON A.Business_ID=B.Business_ID
)
GO

CREATE VIEW Game_Ad_Impressions AS (
	SELECT SG.Game_ID, SG.Game_Date,SG.Game_Location, SG.Oppossing_Team, I.Ad_ID,I.Placement_in_Game,I.Est_Num_of_Impressions,I.Percent_Engagement
	FROM SyracuseGame SG
	JOIN Impressions I ON SG.Game_ID=I.Game_ID
)
GO

CREATE VIEW Agency_Clients AS (
	SELECT AA.Agency_ID,B.Business_ID,B.Business_Name,B.Business_Type,A.Ad_ID,A.Ad_Title,A.Ad_Type,A.Ad_Duration,A.Ad_TargetAgeDemo
	FROM Advertisement A
	JOIN AdvertisingAgency AA ON A.Agency_ID=AA.Agency_ID
	JOIN Business B ON A.Business_ID=B.Business_ID
)
GO

CREATE VIEW Game_Info AS (
	SELECT SG.Game_ID,SG.Game_Date,SG.Game_Location,SG.Oppossing_Team,SG.Syracuse_Score,SG.Oppossing_Score, S.Sponsor_ID, S.Sponsor_Name
	FROM SyracuseGame SG
	JOIN Sponsor S ON SG.Sponsor_ID=S.Sponsor_ID
);
GO