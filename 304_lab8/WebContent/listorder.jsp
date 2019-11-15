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
<style>

body {
	background-image: url("clewwwds.jpg");
	background-repeat: no-repeat;
	background-position: right top;
	background-attachment: fixed;
	background-size: 100%;
}

a:link, a:visited {
  text-align: center;
  text-decoration: none;
  color: #674B4B;
}

a:hover, a:active {
  color:lightSlateGray;
}

.div1 {
	font-size: 22px;
	margin-top: 70px;
	margin-bottom: 70px;
	margin-left:70px;
	margin-right:70px;
	text-align: center;
	font-family:;
}

</style>
</head>
<body>
	<nav class="navbar navbar-expand-md navbar-light bg-light fixed-top">
		<a class="navbar-brand" href="shop.html">MIT</a>
		<button class="navbar-toggler" type="button" data-toggle="collapse"
			data-target="#navbarsExampleDefault"
			aria-controls="navbarsExampleDefault" aria-expanded="false"
			aria-label="Toggle navigation">
			<span class="navbar-toggler-icon"></span>
		</button>

		<div class="collapse navbar-collapse" id="navbarsExampleDefault">
			<ul class="navbar-nav mr-auto">
				<li class="nav-item active"><a class="nav-link"
					href="shop.html">Home <span class="sr-only">(current)</span>
				</a></li>
				<!-- <li class="nav-item"><a class="nav-link" href="#">Link</a></li> -->
				<li class="nav-item dropdown"><a
					class="nav-link dropdown-toggle" href="#" id="dropdown01"
					data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">Menu</a>
					<div class="dropdown-menu" aria-labelledby="dropdown01">
						<a class="dropdown-item" href="listprod.jsp">List Products</a> <a
							class="dropdown-item" href="listorder.jsp">List Orders</a> <a
							class="dropdown-item" href="showcart.jsp">Show Cart</a>
					</div></li>
			</ul>
			<form class="form-inline my-2 my-lg-0" method="get"
				action="listprod.jsp">
				<input class="form-control mr-sm-2" type="text" placeholder="Search"
					aria-label="Search" name="productName">
				<button class="btn btn-secondary my-2 my-sm-0 white" type="submit">Search</button>
			</form>
		</div>
	</nav>
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
			String url = "jdbc:sqlserver://sql04.ok.ubc.ca:1433;DatabaseName=db_mcrouse;";
		String uid = "mcrouse";
		String pw = "19271824";

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

