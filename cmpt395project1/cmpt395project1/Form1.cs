using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Data.SqlClient;  

namespace cmpt395project1
{
    public partial class Form1 : Form
    {
        SqlConnection myConnection;
        SqlCommand myCommand;
        SqlDataReader myReader;

        public Form1()
        {
            InitializeComponent();

            try
            {
                myConnection = new SqlConnection(
                    "Server=LAPTOP-3MSVSB2A;" +
                    "Database=Academic_Department_Course;" +
                    "Integrated Security=True;"
                );
                myConnection.Open();
                myCommand = new SqlCommand();
                myCommand.Connection = myConnection;
            }
            catch
            {
            }
            
        }

        private void btnSearch_Click(object sender, EventArgs e)
        {
            // accidental copy of the search code, will be removed in final version
        }

        private void btnRegister_Click(object sender, EventArgs e)
        {
            // accidental copy of the register code, will be removed in final version
        }
        private void tabPage1_Click(object sender, EventArgs e)
        {

        }

        private void lblStudentID_Click(object sender, EventArgs e)
        {

        }

        // loads term and year dropdowns from database, setsup cart columns
        private void Form1_Load_1(object sender, EventArgs e)
        {
            myCommand.CommandText = "SELECT DISTINCT Term FROM Course_sec";
            myReader = myCommand.ExecuteReader();
            while (myReader.Read())
            {
                cmbTerm.Items.Add(myReader["Term"].ToString());
            }
            myReader.Close();
            cmbTerm.SelectedIndex = 0;

            myCommand.CommandText = "SELECT DISTINCT Year FROM Course_sec ORDER BY Year";
            myReader = myCommand.ExecuteReader();
            while (myReader.Read())
            {
                cmbYear.Items.Add(myReader["Year"].ToString());
            }
            myReader.Close();
            cmbYear.SelectedIndex = 0;

            // setup cart datagridview column, enrollment will be done based on SectionID, other columns are just for display purposes
            dgvCart.Columns.Add("StudentID", "Student ID");
            dgvCart.Columns.Add("SectionID", "Section ID");
            dgvCart.Columns.Add("CourseCode", "Course Code");
            dgvCart.Columns.Add("CourseName", "Course Name");
            dgvCart.Columns.Add("Instructor", "Instructor");
            dgvCart.Columns.Add("Day", "Day");
            dgvCart.Columns.Add("StartTime", "Start Time");
            dgvCart.Columns.Add("EndTime", "End Time");
        }

        // main search function, queries database for courses matching selected term and year, displays results in datagridview
        private void btnSearch_Click_1(object sender, EventArgs e)
        {
            dgvCourses.Rows.Clear();
            dgvCourses.Columns.Clear();

            dgvCourses.Columns.Add("SectionID", "Section ID");
            dgvCourses.Columns.Add("CourseCode", "Course Code");
            dgvCourses.Columns.Add("CourseName", "Course Name");
            dgvCourses.Columns.Add("Instructor", "Instructor");
            dgvCourses.Columns.Add("Day", "Day");
            dgvCourses.Columns.Add("StartTime", "Start Time");
            dgvCourses.Columns.Add("EndTime", "End Time");
            dgvCourses.Columns.Add("Capacity", "Capacity");
            dgvCourses.Columns.Add("Seats Available", "Seats Available");

            myCommand.CommandText =
                "SELECT cs.SectionID, c.CourseCode, c.CourseName, " +
                "i.FirstName + ' ' + i.LastName AS Instructor, " +
                "cs.ScheduleDay, cs.StartTime, cs.EndTime, cs.Capacity, " +
                "cs.Capacity - COUNT(r.RegistrationID) AS SeatsAvailable " +
                "FROM Course_sec cs " +
                "JOIN Course c ON cs.CourseID = c.CourseID " +
                "JOIN Instructor i ON cs.InstructorID = i.InstructorID " +
                "LEFT JOIN Registration r ON cs.SectionID = r.SectionID " +
                "AND r.Status = 'Registered' " +
                "WHERE cs.Term = @Term AND cs.Year = @Year " +
                "GROUP BY cs.SectionID, c.CourseCode, c.CourseName, " +
                "i.FirstName, i.LastName, cs.ScheduleDay, " +
                "cs.StartTime, cs.EndTime, cs.Capacity";

            myCommand.Parameters.Clear();
            myCommand.Parameters.AddWithValue("@Term", cmbTerm.SelectedItem.ToString());
            myCommand.Parameters.AddWithValue("@Year", int.Parse(cmbYear.SelectedItem.ToString()));

            try
            {
                myReader = myCommand.ExecuteReader();
                while (myReader.Read())
                {
                    dgvCourses.Rows.Add(
                        myReader["SectionID"].ToString(),
                        myReader["CourseCode"].ToString(),
                        myReader["CourseName"].ToString(),
                        myReader["Instructor"].ToString(),
                        myReader["ScheduleDay"].ToString(),
                        myReader["StartTime"].ToString(),
                        myReader["EndTime"].ToString(),
                        myReader["Capacity"].ToString(),
                        myReader["SeatsAvailable"].ToString()
                    );
                }
                myReader.Close();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), "Error");
            }
        }

        // adds selected course from search results to cart datagridview, checks for duplicates
        private void btnAddToCart_Click(object sender, EventArgs e)
        {

            // Check student ID is entered before adding to cart
            if (txtStudentID.Text == "")
            {
                MessageBox.Show("Please enter your Student ID before adding to cart.", "Error");
                return;
            }

            if (dgvCourses.SelectedRows.Count == 0)
            {
                MessageBox.Show("Please select a course to add to cart.", "Error");
                return;
            }

            DataGridViewRow selectedRow = dgvCourses.SelectedRows[0];
            string sectionID = selectedRow.Cells["SectionID"].Value.ToString();

            // Check if already in cart
            foreach (DataGridViewRow row in dgvCart.Rows)
            {
                if (row.Cells["SectionID"].Value != null &&
                    row.Cells["SectionID"].Value.ToString() == sectionID)
                {
                    MessageBox.Show("This course is already in your cart.", "Warning");
                    return;
                }
            }

            dgvCart.Rows.Add(
                txtStudentID.Text,
                sectionID,
                selectedRow.Cells["CourseCode"].Value.ToString(),
                selectedRow.Cells["CourseName"].Value.ToString(),
                selectedRow.Cells["Instructor"].Value.ToString(),
                selectedRow.Cells["Day"].Value.ToString(),
                selectedRow.Cells["StartTime"].Value.ToString(),
                selectedRow.Cells["EndTime"].Value.ToString()
            );

            MessageBox.Show("Course added to cart!", "Success");
        }

        // clears all courses from cart datagridview
        private void btnClearCart_Click(object sender, EventArgs e)
        {
            dgvCart.Rows.Clear();
            MessageBox.Show("Cart cleared!", "Success");
        }
    }
}


/*
 * ENROLL TAB NOTES:
 * - Cart data is in dgvCart (in memory)
 * - Each row has StudentID column - filter by this to get the right student's courses
 * - Get student ID from txtEnrollStudentID.Text on Enroll tab
 * - Loop through dgvCart rows where StudentID matches, call RegisterStudent for each
 * - Database connection already set up: use myConnection and myCommand
 * - Stored procedure: EXEC RegisterStudent @StudentID, @SectionID, @RegistrationDate
 */