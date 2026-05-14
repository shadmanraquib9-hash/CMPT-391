Create database Academic_Department_Course
go
use Academic_Department_Course
go

Create table Department(
DepartmentID int identity(1,1) PRIMARY KEY,
DepartmentName varchar(30),
HeadInstructorID int,
);

Create table Course(
CourseID int identity(1,1) PRIMARY KEY,
CourseCode varchar(7),
CourseName varchar(30),
Credit int,
DepartmentID int,
FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID)
);

Create table Instructor(
InstructorID int identity(1,1) PRIMARY KEY,
FirstName varchar(30),
LastName varchar(30),
Email varchar(50),
DepartmentID int,
FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID)
);

Create table Course_sec(
SectionID int identity(1,1) PRIMARY KEY,
CourseID int,
InstructorID int,
Term varchar(30),
Year int,
ScheduleDay varchar(10),
StartTime time ,
EndTime time,
Capacity int,
FOREIGN KEY (CourseID) REFERENCES Course(CourseID),
FOREIGN KEY (InstructorID) REFERENCES Instructor(InstructorID)
);

Create table Student(
StudentID int identity(1,1) PRIMARY KEY,
FirstName varchar(30),
LastName varchar(30),
Email varchar(50),
Program varchar(30)
);

Create table Registration(
RegistrationID int identity(1,1) PRIMARY KEY,
StudentID int,
SectionID int,
RegistrationDate date,
Status varchar(20),
FOREIGN KEY (StudentID) REFERENCES Student(StudentID),
FOREIGN KEY (SectionID) REFERENCES Course_sec(SectionID)
);


Alter table Department
Add constraint FK_Department_HeadInstructor
FOREIGN KEY (HeadInstructorID) REFERENCES Instructor(InstructorID);


--insert into table
-- Department
Insert into Department (DepartmentName, HeadInstructorID)
Values
('Computer Science', NULL),
('Mathematics', NULL),
('Physics', NULL),
('Business', NULL),
('Engineering', NULL);

---- Instructor
Insert into Instructor (FirstName, LastName, Email, DepartmentID)
Values
('John', 'Smith', 'john.smith@email.com', 1),
('Sarah', 'Johnson', 'sarah.johnson@email.com', 2),
('Michael', 'Brown', 'michael.brown@email.com', 3),
('Emily', 'Davis', 'emily.davis@email.com', 4),
('David', 'Wilson', 'david.wilson@email.com', 5);

-- Update Department heads
UPDATE Department
SET HeadInstructorID = 1
WHERE DepartmentID = 1;

UPDATE Department
SET HeadInstructorID = 2
WHERE DepartmentID = 2;

UPDATE Department
SET HeadInstructorID = 3
WHERE DepartmentID = 3;

UPDATE Department
SET HeadInstructorID = 4
WHERE DepartmentID = 4;

UPDATE Department
SET HeadInstructorID = 5
WHERE DepartmentID = 5;

 --Course
Insert into Course (CourseCode, CourseName, Credit, DepartmentID)
Values
('CS101', 'Intro to Programming', 3, 1),
('MTH201', 'Calculus I', 4, 2),
('PHY301', 'Physics I', 4, 3),
('BUS101', 'Business I', 3, 4),
('EN210', 'Engineering Design', 3, 5);

-- Student
Insert into Student (FirstName, LastName, Email, Program)
Values
('Alex', 'Taylor', 'alex.taylor@email.com', 'Computer Science'),
('Sophia', 'Martin', 'sophia.martin@email.com', 'Mathematics'),
('Daniel', 'Lee', 'daniel.lee@email.com', 'Physics'),
('Olivia', 'Clark', 'olivia.clark@email.com', 'Business'),
('James', 'Walker', 'james.walker@email.com', 'Engineering');


--there is some problem with the course_sec and regis table
--everytime i create the ID changes sometime. If you are having problem check the Id course,,instID,studen and section
-- Course_sec
Insert into Course_sec
(CourseID, InstructorID, Term, Year, ScheduleDay, StartTime, EndTime, Capacity)
Values
(1, 1, 'Fall', 2026, 'Monday', '09:00', '10:30', 30),
(2, 2, 'Fall', 2026, 'Tuesday', '11:00', '12:30', 25),
(3, 3, 'Winter', 2027, 'Wednesday', '13:00', '14:30', 20),
(4, 4, 'Winter', 2027, 'Thursday', '10:00', '11:30', 35),
(5, 5, 'Spring', 2027, 'Friday', '14:00', '15:30', 40);

-- Registration
Insert into Registration
(StudentID, SectionID, RegistrationDate, Status)
Values
(1, 1, '2026-09-01', 'Registered'),
(2, 2, '2026-09-02', 'Registered'),
(3, 3, '2027-01-05', 'Registered'),
(4, 4, '2027-01-06', 'Pending'),
(5, 5, '2027-05-01', 'Registered');

