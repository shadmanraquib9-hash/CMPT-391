# CMPT 391 Project

Files:

1. Create_and_insert_AcadDepCour.sql
   Creates the database and inserts sample data.

2. registration_requirements.sql
   Creates prerequisite requirements and registration validation procedure.

Validation Rules:

- Student must exist
- Section must exist
- No duplicate registrations
- Capacity check
- Schedule conflict check
- Prerequisite completion check

Test Cases Included:

- Successful registration
- Missing prerequisite
- Duplicate registration
- Invalid student
- Invalid section
- Schedule conflict
- Full section
