USE RESTAURANT
GO

--solution: set transaction isolation level to serializable
SET TRAN ISOLATION LEVEL SERIALIZABLE
BEGIN TRAN
SELECT * FROM MenuItem
WAITFOR DELAY '00:00:05'
SELECT * FROM MenuItem
COMMIT TRAN