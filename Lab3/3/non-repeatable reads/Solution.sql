USE RESTAURANT
GO

--solution: set transaction isolation level to repeatable read
SET TRAN ISOLATION LEVEL REPEATABLE READ
BEGIN TRAN
SELECT * FROM MenuItem
WAITFOR DELAY '00:00:05'
--now we see the value before the update 
SELECT * FROM MenuItem
COMMIT TRAN

--DELETE FROM MenuItem WHERE itemID=15