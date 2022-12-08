USE BD_class



CREATE TABLE Versions
(Vid INT PRIMARY KEY IDENTITY,
[version] INT);


/*
GO
CREATE PROCEDURE name_procedure
--the list of parameters
AS
BEGIN
--the code
END;
*/


--procedure that adds a column
GO
CREATE PROCEDURE usp_add_new_column 
AS
BEGIN
ALTER TABLE Cinema
ADD [Location] VARCHAR(50)
PRINT 'Column Location has been added in table Cinema'

	UPDATE Versions
	SET version = 1;
END
--EXEC usp_add_new_column


--procedure that deletes a column
GO
CREATE PROCEDURE usp_remove_new_column
AS
BEGIN
	ALTER TABLE Cinema
	DROP COLUMN [Location]
	PRINT 'Column Location has been deleted from table Cinema'

	UPDATE Versions
	SET version = 0;
END 
--EXEC usp_remove_new_column


--procedure that creates a table
GO
CREATE PROCEDURE usp_create_table
AS
BEGIN
	CREATE TABLE Film_Premiere
	(Pid INT NOT NULL,
	NoOfParticipants INT,
	[Location] VARCHAR(50))
	PRINT 'Table Film_Premiere has been created'

	UPDATE Versions
	SET version = 2;
END
--EXEC usp_create_table


--procedure that deletes a table
GO
CREATE PROCEDURE usp_remove_table
AS
BEGIN
	DROP TABLE Film_Premiere
	PRINT 'Table Film_Premiere has been deleted'

	UPDATE Versions
	SET version = 1;
END
--EXEC usp_remove_table


--procedure that adds a primary key
GO
CREATE PROCEDURE usp_add_pk_constraint
AS
BEGIN
	ALTER TABLE Film_Premiere
	ADD CONSTRAINT pk_Film_Premiere PRIMARY KEY(Pid)
	PRINT 'A primary key has been added in table Film_Premiere'

	UPDATE Versions
	SET version = 3;
END
--EXEC usp_add_pk_constraint


--procedure that deletes a primary key
GO
CREATE PROCEDURE usp_remove_pk_constraint
AS
BEGIN
	ALTER TABLE Film_Premiere
	DROP CONSTRAINT pk_Film_Premiere
	PRINT 'The primary key has been deleted from table Film_Premiere'

	UPDATE Versions
	SET version = 2;
END
--EXEC usp_remove_pk_constraint

--procedure that adds a foreign key
GO
CREATE PROCEDURE usp_add_fk_constraint
AS
BEGIN
	ALTER TABLE Film_Premiere
	ADD CONSTRAINT fk_Film_Premiere FOREIGN KEY(Pid) REFERENCES Cinema(Cid)
	PRINT 'A foreign key has been added in table Film_Premiere'

	UPDATE Versions
	SET version = 4;
END
--EXEC usp_add_fk_constraint


--procedure that deletes a foreign key
GO
CREATE PROCEDURE usp_remove_fk_constraint
AS
BEGIN
	ALTER TABLE Film_Premiere
	DROP CONSTRAINT fk_Film_Premiere
	PRINT 'The foreign key has been deleted from table Film_Premiere'

	UPDATE Versions
	SET version = 3;
END
--EXEC usp_remove_fk_constraint

INSERT INTO Versions
(version)
VALUES
(0);


--DROP PROCEDURE usp_back
GO
CREATE PROCEDURE usp_back
(@version INT)
AS
BEGIN
	DECLARE @currentVersion INT = (SELECT [version]
		FROM [Versions])

		IF @currentVersion = 4 AND @version = 0
			BEGIN
			EXEC usp_remove_fk_constraint
			EXEC usp_remove_pk_constraint
			EXEC usp_remove_table
			EXEC usp_remove_new_column
			END;
		ELSE
		IF @currentVersion = 4 AND @version = 1
			BEGIN
			EXEC usp_remove_fk_constraint
			EXEC usp_remove_pk_constraint
			EXEC usp_remove_table
			END;
		ELSE
		IF @currentVersion = 4 AND @version = 2
			BEGIN
			EXEC usp_remove_fk_constraint
			EXEC usp_remove_pk_constraint
			END;
		ELSE
		IF @currentVersion = 4 AND @version = 3
			BEGIN
			EXEC usp_remove_fk_constraint
			END;
		ELSE

		IF @currentVersion = 3 AND @version = 0
			BEGIN
			EXEC usp_remove_pk_constraint
			EXEC usp_remove_table
			EXEC usp_remove_new_column
			END;
		ELSE
		IF @currentVersion = 3 AND @version = 1
			BEGIN
			EXEC usp_remove_pk_constraint
			EXEC usp_remove_table
			END;
		ELSE
		IF @currentVersion = 3 AND @version = 2
			BEGIN
			EXEC usp_remove_pk_constraint
			END;
		ELSE
		IF @currentVersion = 2 AND @version = 0
			BEGIN
			EXEC usp_remove_table
			EXEC usp_remove_new_column
			END;
		ELSE
		IF @currentVersion = 2 AND @version = 1
			BEGIN
			EXEC usp_remove_table
			END;
		ELSE
		IF @currentVersion = 1 AND @version = 0
			BEGIN
			EXEC usp_remove_new_column
			END;
		ELSE




		IF @currentVersion = 0 AND @version = 4
			BEGIN
			EXEC usp_add_new_column
			EXEC usp_create_table
			EXEC usp_add_pk_constraint
			EXEC usp_add_fk_constraint
			END;
		ELSE
		IF @currentVersion = 1 AND @version = 4
			BEGIN
			EXEC usp_create_table
			EXEC usp_add_pk_constraint
			EXEC usp_add_fk_constraint
			END;
		ELSE
		IF @currentVersion = 2 AND @version = 4
			BEGIN
			EXEC usp_add_pk_constraint
			EXEC usp_add_fk_constraint
			END;

			ELSE
		IF @currentVersion = 3 AND @version = 4
			BEGIN
			EXEC usp_add_fk_constraint
			END;


		ELSE
		IF @currentVersion = 0 AND @version = 3
			BEGIN
			EXEC usp_add_new_column
			EXEC usp_create_table
			EXEC usp_add_pk_constraint
			END;
		ELSE
		IF @currentVersion = 1 AND @version = 3
			BEGIN
			EXEC usp_create_table
			EXEC usp_add_pk_constraint
			END;
		ELSE
		IF @currentVersion = 2 AND @version = 3
			BEGIN
			EXEC usp_add_pk_constraint
			END;

		ELSE

		IF @currentVersion = 0 AND @version = 2
			BEGIN
			EXEC usp_add_new_column
			EXEC usp_create_table
			END;
		ELSE
		IF @currentVersion = 1 AND @version = 2
			BEGIN
			EXEC usp_create_table
			END;
		ELSE
		IF @currentVersion = 0 AND @version = 1
			BEGIN
			EXEC usp_add_new_column
			END;

END;

EXEC usp_back 3
GO
CREATE PROCEDURE usp_operate
AS
BEGIN

	EXEC usp_back 0

	EXEC usp_add_new_column
	
	EXEC usp_back 0

	EXEC usp_add_new_column
	EXEC usp_create_table
	
	EXEC usp_back 0

	EXEC usp_add_new_column
	EXEC usp_create_table
	EXEC usp_add_pk_constraint

	EXEC usp_back 0

	EXEC usp_add_new_column
	EXEC usp_create_table
	EXEC usp_add_pk_constraint
	EXEC usp_add_fk_constraint

	EXEC usp_back 0
END;