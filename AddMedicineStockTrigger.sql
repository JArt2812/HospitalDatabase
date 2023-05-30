DELIMITER %%
DROP TRIGGER IF EXISTS addStock;
CREATE TRIGGER addStock AFTER INSERT ON transactiondetail FOR EACH ROW
BEGIN

DECLARE lt CHAR(20);
DECLARE nt DATE;
DECLARE cd DATE; 

SELECT MAX(DATE) INTO nt FROM internaltransaction;
SET cd = CURDATE();
SELECT MAX(transactionID) INTO lt FROM internaltransaction;
IF (nt <> cd) THEN
INSERT INTO internaltransaction(transactionID, date)
VALUES((cast(cast(lt as INT)+1 AS CHAR(20))), cd);
END IF;

INSERT INTO stock(medicineID,expirationDate, stock)
VALUES(new.medicineID, ADDDATE(curdate(), interval 2 year), new.amount)
ON DUPLICATE KEY UPDATE stock = stock.stock + VALUES(stock);

END %%

DROP TRIGGER IF EXISTS medicineStockUpdate;
CREATE TRIGGER medicineStockUpdate AFTER INSERT ON transactiondetail FOR EACH ROW
BEGIN
	
UPDATE medicine
SET medicine.stock = medicine.stock + new.amount
WHERE medicine.medicineID = NEW.medicineID;

END %%
