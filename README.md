# Project_zerot_trust_principle
# NUIS Project – Team Work Plan

## Project Overview
This project aims to build a secure National University Information System (NUIS) using SQL Server.
The main goal is to design a database system that prevents data leakage, enforces strict access control,
and records all sensitive operations such as grade changes.

The project is implemented purely using SQL code and is divided into clear stages to ensure proper teamwork
and correct system design.

---

## Team Size
- Total Members: 6
- Skill Level: Beginner in SQL
- Approach: Step-by-step, role-based teamwork

---

## Project Development Stages

### Phase 0 – Project Setup (Leader Only)
**Objective:** Prepare the project environment and unify standards.

**Tasks:**
- Create the main project folder / repository
- Create the main SQL file structure
- Define naming conventions for tables, roles, and columns
- Assign tasks to team members

**Output:**
- Project structure ready
- Clear naming rules

---

### Phase 1 – Database & Tables
**Assigned To:**   
**Objective:** Create the database and all required tables.

**Tasks:**
- Create the database
- Create core tables (Students, Instructors, Courses, Enrollments, Audit)
- Define primary keys and basic structure

**Rules:**
- No roles
- No permissions
- Tables only

**Output:**
- `01_tables.sql`

---

### Phase 2 – Roles Creation
**Assigned To:**   
**Objective:** Define system roles.

**Tasks:**
- Create roles such as:
  - StudentRole
  - InstructorRole
  - AuditorRole
  - DBARole

**Rules:**
- No GRANT
- No table access
- Roles only

**Output:**
- `02_roles.sql`

---

### Phase 3 – Views (Security Layer)
**Assigned To:** 
**Objective:** Create secure views for data access.

**Tasks:**
- Create views for students and instructors
- Ensure views expose only allowed data

**Rules:**
- Views depend on tables
- No permissions assigned here

**Output:**
- `03_views.sql`

---

### Phase 4 – Permissions (Access Control)
**Assigned To:** 
**Objective:** Link roles with permissions safely.

**Tasks:**
- Grant permissions to roles on views only
- Revoke any direct access to tables

**Rules:**
- No direct table access
- Use GRANT / REVOKE only

**Output:**
- `04_permissions.sql`

---

### Phase 5 – Auditing & Triggers
**Assigned To:** Team Member 5  
**Objective:** Track all sensitive changes.

**Tasks:**
- Create audit table
- Create trigger to log grade updates

**Rules:**
- Every grade update must be logged
- No silent modifications allowed

**Output:**
- `05_audit.sql`

---

## Final Integration
**Responsibility:** Project Leader(hossam mohamed)

**Tasks:**
- Review all SQL files
- Merge them into one final script
- Test execution order
- Ensure system works as expected

**Final Output:**
- `NUIS_Final.sql`

---

## Execution Order
1. 01_tables.sql  
2. 02_roles.sql  
3. 03_views.sql  
4. 04_permissions.sql  
5. 05_audit.sql  

---

## Team Rules
- No one changes table or column names without leader approval
- No direct permissions on tables
- All work must follow the defined phases
- Simplicity is required (beginner-friendly SQL)

---

## Project Goal (Final Result)
A secure SQL Server database system where:
- Users can only access their own data
- Unauthorized access is impossible
- All sensitive actions are fully audited
- Data integrity and privacy are guaranteed

