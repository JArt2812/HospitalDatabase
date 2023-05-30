DROP DATABASE IF EXISTS Hospital;
CREATE DATABASE Hospital;
CREATE TABLE Employee (
	employeeID char(8),
	firstName varchar(25),
	middleName varchar(25),
	lastName varchar(25),
	gender varchar(6),
	phoneNumber char(20),
	address varchar(255),
	salary decimal,
	birthDate date,
	dateJoined date,
	PRIMARY KEY (employeeID)
);
CREATE TABLE Doctor (
specialty varchar(100),
doctorID char(8) REFERENCES Employee(employeeID)
);
CREATE TABLE Nurse (
	yearsOfExperience int,
	nurseID char(8) REFERENCES Employee(employeeID)
);
CREATE TABLE MiscWorker (
	type varchar(100),
	workerID char(8) REFERENCES Employee(employeeID)
);
CREATE TABLE DoctorSchedule (
	doctorID char(8),
	dayOfShift char(9),
	startShift time,
	endShift time,
	FOREIGN KEY (doctorID) REFERENCES Doctor(doctorID)
);
CREATE TABLE Patient (
	patientID char(8),
	f_name varchar(25),
	m_name varchar(25),
	l_name varchar(25),
	Gender char(6),
	address varchar(255),
	homephone char(20),
	cellphonenumber char(20),
	PRIMARY KEY (patientID)
);
CREATE TABLE Block (
	blockCode char(4),
	blockFloor int,
	PRIMARY KEY (blockCode)
);

CREATE TABLE RoomDetail (
	roomType int,
	class varchar(25),
	pricePerDay decimal,
	PRIMARY KEY (roomType)
);

CREATE TABLE Room (
	roomNumber char(3),
	roomType int,
	blockCode char(4),
	status varchar(8),
	PRIMARY KEY (roomNumber),
	FOREIGN KEY (blockCode) REFERENCES Block(blockCode),
	FOREIGN KEY (roomType) REFERENCES RoomDetail(roomType)
);

CREATE TABLE Treatment (
	treatmentID char(5),
	name varchar(100),
	cost decimal,
	PRIMARY KEY (treatmentID)
);

CREATE OR REPLACE TABLE Appointment (
	appointmentID char(10),
	startTime time,
	endTime time,
	date date,
	patientID char(8),
	doctorID char(8),
	treatmentID char(5),
	PRIMARY KEY (appointmentID),
	FOREIGN KEY (patientID) REFERENCES Patient(patientID),
	FOREIGN KEY (doctorID) REFERENCES Doctor(doctorID),
	FOREIGN KEY (treatmentID ) REFERENCES Treatment(treatmentID)
);

CREATE TABLE StandBy (
	nurseID char(8),
	dayOfShift char(9),
	blockCode char(4),
	oncallStart time,
	oncallEnd time,
	FOREIGN KEY (blockCode) REFERENCES Block(blockCode),
	FOREIGN KEY (nurseID) REFERENCES Nurse(nurseID),
	PRIMARY KEY (nurseID,dayOfShift)
);

CREATE TABLE TrainedIn (
	doctorID char(8),
	treatmentID char(5),
	certificationDate date,
	certificationExpires date,
	FOREIGN KEY (doctorID) REFERENCES Doctor(doctorID),
	FOREIGN KEY (treatmentID) REFERENCES Treatment(treatmentID),
	PRIMARY KEY(doctorID, treatmentID)
);

CREATE TABLE Department (
	departmentID char(6),
	name varchar(100),
	head char(8),
	PRIMARY KEY (departmentID),
	FOREIGN KEY (head) REFERENCES Doctor(doctorID)
);

CREATE TABLE AffiliatedWith (
	doctorID char(8),
	departmentID char(6),
	primaryAffiliation varchar(100),
	FOREIGN KEY (doctorID) REFERENCES Doctor(doctorID),
	FOREIGN KEY (departmentID) REFERENCES Department(departmentID),
	PRIMARY KEY (doctorID, departmentID)
);
CREATE TABLE Medicine (
	medicineID char(4),
	stock int,
	name varchar(100),
	brand varchar(100),
	description varchar(255),
	price decimal,
	minStock int,
	PRIMARY KEY (medicineID)
);

