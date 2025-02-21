CREATE DATABASE Hospital;
USE Hospital;

CREATE TABLE Departments
(
    ID INT PRIMARY KEY IDENTITY (1,1) NOT NULL,
    Name NVARCHAR(100) NOT NULL UNIQUE CHECK (LEN(Name) > 0)
);

CREATE TABLE Doctors
(
    Id INT PRIMARY KEY IDENTITY (1,1) NOT NULL,
    Name NVARCHAR(MAX) NOT NULL CHECK (LEN(Name) > 0),
    Premium INT NOT NULL CHECK (Premium >= 0) DEFAULT 0,
    Salary MONEY NOT NULL CHECK (Salary > 0),
    Surname NVARCHAR(MAX) NOT NULL CHECK (LEN(Surname) > 0)
);

CREATE TABLE Specializations
(
    ID INT PRIMARY KEY IDENTITY (1,1) NOT NULL,
    Name NVARCHAR(100) NOT NULL UNIQUE CHECK (LEN(Name) > 0)
);

CREATE TABLE DoctorsSpecializations
(
    ID INT PRIMARY KEY IDENTITY (1,1) NOT NULL,
    DoctorID INT NOT NULL,
    SpecializationId INT NOT NULL,
    FOREIGN KEY (DoctorID) REFERENCES Doctors(ID),
    FOREIGN KEY (SpecializationId) REFERENCES Specializations(ID)
);

CREATE TABLE Sponsors
(
    Id INT PRIMARY KEY IDENTITY (1,1) NOT NULL,
    Name NVARCHAR(100) NOT NULL UNIQUE CHECK (LEN(Name) > 0)
);

CREATE TABLE Donations
(
    Id INT PRIMARY KEY IDENTITY (1,1) NOT NULL,
    Amount MONEY NOT NULL CHECK (Amount > 0),
    Date DATE NOT NULL CHECK (Date <= GETDATE()) DEFAULT GETDATE(),
    DepartmentID INT NOT NULL,
    SponsorId INT NOT NULL,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(ID),
    FOREIGN KEY (SponsorId) REFERENCES Sponsors(ID)
);

CREATE TABLE Vacations
(
    ID INT PRIMARY KEY IDENTITY (1,1) NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    DoctorID INT NOT NULL,
    CHECK (EndDate >= StartDate),
    FOREIGN KEY (DoctorID) REFERENCES Doctors(ID)
);

CREATE TABLE Wards
(
    ID INT PRIMARY KEY IDENTITY (1,1) NOT NULL,
    Name NVARCHAR(20) NOT NULL UNIQUE CHECK (LEN(Name) > 0),
    DepartmentID INT NOT NULL,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(ID)
);

CREATE TABLE Diseases
(
    ID INT PRIMARY KEY IDENTITY (1,1) NOT NULL,
    Name NVARCHAR(100) NOT NULL UNIQUE CHECK (LEN(Name) > 0),
    Severity INT NOT NULL CHECK (Severity > 1) DEFAULT 1,
    Contagious BIT NOT NULL DEFAULT 0,
    SpecializationID INT NOT NULL,
    FOREIGN KEY (SpecializationID) REFERENCES Specializations(ID)
);

CREATE TABLE Examinations
(
    ID INT PRIMARY KEY IDENTITY (1,1) NOT NULL,
    DiseaseID INT NOT NULL,
    DepartmentID INT NOT NULL,
    Date DATE NOT NULL DEFAULT GETDATE(),
    DayOfWeek INT NOT NULL CHECK (DayOfWeek > 0 AND DayOfWeek < 8),
    EndTime TIME NOT NULL,
    Name NVARCHAR(100) NOT NULL CHECK (LEN(Name) > 0),
    StartTime TIME NOT NULL CHECK (StartTime BETWEEN '08:00' AND '18:00'),
    CHECK (StartTime < EndTime),
    FOREIGN KEY (DiseaseID) REFERENCES Diseases(ID),
    FOREIGN KEY (DepartmentID) REFERENCES Departments(ID)
);

