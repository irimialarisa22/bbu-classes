USE BD_examples
GO

IF OBJECT_ID ('Researchers','U') IS NOT NULL
	DROP TABLE Researchers

IF OBJECT_ID ('Papers','U') IS NOT NULL
	DROP TABLE Papers

IF OBJECT_ID ('AuthorContribution','U') IS NOT NULL
	DROP TABLE AuthorContribution


/*Researchers(RID: integer, Name: string, ImpactFactor: integer, Age*: integer)
Papers(PID: integer, Title: string, Conference: string)
AuthorContribution(RID: integer, PID: integer, Year: integer)
*/
CREATE TABLE Researchers
(RID INT PRIMARY KEY IDENTITY(1,1),
Name VARCHAR(100),
ImpactFactor INT,
Age INT)

CREATE TABLE Papers
(PID INT PRIMARY KEY IDENTITY(1,1),
Title VARCHAR(100),
Conference VARCHAR(100))

CREATE TABLE AuthorContribution
(RID INT FOREIGN KEY REFERENCES Researchers(RID),
PID INT FOREIGN KEY REFERENCES Papers(PID),CONSTRAINT Pk_AuthorContribution PRIMARY KEY(RID,PID),
Year INT)


SET IDENTITY_INSERT Researchers ON
INSERT INTO Researchers(RID,Name,ImpactFactor,Age) VALUES (1,'Popescu',10,30)
INSERT INTO Researchers(RID,Name,ImpactFactor,Age) VALUES (2,'Ionescu',10,20)
INSERT INTO Researchers(RID,Name,ImpactFactor,Age) VALUES (4,'Andreescu',5,24)
SET IDENTITY_INSERT Researchers OFF


SET IDENTITY_INSERT Papers ON
INSERT INTO Papers(PID,Title,Conference) VALUES (307,'Viata ca o prada','TBA')
INSERT INTO Papers(PID,Title,Conference) VALUES (200,'Chirita','EDBT')
INSERT INTO Papers(PID,Title,Conference) VALUES (309,'Regele mustelor','EDBT')
INSERT INTO Papers(PID,Title,Conference) VALUES (200,'In cautarea oii fantastice','TBA')


SELECT * FROM Papers
INSERT INTO AuthorContribution(RID,PID,Year) VALUES (1,307,2011)
INSERT INTO AuthorContribution(RID,PID,Year) VALUES (1,200,2012)
INSERT INTO AuthorContribution(RID,PID,Year) VALUES (2,307,2011)
INSERT INTO AuthorContribution(RID,PID,Year) VALUES (2,211,2011)
INSERT INTO AuthorContribution(RID,PID,Year) VALUES (4,307,2011)
INSERT INTO AuthorContribution(RID,PID,Year) VALUES (4,200,2011)




--Find the names of researchers who have worked on the paper with PID = 307.
SELECT R.Name
FROM Researchers R, AuthorContribution A
WHERE R.RID = A.RID AND A.PID = 307

--Find the names and ages of all researchers. Eliminate duplicates
SELECT DISTINCT R.Name, R.Age
FROM Researchers R

--Find the researchers with an impact factor > 3 (all the data about researchers)
SELECT R.RID, R.Name, R.ImpactFactor, R.Age
FROM Researchers AS R
WHERE R.ImpactFactor> 3

--Find the title with PID = 307
SELECT P.Title
FROM Papers P
WHERE P.PID = 309

--Find the names of researchers who have published in the EDBT conference
SELECT R.Name
FROM Researchers R, AuthorContribution A, Papers P
WHERE R.RID = A.RID AND A.PID = P.PID AND P.Conference= 'EDBT'

--Find the ids of researchers who have published in the EDBT conference
SELECT R.RID
FROM Researchers R, AuthorContribution A, Papers P
WHERE R.RID = A.RID AND A.PID = P.PID AND P.Conference= 'EDBT'

--Find the names of researchers who have published at least one paper.
SELECT DISTINCT R.Name
FROM Researchers R, AuthorContribution A
WHERE R.RID = A.RID