CREATE TABLE Prescribes (
	doctorID char(8),
	patientID char(8),
	medicineID char(4),
	date date,
	amount int,
	FOREIGN KEY (doctorID) REFERENCES Doctor(doctorID),
	FOREIGN KEY (patientID) REFERENCES Patient(patientID),
	FOREIGN KEY (medicineID) REFERENCES Medicine(medicineID),
	PRIMARY KEY (doctorID, patientID, date)
);
CREATE TABLE Stock (
	medicineID char(4),
	expirationDate date,
	stock int,
	FOREIGN KEY (medicineID) REFERENCES Medicine(medicineID),
	PRIMARY KEY (medicineID, expirationDate)
);
CREATE TABLE Supplier (
	supplierID char(4),
	name varchar(100),
	phoneNumber char(20),
	location varchar(100),
	PRIMARY KEY (supplierID)
);
CREATE TABLE TransactionDetail (
	amount int,
	price decimal,
	medicineID char(4),
	supplierID char(4),
	FOREIGN KEY (medicineID) REFERENCES Medicine(medicineID),
	FOREIGN KEY (supplierID) REFERENCES Supplier(supplierID)
);
CREATE TABLE InternalTransaction (
	transactionID char(7) DEFAULT 1120000,
	date date,
	PRIMARY KEY (transactionID)
);

CREATE TABLE StaysIn (
	stayID char(9),
	patientID char(8),
	roomNumber char(3),
	nurseID char(8), 
	startDate date,
	endDate date,
	FOREIGN KEY (patientID) REFERENCES Patient(patientID),
	FOREIGN KEY (roomNumber) REFERENCES Room(roomNumber),
	FOREIGN KEY (nurseID) REFERENCES Nurse(nurseID),
	PRIMARY KEY (stayID)
);

CREATE TABLE CustomerTransaction (
	customerTransactionID char(8),
	medicineID char(4),
	treatmentID char(5),
	stayID char(9),
	patientID char(8),
	date date,
	time time,
	transactionMethod varchar(25),
	discount decimal,
	FOREIGN KEY (medicineID) REFERENCES Medicine(medicineID),
	FOREIGN KEY (treatmentID) REFERENCES Treatment(treatmentID),
	FOREIGN KEY (stayID) REFERENCES StaysIn(stayID),
	FOREIGN KEY (patientID) REFERENCES Patient(patientID),
	PRIMARY KEY (customerTransactionID)
);





INSERT INTO Employee(employeeID,firstName,middleName,lastName,gender,phoneNumber,address, salary, birthDate, dateJoined)
VALUES 
("20170101","Albert",NULL,"Terios","Male","+62-838-555-762","Taman Golf",NULL,'1990-10-29','2017-08-28'),
("20160102","Pixel",NULL,"Terios","Male","+62-838-555-822","Taman Parahyangan",NULL,'1979-07-05','2016-05-19'),
("20140107","Arthur",NULL,"Jason","Male","+62-878-555-975","Jl. Permata Timur",NULL,'1985-11-03','2014-10-27'),
("20100113","Peter",NULL,"Iskandar","Male","+62-813-555-100","Taman Kencana",NULL,'1988-08-11','2010-05-29'),
("20140115","Marcellinus","Aditya","Witarsah","Male","+62-899-555-465","Jl. Gajah Mada",NULL,'1990-11-08','2014-12-15'),
("20110116","Matthew",NULL,"Mackinson","Male","+62-896-555-128","Jl. Citra",NULL,'1989-05-27','2011-02-18'),
("20170119","Udin",NULL,"Hasan","Male","+62-838-555-243","Jl. Diponegoro",NULL,'1988-06-17','2017-11-26'),
("20110120","Budi",NULL,"Utomo","Male","+62-897-555-155","Jl. Merdeka",NULL,'1987-01-09','2011-10-09'),
("20120124","Fadil",NULL,"Mohammad","Male","+62-838-555-392","Jl. Basuki Rahmat",NULL,'1985-03-14','2012-04-03'),
("20120127","Fendi",NULL,"Muhammad","Male","+62-838-555-999","Jl. Rahmat Basuki",NULL,'1980-01-26','2012-04-03');



