USE DW_AdvancedEducation;
GO
--need to check for uni
-- Load DimDate
INSERT INTO DimDate (Semester, Year)
VALUES
('Fall', 2026),
('Winter', 2027),
('Spring', 2027),
('Summer', 2027),
('Fall', 2027);

-- Load DimCourse
INSERT INTO DimCourse (CourseCode, CourseName, Department, Faculty, University)
VALUES
('CS101', 'Intro to Programming', 'Computer Science', 'Science', 'MacEwan University'),
('MTH201', 'Calculus I',          'Mathematics',      'Science', 'MacEwan University'),
('PHY301', 'Physics I',           'Physics',          'Science', 'MacEwan University'),
('BUS101', 'Business I',          'Business',         'Business','MacEwan University'),
('EN210',  'Engineering Design',  'Engineering',      'Engineering', 'MacEwan University'),
('CS202',  'Data Structures',     'Computer Science', 'Science', 'MacEwan University'),
('CS303',  'Database Systems',    'Computer Science', 'Science', 'MacEwan University'),
('MTH202', 'Linear Algebra',      'Mathematics',      'Science', 'MacEwan University'),
('MTH305', 'Statistics',          'Mathematics',      'Science', 'MacEwan University'),
('PHY210', 'Modern Physics',      'Physics',          'Science', 'MacEwan University'),
('PHY320', 'Thermodynamics',      'Physics',          'Science', 'MacEwan University'),
('BUS220', 'Marketing',           'Business',         'Business','MacEwan University'),
('BUS330', 'Finance',             'Business',         'Business','MacEwan University'),
('ENG220', 'Circuit Analysis',    'Engineering',      'Engineering', 'MacEwan University'),
('ENG340', 'Fluid Mechanics',     'Engineering',      'Engineering', 'MacEwan University');

INSERT INTO DimInstructor (InstructorName, Faculty, Rank, University)
VALUES
('John Smith',    'Science',     'Professor',          'MacEwan University'),
('Sarah Johnson', 'Science',     'Associate Professor','MacEwan University'),
('Michael Brown', 'Science',     'Lecturer',           'MacEwan University'),
('Emily Davis',   'Business',    'Professor',          'MacEwan University'),
('David Wilson',  'Engineering', 'Associate Professor','MacEwan University'),
('Robert Moore',  'Science',     'Lecturer',           'MacEwan University'),
('Linda White',   'Science',     'Professor',          'MacEwan University'),
('Chris Hall',    'Science',     'Lecturer',           'MacEwan University'),
('Karen Allen',   'Business',    'Associate Professor','MacEwan University'),
('Steven Young',  'Engineering', 'Professor',          'MacEwan University'),
('Nancy King',    'Science',     'Lecturer',           'MacEwan University'),
('Brian Scott',   'Science',     'Associate Professor','MacEwan University'),
('Laura Green',   'Science',     'Professor',          'MacEwan University'),
('Kevin Baker',   'Business',    'Lecturer',           'MacEwan University'),
('Megan Adams',   'Engineering', 'Associate Professor','MacEwan University');


INSERT INTO DimStudent (StudentName, Major, Gender)
VALUES
('Alex Taylor',       'Computer Science', 'Male'),
('Sophia Martin',     'Mathematics',      'Female'),
('Daniel Lee',        'Physics',          'Male'),
('Olivia Clark',      'Business',         'Female'),
('James Walker',      'Engineering',      'Male'),
('Ethan Harris',      'Computer Science', 'Male'),
('Mia Nelson',        'Business',         'Female'),
('Noah Carter',       'Engineering',      'Male'),
('Ava Mitchell',      'Physics',          'Female'),
('Lucas Perez',       'Mathematics',      'Male'),
('Charlotte Roberts', 'Computer Science', 'Female'),
('Benjamin Turner',   'Engineering',      'Male'),
('Amelia Phillips',   'Business',         'Female'),
('Henry Campbell',    'Physics',          'Male'),
('Ella Parker',       'Mathematics',      'Female');


INSERT INTO FactCourseOffering (CourseKey, InstructorKey, StudentKey, DateKey, CourseCount, EnrollmentCount)
VALUES
(1,  1,  1,  1, 1, 1),   -- Alex= CS101, John Smith, Fall 2026
(2,  2,  2,  1, 1, 1),   -- Sophia= MTH201, Sarah Johnson, Fall 2026
(3,  3,  3,  2, 1, 1),   -- Daniel= PHY301, Michael Brown, Winter 2027
(4,  4,  4,  2, 1, 1),   -- Olivia= BUS101, Emily Davis, Winter 2027
(5,  5,  5,  3, 1, 1),   -- James= EN210, David Wilson, Spring 2027
(6,  6,  6,  1, 1, 1),   -- Ethan= CS202, Robert Moore, Fall 2026
(7,  7,  7,  1, 1, 1),   -- Mia= CS303, Linda White, Fall 2026
(8,  8,  8,  2, 1, 1),   -- Noah= MTH202, Chris Hall, Winter 2027
(9,  9,  9,  2, 1, 1),   -- Ava= MTH305, Karen Allen, Winter 2027
(10, 10, 10, 3, 1, 1),   -- Lucas= PHY210, Steven Young, Spring 2027
(11, 11, 11, 3, 1, 1),   -- Charlotte= PHY320, Nancy King, Spring 2027
(12, 12, 12, 4, 1, 1),   -- Benjamin= BUS220, Brian Scott, Summer 2027
(13, 13, 13, 4, 1, 1),   -- Amelia= BUS330, Laura Green, Summer 2027
(14, 14, 14, 5, 1, 1),   -- Henry= ENG220, Kevin Baker, Fall 2027
(15, 15, 15, 5, 1, 1);   -- Ella= ENG340, Megan Adams, Fall 2027