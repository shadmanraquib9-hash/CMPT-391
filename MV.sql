--Course seat available

CREATE VIEW mv_cou_seat_ava
WITH SCHEMABINDING
AS
SELECT
    cs.SectionID,
    cs.CourseID,
    cs.Term,
    cs.Year,
    cs.Capacity,
    COUNT_BIG(r.RegistrationID) AS EnrolledCount,
    cs.Capacity - COUNT_BIG(r.RegistrationID) AS SeatsAvailable
FROM dbo.Course_sec cs
LEFT JOIN dbo.Registration r 
    ON cs.SectionID = r.SectionID 
    AND r.Status = 'Registered'
GROUP BY cs.SectionID, cs.CourseID, cs.Term, cs.Year, cs.Capacity;
GO

CREATE UNIQUE CLUSTERED INDEX idx_mv_cou_seat_ava
ON mv_cou_seat_ava(SectionID);
GO

--Student cart

CREATE VIEW mv_stud_cart_sum
WITH SCHEMABINDING
AS
SELECT
    sc.StudentID,
    sc.SectionID,
    COUNT_BIG(sc.CartID) AS CartItemCount
FROM dbo.ShoppingCart sc
WHERE sc.Status = 'Pending' 
GROUP BY sc.StudentID, sc.SectionID;
GO

CREATE UNIQUE CLUSTERED INDEX idx_mv_stud_cart_sum
ON mmv_stud_cart_sum(StudentID, SectionID);
GO

--Student regist
CREATE VIEW mv_Stud_reg_sum
WITH SCHEMABINDING
AS
SELECT
    r.StudentID,
    r.SectionID,
    COUNT_BIG(r.RegistrationID) AS RegistrationCount
FROM dbo.Registration r
WHERE r.Status = 'Registered'
GROUP BY r.StudentID, r.SectionID;
GO

CREATE UNIQUE CLUSTERED INDEX idx_mv_Stud_reg_sum
ON mmv_Stud_reg_sum(StudentID, SectionID);
GO