INSERT INTO Doctor(doctorID,specialty)
VALUES 
("20170101","Skin"),
("20160102","Eye"),
("20140107","ENT"),
("20100113","Brain"),
("20140115","Child"),
("20110116","Skin"),
("20170119","Heart"),
("20110120","Skin"),
("20120124","Bone"),
("20120127","Bone");

INSERT INTO
Employee(employeeID, firstName, middleName, lastName, gender, phoneNumber, address, salary, birthDate, dateJoined)
VALUES
("20100227", "Yohanes", NULL, "Terangbumi", "Male", "+62-858-555-465", "Jl. Kartini", NULL,'1989-1-15', '2010-09-11'), 
("20130228", "Bambang", NULL, "Kisno", "Male", "+62-838-555-486", "Jl. Hangtuah", NULL,'1995-9-10', '2013-09-08'),
("20140232", "Celine", NULL, "Hidayat", "Female", "+62-855-555-328", "Jl. Tanjung Balai", NULL,'1990-12-1', '2014-03-17'),
("20130233", "Michelle", NULL, "Callista" ,"Female" , "+62-856-555-281", "Jl. Sri Tanjung", NULL,'2000-2-25', '2013-12-25'),
("20120236", "Riah", "Putri", "Hartono", "Female", "+62-856-555-982", "Jl. MT. Haryono", NULL,'1997-5-8', '2012-02-14');

INSERT INTO nurse(NurseID, yearsOfExperience)
VALUES
("20100227",10),
("20130228",5),
("20140232",7),
("20130233",2),
("20120236",1);

INSERT INTO
Patient (patientID, f_name, m_name, l_name, Gender, address, homephone, cellphonenumber)
VALUES
("20200300","Skiven",NULL,"Albertos","Male","Jl. Jokowi","021-601-455 "
,"+62-878-555-72"),
("20200301","Aran",NULL,"Dotson","Male","Jl. Pembangunan","0771-31045"
,"+62-855-555-635"),
("20200302","Margie",NULL,"Rawlings","Female","Jl. Nagoya","0772-31011"
,"+62-857-555-166"),
("20200303","Debra",NULL,"Khan","Female","Jl. Imam Bonjol","021-5446355"
,"+62-856-555-779"),
("20200304","Erica",NULL,"Edmonds","Female","Jl. Pendidikan","021-8197310"
,"+62-878-555-166"),
("20200309","Maria",NULL,"Peterson","Female","Jl. Melati","021-56712910"
,"+62-878-541-123"),
("20200310","Edward","James","Cullen","Male","Jl. Parahyangan","021-70456615"
,"+62-812-430-216"),
("20200311","Barry",NULL,"Woods","Male","Jl. Mawar","021-50402310"
,"+62-813-045-334"),
("20200315","Aaron",NULL,"Stokes","Male","Jl. Pengajaran","021-8197310"
,"+62-867-555-776"),
("20200399","Sherlock",NULL,"Holmes","Male","Jl. Bakers","021-5642318"
,"+62-867-555-777"),
("20200364","Rodney",NULL,"Piekarski","Male","Jl. Daan Mogot","021-1573214"
,"+62-855-555-276"),
("20200366","Larue",NULL,"Dedman","Female","Jl. Dewi Sartika","021-1234515"
,"+62-814-555-278"),
("20200333","Renae",NULL,"Critelli","Female","Jl. Halim perdanakusuma","021-7894152"
,"+62-814-555-278"),
("20200314","Sean",NULL,"Legrande","Male","Jl. Hayam Wuruk","021-13657512"
,"+62-838-555-333"),
("20200346","Forrest",NULL,"Dewolfe","Male","Jl. Jelakeng","021-3254785"
,"+62-855-555-721"),
("20200355","Oswaldo",NULL,"Martone","Male","Jl. Jenderal Ahmad Yani","021-1452789"
,"+62-854-555-599"),
("20200374","Elida",NULL,"Rodd","Female","Jl. Jenderal Gatot Subroto","021-4521563"
,"+62-838-555-059"),
("20200377","Rubye",NULL,"Kropf","Female","Jl. Jenderal Sudirman","021-3652145"
,"+62-878-555-271"),
("20200388","Cheryll",NULL,"Unruh","Female","Jl. Laksamana Yos Sudarso","021-9658748"
,"+62-811-555-448"),
("20200332","Chau",NULL,"Massi","Female","Jl. M.H.Thamrin","021-8569325"
,"+62-754-451-487"),
("20200322","Earnest",NULL,"Rivers","Male","Jl. Medan Merdeka","021-32146569"
,"+62-825-548-625"),
("20200344","Edison",NULL,"Seeger","Male","Jl. Prapatan","021-7412585"
,"+62-826-547-521"),
("20200341","Amos",NULL,"Old","Male","Jl. Raya Bogor","021-963258"
,"+62-836-471-541");




