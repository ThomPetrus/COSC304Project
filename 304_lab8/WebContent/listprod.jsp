<%@page import="java.util.Arrays"%>
<%@ page import="java.sql.*,java.net.URLEncoder"%>
<%@ page import="java.text.NumberFormat"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>MIT Inc and Sons Ltd</title>
<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"
	integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo"
	crossorigin="anonymous"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"
	integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1"
	crossorigin="anonymous"></script>

<link rel="stylesheet"
	href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css"
	integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T"
	crossorigin="anonymous">
<script
	src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"
	integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM"
	crossorigin="anonymous"></script>
<link href="css/mainstyle.css" rel="stylesheet">
</head>
<body>
<%@ include file="header.jsp"%>

	<div class="div1">
		<h1>Search for the products you want to buy:</h1>

		<form method="get" action="listprod.jsp">
			<p align="left">
				<select size="1" name="categoryName">
					<option>All</option>
					<option>Beverages</option>
					<option>Condiments</option>
					<option>Confections</option>
					<option>Dairy Products</option>
					<option>Grains/Cereals</option>
					<option>Meat/Poultry</option>
					<option>Produce</option>
					<option>Seafood</option>
				</select> <input type="text" name="productName" size="50"> <input
					type="submit" value="Submit"><input type="reset"
					value="Reset"> (Leave blank for all products)
		</form>
	</div>
	<div class="products">
		<%
			// Get product name to search for
			String name = request.getParameter("productName");
			String catgName = request.getParameter("categoryName");
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
				String SQL = "SELECT productId, productName, productPrice FROM product";
				boolean hasProduct = name != null && !name.equals("");
				boolean catSelect = false;
				if (catgName == null)
					catSelect = false;
				else if (catgName.equalsIgnoreCase("all"))
					catSelect = false;
				else
					catSelect = true;

				PreparedStatement pstmt = null;
				ResultSet rst = null;

				if (!hasProduct && !catSelect) {
					out.print("<h1 align=\"center\">All Products:</h1>");
					pstmt = con.prepareStatement(SQL);
					rst = pstmt.executeQuery();
				}
				if (hasProduct) {
					out.print("<h1 align=\"center\">Products containing '" + name + "'</h1>");
					name = "'%" + name + "%'";
					SQL += " WHERE productName LIKE " + name;
					pstmt = con.prepareStatement(SQL);
					rst = pstmt.executeQuery();
				}
				if (catSelect) {
					out.print("<h1 align=\"center\">Products in '" + catgName + " category.'</h1>");
					String SQL2 = "SELECT categoryId FROM category WHERE categoryName = '" + catgName + "'";
					pstmt = con.prepareStatement(SQL2);
					rst = pstmt.executeQuery();
					int catgId = 0;
					if (rst.next()) {
						catgId = rst.getInt(1);
						SQL += " WHERE categoryId = " + catgId;
						pstmt = con.prepareStatement(SQL);
						rst = pstmt.executeQuery();
					}
				}

				out.print("<table width=\"75%\" align=\"center\"><th></th><th>Product Name</th><th>Price</th>");
				while (rst.next()) {
					out.print("<tr>");
					out.print("<td><a href=\"addcart.jsp?id=" + rst.getInt(1) + "&name=" + rst.getString(2) + "&price="
							+ rst.getDouble(3) + "\">Add Cart</a></td>");
					out.print("<td>" + rst.getString(2) + "</td><td>" + currFormat.format(rst.getDouble(3)) + "</td>");
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
	</div>
</body>
</html>
