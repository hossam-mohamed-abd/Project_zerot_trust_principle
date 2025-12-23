#  Secure University Database System (SQL Server)

##  Project Overview
This project implements a **Secure University Database System** using **Microsoft SQL Server**.

The main goal is to demonstrate:
- Proper database design
- Role-Based Access Control (RBAC)
- Secure data access using Views
- Auditing sensitive operations (grade updates)
- Real-world database security concepts

This is **not a simple CRUD project**, but a **security-focused database system**.

---

##  System Concept
The system manages:
- Students
- Instructors
- Courses
- Enrollments (Grades)
- Audit logs for grade changes

Each user type has **strict permissions**:
- Students see only their own grades
- Instructors see and update only their students
- Auditors review changes only
- DBA controls everything

---

**Database Name :**
****UniversityDB****
---

### ===> Database Tables

#### 2 Users
Stores system users (logical users, not logins)

```sql
CREATE TABLE Users (
    UserID INT PRIMARY KEY,
    Username NVARCHAR(100) NOT NULL,
    UserType NVARCHAR(20) NOT NULL
);
```

#### 2 Faculties
```sql
CREATE TABLE Faculties (
    FacultyID INT PRIMARY KEY,
    FacultyName NVARCHAR(100) NOT NULL UNIQUE
);
```

#### 3 Departments
```sql
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName NVARCHAR(100) NOT NULL,
    FacultyID INT NOT NULL,
    FOREIGN KEY (FacultyID) REFERENCES Faculties(FacultyID)
);
```

#### 4 Students
```sql
CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    UserID INT UNIQUE NOT NULL,
    StudentName NVARCHAR(100) NOT NULL,
    NationalID NVARCHAR(20) UNIQUE NOT NULL,
    GPA DECIMAL(3,2),
    DepartmentID INT NOT NULL,
    CHECK (GPA BETWEEN 0 AND 4),
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);
```

#### 5 Instructors
```sql
CREATE TABLE Instructors (
    InstructorID INT PRIMARY KEY,
    UserID INT UNIQUE NOT NULL,
    InstructorName NVARCHAR(100) NOT NULL,
    DepartmentID INT NOT NULL,
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

```

#### 6 Courses
```sql
CREATE TABLE Courses (
    CourseID INT PRIMARY KEY,
    CourseName NVARCHAR(100) NOT NULL,
    DepartmentID INT NOT NULL,
    InstructorID INT NOT NULL,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID),
    FOREIGN KEY (InstructorID) REFERENCES Instructors(InstructorID)
);
```

#### 7 Enrollments
```sql
CREATE TABLE Enrollments (
    StudentID INT NOT NULL,
    CourseID INT NOT NULL,
    Grade INT CHECK (Grade BETWEEN 0 AND 100),
    PRIMARY KEY (StudentID, CourseID),
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);
```

#### 8 GradeAudit (Audit Log)
```sql
CREATE TABLE GradeAudit (
    AuditID INT IDENTITY PRIMARY KEY,
    StudentID INT,
    CourseID INT,
    OldGrade INT,
    NewGrade INT,
    ChangedBy INT,
    ChangeDate DATETIME DEFAULT GETDATE()
);
```
---
## Roles & Security

### Roles Created
```sql
CREATE ROLE StudentRole;
CREATE ROLE InstructorRole;
CREATE ROLE AuditorRole;
CREATE ROLE DBARole;
```
### SQL Server Logins
| Role | Login | Password |
|----|------|-------|
| Student | login_student | Student@123|
| Instructor  | login_instructor   | Instructor@123 |
| Auditor  | login_auditor  | Auditor@123 |
| DBA  | login_DBA  | DBA@123 |

```sql
CREATE LOGIN login_student WITH PASSWORD='Student@123';
CREATE USER login_student FOR LOGIN login_student;
ALTER ROLE StudentRole ADD MEMBER login_student;
```

### Direct Table Access Disabled
#### Direct Table Access Disabled
```sql
DENY SELECT, INSERT, UPDATE, DELETE ON Students TO StudentRole;
DENY SELECT, INSERT, UPDATE, DELETE ON Enrollments TO InstructorRole;
```

##  Secure Views

###  StudentGradesView

> **Description**  
> Students can see only their own grades.

```sql
CREATE VIEW StudentGradesView AS
SELECT u.Username, s.StudentName, c.CourseName, e.Grade
FROM Users u
JOIN Students s ON u.UserID=s.UserID
JOIN Enrollments e ON s.StudentID=e.StudentID
JOIN Courses c ON e.CourseID=c.CourseID
WHERE u.Username =
    CASE SYSTEM_USER
        WHEN 'login_student' THEN 'student_ali'
    END;
```
```sql
GRANT SELECT ON StudentGradesView TO StudentRole;
```

###  InstructorStudentsView

> **Description**  
> Instructors can see and update grades of their own students only.

```sql
CREATE VIEW InstructorStudentsView AS
SELECT i.InstructorName, s.StudentName, c.CourseName,
       e.Grade, e.StudentID, e.CourseID
FROM Instructors i
JOIN Courses c ON i.InstructorID=c.InstructorID
JOIN Enrollments e ON c.CourseID=e.CourseID
JOIN Students s ON e.StudentID=s.StudentID
WHERE i.InstructorName =
    CASE SYSTEM_USER
        WHEN 'login_instructor' THEN 'Dr. Ahmed Ali'
    END;
```
```sql
GRANT SELECT, UPDATE ON InstructorStudentsView TO InstructorRole;
```

##  Audit Trigger (Grade Updates)

```sql
CREATE TRIGGER trg_LogGradeUpdate
ON Enrollments
AFTER UPDATE
AS
BEGIN
    INSERT INTO GradeAudit
    SELECT d.StudentID, d.CourseID,
           d.Grade, i.Grade,
           u.UserID, GETDATE()
    FROM deleted d
    JOIN inserted i ON d.StudentID=i.StudentID AND d.CourseID=i.CourseID
    JOIN Users u ON u.Username='inst_ahmed'
    WHERE d.Grade <> i.Grade;
END;
```
### Auditor View
```sql
CREATE VIEW AuditGradesView AS
SELECT s.StudentName, c.CourseName,
       ga.OldGrade, ga.NewGrade,
       u.Username, ga.ChangeDate
FROM GradeAudit ga
JOIN Students s ON ga.StudentID=s.StudentID
JOIN Courses c ON ga.CourseID=c.CourseID
JOIN Users u ON ga.ChangedBy=u.UserID;
```
```sql
GRANT SELECT ON AuditGradesView TO AuditorRole;
```

## Testing Scenarios
### Student
```sql
SELECT * FROM StudentGradesView;  --  Allowed
SELECT * FROM Students;           --  Denied
```
### Instructor
```sql
UPDATE InstructorStudentsView
SET Grade=90
WHERE StudentID=1 AND CourseID=1;
```
### Auditor
```sql
SELECT * FROM AuditGradesView;
```

