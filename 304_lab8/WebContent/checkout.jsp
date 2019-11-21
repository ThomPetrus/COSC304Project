<!DOCTYPE html>
<html>
<head>
<title>MIT Inc and Sons Ltd - Checkout</title>
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
	<%@ include file="jdbc.jsp"%>

	<div class="div1">
		<h1>Enter your customer id and password to complete the
			transaction:</h1>

		<form method="get" action="checkout.jsp">
			<table align="center">
				<tr>
					<td>Customer ID:</td>
					<td><input type="text" name="customerId" size="20"></td>
				</tr>
				<tr>
					<td>Password:</td>
					<td><input type="password" name="password" size="20"></td>
				</tr>
				<tr>
					<td><input type="submit" value="Submit"></td>
					<td><input type="reset" value="Reset"></td>
				</tr>
			</table>
		</form>


		<%
			String customerId = request.getParameter("customerId");
			String pw = request.getParameter("password");

			if (customerId != null && customerId != "" && pw != null && pw != "") {

				try {
					getConnection();
					String SQL = "SELECT password FROM customer WHERE customerId = " + customerId + " AND password = '"+pw+"';";
					PreparedStatement pstmt = con.prepareStatement(SQL);
					ResultSet rst = pstmt.executeQuery();

					if (rst.next()) {
						response.sendRedirect("order.jsp?customerId=" + customerId);
					} else {
						out.write("<h3>Incorrect Customer Id and Password Combination.</h3>");
					}
					closeConnection();
				} catch (Exception e) {
					System.err.println(e.getMessage());
				}
			}
		%>

	</div>
</body>
</html>