-- INSERTING

INSERT INTO Departments(Name) VALUES
('Cardiology'),
('Intensive Treatment'),
('Oncology'),
('Pediatrics'),
('Surgery'),
('Traumatology');

INSERT INTO Specializations(Name) VALUES
('Cardiologist'),
('Intensivist'),
('Oncologist'),
('Pediatrician'),
('Surgeon'),
('Traumatologist');

INSERT INTO Doctors(Name, Premium, Salary, Surname) VALUES
('John', 100, 5000, 'Doe'),
('Helen', 200, 2000, 'Williams'),
('Jack', 400, 4000, 'Doe'),
('Jill', 300, 2000, 'Doe'),
('Jim', 0, 1000, 'Doe'),
('Jenny', 200, 4000, 'Doe');

INSERT INTO DoctorsSpecializations(DoctorID, SpecializationId) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6);

INSERT INTO Sponsors(Name) VALUES
('Bill Gates'),
('Elon Musk'),
('Jeff Bezos'),
('Mark Zuckerberg'),
('Umbrella Corporation'),
('Larry Page');

INSERT INTO Donations(Amount, DepartmentID, SponsorId, Date) VALUES
(100000, 1, 1, '2025-01-01'),
(200000, 2, 2, '2025-02-01'),
(30000, 3, 3, '2024-12-01'),
(4000, 4, 4, '2025-02-11'),
(500000, 5, 5, '2025-01-05'),
(6000, 6, 6, '2025-01-23'),
(60000, 6, 6, '2025-02-15');

INSERT INTO Vacations(StartDate, EndDate, DoctorID) VALUES
('2025-01-01', '2025-01-02', 1),
('2025-02-01', '2025-02-03', 2),
('2025-03-01', '2025-03-10', 3),
('2025-04-01', '2025-04-10', 4),
('2025-05-01', '2025-05-10', 5),
('2025-06-01', '2025-06-10', 6);

INSERT INTO Wards(Name, DepartmentID) VALUES
('Cardiology-1', 1),
('Cardiology-2', 1),
('IntensiveTreatment1', 2),
('IntensiveTreatment2', 2),
('Oncology-1', 3),
('Oncology-2', 3),
('Pediatrics-1', 4),
('Pediatrics-2', 4),
('Surgery-1', 5),
('Surgery-2', 5),
('Traumatology-1', 6),
('Traumatology-2', 6);

INSERT INTO Diseases(Name, Severity, Contagious, SpecializationID) VALUES
('Heart attack', 5, 0, 1),
('Pneumonia', 4, 1, 2),
('Leukemia', 5, 1, 3),
('Chickenpox', 3, 1, 4),
('Appendicitis', 4, 0, 5),
('Fracture', 2, 0, 6);

INSERT INTO Examinations(DiseaseID, DepartmentID, DayOfWeek, EndTime, Name, StartTime, Date) VALUES
(1, 1, 2, '10:00', 'Cardiology examination', '08:00', '2025-01-01'),
(2, 2, 3, '11:00', 'Intensive treatment examination', '09:00', '2025-02-02'),
(3, 3, 4, '12:00', 'Oncology examination', '10:00', '2024-03-03'),
(4, 4, 5, '13:00', 'Pediatrics examination', '11:00', '2024-12-04'),
(5, 5, 6, '14:00', 'Surgery examination', '12:00', '2024-11-05'),
(6, 6, 7, '15:00', 'Traumatology examination', '13:00', '2024-10-06');

-- SELECTING 

SELECT Doctors.Name + ' ' + Doctors.Surname AS "Full Name", Specializations.Name AS "Specialization"
FROM Doctors
INNER JOIN DoctorsSpecializations ON Doctors.Id = DoctorsSpecializations.DoctorID
INNER JOIN Specializations ON DoctorsSpecializations.SpecializationId = Specializations.ID;

