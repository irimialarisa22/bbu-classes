USE BD_examples
GO

IF OBJECT_ID ('TouristResort', 'U') IS NOT NULL
    DROP TABLE TouristResort
IF OBJECT_ID ('Tourists', 'U') IS NOT NULL
    DROP TABLE Tourists
IF OBJECT_ID ('Seas', 'U') IS NOT NULL
    DROP TABLE Seas
IF OBJECT_ID ('Therapies', 'U') IS NOT NULL
    DROP TABLE Therapies
IF OBJECT_ID ('Resorts', 'U') IS NOT NULL
    DROP TABLE Resorts
GO

CREATE TABLE Tourists
(Tid INT PRIMARY KEY IDENTITY(1,1),
TName VARCHAR(50),
TCond VARCHAR(50));

CREATE TABLE Seas
(Sid INT PRIMARY KEY IDENTITY(1,1),
SName VARCHAR(50),
Saltiness INT);

CREATE TABLE Therapies
(Thid INT PRIMARY KEY IDENTITY(1,1),
ThName VARCHAR(50),
Duration INT,
Price INT,
Tid INT REFERENCES Tourists(Tid) UNIQUE);

CREATE TABLE Resorts
(Rid INT PRIMARY KEY IDENTITY(1,1),
RName VARCHAR(50),
Position VARCHAR(50),
Coast VARCHAR(50));

CREATE TABLE TouristResort
(Tid INT REFERENCES Tourists(Tid),
Rid INT REFERENCES Resorts(Rid),
CheckIn DATE,
TRDuration INT,
PRIMARY KEY(Tid, Rid));

INSERT Tourists VALUES ('Ana Aanei', 'Artritis'), ('Ionut Ionescu', 'Scoliosis')
INSERT Seas VALUES ('Adriatic Sea', 2), ('Black Sea', 3)
INSERT Therapies VALUES ('Thermal', 7, 700, 1), ('Mud', 5, 450, 2)
INSERT Resorts VALUES ('Livigno', 'Northern', 'Italian'), ('Eforie Sud', 'Southern', 'Romanian'), ('Livigno', 'Northern', 'Italian')
INSERT TouristResort VALUES (1, 1, '2016-07-07', 6), (2, 1, '2017-12-14', 7), (2, 2, '2018-06-22', 4)


SELECT * FROM Tourists
SELECT * FROM Seas
SELECT * FROM Therapies
SELECT * FROM Resorts
SELECT * FROM TouristResort

GO
CREATE PROCEDURE uspAddBooking @TName VARCHAR(50), @RName VARCHAR(50),
    @CheckIn DATE, @TRDuration INT
AS
    DECLARE @Tid INT=(SELECT Tid FROM Tourists WHERE TName=@RName),
	    @Rid INT=(SELECT Rid FROM Resorts WHERE RName=@RName)
	IF @Rid IS NULL OR @Tid IS NULL
	    RAISERROR('rid/tid is/are null', 16, 1)
	ELSE 
	  IF EXISTS (SELECT * FROM TouristResort WHERE Tid=@Tid and Rid=@Rid)
	    RAISERROR('tourist already on a vacation', 16, 1)
	  ELSE
	    INSERT TouristResort(Tid, Rid, CheckIn, TRDuration) VALUES
		   (@Tid, @Rid, @CheckIn, @TRDuration)

GO

uspAddBooking 'Ana Aanei', 'Eforie Sud', '2019-01-01', 5

SELECT * FROM Tourists
SELECT * FROM Resorts
SELECT * FROM TouristResort

GO
CREATE FUNCTION ufGetResorts(@Z INT)
RETURNS TABLE 
RETURN SELECT R.RName
FROM Resorts R
WHERE R.Rid IN
    (SELECT TR.Rid
    FROM TouristResort TR
    GROUP BY TR.Rid
    HAVING COUNT(*) > @Z)
GO

SELECT * FROM ufGetResorts(2)