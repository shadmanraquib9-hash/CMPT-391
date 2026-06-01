-- ROLL UP: Total courses per university (highest level)
SELECT University, COUNT(*) AS TotalCourses
FROM FactCourseOffering f
JOIN DimCourse c ON f.CourseKey = c.CourseKey
GROUP BY University;

-- ROLL UP one level down: Courses per Faculty
SELECT University, Faculty, COUNT(*) AS TotalCourses
FROM FactCourseOffering f
JOIN DimCourse c ON f.CourseKey = c.CourseKey
GROUP BY University, Faculty;

-- DRILL DOWN: Courses per Department within a Faculty
SELECT University, Faculty, Department, COUNT(*) AS TotalCourses
FROM FactCourseOffering f
JOIN DimCourse c ON f.CourseKey = c.CourseKey
GROUP BY University, Faculty, Department;

-- DRILL DOWN by Time: Courses per Year then per Semester
SELECT Year, Semester, COUNT(*) AS TotalCourses
FROM FactCourseOffering f
JOIN DimDate d ON f.DateKey = d.DateKey
GROUP BY Year, Semester
ORDER BY Year, Semester;

-- Filter by Instructor
SELECT i.InstructorName, COUNT(*) AS CoursesTaught
FROM FactCourseOffering f
JOIN DimInstructor i ON f.InstructorKey = i.InstructorKey
GROUP BY i.InstructorName;

-- Filter by Student Major
SELECT s.Major, COUNT(*) AS EnrollmentCount
FROM FactCourseOffering f
JOIN DimStudent s ON f.StudentKey = s.StudentKey
GROUP BY s.Major;