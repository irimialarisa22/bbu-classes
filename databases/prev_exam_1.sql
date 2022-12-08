USE BD_examples
GO

IF OBJECT_ID ('RoutesStations','U') IS NOT NULL
	DROP TABLE RoutesStations

IF OBJECT_ID ('Stations','U') IS NOT NULL
	DROP TABLE Stations

IF OBJECT_ID ('Routes','U') IS NOT NULL
	DROP TABLE Routes

IF OBJECT_ID ('Trains','U') IS NOT NULL
	DROP TABLE Trains

IF OBJECT_ID ('TrainTypes','U') IS NOT NULL
	DROP TABLE TrainTypes
GO

CREATE TABLE TrainTypes
(TTid INT PRIMARY KEY IDENTITY(1,1),
Description VARCHAR(100))

CREATE TABLE Trains
(Tid INT PRIMARY KEY IDENTITY(1,1),
TName VARCHAR(100),
TTid INT REFERENCES TrainTypes(TTid))

CREATE TABLE Routes
(Rid INT PRIMARY KEY IDENTITY(1,1),
RName VARCHAR(100) UNIQUE,
Tid INT REFERENCES Trains(Tid))


CREATE TABLE Stations
(Sid INT PRIMARY KEY IDENTITY(1,1),
SName VARCHAR(100) UNIQUE)


CREATE TABLE RoutesStations
(Rid INT REFERENCES Routes(Rid),
Sid INT REFERENCES Stations(Sid),
Arrival TIME,
Departure TIME,
PRIMARY KEY(Rid,Sid))

GO
CREATE OR ALTER PROC usp_station_on_route
	@SName VARCHAR(100),@RName VARCHAR(100),
	@Arrival TIME,@Departure TIME
AS
	DECLARE @Sid INT = (SELECT Sid
						FROM Stations
						WHERE SName = @SName),
			@Rid INT = (SELECT Rid
						FROM Routes
						WHERE Rname = @Rname)
IF @Sid IS NULL OR @Rid IS NULL
BEGIN 
	RAISERROR('No such station/routes',16,1)
	RETURN 1
END
IF EXISTS(SELECT* FROM RoutesStations
	WHERE Rid = @Rid and Sid = @Sid)
	UPDATE RoutesStations
	SET Arrival = @Arrival,Departure = @Departure
	WHERE Rid = @Rid AND Sid = @Sid
ELSE
	INSERT RoutesStations(Rid,Sid,Arrival,Departure)
	VALUES (@Rid, @Sid,@Arrival,@Departure)
GO



INSERT TrainTypes 
	VALUES ('Interregio'),('regio')
INSERT Trains
	VALUES ('t1',1),('t2',2),('t3',2)
INSERT Routes 
	VALUES ('r1',1),('r2',2),('r3',3)
INSERT Stations
	VALUES ('s1'),('s2'),('s3')



SELECT *FROM TrainTypes
SELECT *FROM Trains
SELECT * FROM Routes
SELECT *FROM Stations


EXEC usp_station_on_route 's2','r1','6:30','6:35'

EXEC usp_station_on_route 's3','r1','6:40','6:45'
EXEC usp_station_on_route 's3','r2','7:45','7:50'
EXEC usp_station_on_route 's3','r3','8:45','8:50'



GO
CREATE OR ALTER FUNCTION usp_filter_station(@R INT)
RETURNS TABLE 
RETURN SELECT S.SName
FROM Stations S
WHERE S.Sid IN
		(SELECT RS.Sid
		FROM RoutesStations RS
		GROUP BY RS.Sid
		HAVING COUNT(*) >= @R)
GO


SELECT *FROM usp_filter_station(3)