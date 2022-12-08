USE BD_class
GO

--validate function of a field
GO
CREATE FUNCTION validate_no_of_rooms(@noOfRooms INT)
RETURNS INT AS
BEGIN
	DECLARE @no INT
	IF @noOfRooms >= 10 and @noOfRooms <= 40
		SET @no=1
	ELSE
		SET @no=0
	RETURN @no
END


--validate function of a field
GO
CREATE FUNCTION validate_no_of_seats(@noOfSeats INT)
RETURNS INT AS
BEGIN
	DECLARE @no INT
	IF @noOfSeats >= 1000 and @noOfSeats <= 5000
		SET @no=1
	ELSE
		SET @no=0
	RETURN @no
END


--procedure that adds data in the table
GO
CREATE PROCEDURE usp_add_cinema @Cid INT,@noOfRooms INT,@noOfSeats INT
AS
	BEGIN
		IF dbo.validate_no_of_rooms(@noOfRooms) = 1 and dbo.validate_no_of_seats(@noOfSeats) = 1
		BEGIN
			INSERT INTO Cinema(Cid,NoofRooms,NoOfSeats) VALUES (@Cid,@noOfRooms,@noOfSeats)
			PRINT 'Successfully added'
		END
		ELSE 
		BEGIN 

			PRINT 'The parameters are not correct'
		END
	END
SET IDENTITY_INSERT Cinema ON
EXEC usp_add_cinema 11,20,2000
EXEC usp_add_cinema 12,13,3000
EXEC usp_add_cinema 13,16,6000
SET IDENTITY_INSERT Cinema OFF
SELECT* FROM Cinema



----validate function of a field
GO
CREATE FUNCTION validate_first_name(@firstName VARCHAR(50))
RETURNS bit AS 
BEGIN 
	DECLARE @b bit
	IF @firstName LIKE '[a-z]%[a-z]'
		SET @b = 1
	ELSE
		SET @b = 0
	RETURN @b
END

--validate function of a field
GO
CREATE FUNCTION validate_last_name(@lastName VARCHAR(50))
RETURNS bit AS 
BEGIN 
	DECLARE @b bit
	IF @lastName LIKE '[a-z]%[a-z]'
		SET @b = 1
	ELSE
		SET @b = 0
	RETURN @b
END


--validate function of a field
GO
CREATE FUNCTION validate_date_of_birth(@dateOfBirth VARCHAR(50))
RETURNS INT AS
BEGIN 
	DECLARE @valid INT
	IF ISDATE(@dateOfBirth) = 1
		SET @valid = 1
	ELSE
		SET @valid = 0
	RETURN @valid
END

---validate function of a field
GO
CREATE FUNCTION validate_nationality(@nationality VARCHAR(50))
RETURNS bit AS 
BEGIN 
	DECLARE @b bit
	IF @nationality LIKE '[a-z]%[a-z]'
		SET @b = 1
	ELSE
		SET @b = 0
	RETURN @b
END


--procedure that adds data in the table
GO
CREATE PROCEDURE usp_add_actor @Aid INT,@firstName VARCHAR(50),@lastName VARCHAR(50),@dateOfBirth VARCHAR(50),@nationality VARCHAR(50)
AS
	BEGIN
		IF dbo.validate_first_name(@firstName) = 1 and dbo.validate_last_name(@lastName) = 1 and dbo.validate_date_of_birth(@dateOfBirth) = 1 and dbo.validate_nationality(@nationality) = 1
		BEGIN
			INSERT INTO Actor(Aid,FirstName,LastName,DateOfBirth,Nationality) VALUES (@Aid,@firstName,@lastName,@dateOfBirth,@nationality)
			PRINT 'Successfully added'
		END
		ELSE 
		BEGIN 
			PRINT 'The parameters are not correct'
		END
	END
SET IDENTITY_INSERT Actor ON
EXEC usp_add_actor 11,'Emilia','Clarke','1992-05-11','SUA'
EXEC usp_add_actor 12,'Robert','De Niro','1942-02-20','SUA'
EXEC usp_add_actor 13,'Will','Smith','1990-02-30','UK' 
SELECT *FROM Actor



--view
GO
CREATE VIEW view_actor 
AS
	SELECT A.FirstName,A.LastName
	FROM Actor A
	INNER JOIN Acts_in AI ON AI.Aid = A.Aid
	INNER JOIN Film F ON F.Fid = AI.Fid
	INNER JOIN Characterises C ON C.Fid = F.Fid
	INNER JOIN Genre G ON G.Gid = C.Gid AND G.Category = 'romance'
SELECT *FROM view_actor




/*
TRIGGERS
*/



--create table of triggers
CREATE TABLE Logs
(Lid INT NOT NULL,TriggerDate DATE, TriggerType VARCHAR(50), NameAffectedTable VARCHAR(50), NoAMDRows INT);

CREATE TABLE Cinema_copy
(Cid INT NOT NULL,NoofRooms INT,NoOfSeats INT);

