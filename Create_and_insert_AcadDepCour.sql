--Create database Academic_Department_Course
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

Create table  ShoppingCart(
CartID int identity(1,1) PRIMARY KEY,
StudentID int,
SectionID int,
AddedDate date,
Status varchar(20),
FOREIGN KEY (StudentID) REFERENCES Student(StudentID),
FOREIGN KEY (SectionID) REFERENCES Course_sec(SectionID)
);


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
('David', 'Wilson', 'david.wilson@email.com', 5),
('Robert', 'Moore', 'robert.moore@email.com', 1),
('Linda', 'White', 'linda.white@email.com', 2),
('Chris', 'Hall', 'chris.hall@email.com', 3),
('Karen', 'Allen', 'karen.allen@email.com', 4),
('Steven', 'Young', 'steven.young@email.com', 5),
('Nancy', 'King', 'nancy.king@email.com', 1),
('Brian', 'Scott', 'brian.scott@email.com', 2),
('Laura', 'Green', 'laura.green@email.com', 3),
('Kevin', 'Baker', 'kevin.baker@email.com', 4),
('Megan', 'Adams', 'megan.adams@email.com', 5);

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
('EN210', 'Engineering Design', 3, 5),
('CS202', 'Data Structures', 4, 1),
('CS303', 'Database Systems', 3, 1),
('MTH202', 'Linear Algebra', 3, 2),
('MTH305', 'Statistics', 4, 2),
('PHY210', 'Modern Physics', 4, 3),
('PHY320', 'Thermodynamics', 3, 3),
('BUS220', 'Marketing', 3, 4),
('BUS330', 'Finance', 4, 4),
('ENG220', 'Circuit Analysis', 4, 5),
('ENG340', 'Fluid Mechanics', 3, 5);

-- Student
Insert into Student (FirstName, LastName, Email, Program)
Values
('Alex', 'Taylor', 'alex.taylor@email.com', 'Computer Science'),
('Sophia', 'Martin', 'sophia.martin@email.com', 'Mathematics'),
('Daniel', 'Lee', 'daniel.lee@email.com', 'Physics'),
('Olivia', 'Clark', 'olivia.clark@email.com', 'Business'),
('James', 'Walker', 'james.walker@email.com', 'Engineering'),
('Ethan', 'Harris', 'ethan.harris@email.com', 'Computer Science'),
('Mia', 'Nelson', 'mia.nelson@email.com', 'Business'),
('Noah', 'Carter', 'noah.carter@email.com', 'Engineering'),
('Ava', 'Mitchell', 'ava.mitchell@email.com', 'Physics'),
('Lucas', 'Perez', 'lucas.perez@email.com', 'Mathematics'),
('Charlotte', 'Roberts', 'charlotte.roberts@email.com', 'Computer Science'),
('Benjamin', 'Turner', 'benjamin.turner@email.com', 'Engineering'),
('Amelia', 'Phillips', 'amelia.phillips@email.com', 'Business'),
('Henry', 'Campbell', 'henry.campbell@email.com', 'Physics'),
('Ella', 'Parker', 'ella.parker@email.com', 'Mathematics');


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
(5, 5, 'Spring', 2027, 'Friday', '14:00', '15:30', 40),
(6, 6, 'Fall', 2026, 'Monday', '08:00', '09:30', 30),
(7, 7, 'Fall', 2026, 'Tuesday', '10:00', '11:30', 25),
(8, 8, 'Winter', 2027, 'Wednesday', '12:00', '13:30', 20),
(9, 9, 'Winter', 2027, 'Thursday', '14:00', '15:30', 35),
(10, 10, 'Spring', 2027, 'Friday', '09:00', '10:30', 40),
(11, 11, 'Spring', 2027, 'Monday', '11:00', '12:30', 30),
(12, 12, 'Summer', 2027, 'Tuesday', '13:00', '14:30', 25),
(13, 13, 'Summer', 2027, 'Wednesday', '15:00', '16:30', 20),
(14, 14, 'Fall', 2027, 'Thursday', '08:30', '10:00', 35),
(15, 15, 'Fall', 2027, 'Friday', '10:30', '12:00', 40);

-- Registration
Insert into Registration
(StudentID, SectionID, RegistrationDate, Status)
Values
(1, 1, '2026-09-01', 'Registered'),
(2, 2, '2026-09-02', 'Registered'),
(3, 3, '2027-01-05', 'Registered'),
(4, 4, '2027-01-06', 'Pending'),
(5, 5, '2027-05-01', 'Registered'),
(6, 6, '2026-09-03', 'Registered'),
(7, 7, '2026-09-04', 'Registered'),
(8, 8, '2027-01-07', 'Pending'),
(9, 9, '2027-01-08', 'Registered'),
(10, 10, '2027-05-02', 'Registered'),
(11, 11, '2027-05-03', 'Pending'),
(12, 12, '2027-06-01', 'Registered'),
(13, 13, '2027-06-02', 'Registered'),
(14, 14, '2027-09-01', 'Pending'),
(15, 15, '2027-09-02', 'Registered');