INSERT INTO
Block (blockCode,blockFloor)
VALUES
("1001",1),
("1002",1),
("2001",2),
("2002",2),
("3001",3),
("3002",3);

INSERT INTO
RoomDetail(roomType, class, pricePerDay)
VALUES
("1","Regular", 1000),
("2","VIP", 3000);


INSERT INTO
Room (roomNumber, roomType, blockCode, status)
VALUES
("101",1,"1001","vacant"),
("102",1,"1002","vacant"),
("103",1,"1001","occupied"),
("201",1,"2001","occupied"),
("202",2,"2002","occupied"),
("203",2,"2002","vacant"),
("301",2,"3001","vacant"),
("302",2,"3001","occupied"),
("303",2,"3002","occupied");

INSERT INTO Treatment(TreatmentID,name,cost)
VALUES
("72001","skinGraph", 2300),
("72002","plasticSurgery",3200),
("72003","X-Ray",2700),
("72004","heartSurgery",10000),
("72005","eyeSurgery",5000),
("72006","brainSurgery",15000),
("72007","BoneFractureRepair",3000),
("72008","Consultation",50);


INSERT INTO
Appointment(appointmentID,startTime,endTime,date,patientID,doctorID,TreatmentID)
VALUES
("2002151601",'13:00:00','18:00:00','2020-04-25',"20200315","20110116","72001"),
("2000013201",'1:00:00','15:00:00','2020-05-12',"20200300","20170101","72002"),
("2002012701",'3:00:00','17:00:00','2020-07-14',"20200302","20170101","72002"),
("2000012703",'4:00:00','20:00:00','2020-08-21',"20200300","20170101","72002"),
("2004163303",'9:00:00','15:00:00','2020-08-20',"20200304","20110116","72002"),
("2002203302",'9:00:00','13:00:00','2020-08-20',"20200302","20110120","72001"),
("2000203203",'13:00:00','16:00:00','2020-08-20',"20200300","20110120","72001"),
("2002203202",'9:00:00','10:00:00','2020-08-24',"20200302","20110120","72008"),
("2004163301",'10:00:00','11:00:00','2020-08-25',"20200304","20110116","72002"),
("2000013205",'6:00:00','18:00:00','2020-08-27',"20200399","20170119","72004"),
("2000013206",'6:00:00','18:00:00','2020-08-29',"20200364","20120127","72007"),
("2000013207",'11:00:00','12:00:00','2020-08-30',"20200366","20140107","72008"),
("2000013209",'11:00:00','12:00:00','2020-08-31',"20200333","20140107","72008"),
("2002012711",'10:00:00','12:00:00','2020-09-02',"20200314","20140107","72008"),
("2002012722",'13:00:00','14:00:00','2020-09-02',"20200309","20170119","72008"),
("2002012788",'10:00:00','11:00:00','2020-09-03',"20200310","20160102","72008"),
("2002032144",'12:00:00','15:00:00','2020-09-05',"20200310","20160102","72005"),
("2002046574",'9:00:00','12:00:00','2020-09-05',"20200309","20170119","72004"),
("2002015487",'9:00:00','12:00:00','2020-09-07',"20200311","20120124","72007"),
("2002012799",'10:00:00','12:00:00','2020-09-10',"20200399","20140115","72008"),
("2004163316",'6:00:00','18:00:00','2020-09-13',"20200322","20120127","72007"),
("2004163341",'9:00:00','13:00:00','2020-09-14',"20200344","20120124","72007"),
("2004163378",'6:00:00','12:00:00','2020-09-19',"20200341","20120127","72007"),
("2004163398",'12:00:00','18:00:00','2020-09-20',"20200300","20120127","72007"),
("2004163399",'10:00:00','18:00:00','2020-09-21',"20200303","20100113","72006"),
("2002203333",'14:00:00','16:00:00','2020-09-22',"20200304","20140115","72008"),
("2002203352",'12:00:00','14:00:00','2020-09-24',"20200309","20140115","72008"),
("2002203377",'12:00:00','18:00:00','2020-09-25',"20200310","20100113","72008"),
("2002203388",'9:00:00','13:00:00','2020-09-28',"20200311","20170119","72008"),
("2002203399",'10:00:00','13:00:00','2020-09-29',"20200315","20160102","72008"),
("2002203341",'14:00:00','17:00:00','2020-09-30',"20200399","20120124","72008");


