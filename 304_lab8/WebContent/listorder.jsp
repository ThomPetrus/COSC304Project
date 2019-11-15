<%@ page import="java.sql.*"%>
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
		<h1>Order List</h1>

		<%
			//TODO:  out.println(currFormat.format(5.0);  // Prints $5.00

			//Note: Forces loading of SQL Server driver
			try { // Load driver class
				Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
			} catch (java.lang.ClassNotFoundException e) {
				out.println("ClassNotFoundException: " + e);
			}

			// Defining login information.
			String url = "jdbc:sqlserver://sql04.ok.ubc.ca:1433;DatabaseName=db_tvande;";
			String uid = "tvande";
			String pw = "33970138";

			//Useful code for formatting currency values:
			NumberFormat currFormat = NumberFormat.getCurrencyInstance();

			//Make connection.
			try (Connection con = DriverManager.getConnection(url, uid, pw);) {

				//First Query for Order Info.
				String SQL = "SELECT O.OrderId, OrderDate, C.CustomerId, firstName, " + "LastName, totalAmount "
						+ "FROM OrderSummary AS O JOIN Customer as C ON O.CustomerId = C.CustomerId";
				PreparedStatement pstmt = con.prepareStatement(SQL);
				ResultSet orders = pstmt.executeQuery();

				//Outside table.
				out.print("<table width=\"100%\"align=\"center\" border=\"1\">");
				out.print(
						"<tr> <th>Order Id</th> <th>Order date</th> <th>Customer Id</th> <th>Customer Name</th> <th>Total Amount</th> </tr>");

				//Print Order info - Product info is handled in a nested query / loop.
				while (orders.next()) {
					out.print("<tr><td>" + orders.getInt(1) + "</td>" + "<td>" + orders.getDate(2) + " "
							+ orders.getTimestamp(2) + "</td>" + "<td>" + orders.getInt(3) + "</td>" + "<td>"
							+ orders.getString(4) + " " + orders.getString(5) + "</td>" + "<td>"
							+ orders.getBigDecimal(6) + "</td></tr>");

					//Second Query
					int orderId = orders.getInt(1);
					SQL = "SELECT productid, quantity, price FROM orderproduct WHERE orderId = ?";
					pstmt = con.prepareStatement(SQL);
					pstmt.setInt(1, orderId);
					ResultSet orderProducts = pstmt.executeQuery();

					//Inside Table - Product Info		
					out.print("<tr align=\"right\"><td colspan=\"5\"><table border=\"1\">");
					out.print("<tr><th>Product Id</th><th>Quantity</th><th>Price</th></tr>");

					//Print product info
					while (orderProducts.next()) {
						out.print("<tr><td>" + orderProducts.getInt(1) + "</td>" + "<td>" + orderProducts.getInt(2)
								+ "</td>" + "<td>" + orderProducts.getBigDecimal(3) + "</td></tr>");
					}

					//Close Inside table
					out.print("</table></td></tr>");
				}

				//Close outside table	
				out.print("</table>");

			} catch (SQLException ex) {
				System.err.print(ex);
			}
		%>
	</div>
</body>
</html>

