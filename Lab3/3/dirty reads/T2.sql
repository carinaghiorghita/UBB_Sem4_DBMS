USE RESTAURANT
GO

--part 2: we can read uncommited data (dirty read)
SET TRAN ISOLATION LEVEL READ UNCOMMITTED
BEGIN TRAN
--see update
SELECT * FROM MenuItem
WAITFOR DELAY '00:00:05'
--update was rolled back
SELECT * FROM MenuItem
COMMIT TRAN

--UPDATE MenuItem SET name = 'Crispy Strips' WHERE itemID = 5