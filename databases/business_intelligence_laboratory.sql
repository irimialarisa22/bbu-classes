CREATE DATABASE BI
USE BI

CREATE TABLE "Organisations" (
    code INT NOT NULL PRIMARY KEY IDENTITY(1, 1),
    name NVARCHAR (100),
    headquarter NVARCHAR (100),
    founded DATE
);

CREATE TABLE "Countries" (
	code INT NOT NULL PRIMARY KEY IDENTITY(1, 1),
    name NVARCHAR (100),
    capital NVARCHAR (100),
    area NUMERIC(8,2),
    population NUMERIC(10,0),
    continent NVARCHAR (100)
);

CREATE TABLE "Relationship" (
    org_code INT NOT NULL,
    country_code INT NOT NULL,
    FOREIGN KEY (org_code) REFERENCES Organisations (code), 
    FOREIGN KEY (country_code) REFERENCES Countries (code),
    UNIQUE (org_code, country_code)
);

INSERT INTO Organisations(name, headquarter, founded) VALUES ('NATO', 'Brussels', '1949-04-04');
INSERT INTO Organisations(name, headquarter, founded) VALUES ('EU', 'Brussels', '1993-11-01');
INSERT INTO Organisations(name, headquarter, founded) VALUES ('ICC', 'Hague', '2002-05-01');
INSERT INTO Organisations(name, headquarter, founded) VALUES ('UNESCO', 'Paris', '1945-11-16');
INSERT INTO Organisations(name, headquarter, founded) VALUES ('WHO', 'Geneva', '1948-04-04');

INSERT INTO Countries(name, capital, area, population, continent) VALUES ('Germany', 'Berlin', 357386, 83.02, 'Europe');
INSERT INTO Countries(name, capital, area, population, continent) VALUES ('France', 'Paris', 643801 , 67.06, 'Europe');
INSERT INTO Countries(name, capital, area, population, continent) VALUES ('Moldova', 'Chisinau', 33846, 2.65, 'Europe');
INSERT INTO Countries(name, capital, area, population, continent) VALUES ('Argentina', 'Buenos Aires', 278, 44.94, 'South America');
INSERT INTO Countries(name, capital, area, population, continent) VALUES ('China', 'Beijing', 9597, 140809, 'Asia');
INSERT INTO Countries(name, capital, area, population, continent) VALUES ('New Zealand', 'Wellington', 268021, 4917, 'Departe');


INSERT INTO Relationship(org_code,country_code) VALUES (1,1)
INSERT INTO Relationship(org_code,country_code) VALUES (1,2)
INSERT INTO Relationship(org_code,country_code) VALUES (2,2)
INSERT INTO Relationship(org_code,country_code) VALUES (2,3)
INSERT INTO Relationship(org_code,country_code) VALUES (3,3)
INSERT INTO Relationship(org_code,country_code) VALUES (4,4)
INSERT INTO Relationship(org_code,country_code) VALUES (5,5)

SELECT * FROM Organisations
SELECT * FROM Countries
SELECT * FROM Relationship

--DROP TABLE Organisations
--DROP TABLE Countries
--DROP TABLE Relationship


--1. List all the countries which are members of NATO
SELECT C.name FROM Countries C INNER JOIN Relationship R
ON C.code = R.country_code INNER JOIN Organisations O
ON O.code = R.org_code
WHERE O.name = 'NATO';

--2. List all the countries which are members of organizations founded before 1980
SELECT DISTINCT C.name FROM Countries C INNER JOIN Relationship R
ON C.code = R.country_code INNER JOIN Organisations O
ON O.code = R.org_code
WHERE DATEDIFF(day, '1/1/1980', O.founded) > 0;

--3. List all the countries which are members of only one organization
SELECT C.name FROM Countries C 
WHERE C.code IN(
SELECT R.country_code  FROM Relationship R
GROUP BY R.country_code
HAVING COUNT(R.org_code)=1);

--4. List all the capitals which are headquarter of no organization
SELECT C.capital FROM Countries C
WHERE C.capital NOT IN
(SELECT O.headquarter FROM Organisations O);

--5. List the population of each continent
SELECT C.continent, SUM(C.population) AS [continent_population]
FROM Countries C
GROUP BY C.continent;

--6. Count the countries of each continent
SELECT C.continent, COUNT(*) AS [number] FROM Countries C
GROUP BY C.continent;