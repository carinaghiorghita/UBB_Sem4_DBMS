USE RESTAURANT
GO

--SELECT * FROM MenuItem
--SELECT * FROM Allergens

--part 1
BEGIN TRAN
-- exclusive lock on table Allergens
UPDATE Allergens SET name = 'Transaction 2' WHERE allergID = 5
WAITFOR DELAY '00:00:10'

--this transaction will be blocked, because T1 already has an exclusive lock on MenuItem
UPDATE MenuItem SET name = 'Transaction 2' WHERE itemID = 5
COMMIT TRAN

--this transaction will be chosen as the deadlock victim 
--and it will terminate with an error
--the tables will contain the values from T1

--UPDATE Allergens SET name = 'soy' WHERE allergID = 5
--UPDATE MenuItem SET name = 'Crispy Strips' WHERE itemID = 5
