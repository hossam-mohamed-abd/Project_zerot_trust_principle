USE NUIS;
GO

-- 1. Create GradeAudit Table

  CREATE TABLE GradeAudit (
    AuditID INT IDENTITY PRIMARY KEY,
    StudentID INT NOT NULL,
    CourseID INT NOT NULL,
    OldGrade INT,
    NewGrade INT,
    ChangedBy INT NOT NULL,
    ChangeDate DATETIME DEFAULT GETDATE(),

    CONSTRAINT FK_GradeAudit_Student
        FOREIGN KEY (StudentID) REFERENCES Students(StudentID),

    CONSTRAINT FK_GradeAudit_Course
        FOREIGN KEY (CourseID) REFERENCES Courses(CourseID),

    CONSTRAINT FK_GradeAudit_User
        FOREIGN KEY (ChangedBy) REFERENCES Users(UserID)
);
GO

-- 2. Trigger to Log Grade Updates
  
CREATE TRIGGER LogGradeUpdate
ON Enrollments
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Log only real grade changes
    INSERT INTO GradeAudit (
        StudentID,
        CourseID,
        OldGrade,
        NewGrade,
        ChangedBy
    )
    SELECT
        d.StudentID,
        d.CourseID,
        d.Grade AS OldGrade,
        i.Grade AS NewGrade,
        u.UserID
    FROM deleted d
    INNER JOIN inserted i
        ON d.StudentID = i.StudentID
       AND d.CourseID = i.CourseID
    INNER JOIN Users u
        ON u.Username = SYSTEM_USER
    WHERE d.Grade <> i.Grade;
END;
GO
