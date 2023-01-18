// See https://aka.ms/new-console-template for more information
using Microsoft.Data.SqlClient;

const string connectionString = "Server=myServerAddress;Database=myDataBase;User Id=myUsername;Password=myPassword;";

using var connection = new SqlConnection(connectionString);



Console.WriteLine("Hello, World!");
