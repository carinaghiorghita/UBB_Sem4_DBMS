USE RESTAURANT
GO

--part 2: the row is changed while T2 is in progress, so we will see both values for price
SET TRAN ISOLATION LEVEL READ COMMITTED
BEGIN TRAN
--see first insert
SELECT * FROM MenuItem
WAITFOR DELAY '00:00:05'
--see update
SELECT * FROM MenuItem
COMMIT TRAN

--DELETE FROM MenuItem WHERE itemID=15