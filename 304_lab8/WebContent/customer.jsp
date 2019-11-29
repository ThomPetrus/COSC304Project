<!DOCTYPE html>
<html>
<head>
<title>Customer Page</title>
<link href="css/mainstyle.css" rel="stylesheet">
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

</head>
<body>
	<%@ include file="header.jsp"%>
	<%@ include file="auth.jsp"%>
	<%@ page import="java.text.NumberFormat"%>
	<%@ include file="jdbc.jsp"%>

	<%
		String userName = (String) session.getAttribute("authenticatedUser");
	%>
		<div class="div1">
	<%
	
	if(userName!=null && userName.equalsIgnoreCase("admin")){
		out.print("<h1>You're logged into the Admin account, silly.</h1>");
	} else if(userName != null){
		// TODO: Print Customer information
		String SQL = "SELECT customerId, firstName, LastName, email, phonenum, address, city, state, postalcode, country, userid FROM customer WHERE userid = '"
				+ userName+"';";
	
		try {
			getConnection();
			PreparedStatement pstmt = con.prepareStatement(SQL);
			ResultSet rst = pstmt.executeQuery();
			
			if(rst.next()){
				out.print("<table align=\"center\" width=\"50%\" bgcolor=\"white\" border=\"1\">");
				out.print("<tr><td>Customer ID:</td><td>"+rst.getString(1)+"</td></tr>");
				out.print("<tr><td>First Name</td><td>"+rst.getString(2)+"</td></tr>");
				out.print("<tr><td>Last Name</td><td>"+rst.getString(3)+"</td></tr>");
				out.print("<tr><td>Email</td><td>"+rst.getString(4)+"</td></tr>");
				out.print("<tr><td>Phone Number</td><td>"+rst.getString(5)+"</td></tr>");
				out.print("<tr><td>Address</td><td>"+rst.getString(6)+"</td></tr>");
				out.print("<tr><td>City</td><td>"+rst.getString(7)+"</td></tr>");
				out.print("<tr><td>State</td><td>"+rst.getString(8)+"</td></tr>");
				out.print("<tr><td>Postal Code</td><td>"+rst.getString(9)+"</td></tr>");
				out.print("<tr><td>Country</td><td>"+rst.getString(10)+"</td></tr>");
				out.print("<tr><td>Username</td><td>"+rst.getString(11)+"</td></tr>");
				out.print("</table>");
			}
			closeConnection();
		}catch(Exception e){
			System.err.println(e.getMessage());
		}
		// Make sure to close connection
	}
	%>
</div>
</body>
</html>

