-- =========================================================
-- CMPT 391 Project - Registration Requirement Checks
-- This file adds prerequisite requirements and checks them
-- before allowing a student to register in a course section.
-- =========================================================
--USE master;
--GO

--IF DB_ID('Academic_Department_Course') IS NOT NULL
--BEGIN
--ALTER DATABASE Academic_Department_Course
--SET SINGLE_USER WITH ROLLBACK IMMEDIATE;

--DROP DATABASE Academic_Department_Course;
--END
--GO

--CREATE DATABASE Academic_Department_Course;
--GO
USE Academic_Department_Course;
GO
-- =========================================================
-- If the table already exists, SQL Server will display an error.
-- Uncomment the DROP TABLE statement below only when the table
-- needs to be recreated from scratch.
-- =========================================================
IF OBJECT_ID('Prerequisite', 'U') IS NOT NULL
  DROP TABLE Prerequisite;
GO
-- =========================================================
-- 2. Create Prerequisite table
-- CourseID = the course the student wants to take
-- PrerequisiteCourseID = the course that must be completed first
-- =========================================================
CREATE TABLE Prerequisite
(
    CourseID INT,
    PrerequisiteCourseID INT,

    PRIMARY KEY (CourseID, PrerequisiteCourseID),

    FOREIGN KEY (CourseID)
        REFERENCES Course(CourseID),

    FOREIGN KEY (PrerequisiteCourseID)
        REFERENCES Course(CourseID)
);
GO
-- =========================================================
-- 3. Insert sample prerequisite requirements
-- These are sample requirements for testing.
-- =========================================================
IF NOT EXISTS (
    SELECT *
FROM Prerequisite
WHERE CourseID = 2
    AND PrerequisiteCourseID = 1
)
INSERT INTO Prerequisite
VALUES
    (2, 1);

IF NOT EXISTS (
    SELECT *
FROM Prerequisite
WHERE CourseID = 3
    AND PrerequisiteCourseID = 1
)
INSERT INTO Prerequisite
VALUES
    (3, 1);

IF NOT EXISTS (
    SELECT *
FROM Prerequisite
WHERE CourseID = 4
    AND PrerequisiteCourseID = 2
)
INSERT INTO Prerequisite
VALUES
    (4, 2);

IF NOT EXISTS (
    SELECT *
FROM Prerequisite
WHERE CourseID = 5
    AND PrerequisiteCourseID = 1
)
INSERT INTO Prerequisite
VALUES
    (5, 1);
GO
-- =========================================================
-- 4. Add one completed course for testing
-- Student 1 completed Section 1.
-- Section 1 belongs to Course 1.
-- This means Student 1 has completed Course 1.
-- =========================================================
IF NOT EXISTS (
    SELECT *
FROM Registration
WHERE StudentID = 1
    AND SectionID = 1
    
)
BEGIN
    INSERT INTO Registration
        (StudentID, SectionID, RegistrationDate, Status)
    VALUES
        (1, 1, '2026-08-01', 'Completed');
END;
GO

-- =========================================================
-- 5. Drop old procedure if it already exists
-- This lets us update and rerun the procedure.
-- =========================================================
IF OBJECT_ID('RegisterStudent', 'P') IS NOT NULL
    DROP PROCEDURE RegisterStudent;
GO

-- =========================================================
-- 6. Create procedure to register a student
-- This checks requirements before inserting into Registration.
-- =========================================================
CREATE PROCEDURE RegisterStudent
    @StudentID INT,
    @SectionID INT,
    @RegistrationDate DATE
