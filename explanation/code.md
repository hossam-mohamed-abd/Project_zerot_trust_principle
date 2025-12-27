```sql
CREATE DATABASE NUIS;
GO
USE NUIS;
GO
```
```sql
CREATE TABLE Faculties (
    FacultyID INT IDENTITY PRIMARY KEY,
    FacultyName NVARCHAR(100) NOT NULL
);

CREATE TABLE Departments (
    DepartmentID INT IDENTITY PRIMARY KEY,
    DepartmentName NVARCHAR(100),
    FacultyID INT,
    FOREIGN KEY (FacultyID) REFERENCES Faculties(FacultyID)
);

CREATE TABLE Students (
    StudentID INT IDENTITY PRIMARY KEY,
    FullName NVARCHAR(150),
    NationalID VARBINARY(256), -- encrypted later
    DepartmentID INT,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

CREATE TABLE Instructors (
    InstructorID INT IDENTITY PRIMARY KEY,
    FullName NVARCHAR(150),
    DepartmentID INT,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

CREATE TABLE Courses (
    CourseID INT IDENTITY PRIMARY KEY,
    CourseName NVARCHAR(100),
    DepartmentID INT,
    InstructorID INT,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID),
    FOREIGN KEY (InstructorID) REFERENCES Instructors(InstructorID)
);

CREATE TABLE Enrollments (
    StudentID INT,
    CourseID INT,
    Semester NVARCHAR(20),
    PRIMARY KEY (StudentID, CourseID),
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);

CREATE TABLE Grades (
    StudentID INT,
    CourseID INT,
    Grade DECIMAL(4,2),
    LastUpdated DATETIME DEFAULT GETDATE(),
    PRIMARY KEY (StudentID, CourseID),
    FOREIGN KEY (StudentID, CourseID)
        REFERENCES Enrollments(StudentID, CourseID)
);
```
```sql
CREATE ROLE StudentRole;
CREATE ROLE InstructorRole;
CREATE ROLE DepartmentAdminRole;
CREATE ROLE AuditorRole;
```
```sql
CREATE VIEW StudentGradesView
AS
SELECT 
    s.StudentID,
    c.CourseName,
    g.Grade
FROM Grades g
JOIN Students s ON g.StudentID = s.StudentID
JOIN Courses c ON g.CourseID = c.CourseID
WHERE s.StudentID = CAST(SESSION_CONTEXT(N'StudentID') AS INT);

```
```sql
GRANT SELECT ON StudentGradesView TO StudentRole;
```
```sql
GRANT UPDATE ON Grades TO InstructorRole;
```
```sql
CREATE TABLE GradeAudit (
    AuditID INT IDENTITY PRIMARY KEY,
    StudentID INT,
    CourseID INT,
    OldGrade DECIMAL(4,2),
    NewGrade DECIMAL(4,2),
    ChangedBy SYSNAME,
    ChangeDate DATETIME DEFAULT GETDATE()
);
```
```sql
CREATE TRIGGER trg_GradeAudit
ON Grades
AFTER UPDATE
AS
BEGIN
    INSERT INTO GradeAudit
    SELECT 
        d.StudentID,
        d.CourseID,
        d.Grade,
        i.Grade,
        SYSTEM_USER,
        GETDATE()
    FROM deleted d
    JOIN inserted i
    ON d.StudentID = i.StudentID
    AND d.CourseID = i.CourseID;
END;
```
```sql
-- Student
CREATE LOGIN login_student 
WITH PASSWORD = 'Student@123';
GO

-- Instructor
CREATE LOGIN login_instructor 
WITH PASSWORD = 'Instructor@123';
GO

-- Auditor
CREATE LOGIN login_auditor 
WITH PASSWORD = 'Auditor@123';
GO
```
```sql
CREATE USER user_student FOR LOGIN login_student;
CREATE USER user_instructor FOR LOGIN login_instructor;
CREATE USER user_auditor FOR LOGIN login_auditor;
```
```sql
ALTER ROLE StudentRole ADD MEMBER user_student;
ALTER ROLE InstructorRole ADD MEMBER user_instructor;
ALTER ROLE AuditorRole ADD MEMBER user_auditor;
GO
```
```sql

```
```sql

```
```sql

```
```sql

```
```sql

```
```sql

```
```sql

```
```sql

```
```sql

```
```sql

```