CREATE TABLE Actor_copy
(Aid INT NOT NULL,FirstName VARCHAR(50),LastName VARCHAR(50),DateOfBirth VARCHAR(50),Nationality VARCHAR(20));


--the trigger that adds in same time data in tables
GO
CREATE TRIGGER add_cinema ON Cinema
FOR INSERT 
AS
BEGIN
	INSERT INTO Cinema_copy(Cid,NoOfRooms,NoOfSeats)
	SELECT Cid,NoOfRooms,NoOfSeats
	FROM inserted
	INSERT INTO Logs(Lid,TriggerDate, TriggerType, NameAffectedTable, NoAMDRows) VALUES (1,GETDATE(), 'INSERT', 'Cinema', @@ROWCOUNT)
END

SET IDENTITY_INSERT Cinema ON
SET IDENTITY_INSERT Cinema OFF
INSERT INTO Cinema (Cid,NoofRooms,NoOfSeats) VALUES (12,13,3000)
INSERT INTO Cinema (Cid,NoofRooms,NoOfSeats) VALUES (13,11,5000)
SELECT *FROM Cinema
SELECT *FROM Cinema_copy
SELECT *FROM Logs



--trigger that deletes in same time data from tables

GO
CREATE TRIGGER remove_cinema ON Cinema
FOR DELETE 
AS
BEGIN
	DELETE FROM Cinema_copy
	WHERE Cid = (SELECT Cid FROM deleted)
	INSERT INTO Logs(Lid,TriggerDate, TriggerType, NameAffectedTable, NoAMDRows) VALUES (2,GETDATE(), 'DELETE', 'Cinema', @@ROWCOUNT)
END

DELETE FROM Cinema
WHERE Cid = 13

SELECT *FROM Cinema
SELECT *FROM Cinema_copy
SELECT *FROM Logs



--trigger that updates in same time data from tables
GO
CREATE TRIGGER update_cinema ON Cinema
FOR UPDATE 
AS
BEGIN
	UPDATE Cinema_copy
	SET NoOfSeats = (SELECT NoOfSeats FROM inserted),NoofRooms = (SELECT NoofRooms FROM inserted)
	WHERE Cid = (SELECT Cid FROM inserted)
	INSERT INTO Logs(Lid,TriggerDate, TriggerType, NameAffectedTable, NoAMDRows) VALUES (3,GETDATE(), 'UPDATE', 'Cinema', @@ROWCOUNT)
END

UPDATE Cinema
SET NoOfSeats = 500
WHERE Cid = 13
DROP TRIGGER update_cinema

SELECT *FROM Cinema
SELECT *FROM Cinema_copy
SELECT *FROM Logs


--the trigger that adds in same time data in tables
GO
CREATE TRIGGER add_actor ON Actor
FOR INSERT 
AS
BEGIN
	INSERT INTO Actor_copy(Aid,FirstName,LastName,DateOfBirth,Nationality)
	SELECT Aid,FirstName,LastName,DateOfBirth,Nationality
	FROM inserted
	INSERT INTO Logs(Lid,TriggerDate, TriggerType, NameAffectedTable, NoAMDRows) VALUES (4,GETDATE(), 'INSERT', 'Actor', @@ROWCOUNT)
END

SET IDENTITY_INSERT Cinema_copy ON
SET IDENTITY_INSERT Cinema_copy OFF

SET IDENTITY_INSERT Actor ON
SET IDENTITY_INSERT Actor OFF
INSERT INTO Actor (Aid,FirstName,LastName,DateOfBirth,Nationality) VALUES (13,'Rodica','Bitanescu','1976-08-01','RO')
SELECT *FROM Actor
SELECT *FROM Actor_copy
SELECT *FROM Logs


--the trigger that updates in same time data in tables
GO
CREATE TRIGGER update_actor ON Actor
FOR UPDATE 
AS
BEGIN
	UPDATE Actor_copy
	SET FirstName = (SELECT FirstName FROM inserted)
	WHERE Aid = (SELECT Aid FROM inserted)
	INSERT INTO Logs(Lid,TriggerDate, TriggerType, NameAffectedTable, NoAMDRows) VALUES (3,GETDATE(), 'UPDATE', 'Actor', @@ROWCOUNT)
END

UPDATE Actor
SET FirstName = 'Sofia'
WHERE Aid = 13


/*
CHECKES AND INDEXES
*/

--checks
SELECT * FROM sys.sql_modules
IF object_id('Cinema') IS NOT NULL
	PRINT 'The table Cinema exists!'
ELSE 
	PRINT 'The table Cinema does not exists!'


IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.VIEWS WHERE TABLE_NAME = N'view_actor') 
BEGIN
	PRINT 'The view exists!'
END 



--indexes
CREATE NONCLUSTERED INDEX N_idx_NoOfRooms ON Cinema(NoOfRooms); 
GO

SELECT * FROM Cinema
ORDER BY Cid

SELECT * FROM Cinema
ORDER BY NoofRooms