INSERT INTO
DoctorSchedule (doctorID,dayOfShift,startShift,endShift)
VALUES
("20170101","Monday",'8:00:00','12:00:00'),
("20170101","Tuesday",'1:00:00','17:00:00'),
("20170101","Thursday",'4:00:00','20:00:00'),
("20170101","Saturday",'9:00:00','13:00:00'),
("20110116","Tuesday",'10:00:00','14:00:00'),
("20110116","Wednesday",'12:00:00','18:00:00'),
("20110116","Thursday",'9:00:00','15:00:00'),
("20110120","Monday",'9:00:00','16:00:00'),
("20110120","Wednesday",'9:00:00','16:00:00'),
("20110120","Thursday",'9:00:00','16:00:00'),
("20110120","Friday",'9:00:00','16:00:00'),
("20110120","Sunday",'11:00:00','17:00:00'),
("20170119","Monday",'6:00:00','18:00:00'),
("20170119","Wednesday",'6:00:00','18:00:00'),
("20170119","Friday",'6:00:00','18:00:00'),
("20170119","Saturday",'9:00:00','12:00:00'),
("20160102","Tuesday",'9:00:00','16:00:00'),
("20160102","Thursday",'9:00:00','13:00:00'),
("20160102","Saturday",'12:00:00','16:00:00'),
("20120124","Monday",'9:00:00','13:00:00'),
("20120124","Wednesday",'13:00:00','17:00:00'),
("20120127","Thursday",'6:00:00','18:00:00'),
("20120127","Friday",'6:00:00','18:00:00'),
("20120127","Saturday",'6:00:00','18:00:00'),
("20120127","Sunday",'6:00:00','18:00:00'),
("20100113","Monday",'10:00:00','18:00:00'),
("20100113","Wednesday",'10:00:00','18:00:00'),
("20100113","Friday",'10:00:00','18:00:00'),
("20140115","Tuesday",'10:00:00','16:00:00'),
("20140115","Thursday",'10:00:00','16:00:00'),
("20140115","Saturday",'10:00:00','16:00:00'),
("20140107","Monday",'10:00:00','16:00:00'),
("20140107","Tuesday",'10:00:00','16:00:00'),
("20140107","Wednesday",'10:00:00','16:00:00'),
("20140107","Thursday",'10:00:00','16:00:00'),
("20140107","Friday",'10:00:00','16:00:00'),
("20140107","saturday",'10:00:00','16:00:00'),
("20140107","Sunday",'10:00:00','16:00:00');


INSERT INTO
Medicine(medicineID, stock, name, brand, description, price, minstock)
VALUES
("1301",100,"Mudrock","Dolap","Pain Killer",10,10),
("1302",89,"Fireash","Dolap","For Cold",16,25),
("1303",18,"Feeder","Dopa","For Upset Stomach",13,20),
("1304",24,"Ezicure","Dopa","Paracetamol",14,25),
("1305",69,"SKP-682","SKP","Antibiotic",15,25),
("1306",47,"SKP-166","SKP","Alleviate Muscle Pain",19,15);



INSERT INTO trainedin(DoctorID,treatmentID,certificationDate,certificationExpires)
VALUES
("20170101","72001",'2014-07-09','2019-07-09'),
("20160102","72001",'2015-03-10','2020-03-10'),
("20140107","72003",'2013-09-07','2018-09-07');

INSERT INTO
StaysIn(stayID, patientID, roomNumber, nurseID, startDate, endDate)
VALUES
("200509003","20200309","101","20100227",'2020-09-05','2020-09-08'), ("200409005","20200310","103","20140232",'2020-09-05','2020-09-12'), ("200709001","20200311","202","20130233",'2020-09-07','2020-09-11');

