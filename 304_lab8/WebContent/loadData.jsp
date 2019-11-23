<%@ page import="java.io.File" %>
<%@ page import="java.util.Scanner" %>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Database Restore</title>
</head>
<body>
<%@ include file="jdbc.jsp"%>
<%
String url = "jdbc:sqlserver://sql04.ok.ubc.ca:1433;DatabaseName=db_tvande;";
String uid = "tvande";
String pw = "33970138";

System.out.println("Connecting to database.");

Connection con = DriverManager.getConnection(url, uid, pw);
		
/*

This will not function when uploaded to the server, for some reason I can not get it to find the file/ 
Must be some way to fix it

*/

String fileName = "C:\\Users\\iheal\\eclipse-workspace\\gemSite\\data\\orderdb_sql.ddl";

try
{
    // Create statement
    Statement stmt = con.createStatement();
    
    Scanner scanner = new Scanner(new File(fileName));
    // Read commands separated by ;
    scanner.useDelimiter(";");
    while (scanner.hasNext())
    {
        String command = scanner.next();
        if (command.trim().equals(""))
            continue;
        //out.println(command);        // Uncomment if want to see commands executed
        try
        {
        	stmt.execute(command);
        }
        catch (Exception e)
        {	// Keep running on exception.  This is mostly for DROP TABLE if table does not exist.
        	out.println(e);
        }
    }	 
    scanner.close();
    response.sendRedirect("admin.jsp");
}
catch (Exception e)
{
    System.out.println(e.getMessage());
    response.sendRedirect("admin.jsp");
}   
%>
</body>
</html>