SELECT Doctors.Surname, (Doctors.Salary + Doctors.Premium) AS "Total Salary"
FROM Doctors
FULL JOIN Vacations ON Doctors.Id = Vacations.DoctorID
    AND GETDATE() BETWEEN Vacations.StartDate AND Vacations.EndDate
WHERE Vacations.DoctorID IS NULL;

SELECT Wards.Name
FROM Wards
INNER JOIN Departments ON Wards.DepartmentID = Departments.ID
WHERE Departments.Name = 'Intensive Treatment';

SELECT DISTINCT Departments.Name
FROM Donations
INNER JOIN Departments ON Donations.DepartmentID = Departments.ID
INNER JOIN Sponsors ON Donations.SponsorId = Sponsors.Id
WHERE Sponsors.Name = 'Umbrella Corporation';

SELECT Departments.Name AS "Department", Sponsors.Name AS "Sponsor", Donations.Amount, Donations.Date
FROM Donations
INNER JOIN Departments ON Donations.DepartmentID = Departments.ID
INNER JOIN Sponsors ON Donations.SponsorId = Sponsors.Id
WHERE Donations.Date >= DATEADD(MONTH, -1, GETDATE());

SELECT Doctors.Surname, Departments.Name AS "Department"
FROM Doctors
INNER JOIN DoctorsSpecializations ON Doctors.Id = DoctorsSpecializations.DoctorID
INNER JOIN Specializations ON DoctorsSpecializations.SpecializationId = Specializations.ID
INNER JOIN Examinations ON Examinations.DiseaseID = Specializations.ID
INNER JOIN Departments ON Departments.ID = Examinations.DepartmentID
WHERE Examinations.DayOfWeek BETWEEN 2 AND 6;

SELECT Wards.Name AS "Ward", Departments.Name AS "Department"
FROM Doctors
INNER JOIN DoctorsSpecializations ON Doctors.Id = DoctorsSpecializations.DoctorID
INNER JOIN Specializations ON DoctorsSpecializations.SpecializationId = Specializations.ID
INNER JOIN Departments ON Departments.ID = Specializations.ID
INNER JOIN Wards ON Wards.DepartmentID = Departments.ID
WHERE Doctors.Name = 'Helen' AND Doctors.Surname = 'Williams';

SELECT Departments.Name AS "Department", Doctors.Name AS "Doctor", Doctors.Surname
FROM Donations
INNER JOIN Departments ON Donations.DepartmentID = Departments.ID
INNER JOIN Doctors ON Doctors.ID = Donations.DepartmentID
WHERE Donations.Amount > 100000;

SELECT DISTINCT Departments.Name
FROM Doctors
INNER JOIN Departments ON Doctors.ID = Departments.ID
WHERE Doctors.Premium = 0;

SELECT Specializations.Name
FROM Specializations
INNER JOIN Diseases ON Specializations.ID = Diseases.SpecializationID
WHERE Diseases.Severity > 3;

SELECT Departments.Name AS "Department", Diseases.Name AS "Disease"
FROM Examinations
INNER JOIN Departments ON Examinations.DepartmentID = Departments.ID
INNER JOIN Diseases ON Examinations.DiseaseID = Diseases.ID
WHERE Examinations.Date >= DATEADD(MONTH, -6, GETDATE());

SELECT Departments.Name AS "Department", Wards.Name AS "Ward"
FROM Examinations
INNER JOIN Departments ON Examinations.DepartmentID = Departments.ID
INNER JOIN Wards ON Wards.DepartmentID = Departments.ID
INNER JOIN Diseases ON Examinations.DiseaseID = Diseases.ID
WHERE Diseases.Contagious = 1;

-- deleting db

DROP TABLE Examinations;
DROP TABLE Diseases;
DROP TABLE DoctorsSpecializations;
DROP TABLE Specializations;
DROP TABLE Donations;
DROP TABLE Sponsors;
DROP TABLE Vacations;
DROP TABLE Wards;
DROP TABLE Departments;
DROP TABLE Doctors;

USE master;
DROP DATABASE Hospital;