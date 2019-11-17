<!DOCTYPE html>
<html>
<head>
<title>Administrator Page</title>
<link href="css/mainstyle.css" rel="stylesheet">
</head>
<body>
<body>
<%@ include file="header.jsp"%>
<%@ include file="auth.jsp"%>
<%@ include file="jdbc.jsp"%>

	<div class="div1">
	
	<h1>Administrator Sales Report By Day</h1>

<%
	//Note: Forces loading of SQL Server driver
	try { // Load driver class
		Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
	} catch (java.lang.ClassNotFoundException e) {
		out.println("ClassNotFoundException: " + e);
	}

	// Defining login information.
	String url = "jdbc:sqlserver://sql04.ok.ubc.ca:1433;DatabaseName=db_iheales;";
	String uid = "iheales";
	String pw = "40183402";

	//Useful code for formatting currency values:
	//NumberFormat currFormat = NumberFormat.getCurrencyInstance();

	//Make connection.
	try (Connection con = DriverManager.getConnection(url, uid, pw);) {
		// TODO: Write SQL query that prints out total order amount by day
		String sql = "SELECT orderDate, SUM(totalAmount) "
					+ "FROM orderSummary "
					+ "GROUP BY orderDate;";	
		PreparedStatement pstmt;
		pstmt = con.prepareStatement(sql);
		ResultSet rst = pstmt.executeQuery();
		
		//Create the table
		//Outside table.
		out.print("<table width=\"100%\"align=\"center\" border=\"1\">");
		out.print("<tr> <th>Order Date</th> <th>Total Amount</th> </tr>");
		
		while (rst.next()) {
			out.print("<tr><td>" + rst.getString(1) + "</td>" + "<td>" + rst.getBigDecimal(2));
	}
		
		//Close Inside table
		out.print("</table></td></tr>");
	} catch (SQLException ex) {
		System.err.print(ex);
	}
%>
</div>
</body>
</html>

