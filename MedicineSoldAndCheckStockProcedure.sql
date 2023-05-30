DELIMITER %%
DROP PROCEDURE IF EXISTS checkAndupdateStock;
CREATE PROCEDURE checkAndupdateStock() BEGIN 
DECLARE sk INT; 
DECLARE ms INT; 
DECLARE currmed CHAR(20); 
DECLARE counter INT DEFAULT 0; 
DECLARE cm CURSOR FOR
SELECT stock, minStock, medicineID
FROM medicine; 
OPEN cm;
SELECT COUNT(stock) INTO counter
FROM medicine; 
WHILE(counter<>0) DO 
FETCH 
	cm INTO sk, ms, currmed;
	IF (sk<ms) THEN
INSERT INTO transactiondetail(amount, price, medicineID, supplierID) 
VALUES(ms, ms, currmed, CONCAT(19, SUBSTRING(currmed,3))); 
END IF; 
SET counter = counter-1 ; 
END WHILE ; 
CLOSE cm; 
END %%
DROP PROCEDURE IF EXISTS soldCount;
CREATE PROCEDURE soldCount(IN monthDesired DATE)
BEGIN
CREATE OR replace TEMPORARY TABLE tempBuyer (ID char(20),NAME CHAR(20), buyers INT);
CREATE OR REPLACE TEMPORARY TABLE goodProduct(Mname char(20),Gname CHAR(20), buyers INT);
CREATE OR REPLACE TEMPORARY TABLE badProduct(Mname char(20),Bname CHAR(20), buyers INT);
CREATE OR REPLACE TEMPORARY TABLE finalevaluation(Good CHAR(20), OK CHAR(20), Bad CHAR(20));
 
INSERT INTO tempBuyer (ID,NAME, buyers)
SELECT medicine.medicineID, medicine.name, count(customertransaction.medicineID) AS numberOfBuyer
FROM medicine LEFT JOIN customertransaction
ON medicine.medicineID = customertransaction.medicineID
AND YEAR(customertransaction.date) = YEAR(monthDesired)
AND MONTH(customertransaction.date) = MONTH(monthDesired)
GROUP BY medicine.medicineID;

INSERT INTO goodProduct (Mname,Gname, buyers)
SELECT * FROM tempBuyer WHERE buyers = (SELECT MAX(buyers) FROM tempBuyer);

INSERT INTO badProduct (Mname,Bname, buyers)
SELECT * FROM tempBuyer WHERE buyers = (SELECT MIN(buyers) FROM tempBuyer);

UPDATE medicine m, goodProduct gp
SET m.minStock = m.minStock + 5
WHERE m.medicineID = gp.Mname;

UPDATE medicine m, badProduct bp
SET m.minStock = m.minStock - 5
WHERE m.medicineID = bp.Mname AND m.minStock > 5;

SELECT * FROM tempBuyer
UNION
SELECT NULL,"GOOD:", GROUP_CONCAT(Gname SEPARATOR ', ') AS RESULT FROM goodProduct
UNION
SELECT NULL,"BAD:", GROUP_CONCAT(Bname SEPARATOR ', ') AS RESULT FROM badProduct;

 call checkAndUpdateStock();

END %%