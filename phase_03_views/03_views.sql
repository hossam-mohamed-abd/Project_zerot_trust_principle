--Phase 3 – Views (Security Layer)

USE NUIS;
GO

--Student Views

CREATE VIEW dbo.vw_StudentGrades
AS
SELECT
    s.StudentID,
    s.StudentName,
    d.DepartmentName,
    c.CourseName,
    e.Grade
FROM dbo.Students s
JOIN dbo.Departments d ON s.DepartmentID = d.DepartmentID
JOIN dbo.Enrollments e ON s.StudentID = e.StudentID
JOIN dbo.Courses c ON e.CourseID = c.CourseID;
GO

--Instructor Views

CREATE VIEW dbo.vw_InstructorCourses
AS
SELECT
    i.InstructorID,
    i.InstructorName,
    c.CourseID,
    c.CourseName,
    s.StudentID,
    s.StudentName,
    e.Grade
FROM dbo.Instructors i
JOIN dbo.Courses c ON i.InstructorID = c.InstructorID
JOIN dbo.Enrollments e ON c.CourseID = e.CourseID
JOIN dbo.Students s ON e.StudentID = s.StudentID;
GO


--Auditor Views

CREATE VIEW dbo.vw_GradeAudit
AS
SELECT
    ga.AuditID,
    ga.StudentID,
    s.StudentName,
    ga.CourseID,
    c.CourseName,
    ga.OldGrade,
    ga.NewGrade,
    u.Username AS ChangedBy,
    ga.ChangeDate
FROM dbo.GradeAudit ga
JOIN dbo.Students s ON ga.StudentID = s.StudentID
JOIN dbo.Courses c ON ga.CourseID = c.CourseID
JOIN dbo.Users u ON ga.ChangedBy = u.UserID;
GO
