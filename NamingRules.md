# Mandatory Naming Rules (Strict)

This section defines the COMPLETE and FINAL technical contract of the project.
All team members must follow these rules exactly.
This file represents the single source of truth for the entire system.


DATABASE
===============

Database Name:
- NUIS

No other database name is allowed.


TABLES, COLUMNS, DATA TYPES
===============

Faculties
- FacultyID        INT             PRIMARY KEY
- FacultyName      NVARCHAR(100)    NOT NULL UNIQUE

--------------------------------------------------

Departments
- DepartmentID     INT             PRIMARY KEY
- DepartmentName   NVARCHAR(100)    NOT NULL
- FacultyID        INT             NOT NULL

Foreign Key:
- FacultyID → Faculties(FacultyID)

--------------------------------------------------

Users
- UserID           INT             PRIMARY KEY
- Username         NVARCHAR(100)    NOT NULL UNIQUE
- UserType         NVARCHAR(20)     NOT NULL

Allowed UserType values:
- Student
- Instructor
- Auditor
- DBA

--------------------------------------------------

Students
- StudentID        INT             PRIMARY KEY
- UserID           INT             NOT NULL UNIQUE
- StudentName      NVARCHAR(100)    NOT NULL
- NationalID       NVARCHAR(20)     NOT NULL UNIQUE
- GPA              DECIMAL(3,2)     CHECK (GPA BETWEEN 0 AND 4)
- DepartmentID     INT             NOT NULL

Foreign Keys:
- UserID → Users(UserID)
- DepartmentID → Departments(DepartmentID)

--------------------------------------------------

Instructors
- InstructorID     INT             PRIMARY KEY
- UserID           INT             NOT NULL UNIQUE
- InstructorName   NVARCHAR(100)    NOT NULL
- DepartmentID     INT             NOT NULL

Foreign Keys:
- UserID → Users(UserID)
- DepartmentID → Departments(DepartmentID)

--------------------------------------------------

Courses
- CourseID         INT             PRIMARY KEY
- CourseName       NVARCHAR(100)    NOT NULL
- DepartmentID     INT             NOT NULL
- InstructorID     INT             NOT NULL

Foreign Keys:
- DepartmentID → Departments(DepartmentID)
- InstructorID → Instructors(InstructorID)

--------------------------------------------------

Enrollments
- StudentID        INT             NOT NULL
- CourseID         INT             NOT NULL
- Grade            INT             CHECK (Grade BETWEEN 0 AND 100)

Primary Key:
- (StudentID, CourseID)

Foreign Keys:
- StudentID → Students(StudentID)
- CourseID → Courses(CourseID)

--------------------------------------------------

GradeAudit
- AuditID          INT IDENTITY    PRIMARY KEY
- StudentID        INT             NOT NULL
- CourseID         INT             NOT NULL
- OldGrade         INT
- NewGrade         INT
- ChangedBy        INT             NOT NULL
- ChangeDate       DATETIME        DEFAULT GETDATE()

Foreign Keys:
- StudentID → Students(StudentID)
- CourseID → Courses(CourseID)
- ChangedBy → Users(UserID)


ROLES (SECURITY CONTRACT)
==================================================

The following database roles MUST exist:

- StudentRole
- InstructorRole
- AuditorRole
- DBARole

Rules:
- No permissions granted directly to users
- All permissions are granted through roles only


VIEWS (MANDATORY SECURITY LAYER)
==================================================

The following views MUST exist:

- StudentView
- InstructorView

Rules:
- Views are the ONLY allowed access layer
- Direct SELECT / UPDATE on tables is forbidden
- Roles interact ONLY with views


PERMISSION RULES
==================================================

StudentRole:
- SELECT on StudentView only

InstructorRole:
- SELECT, UPDATE on InstructorView only

AuditorRole:
- SELECT on all views
- NO INSERT, UPDATE, DELETE

DBARole:
- Full control
- All grade changes must be audited


AUDITING RULES
==================================================

- Any UPDATE on Enrollments.Grade MUST be logged
- Logging must include:
  - Old value
  - New value
  - User who changed it
  - Date and time
- Silent grade modification is strictly forbidden


NAMING CONVENTIONS
==================================================

- Use PascalCase for all names
- No underscores (_)
- No abbreviations
- No pluralization inconsistencies
- No additional tables or columns allowed


ENFORCEMENT
==================================================

Any SQL code that:
- Violates naming rules
- Breaks constraints
- Bypasses views
- Skips auditing

will be rejected and rewritten.

These rules are FINAL and binding for all team members.
