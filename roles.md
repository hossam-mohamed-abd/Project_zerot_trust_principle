# National University Information System (NUIS)
## SQL Server Project – Team Guide & Development Plan

---

## 1. Project Overview

This project aims to build a **secure National University Information System (NUIS)** using
**Microsoft SQL Server only**.

The system is designed to solve critical problems found in traditional university systems,
such as:
- Data leakage between faculties
- Unauthorized access to student records
- Silent modification of grades
- Lack of auditing and accountability

The project focuses on **database security, role-based access control, and auditing**.
No frontend or backend application is required.

---

## 2. Project Scope

### Included
- Database creation
- Tables design
- Roles and permissions
- Secure views
- Auditing using triggers
- SQL Server implementation only

### Not Included
- Frontend UI
- Backend API
- Web or desktop applications

---

## 3. Team Information

- Team Size: 6 Members
- Skill Level: Beginner in SQL
- Development Style: Step-by-step, role-based teamwork
- Leadership Model: One leader responsible for naming, review, and integration

---

## 4. Technology Stack

- Database Engine: Microsoft SQL Server
- Language: SQL
- Development Type: Database-only project

---

## 5. Project Structure

All project files must follow this structure exactly:

NUIS_Project/
│
├── 01_tables.sql
├── 02_roles.sql
├── 03_views.sql
├── 04_permissions.sql
├── 05_audit.sql
└── NUIS_Final.sql

yaml
Copy code

---

## 6. Execution Order

The SQL files must be executed in the following order:

1. 01_tables.sql  
2. 02_roles.sql  
3. 03_views.sql  
4. 04_permissions.sql  
5. 05_audit.sql  

The final merged file:
- `NUIS_Final.sql`

---

## 7. Mandatory Naming Rules (Strict)

⚠️ These rules are **mandatory**.
No team member is allowed to change any name without leader approval.

---

### 7.1 Database Name

NUIS

yaml
Copy code

---

### 7.2 Tables and Columns

#### Table: Students
StudentID
StudentName
NationalID
GPA

yaml
Copy code

---

#### Table: Instructors
InstructorID
InstructorName

yaml
Copy code

---

#### Table: Courses
CourseID
CourseName
InstructorID

yaml
Copy code

---

#### Table: Enrollments
StudentID
CourseID
Grade

yaml
Copy code

---

#### Table: GradeAudit
AuditID
StudentID
CourseID
OldGrade
NewGrade
ChangeDate

yaml
Copy code

---

### 7.3 Roles

Roles must be created exactly with the following names:

StudentRole
InstructorRole
AuditorRole
DBARole

yaml
Copy code

---

### 7.4 Views

Views must be created exactly with the following names:

StudentView
InstructorView

yaml
Copy code

---

## 8. Development Phases

The project is divided into clear phases.
Each phase has a specific responsibility and output.

---

### Phase 0 – Project Setup
**Responsible:** Project Leader

**Tasks:**
- Prepare project structure
- Define naming rules
- Assign tasks to team members
- Review and approve all outputs

**Output:**
- Ready project environment
- Unified naming standards

---

### Phase 1 – Database & Tables
**Responsible:** Team Member 1

**Tasks:**
- Create database `NUIS`
- Create all required tables
- Define primary keys
- Keep table design simple and clear

**Rules:**
- Tables only
- No roles
- No permissions
- No views

**Output File:**
- `01_tables.sql`

---

### Phase 2 – Roles Creation
**Responsible:** Team Member 2

**Tasks:**
- Create all system roles

**Rules:**
- Roles only
- No GRANT
- No access to tables or views

**Output File:**
- `02_roles.sql`

---

### Phase 3 – Views (Security Layer)
**Responsible:** Team Member 3

**Tasks:**
- Create secure views
- Expose only necessary columns
- Hide sensitive data where possible

**Rules:**
- Views only
- No permissions
- No role assignments

**Output File:**
- `03_views.sql`

---

### Phase 4 – Permissions (Access Control)
**Responsible:** Team Member 4

**Tasks:**
- Grant permissions to roles using views only
- Revoke any direct table access
- Apply least privilege principle

**Rules:**
- No direct permissions on tables
- GRANT / REVOKE only

**Output File:**
- `04_permissions.sql`

---

### Phase 5 – Auditing & Triggers
**Responsible:** Team Member 5

**Tasks:**
- Create audit table
- Create trigger to log grade changes
- Ensure no grade update happens without logging

**Rules:**
- Every grade update must be audited
- No silent modifications

**Output File:**
- `05_audit.sql`

---

## 9. Final Integration

**Responsible:** Project Leader

**Tasks:**
- Review all SQL files
- Ensure naming consistency
- Merge all files into one final script
- Test full execution from start to end

**Final Output:**
- `NUIS_Final.sql`

---

## 10. Team Rules

- Naming rules are mandatory
- No direct permissions on tables
- No individual changes without leader approval
- Keep SQL simple and beginner-friendly
- Every file must follow its assigned phase only

---

## 11. Final Goal (Expected Result)

The final system must guarantee that:

- Each user can access only their own data
- No unauthorized data access is possible
- Grades cannot be modified without being recorded
- All sensitive operations are fully audited
- Data integrity and privacy are protected at all times

Failure to meet these goals means the system is rejected.

---

## 12. Conclusion

This project demonstrates the ability to design a **secure, well-structured, and audited
database system** using SQL Server, even with beginner-level SQL knowledge, through proper
planning, teamwork, and strict organization.
