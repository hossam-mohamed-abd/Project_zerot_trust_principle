# National University Information System (NUIS)
## SQL Server Team Project – Complete Development Guide

---

## 1. Project Introduction

This project implements a **National University Information System (NUIS)** using **Microsoft SQL Server only**.

The purpose of the system is to solve major security and data management problems found in traditional
university systems, such as:
- Data leakage between faculties
- Unauthorized access to student information
- Silent modification of grades
- Lack of accountability and auditing

The project focuses entirely on **database design, security, access control, and auditing**.
No frontend, backend, or application code is required.

---

## 2. Project Scope

### What This Project Includes
- Creating a SQL Server database
- Designing database tables
- Creating roles for different users
- Controlling access using permissions
- Using views as a security layer
- Auditing grade changes using triggers

### What This Project Does NOT Include
- Web or desktop applications
- User interfaces
- APIs or backend logic

---

## 3. Team Information

- Team Size: 6 Members
- SQL Level: Beginner
- Project Type: Database-only
- Development Method: Step-by-step phases
- Leadership Model: One leader controls naming, review, and final integration

---

## 4. Technology Used

- Database Engine: Microsoft SQL Server
- Language: SQL
- Environment: Local SQL Server instance

---

## 5. Core Project Idea

The system must guarantee that:
- Every user can access only what they are allowed to
- Students can see only their own data
- Instructors can modify grades only for their courses
- Auditors can see logs but cannot modify data
- Even the DBA cannot change grades without leaving evidence

If any of these conditions fail, the system is considered rejected.

---

## 6. Mandatory Naming Rules (Strict)

⚠️ Naming rules are mandatory and cannot be changed without leader approval.

### Database Name
NUIS

---

### Tables and Columns

#### Students
StudentID
StudentName
NationalID
GPA

#### Instructors
InstructorID
InstructorName

shell
Copy code

#### Courses
CourseID
CourseName
InstructorID

shell
Copy code

#### Enrollments
StudentID
CourseID
Grade

shell
Copy code

#### GradeAudit
AuditID
StudentID
CourseID
OldGrade
NewGrade
ChangeDate

yaml
Copy code

---

### Roles
StudentRole
InstructorRole
AuditorRole
DBARole

yaml
Copy code

---

### Views
StudentView
InstructorView

yaml
Copy code

---

## 7. Development Strategy (How the Team Works)

The project is developed in **clear ordered stages**.
Each stage depends on the previous one.

The correct order is:
1. Database and tables
2. Roles creation
3. Views creation
4. Permissions assignment
5. Auditing implementation
6. Final review and testing

---

## 8. Development Stages and Responsibilities

### Stage 0 – Project Setup
**Responsible:** Project Leader

- Define naming rules
- Organize the workflow
- Assign tasks to team members
- Review all outputs
- Approve final result

---

### Stage 1 – Database & Tables
**Responsible:** Team Member 1

- Create the database `NUIS`
- Create all required tables
- Define primary keys
- Keep structure simple and clear

**Rules:**
- Tables only
- No roles
- No permissions
- No views

---

### Stage 2 – Roles Creation
**Responsible:** Team Member 2

- Create all system roles

**Rules:**
- Roles only
- No GRANT statements
- No access to tables or views

---

### Stage 3 – Views (Security Layer)
**Responsible:** Team Member 3

- Create views for students and instructors
- Expose only allowed columns
- Hide sensitive data where needed

**Rules:**
- Views only
- No permissions
- No roles

---

### Stage 4 – Permissions (Access Control)
**Responsible:** Team Member 4

- Grant permissions to roles
- Use views only
- Revoke any direct table access

**Rules:**
- No direct permissions on tables
- Follow least privilege principle

---

### Stage 5 – Auditing & Triggers
**Responsible:** Team Member 5

- Create audit table
- Create trigger to log grade changes
- Ensure every grade update is recorded

**Rules:**
- No silent modifications
- Auditing is mandatory

---

## 9. Leader Final Responsibilities

The project leader must:
- Review all SQL code
- Ensure naming consistency
- Ensure correct execution order
- Test the system from start to end
- Validate security and auditing behavior

---

## 10. Team Rules

- Naming rules are mandatory
- No one works outside their assigned stage
- No direct table permissions
- No individual decisions without leader approval
- SQL must remain simple and beginner-friendly

---

## 11. Final Expected Result

The final system must demonstrate that:
- Data leakage is impossible
- Unauthorized access is blocked
- Grade manipulation is fully audited
- Responsibility and accountability are enforced
- Database security is correctly implemented

---

## 12. Conclusion

This project demonstrates how a secure and professional database system can be built using SQL Server,
even by a beginner team, through proper planning, strict organization, and clear responsibility
distribution.