INSERT INTO
CustomerTransaction(customerTransactionID, medicineID, treatmentID, stayID, patientID, date, time, transactionMethod, discount)
VALUES
("20042515",NULL,"72001",NULL,"20200315",'2020-04-25','18:00:00',"creditcard",0),
("20051231","1305","72002",NULL,"20200300",'2020-05-12','15:00:00',"creditcard",10),
("20071445","1305","72002",NULL,"20200302",'2020-07-14','17:00:00',"creditcard",0),
("20082070","1305","72002",NULL,"20200300",'2020-08-21','20:00:00',"creditcard",5),
("20082029","1305","72002",NULL,"20200304",'2020-08-20','15:00:00',"debitcard",0),
("20082023","1304","72001",NULL,"20200302",'2020-08-20','13:00:00',"creditcard",0),
("20082039","1304","72001",NULL,"20200300",'2020-08-20','16:00:00',"creditcard",0),
("20082419",NULL,"72008",NULL,"20200302",'2020-08-24','10:00:00',"creditcard",5),
("20082517","1305","72002",NULL,"20200304",'2020-08-25','11:00:00',"debitcard",0),
("20082765","1301","72004",NULL,"20200399",'2020-08-27','18:00:00',"creditcard",0),
("20082954","1306","72007",NULL,"20200364",'2020-08-29','18:00:00',"debitcard",0),
("20083016",NULL,"72008",NULL,"20200366",'2020-08-30','12:00:00',"creditcard",5),
("20083115",NULL,"72008",NULL,"20200333",'2020-08-31','12:00:00',"creditcard",0),
("20090213",NULL,"72008",NULL,"20200314",'2020-09-02','12:00:00',"creditcard",0),
("20090227",NULL,"72008",NULL,"20200309",'2020-09-02','14:00:00',"debitcard",0),
("20090308",NULL,"72008",NULL,"20200310",'2020-09-03','11:00:00',"creditcard",0),
("20090826","1301","72004","200409005","20200309",'2020-09-08','13:00:00',"debitcard",5),
("20091018",NULL,"72008",NULL,"20200399",'2020-09-10','12:00:00',"creditcard",0),
("20091114","1306","72007","200709001","20200311",'2020-09-11','11:00:00',"creditcard",0),
("20091215","1301","72005","200509003","20200310",'2020-09-12','12:00:00',"creditcard",0),
("20091341","1306","72007",NULL,"20200322",'2020-09-13','18:00:00',"creditcard",0),
("20091412","1306","72007",NULL,"20200344",'2020-09-14','13:00:00',"creditcard",0),
("20091916","1306","72007",NULL,"20200341",'2020-09-19','12:00:00',"creditcard",10),
("20092038","1306","72007",NULL,"20200300",'2020-09-20','18:00:00',"creditcard",0),
("20092135","1304","72006",NULL,"20200303",'2020-09-21','18:00:00',"creditcard",0),
("20092228",NULL,"72008",NULL,"20200304",'2020-09-22','16:00:00',"creditcard",0),
("20092418",NULL,"72008",NULL,"20200309",'2020-09-24','14:00:00',"debitcard",10),
("20092533",NULL,"72008",NULL,"20200310",'2020-09-25','18:00:00',"creditcard",0),
("20092811",NULL,"72008",NULL,"20200311",'2020-09-28','13:00:00',"creditcard",0),
("20092910",NULL,"72008",NULL,"20200315",'2020-09-29','13:00:00',"debitcard",0),
("20093034",NULL,"72008",NULL,"20200399",'2020-09-30','17:00:00',"creditcard",5);




