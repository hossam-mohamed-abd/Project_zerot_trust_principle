# 🧾 شرح كود SQL المستخدم في مشروع Secure University Database System

---

##  أولًا: إنشاء قاعدة البيانات

```sql
CREATE DATABASE UniversityDB;
```
###  الشرح

- السطر ده بيعمل **قاعدة بيانات جديدة**
- اسم قاعدة البيانات هو **UniversityDB**
- قاعدة البيانات دي تعتبر **الحاوية الأساسية** اللي هيتخزن جواها:
  - كل الجداول
  - العلاقات
  - القيود (Constraints)
  - الصلاحيات (Permissions)

>  بدون إنشاء قاعدة البيانات، لا يمكن إنشاء أي جداول أو تطبيق أي نظام أمان داخل المشروع.
-------
```sql
USE UniversityDB;
```
###  الشرح

-بنقول لـ SQL Server:
أي أوامر جاية بعد كده تتنفذ جوه قاعدة البيانات دي

-------
## جدول Users
```sql
CREATE TABLE Users (
    UserID INT PRIMARY KEY,
    Username NVARCHAR(100) NOT NULL,
    UserType NVARCHAR(20) NOT NULL
);
```
###  الشرح
الجدول ده بيخزن الأشخاص في النظام

UserID رقم مميز لكل شخص

Username اسم المستخدم

UserType نوعه (Student / Instructor / Auditor / DBA)

> ده جدول بيانات، مش تسجيل دخول.
-------
## جدول Students
```sql
CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    UserID INT UNIQUE NOT NULL,
    StudentName NVARCHAR(100) NOT NULL,
    NationalID NVARCHAR(20) UNIQUE NOT NULL,
    GPA DECIMAL(3,2),
    DepartmentID INT NOT NULL,
    CHECK (GPA BETWEEN 0 AND 4)
);
```
###  الشرح
ده جدول الطلاب الحقيقيين

كل طالب ليه:

اسم

رقم قومي

GPA

>CHECK بتضمن إن الـ GPA بين 0 و 4 فقط > ده جدول بيانات، مش تسجيل دخول.

-------
## جدول Instructors
```sql
CREATE TABLE Instructors (
    InstructorID INT PRIMARY KEY,
    UserID INT UNIQUE NOT NULL,
    InstructorName NVARCHAR(100) NOT NULL,
    DepartmentID INT NOT NULL
);
```
###  الشرح
ده جدول المدرسين

كل مدرس مربوط بـ User واحد فقط

بيحدد اسم المدرس والقسم بتاعه
-------
## جدول Courses
```sql
CREATE TABLE Courses (
    CourseID INT PRIMARY KEY,
    CourseName NVARCHAR(100) NOT NULL,
    DepartmentID INT NOT NULL,
    InstructorID INT NOT NULL
);
```
###  الشرح
ده جدول المواد الدراسية

كل مادة:

اسمها

القسم التابع ليها

المدرس المسؤول عنها
-------
## جدول Enrollments
```sql
CREATE TABLE Enrollments (
    StudentID INT NOT NULL,
    CourseID INT NOT NULL,
    Grade INT CHECK (Grade BETWEEN 0 AND 100),
    PRIMARY KEY (StudentID, CourseID)
);
```
###  الشرح
ده أهم جدول

بيربط:

الطالب

بالمادة

وبدرجته

الـ PRIMARY KEY المزدوج يمنع تكرار نفس الطالب في نفس المادة
-------
## جدول GradeAudit (المراقبة)
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
###  الشرح
ده جدول تسجيل التعديلات

أي تغيير درجة:

يتسجل هنا تلقائي

IDENTITY يعني الرقم بيزيد لوحده

GETDATE() بتسجل وقت التعديل


---

## إنشاء Roles
```sql
CREATE ROLE StudentRole;
CREATE ROLE InstructorRole;
CREATE ROLE AuditorRole;
CREATE ROLE DBARole;
```
###  الشرح
Role = مجموعة صلاحيات

بدل ما ندي صلاحيات لكل شخص

بنديها للدور
-----


## إنشاء Login و User 
```sql
CREATE LOGIN login_student WITH PASSWORD='Student@123';
CREATE USER login_student FOR LOGIN login_student;
ALTER ROLE StudentRole ADD MEMBER login_student;
```
###  الشرح
- ```sql CREATE LOGIN ```: حساب دخول فعلي للسيرفر.
- ```sql CREATE USER ```: يربط الحساب بقاعدة البيانات.
- ```sql ALTER ROLE ```: يضيف المستخدم للدور المناسب.



