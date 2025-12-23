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
