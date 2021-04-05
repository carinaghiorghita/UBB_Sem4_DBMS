using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Configuration;
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
        SqlDataAdapter daChild, daParent;
        DataSet ds;
        BindingSource bsChild, bsParent;
        SqlCommandBuilder cbChild;

        private void updateButton_Click(object sender, EventArgs e)
        {
            this.daParent.Update(this.ds, getParentTable());
            this.daChild.Update(this.ds, getChildTable());
        }


        public Form1()
        {
            InitializeComponent();
        }

        private string getConnectionString()
        {
            return ConfigurationManager.ConnectionStrings["connection_string"].ConnectionString.ToString();
        }

        private string getPKName()
        {
            return ConfigurationManager.AppSettings["parent_table_pk"];
        }

        private string getFKName()
        {
            return ConfigurationManager.AppSettings["child_table_fk"];
        }

        private string getParentTable()
        {
            return ConfigurationManager.AppSettings["parent_table"];
        }

        private string getParentQuery()
        {
            return ConfigurationManager.AppSettings["parent_query"];
        }

        private string getChildTable()
        {
            return ConfigurationManager.AppSettings["child_table"];
        }


        private string getChildQuery()
        {
            return ConfigurationManager.AppSettings["child_query"];
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            dbConn = new SqlConnection(getConnectionString());

            daParent = new SqlDataAdapter(getParentQuery(), dbConn);
            daChild = new SqlDataAdapter(getChildQuery(), dbConn);

            cbChild = new SqlCommandBuilder(daChild);

            ds = new DataSet();

            daParent.Fill(ds, getParentTable());
            daChild.Fill(ds, getChildTable());

            DataRelation dr = new DataRelation("fk_child_parent",
                ds.Tables[getParentTable()].Columns[getPKName()],
                ds.Tables[getChildTable()].Columns[getFKName()]);

            ds.Relations.Add(dr);

            //binding source for parent
            bsParent = new BindingSource();
            bsParent.DataSource = ds;
            bsParent.DataMember = getParentTable();

            //binding source for child
            bsChild = new BindingSource();
            bsChild.DataSource = bsParent;
            bsChild.DataMember = "fk_child_parent";

            parentView.DataSource = bsParent;
            childView.DataSource = bsChild;

        }


    }
}
