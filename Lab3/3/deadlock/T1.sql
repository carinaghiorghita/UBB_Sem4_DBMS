USE RESTAURANT
GO

--SELECT * FROM MenuItem
--SELECT * FROM Allergens

--part 1
BEGIN TRAN
--exclusive lock on table MenuItem
UPDATE MenuItem SET name = 'Transaction 1' WHERE itemID = 5
WAITFOR DELAY '00:00:10'

--this transaction will be blocked, because T2 already has an exclusive lock on Allergens
UPDATE Allergens SET name = 'Transaction 1' WHERE allergID = 5
COMMIT TRAN

