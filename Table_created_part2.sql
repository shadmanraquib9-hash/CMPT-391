CREATE DATABASE DW_AdvancedEducation
GO
-- DimCourse
CREATE TABLE DimCourse (
    CourseKey       INT IDENTITY(1,1) PRIMARY KEY,
    CourseCode      VARCHAR(10),
    CourseName      VARCHAR(50),
    Department      VARCHAR(50),
    Faculty         VARCHAR(50),
    University      VARCHAR(100)
);

-- DimInstructor
CREATE TABLE DimInstructor (
    InstructorKey   INT IDENTITY(1,1) PRIMARY KEY,
    InstructorName  VARCHAR(60),
    Faculty         VARCHAR(50),
    Rank            VARCHAR(30),
    University      VARCHAR(100)
);

-- DimStudent
CREATE TABLE DimStudent (
    StudentKey      INT IDENTITY(1,1) PRIMARY KEY,
    StudentName     VARCHAR(60),
    Major           VARCHAR(50),
    Gender          VARCHAR(10)
);

-- DimDate
CREATE TABLE DimDate (
    DateKey         INT IDENTITY(1,1) PRIMARY KEY,
    Semester        VARCHAR(20),
    Year            INT
);


CREATE TABLE FactCourseOffering (
    FactID          INT IDENTITY(1,1) PRIMARY KEY,
    CourseKey       INT,
    InstructorKey   INT,
    StudentKey      INT,
    DateKey         INT,
    CourseCount     INT DEFAULT 1,
    EnrollmentCount INT,
    FOREIGN KEY (CourseKey)     REFERENCES DimCourse(CourseKey),
    FOREIGN KEY (InstructorKey) REFERENCES DimInstructor(InstructorKey),
    FOREIGN KEY (StudentKey)    REFERENCES DimStudent(StudentKey),
    FOREIGN KEY (DateKey)       REFERENCES DimDate(DateKey)
);