AS
BEGIN
    DECLARE @StudentName VARCHAR(100);
    DECLARE @CourseName VARCHAR(100);
    DECLARE @CourseCode VARCHAR(20);

    -- Check 1: Student must exist
    IF NOT EXISTS (
        SELECT *
    FROM Student
    WHERE StudentID = @StudentID
    )
    BEGIN
        PRINT 'Registration failed: StudentID '
            + CAST(@StudentID AS VARCHAR(10))
            + ' does not exist.';
        RETURN;
    END;

    -- Get student name after confirming student exists
    SELECT @StudentName = FirstName + ' ' + LastName
    FROM Student
    WHERE StudentID = @StudentID;

    -- Check 2: Section must exist
    IF NOT EXISTS (
        SELECT *
    FROM Course_sec
    WHERE SectionID = @SectionID
    )
    BEGIN
        PRINT 'Registration failed for '
            + @StudentName
            + ': SectionID '
            + CAST(@SectionID AS VARCHAR(10))
            + ' does not exist.';
        RETURN;
    END;

    -- Get course name after confirming section exists
    SELECT
        @CourseName = c.CourseName,
        @CourseCode = c.CourseCode
    FROM Course c, Course_sec cs
    WHERE c.CourseID = cs.CourseID
        AND cs.SectionID = @SectionID;

    -- Check 3: Student cannot register twice in the same section
    IF EXISTS (
        SELECT *
    FROM Registration
    WHERE StudentID = @StudentID
        AND SectionID = @SectionID
        AND Status = 'Registered'
    )
    BEGIN
        PRINT 'Registration failed: '
            + @StudentName
            + ' is already registered in '
            + @CourseCode + ' / ' + @CourseName
            + '.';
        RETURN;
    END;
    -- Check 4: Course section must have available space
    IF (
        SELECT COUNT(*)
    FROM Registration
    WHERE SectionID = @SectionID
        AND Status = 'Registered'
    ) >= (
        SELECT Capacity
    FROM Course_sec
    WHERE SectionID = @SectionID
    )
    BEGIN
        PRINT 'Registration failed: '
            + @StudentName
            + ' cannot register in '
            + @CourseCode + ' / ' + @CourseName
            + ' because the course section is full.';
        RETURN;
    END;

    -- Check 5: Student cannot register in another section at the same time
    IF EXISTS (
        SELECT *
    FROM Registration r, Course_sec existingSec, Course_sec newSec
    WHERE r.SectionID = existingSec.SectionID
        AND newSec.SectionID = @SectionID
        AND r.StudentID = @StudentID
        AND r.Status = 'Registered'
        AND existingSec.Term = newSec.Term
        AND existingSec.Year = newSec.Year
        AND existingSec.ScheduleDay = newSec.ScheduleDay
        AND existingSec.StartTime < newSec.EndTime
        AND newSec.StartTime < existingSec.EndTime
    )
    BEGIN
        PRINT 'Registration failed: '
            + @StudentName
            + ' has a schedule conflict for '
            + @CourseCode + ' / ' + @CourseName
            + '.';
        RETURN;
    END;

    -- Check 6: Student must complete prerequisite courses
    IF EXISTS (
        SELECT *
    FROM Prerequisite p, Course_sec cs
    WHERE p.CourseID = cs.CourseID
        AND cs.SectionID = @SectionID
        AND NOT EXISTS (
            SELECT *
        FROM Registration r, Course_sec completed
        WHERE r.SectionID = completed.SectionID
            AND r.StudentID = @StudentID
            AND completed.CourseID = p.PrerequisiteCourseID
            AND r.Status = 'Completed'
        )
    )
    BEGIN
        PRINT 'Registration failed: '
            + @StudentName
            + ' cannot register in '
            + @CourseCode + ' / ' + @CourseName
            + ' because the prerequisite course was not completed.';
        RETURN;
    END;

    -- If all checks passed, insert the registration
    INSERT INTO Registration
        (StudentID, SectionID, RegistrationDate, Status)
    VALUES
        (@StudentID, @SectionID, @RegistrationDate, 'Registered');

    PRINT 'Registration successful: '
        + @StudentName
        + ' registered for '
        + @CourseCode + ' / ' + @CourseName
        + '.';
END;
GO

-- --TEST SECTION
-- Registration validation rules:
-- 1. Student must exist
-- 2. Section must exist
-- 3. Student cannot register twice in the same section
-- 4. Section must have available capacity
-- 5. Student cannot have a schedule conflict
-- 6. Student must satisfy prerequisite requirements

