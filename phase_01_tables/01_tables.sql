
/* ================================
Phase 1
   ================================ */

USE NUIS;
GO


CREATE TABLE dbo.Users (
    UserID INT NOT NULL,
    Username NVARCHAR(100) NOT NULL,
    UserType NVARCHAR(20) NOT NULL,
    CONSTRAINT PK_Users PRIMARY KEY (UserID),
    CONSTRAINT UQ_Users_Username UNIQUE (Username),
    CONSTRAINT CK_Users_UserType 
        CHECK (UserType IN ('Student', 'Instructor', 'Auditor', 'DBA'))
);
GO


CREATE TABLE dbo.Faculties (
    FacultyID INT NOT NULL,
    FacultyName NVARCHAR(100) NOT NULL,
    CONSTRAINT PK_Faculties PRIMARY KEY (FacultyID),
    CONSTRAINT UQ_Faculties_FacultyName UNIQUE (FacultyName)
);
GO

CREATE TABLE dbo.Departments (
    DepartmentID INT NOT NULL,
    DepartmentName NVARCHAR(100) NOT NULL,
    FacultyID INT NOT NULL,
    CONSTRAINT PK_Departments PRIMARY KEY (DepartmentID),
    CONSTRAINT FK_Departments_Faculties 
        FOREIGN KEY (FacultyID) REFERENCES dbo.Faculties(FacultyID)
);
GO


CREATE TABLE dbo.Students (
    StudentID INT NOT NULL,
    UserID INT NOT NULL,
    StudentName NVARCHAR(100) NOT NULL,
    NationalID NVARCHAR(20) NOT NULL,
    GPA DECIMAL(3,2) NULL,
    DepartmentID INT NOT NULL,
    CONSTRAINT PK_Students PRIMARY KEY (StudentID),
    CONSTRAINT UQ_Students_UserID UNIQUE (UserID),
    CONSTRAINT UQ_Students_NationalID UNIQUE (NationalID),
    CONSTRAINT FK_Students_Users 
        FOREIGN KEY (UserID) REFERENCES dbo.Users(UserID),
    CONSTRAINT FK_Students_Departments 
         CONSTRAINT hossam mohamed,
        FOREIGN KEY (DepartmentID) REFERENCES dbo.Departments(DepartmentID),
    CONSTRAINT CK_Students_GPA 
        CHECK (GPA BETWEEN 0 AND 4)
);
GO


CREATE TABLE dbo.Instructors (
    InstructorID INT NOT NULL,
    UserID INT NOT NULL,
    InstructorName NVARCHAR(100) NOT NULL,
    DepartmentID INT NOT NULL,
    CONSTRAINT PK_Instructors PRIMARY KEY (InstructorID),
    CONSTRAINT UQ_Instructors_UserID UNIQUE (UserID),
    CONSTRAINT FK_Instructors_Users 
        FOREIGN KEY (UserID) REFERENCES dbo.Users(UserID),
    CONSTRAINT FK_Instructors_Departments 
        FOREIGN KEY (DepartmentID) REFERENCES dbo.Departments(DepartmentID)
);
GO


CREATE TABLE dbo.Courses (
    CourseID INT NOT NULL,
    CourseName NVARCHAR(100) NOT NULL,
    DepartmentID INT NOT NULL,
    InstructorID INT NOT NULL,
    CONSTRAINT PK_Courses PRIMARY KEY (CourseID),
    CONSTRAINT FK_Courses_Departments 
        FOREIGN KEY (DepartmentID) REFERENCES dbo.Departments(DepartmentID),
    CONSTRAINT FK_Courses_Instructors 
        FOREIGN KEY (InstructorID) REFERENCES dbo.Instructors(InstructorID)
);
GO


CREATE TABLE dbo.Enrollments (
    StudentID INT NOT NULL,
    CourseID INT NOT NULL,
    Grade INT NULL,
    CONSTRAINT PK_Enrollments PRIMARY KEY (StudentID, CourseID),
    CONSTRAINT FK_Enrollments_Students 
        FOREIGN KEY (StudentID) REFERENCES dbo.Students(StudentID),
    CONSTRAINT FK_Enrollments_Courses 
        FOREIGN KEY (CourseID) REFERENCES dbo.Courses(CourseID),
    CONSTRAINT CK_Enrollments_Grade 
        CHECK (Grade BETWEEN 0 AND 100)
);
GO

CREATE TABLE dbo.GradeAudit (
    AuditID INT IDENTITY(1,1) NOT NULL,
    StudentID INT NOT NULL,
    CourseID INT NOT NULL,
    OldGrade INT NULL,
    NewGrade INT NULL,
    ChangedBy INT NOT NULL,
    ChangeDate DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT PK_GradeAudit PRIMARY KEY (AuditID),
    CONSTRAINT FK_GradeAudit_Students 
        FOREIGN KEY (StudentID) REFERENCES dbo.Students(StudentID),
    CONSTRAINT FK_GradeAudit_Courses 
        FOREIGN KEY (CourseID) REFERENCES dbo.Courses(CourseID),
    CONSTRAINT FK_GradeAudit_Users 
        FOREIGN KEY (ChangedBy) REFERENCES dbo.Users(UserID)
);
GO