### لماذا نحتاج Login و User؟
- **Login**: يسمح للمستخدم بالدخول إلى السيرفر.
- **User**: يحدد ما يمكن للمستخدم فعله داخل قاعدة بيانات معينة.

> بدون CREATE USER  
> المستخدم يدخل السيرفر لكنه لا يستطيع استخدام قاعدة البيانات.
-----


## منع الوصول المباشر للجداول (DENY) 
```sql
DENY SELECT, INSERT, UPDATE, DELETE ON Students TO StudentRole;
```
###  الشرح
السطر ده بيمنع الطالب نهائيًا:

يشوف

يضيف

يعدل

يحذف
من جدول Students


### الأمان هنا:

- ممنوع التعامل المباشر مع الجداول

-----

## StudentGradesView
```sql
CREATE OR ALTER VIEW InstructorStudentsView
AS
SELECT
    i.InstructorName,
    s.StudentName,
    c.CourseName,
    e.Grade,
    e.StudentID,
    e.CourseID
FROM Users u
JOIN Instructors i ON u.UserID = i.UserID
JOIN Courses c ON i.InstructorID = c.InstructorID
JOIN Enrollments e ON c.CourseID = e.CourseID
JOIN Students s ON e.StudentID = s.StudentID
WHERE u.Username = SUSER_SNAME();
GO
```
###  الشرح
View بتعرض درجات الطالب فقط

SYSTEM_USER بتعرف مين اللي داخل

الشرط بيضمن إن الطالب يشوف نفسه بس
-----

## InstructorStudentsView
```sql
CREATE OR ALTER VIEW InstructorStudentsView
AS
SELECT
    i.InstructorName,
    s.StudentName,
    c.CourseName,
    e.Grade,
    e.StudentID,
   e.StudentID
FROM Users u

FROM Users u
JOIN Instructors i ON u.Use
JOIN Courses c ON i.InstructorID = c.InstructorID
JOIN Enrollments e ON c.CourseID = e.CourseID
JOIN Students s ON e.StudentID = s.StudentID
WHERE u.Username = SUSER_SNAME();
HE
```
``
###audit viow
المدرس يشوف الطلبة بتوعه فقط
```sql
CREATE OR ALTER VIEW AuditGradesView
AS
SELECT
    s.StudentName,
    c.CourseName,
    ga.OldGrade,
    ga.NewGrade,
    u.Username AS ChangedBy,
    ga.ChangeDate
FROM GradeAudit ga
JOIN Students s ON ga.StudentID = s.StudentID
JOIN Courses c ON ga.CourseID = c.CourseID
JOIN Users u ON ga.ChangedBy = u.UserID;
GO
```
يقدر يعدل درجاتهم

ميشوفش طلبة مدرس تاني
-----

## Trigger (تسجيل تعديل الدرجات)
```sql
GRANT SELECT, UPDATE ON InstructorStudentsView TO InstructorRole;
GO

DENY SELECT, INSERT, UPDATE, DELETE ON Enrollments TO InstructorRole;
DENY SELECT, INSERT, UPDATE, DELETE ON Students TO InstructorRole;
GO
```
###  الشرح
التريجر بيشتغل تلقائي بعد أي تعديل
ل

deleted = الدرجة القديمة

inserted = الدرجة الجديدة

بيسجل التغيير فيGradeAudit

---
## Testing & Verification
### StudentRole
<img width="636" height="587" alt="image" src="https://github.com/user-attachments/assets/eab3bdf8-6368-4c0b-9bf8-9d00fd07941c" 


```sql

student_ali
Student@123
```
```sql
SELECT * FROM StudentGradesView;
```
```sql
SELECT * FROM Students;
-- RESULT : The SELECT permission was denied on the object 'Student
-- BECUSE DENY
```
```sql
UPDATE Enrollments
SET Grade = 100
WHERE StudentID = 1 AND CourseID = 1;
```
### InstructorRole
<img width="624" height="330" alt="image" src="https://github.com/user-attachments/assets/bc56a588-948c-43c9-b3be-293f17e6b547" />


```sql
inst_ahmed
Password@123
```
```sql
SELECT * FROM InstructorStudentsView;
```
```sql
UPDATE InstructorStudentsView
SET Grade = 90
WHERE StudentID = 1 AND CourseID = 1;
```
```sql
SELECT * FROM Students;
--RESULT : The SELECT permission was denied on the object 'Students'
```

### AuditorRole

```sql
auditor_1
Password@123
```
```sql
SELECT * FROM AuditGradesView;
```


### DBA
```sql
SELECT * FROM Students;
SELECT * FROM Enrollments;
SELECT * FROM GradeAudit;
```

```sql
SELECT * FROM GradeAudit;
```