INSERT INTO
Prescribes(doctorID, patientID, medicineID, date, amount)
VALUES
("20170101", "20200300", "1305", '2020-05-12', 1),
("20170101", "20200302", "1305", '2020-07-14', 2),
("20170101", "20200300", "1305", '2020-08-21', 1),
("20110116", "20200304", "1305", '2020-08-20', 3),
("20110120", "20200302", "1304", '2020-08-20', 1),
("20110120", "20200300", "1304", '2020-08-20', 2),
("20110116", "20200304", "1305", '2020-08-25', 1),
("20170119", "20200399", "1301", '2020-08-27', 1),
("20120127", "20200364", "1306", '2020-08-29', 3),
("20160102", "20200310", "1301", '2020-09-05', 2),
("20170119", "20200309", "1301", '2020-09-05', 3),
("20120124", "20200311", "1306", '2020-09-07', 2),
("20120127", "20200322", "1306", '2020-09-13', 2),
("20120124", "20200344", "1306", '2020-09-14', 4),
("20120127", "20200341", "1306", '2020-09-19', 3),
("20120127", "20200300", "1306", '2020-09-20', 2),
("20100113", "20200303", "1304", '2020-09-21', 1);


INSERT INTO supplier (supplierID, name, phoneNumber, location)
VALUES
("1901", "Pt. BamiCinder", "+62-838-555-111", "Taman Macan"),
("1902", "Pt. FortyFive", "+62-838-555-322", "Taman Kencana"),
("1903", "Pt. WoodID", "+62-838-555-853", "Jl. Murapati"),
("1904", "Pt. WeCure", "+62-838-555-821", "Jl. Patimura"),
("1905", "Pt. Happylife", "+62-838-985-135", "Jl. Permata Utara"),
("1906", "Pt. ATS", "+62-838-895-003", "Jl. Pertama");

INSERT INTO INTERNALTRANSACTION (transactionID, date)
VALUES
("1120000", '2020-00-00');

Insert into department (departmentID,name,head)
Values
("416001","Cardiology","20170119"),
("416002","Opthalmology","20160102"),
("416003","Orthopaedics","20120124"),
("416004","Neurology","20100113"),
("416005","ENT","20140107"),
("416006","Skin","20110116"),
("416007","Child","20140115");


Insert into StandBy (nurseID,dayOfShift,blockCode,oncallStart,oncallEnd)
values 
("20100227","Monday","1001",'12:00:00','15:00:00'),
("20130228","Wednesday","1002",'19:00:00','23:00:00'),
("20140232","Thursday","2001",'5:00:00','12:00:00'),
("20130233","Sunday","2002",'3:00:00','8:00:00'),
("20120236","Saturday","3001",'8:00:00','14:00:00'),
("20100227","Friday","3002",'17:00:00','21:00:00'),
("20130228","Tuesday","2001",'15:00:00','20:00:00');

Insert into AffiliatedWith (doctorID,departmentID,primaryAffiliation)
Values
("20170101","416006","TRUE"),
("20160102","416002","TRUE"),
("20140107","416005","TRUE"),
("20100113","416004","TRUE"),
("20140115","416007","TRUE"),
("20110116","416006","FALSE"),
("20170119","416001","TRUE"),
("20110120","416006","FALSE"),
("20120124","416003","TRUE"),
("20120127","416003","FALSE");

Insert into employee(employeeID,firstName,middleName,lastName,gender,phoneNumber,address,salary,birthDate,dateJoined)
Values
("20150037","Tiffany",NULL,"Felicita","Female","+62-812-9050-6742","Jl. Delima",34000,'1988-07-03','2015-06-11'),
("20190039","Fransisca","Dwi","Halim","Female","+62-823-5648-3397","Jl. Curug",33600,'1992-12-15','2019-09-16'),
("20090043","Andreas",NULL,"Saputra","Male","+62-815-4534-9965","Jl. Sumatera",33600,'1980-04-27','2009-02-09'),
("20110047","Diana",NULL,"Putri","Female","+62-818-3009-2787","Jl. Soeharto",34000,'1982-09-09','2011-03-01'),
("20170050","Intan",NULL,"Simanjuntak","Female","+62-822-7765-9234","Jl. Pascal",34000,'1991-06-18','2017-06-21'),
("20120051","Nicholas",NULL,"Wijaya","Male","+62-858-6713-2054","Jl. Darwin",33600,'1986-08-20','2012-04-23');

Insert into miscworker(workerID, type)
Values
("20150037","Cleaner"),
("20190039","Security"),
("20090043","Security"),
("20110047","Cleaner"),
("20170050","Cleaner"),
("20120051","Security");


INSERT INTO TRANSACTIONDETAIL (medicineID, amount, price, supplierID)
VALUES

