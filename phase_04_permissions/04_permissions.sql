/* ================================
   Phase 6 – Data Seeding & Testing Logs
   ================================ */

USE NUIS;
GO

-- 1. Insert Users (We need UserID 1 because the Trigger uses it as 'ChangedBy')
-- Note: Based on your schema, IDs are manual, not Identity.
INSERT INTO dbo.Users (UserID, Username, UserType) VALUES 
(1, 'AdminUser', 'DBA'),         -- This will be the one "changing" the grades in our trigger logic
(2, 'Dr.Ahmed', 'Instructor'),
(3, 'Hussam', 'Student'),
(4, 'AuditUser', 'Auditor');
GO

-- 2. Insert Faculties & Departments
INSERT INTO dbo.Faculties (FacultyID, FacultyName) VALUES 
(100, 'Faculty of Computer Science');

INSERT INTO dbo.Departments (DepartmentID, DepartmentName, FacultyID) VALUES 
(10, 'Computer Science', 100),
(20, 'Information Systems', 100);
GO

-- 3. Insert Profiles (Instructor & Student)
INSERT INTO dbo.Instructors (InstructorID, UserID, InstructorName, DepartmentID) VALUES 
(200, 2, 'Dr. Ahmed Ali', 10);

INSERT INTO dbo.Students (StudentID, UserID, StudentName, NationalID, GPA, DepartmentID) VALUES 
(300, 3, 'Hussam Ezzat', '30101010101', 3.4, 10);
GO

-- 4. Insert Course & Enrollment
INSERT INTO dbo.Courses (CourseID, CourseName, DepartmentID, InstructorID) VALUES 
(500, 'Database Systems II', 10, 200);

-- Hussam enrolls in Database Systems II with an initial grade of 85
INSERT INTO dbo.Enrollments (StudentID, CourseID, Grade) VALUES 
(300, 500, 85);
GO

print '=== Data Inserted Successfully ===';
GO

/* ================================
   THE MOMENT OF TRUTH: Generating the Log
   ================================ */

-- Scenario: The Instructor realized there was a mistake. 
-- Hussam actually got 95, not 85.
-- Let's UPDATE the grade. This action should fire the TRIGGER.

UPDATE dbo.Enrollments
SET Grade = 95
WHERE StudentID = 300 AND CourseID = 500;
GO

print '=== Grade Updated. Checking Logs... ===';
GO

-- 5. View the Audit Logs
-- Now we query the Audit View to see if it caught the change.
SELECT * FROM dbo.vw_GradeAudit;
GO
