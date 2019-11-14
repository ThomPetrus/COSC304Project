<%@page import="java.util.Arrays"%>
<%@ page import="java.sql.*,java.net.URLEncoder"%>
<%@ page import="java.text.NumberFormat"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>MIT Inc and Sons Ltd</title>
</head>
<body>

	<h1>Search for the products you want to buy:</h1>

	<form method="get" action="listprod.jsp">
		<input type="text" name="productName" size="50"> <input
			type="submit" value="Submit"><input type="reset"
			value="Reset"> (Leave blank for all products)
	</form>

	<%
		// Get product name to search for
		String name = request.getParameter("productName");

		//Note: Forces loading of SQL Server driver
		try { // Load driver class
			Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
		} catch (java.lang.ClassNotFoundException e) {
			out.println("ClassNotFoundException: " + e);
		}

		// Variable name now contains the search string the user entered
		// Use it to build a query and print out the resultset.  Make sure to use PreparedStatement!

		String url = "jdbc:sqlserver://sql04.ok.ubc.ca:1433;DatabaseName=db_tvande;";
		String uid = "tvande";
		String pw = "33970138";
		NumberFormat currFormat = NumberFormat.getCurrencyInstance();
		
		// Make the connection
		try (Connection con = DriverManager.getConnection(url, uid, pw)) {
			String SQL = SQL = "SELECT productId, productName, productPrice FROM product";
			boolean hasProduct = name != null && !name.equals("");

			PreparedStatement pstmt = null;
			ResultSet rst = null;

			if (!hasProduct) {
				out.print("<h1>All Products:</h1>");
				pstmt = con.prepareStatement(SQL);
				rst = pstmt.executeQuery();
			} else if (hasProduct) {
				out.print("<h1>Products containing '" + name + "'</h1>");
				name = "'%" + name + "%'";
				SQL += " WHERE productName LIKE " + name;
				pstmt = con.prepareStatement(SQL);
				rst = pstmt.executeQuery();
			}
			
			out.print("<table><th></th><th>Product Name</th><th>Price</th>");
			while(rst.next()){
				out.print("<tr>");
				out.print("<td><a href=\"addcart.jsp?id=" + rst.getInt(1) + "&name=" + rst.getString(2) + "&price="+ rst.getDouble(3) +"\">Add Cart</a></td>");
				out.print("<td>" + rst.getString(2)+ "</td><td>" + currFormat.format(rst.getDouble(3))+"</td>");
				out.print("</tr>");
			}
			
			
			

		} catch (SQLException ex) {
			System.err.println(ex);
		}
		// Print out the ResultSet

		// For each product create a link of the form
		// addcart.jsp?id=productId&name=productName&price=productPrice
		// Close connection

		// Useful code for formatting currency values:
		
		
	%>

</body>
</html>
