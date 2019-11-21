<!DOCTYPE html>
<html>
<head>
<title>Administrator Page</title>
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
<body>
	<%@ include file="auth.jsp"%>
	<%@ include file="jdbc.jsp"%>
	<%@ include file="header.jsp"%>
	
	<div class="div1">
		

		<%
		String userName = (String) session.getAttribute("authenticatedUser");
		
		if(userName != null && userName.equalsIgnoreCase("admin")){
			
			out.print("<h1>Administrator Sales Report By Day</h1>");
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
			//NumberFormat currFormat = NumberFormat.getCurrencyInstance();

			//Make connection.
			try (Connection con = DriverManager.getConnection(url, uid, pw);) {
				// TODO: Write SQL query that prints out total order amount by day
				String sql = "SELECT orderDate, SUM(totalAmount) " + "FROM orderSummary " + "GROUP BY orderDate;";
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
		} else {
			out.print("<h1>Only Administrators have access to the admin page.</h1>");
		}
		%>
	</div>
</body>
</html>