--Compute an incremented impactfactor for researchers who worked on two different papers in the same year
SELECT R.Name, R.ImpactFactor+ 1 ASNewIF
FROM Researchers R, AuthorContribution A1, AuthorContribution A2
WHERE R.RID= A1.RID AND R.RID= A2.RID
AND A1.PID <> A2.PID
AND A1.Year= A2.Year

--Find the names of researchers who have published in EDBT or IDEAS
SELECT R.Name
FROM Researchers R, AuthorContribution A, Papers P
WHERE R.RID = A.RID AND A.PID = P.PID AND
(P.Conference= 'IDEAS' OR P.Conference= 'EDBT')

--Find the names of researchers who have worked on the paper with PID=307.
SELECT R.Name
FROM Researchers R
WHERE R.RID IN
(SELECT A.RID
FROM AuthorContribution A
WHERE A.PID = 307)

--Find the age of the youngest researcher for each impact factor
SELECT R.ImpactFactor, MIN(R.Age) AS Min
FROM Researchers R
GROUP BY R.ImpactFactor

--Find the age of the youngest researcher who is at least 18 years old for each impact factor with at least 10 such researchers
SELECT R.ImpactFactor, MIN(R.Age) AS MinAge
FROM Researchers R
WHERE R.Age>= 18
GROUP BY R.ImpactFactor
HAVING COUNT(*) >= 10

--Find the average age of the researchers who is at least 18 years old for each impact factor with at least 10 such researchers
SELECT R.ImpactFactor, AVG(R.Age) AS AvgAge
FROM Researchers R
WHERE R.Age>= 18
GROUP BY R.ImpactFactor
HAVING 9< (SELECT COUNT(*)
FROM Researchers R2
WHERE R2.ImpactFactor = R.ImpactFactor)

SELECT R.Name, R.Age
FROM Researchers R
WHERE R.Age=(SELECT MAX(R2.Age)
FROM Researchers R2)

--Find the number of researchers for each impactfactor. Order the result by the number of researchers
SELECT R.ImpactFactor, COUNT(*) AS NoR
FROM Researchers R
GROUP BY R.ImpactFactor
ORDER BY NoR

--Find the names of researchers who have published in IDEAS and EDBT
SELECT R.Name
FROM Researchers R INNER JOIN AuthorContribution A
ON R.RID = A.RID
INNER JOIN Papers P ON A.PID = P.PID
WHERE P.Conference= 'IDEAS' AND
R.RID IN (SELECT A2.RID
FROM AuthorContribution A2 INNER JOIN Papers P2
ON A2.PID = P2.PID
WHERE P2.Conference = 'EDBT')

----------------------------------------------------------------------------------------------------------------------------------------------------



--tinyint is between 0 to 255
CREATE TABLE Movie
(mid CHAR(10) PRIMARY KEY,
title VARCHAR(70),
/*year_of_release TINYINT,
running_time INT,
box_office DECIMAL(12, 2)*/)


CREATE TABLE MovieCast
(mid CHAR(10),
aid CHAR(10),
PRIMARY KEY(mid, aid),
FOREIGN KEY(mid) REFERENCES Movie(mid)
ON DELETE CASCADE
ON UPDATE NO ACTION)

INSERT Movie (mid,title) VALUES ('1','Spartacus')
INSERT Movie (mid,title) VALUES ('2','Avengers')
INSERT Movie (mid,title) VALUES ('3','Hunger games')

INSERT MovieCast (mid,aid) VALUES ('1','1')
INSERT MovieCast (mid,aid) VALUES ('2','1')
INSERT MovieCast (mid,aid) VALUES ('3','1')

--ON DELETE CASCADE deletes both parent table and child table
SELECT *FROM Movie
SELECT *FROM MovieCast

DELETE FROM Movie
WHERE mid = 1

--ON UPDATE NO ACTION doesn't delete 
UPDATE Movie
SET title = 'John Wick'
WHERE mid = 1