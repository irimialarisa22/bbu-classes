USE BD_class
GO


IF OBJECT_ID ('Genre','U') IS NOT NULL
	DROP TABLE Genre

IF OBJECT_ID ('Producer','U') IS NOT NULL
	DROP TABLE Producer

IF OBJECT_ID ('Film','U') IS NOT NULL
	DROP TABLE Film

IF OBJECT_ID('Cinema','U') IS NOT NULL
	DROP TABLE Cinema

IF OBJECT_ID('Playlist','U') IS NOT NULL
	DROP TABLE Playlist



CREATE TABLE Genre (
Gid INT PRIMARY KEY IDENTITY(1,1),
Name VARCHAR(30),
Description VARCHAR(30)
)

CREATE TABLE Producer (
Pid INT PRIMARY KEY IDENTITY(1,1),
Name VARCHAR(30))

CREATE TABLE Film(
Fid INT PRIMARY KEY IDENTITY(1,1),
Name VARCHAR(100),
Description VARCHAR (100),
Pid INT FOREIGN KEY REFERENCES Producer (Pid) ON UPDATE CASCADE ON DELETE CASCADE,
Gid INT FOREIGN KEY REFERENCES Genre (Gid) ON UPDATE CASCADE ON DELETE CASCADE)


CREATE TABLE Cinema (
Cid INT PRIMARY KEY IDENTITY(1,1),
Name VARCHAR(30),
Web VARCHAR(100))

CREATE TABLE Playlist (
Release_date DATE,
Price INT,
Fid INT FOREIGN KEY REFERENCES Film (Fid),
Cid INT FOREIGN KEY REFERENCES Cinema (Cid),
CONSTRAINT Pk_Playlist PRIMARY KEY (Fid, Cid)
)

SET IDENTITY_INSERT Genre ON
INSERT Genre (Gid, Name, Description) VALUES
(1, 'comedie','haios'),
(2, 'drama','trist'),
(3,'SF','paranormal')
SET IDENTITY_INSERT Genre OFF


SET IDENTITY_INSERT Producer ON
INSERT Producer(Pid, Name) VALUES
(1,'Marvel'),
(2, 'California'),
(3, 'Indian')
SET IDENTITY_INSERT Producer OFF


SET IDENTITY_INSERT Film ON
INSERT Film(Fid, Name, Description, Pid, Gid) VALUES
(1,'The Great Gatsby','o poveste de dragoste',1,2),
(2,'Joker','rasete',2,3),
(3,'Star wars','o calatorie intr-o galaxie noua',3,1)
SET IDENTITY_INSERT Film OFF


SET IDENTITY_INSERT Cinema ON
INSERT Cinema (Cid, Name, Web) VALUES
(1,'FlorinPiersic','cinematograful_vesel.ro'),
(2,'Victoria','hai_sa_vezi_un_film_extraordinar.com'),
(3,'Dacia','hai_la_distractie.ro')
SET IDENTITY_INSERT Cinema OFF


INSERT Playlist (Release_date, Price, Fid, Cid) VALUES
('2019-01-01',15,1,1),('2019-01-01',30,2,1),('2019-01-01',34,1,2)


SELECT *FROM Genre
SELECT *FROM Producer
SELECT *FROM Film
SELECT *FROM Cinema
SELECT *FROM Playlist

GO
CREATE VIEW view_1
AS
SELECT C.Name, C.Web FROM Cinema C
GO
SELECT * FROM view_1



