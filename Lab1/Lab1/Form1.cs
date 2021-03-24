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

namespace Lab1
{
    public partial class Form1 : Form
    {

        SqlConnection dbConn;
        SqlDataAdapter daReservations, daCustomers;
        DataSet ds;
        BindingSource bsReservations, bsCustomers;
        SqlCommandBuilder cbReservations;

        private void updateButton_Click(object sender, EventArgs e)
        {
            daReservations.Update(ds, "Reservations");
        }

        
        public Form1()
        {
            InitializeComponent();
        }


        private void Form1_Load(object sender, EventArgs e)
        {
            dbConn = new SqlConnection("Data Source = DESKTOP-V9IIJ69\\SQLEXPRESS; " +
                "Initial Catalog = RESTAURANT; Integrated Security = SSPI");

            daCustomers = new SqlDataAdapter("SELECT * FROM Customer", dbConn);
            daReservations = new SqlDataAdapter("SELECT * FROM Reservations", dbConn);

            cbReservations = new SqlCommandBuilder(daReservations);

            ds = new DataSet();

            daCustomers.Fill(ds, "Customer");
            daReservations.Fill(ds, "Reservations");

            DataRelation dr = new DataRelation("FK_Reservation_Customer", ds.Tables["Customer"].Columns["customerID"],
                ds.Tables["Reservations"].Columns["customerID"]);

            ds.Relations.Add(dr);

            //binding source for parent
            bsCustomers = new BindingSource();
            bsCustomers.DataSource = ds;
            bsCustomers.DataMember = "Customer";

            //binding source for child
            bsReservations = new BindingSource();
            bsReservations.DataSource = bsCustomers;
            bsReservations.DataMember = "FK_Reservation_Customer";

            customerDataGridView.DataSource = bsCustomers;
            reservationsDataGridView.DataSource = bsReservations;

        }

        
    }
}
