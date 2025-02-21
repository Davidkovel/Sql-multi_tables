CREATE DATABASE Academy;
USE Academy;

CREATE TABLE Curators (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(MAX) NOT NULL CHECK (Name <> ''),
    Surname NVARCHAR(MAX) NOT NULL CHECK (Surname <> '')
);

CREATE TABLE Faculties (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Financing MONEY NOT NULL CHECK (Financing >= 0) DEFAULT 0,
    Name NVARCHAR(100) NOT NULL CHECK (Name <> '') UNIQUE
);

CREATE TABLE Departments (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Financing MONEY NOT NULL CHECK (Financing >= 0) DEFAULT 0,
    Name NVARCHAR(100) NOT NULL CHECK (Name <> '') UNIQUE,
    FacultyId INT NOT NULL,
    FOREIGN KEY (FacultyId) REFERENCES Faculties(Id)
);

CREATE TABLE Groups (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(10) NOT NULL CHECK (Name <> '') UNIQUE,
    Year INT NOT NULL CHECK (Year BETWEEN 1 AND 5),
    DepartmentId INT NOT NULL,
    FOREIGN KEY (DepartmentId) REFERENCES Departments(Id)
);

CREATE TABLE GroupsCurators (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    CuratorId INT NOT NULL,
    GroupId INT NOT NULL,
    FOREIGN KEY (CuratorId) REFERENCES Curators(Id),
    FOREIGN KEY (GroupId) REFERENCES Groups(Id)
);

CREATE TABLE Subjects (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL CHECK (Name <> '') UNIQUE
);

CREATE TABLE Teachers (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(MAX) NOT NULL CHECK (Name <> ''),
    Salary MONEY NOT NULL CHECK (Salary > 0),
    Surname NVARCHAR(MAX) NOT NULL CHECK (Surname <> '')
);


CREATE TABLE Lectures (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    LectureRoom NVARCHAR(MAX) NOT NULL CHECK (LectureRoom <> ''),
    SubjectId INT NOT NULL,
    TeacherId INT NOT NULL,
    FOREIGN KEY (SubjectId) REFERENCES Subjects(Id),
    FOREIGN KEY (TeacherId) REFERENCES Teachers(Id)
);


CREATE TABLE GroupsLectures (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    GroupId INT NOT NULL,
    LectureId INT NOT NULL,
    FOREIGN KEY (GroupId) REFERENCES Groups(Id),
    FOREIGN KEY (LectureId) REFERENCES Lectures(Id)
);

-- INSERTING

INSERT INTO Curators (Name, Surname)
VALUES 
('John', 'Doe'),
('Jane', 'Smith'),
('Michael', 'Johnson');

INSERT INTO Faculties (Financing, Name)
VALUES 
(100000, 'Computer Science'),
(150000, 'Mathematics'),
(120000, 'Physics');

INSERT INTO Departments (Financing, Name, FacultyId)
VALUES 
(50000, 'Software Engineering', 1),
(60000, 'Applied Mathematics', 2),
(55000, 'Theoretical Physics', 3);


INSERT INTO Groups (Name, Year, DepartmentId)
VALUES 
('P107', 1, 1),
('M202', 2, 2),
('P305', 3, 3);

INSERT INTO GroupsCurators (CuratorId, GroupId)
VALUES 
(1, 1),
(2, 2),
(3, 3);

INSERT INTO Subjects (Name)
VALUES 
('Database Theory'),
('Linear Algebra'),
('Quantum Mechanics');

INSERT INTO Teachers (Name, Surname, Salary)
VALUES 
('Samantha', 'Adams', 3000),
('Robert', 'Brown', 3500),
('Emily', 'Davis', 3200);

INSERT INTO Lectures (LectureRoom, SubjectId, TeacherId)
VALUES 
('B103', 1, 1),
('A205', 2, 2),
('C301', 3, 3);

INSERT INTO GroupsLectures (GroupId, LectureId)
VALUES 
(1, 1),
(2, 2),
(3, 3);

-- SELECTING 

SELECT Teachers.Name, Teachers.Surname, Groups.Name AS GroupName
FROM Teachers, Groups;

SELECT f.Name AS FacultyName
FROM Faculties f
WHERE f.Financing < (
    SELECT SUM(d.Financing)
    FROM Departments d
    WHERE d.FacultyId = f.Id
);

SELECT c.Surname AS CuratorSurname, g.Name AS GroupName
FROM Curators c
INNER JOIN GroupsCurators gc ON c.Id = gc.CuratorId
INNER JOIN Groups g ON gc.GroupId = g.Id;

SELECT t.Name, t.Surname
FROM Teachers t
INNER JOIN Lectures l ON t.Id = l.TeacherId
INNER JOIN GroupsLectures gl ON l.Id = gl.LectureId
INNER JOIN Groups g ON gl.GroupId = g.Id
WHERE g.Name = 'P107';

SELECT t.Surname AS TeacherSurname, f.Name AS FacultyName
FROM Teachers t
INNER JOIN Lectures l ON t.Id = l.TeacherId
INNER JOIN Subjects s ON l.SubjectId = s.Id
INNER JOIN Departments d ON s.Id = d.Id
INNER JOIN Faculties f ON d.FacultyId = f.Id;

SELECT d.Name AS DepartmentName, g.Name AS GroupName
FROM Departments d
INNER JOIN Groups g ON d.Id = g.DepartmentId;

SELECT s.Name AS SubjectName
FROM Subjects s
INNER JOIN Lectures l ON s.Id = l.SubjectId
INNER JOIN Teachers t ON l.TeacherId = t.Id
WHERE t.Name = 'Samantha' AND t.Surname = 'Adams';

SELECT d.Name AS DepartmentName
FROM Departments d
INNER JOIN Subjects s ON d.Id = s.Id
WHERE s.Name = 'Database Theory';

SELECT g.Name AS GroupName
FROM Groups g
INNER JOIN Departments d ON g.DepartmentId = d.Id
INNER JOIN Faculties f ON d.FacultyId = f.Id
WHERE f.Name = 'Computer Science';

SELECT g.Name AS GroupName, f.Name AS FacultyName
FROM Groups g
INNER JOIN Departments d ON g.DepartmentId = d.Id
INNER JOIN Faculties f ON d.FacultyId = f.Id
WHERE g.Year = 5;

SELECT t.Name + ' ' + t.Surname AS TeacherFullName, s.Name AS SubjectName, g.Name AS GroupName
FROM Teachers t
INNER JOIN Lectures l ON t.Id = l.TeacherId
INNER JOIN Subjects s ON l.SubjectId = s.Id
INNER JOIN GroupsLectures gl ON l.Id = gl.LectureId
INNER JOIN Groups g ON gl.GroupId = g.Id
WHERE l.LectureRoom = 'B103';

-- deleting db

DROP TABLE GroupsLectures;
DROP TABLE Lectures;
DROP TABLE Groups;
DROP TABLE Departments;
DROP TABLE GroupsCurators;
DROP TABLE Faculties;
DROP TABLE Curators;
DROP TABLE Subjects;
DROP TABLE GroupsCurators;
DROP TABLE Deaprtments;

USE master;
DROP DATABASE Academy;