USE RESTAURANT
GO

--solution: set deadlock priority to high for the second transaction
--now, T1 will be chosen as the deadlock victim, as it has a lower priority
--default priority is normal (0)

SET DEADLOCK_PRIORITY HIGH
BEGIN TRAN
-- exclusive lock on table Allergens
UPDATE Allergens SET name = 'Transaction 2' WHERE allergID = 5
WAITFOR DELAY '00:00:10'

UPDATE MenuItem SET name = 'Transaction 2' WHERE itemID = 5
COMMIT TRAN

--UPDATE Allergens SET name = 'soy' WHERE allergID = 5
--UPDATE MenuItem SET name = 'Crispy Strips' WHERE itemID = 5