-- -- =========================================================
-- -- TEST SETUP: Add completed prerequisite for Alex Taylor
-- -- Alex completed CS101, so he can register in MTH201.
-- -- =========================================================
-- IF NOT EXISTS (
--     SELECT *
--     FROM Registration
--     WHERE StudentID = 1
--     AND SectionID = 1
--     AND Status = 'Completed'
-- )
-- BEGIN
--     INSERT INTO Registration (StudentID, SectionID, RegistrationDate, Status)
--     VALUES (1, 1, '2026-08-01', 'Completed');
-- END;
-- GO

-- -- TEST CASE 1: Successful registration
-- EXEC RegisterStudent 1, 2, '2026-09-10';
-- GO

-- -- TEST CASE 2: Failed prerequisite
-- EXEC RegisterStudent 2, 4, '2026-09-10';
-- GO

-- -- TEST CASE 3: Student does not exist
-- EXEC RegisterStudent 99, 2, '2026-09-10';
-- GO

-- -- TEST CASE 4: Section does not exist
-- EXEC RegisterStudent 1, 99, '2026-09-10';
-- GO

-- -- =========================================================
-- -- TEST SETUP: Schedule conflict section
-- -- This creates a new section at the same time as Alex's CS101.
-- -- =========================================================
-- INSERT INTO Course_sec
-- (CourseID, InstructorID, Term, Year, ScheduleDay, StartTime, EndTime, Capacity)
-- VALUES
-- (1, 1, 'Fall', 2026, 'Monday', '09:00', '10:30', 20);
-- GO

-- -- TEST CASE 5: Schedule conflict
-- EXEC RegisterStudent 1, 6, '2026-09-10';
-- GO


-- -- TEST CASE 6: Duplicate registration
-- EXEC RegisterStudent 1, 2, '2026-09-11';
-- GO


-- -- =========================================================
-- -- TEST SETUP: Capacity test section
-- -- CS101 has no prerequisite, no conflict, and capacity = 1.
-- -- =========================================================
-- INSERT INTO Course_sec
-- (CourseID, InstructorID, Term, Year, ScheduleDay, StartTime, EndTime, Capacity)
-- VALUES
-- (1, 1, 'Spring', 2027, 'Monday', '08:00', '09:00', 1);
-- GO

-- -- TEST CASE 7A: Fill capacity
-- EXEC RegisterStudent 2, 7, '2027-03-01';
-- GO

-- -- TEST CASE 7B: Section full
-- EXEC RegisterStudent 3, 7, '2027-03-02';
-- GO

-- -- =========================================================
-- -- View registration results with student and course names
-- -- =========================================================
-- SELECT
--     r.RegistrationID,
--     s.FirstName + ' ' + s.LastName AS StudentName,
--     c.CourseCode,
--     c.CourseName,
--     cs.Term,
--     cs.Year,
--     cs.ScheduleDay,
--     cs.StartTime,
--     cs.EndTime,
--     r.RegistrationDate,
--     r.Status
-- FROM Registration r, Student s, Course_sec cs, Course c
-- WHERE r.StudentID = s.StudentID
-- AND r.SectionID = cs.SectionID
-- AND cs.CourseID = c.CourseID;
-- GO

-- SELECT
--     c.CourseCode,
--     c.CourseName,
--     pc.CourseCode AS PrerequisiteCode,
--     pc.CourseName AS PrerequisiteName
-- FROM Prerequisite p,
--      Course c,
--      Course pc
-- WHERE p.CourseID = c.CourseID
-- AND p.PrerequisiteCourseID = pc.CourseID;
-- GO

-- SELECT *
-- FROM Course_sec;


-- SELECT
--     cs.SectionID,
--     cs.CourseID,
--     c.CourseCode,
--     c.CourseName,
--     cs.Capacity
-- FROM Course_sec cs
-- JOIN Course c
--     ON cs.CourseID = c.CourseID
-- WHERE cs.SectionID = 7;