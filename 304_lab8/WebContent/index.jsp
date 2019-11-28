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
		<h1 align="center">Welcome to MIT Inc and Sons Ltd</h1>
		<table border="1" align="center" bgcolor="white" width="90%">
			<tr>
				<td>
					<h2 align="center">
						<a href="login.jsp">Login</a>
					</h2>
				</td>
			</tr>
			<tr>
				<td>
					<h2 align="center">
						<a href="listprod.jsp">Begin Shopping</a>
					</h2>
				</td>
			</tr>
			<tr>
				<td>
					<h2 align="center">
						<a href="listorder.jsp">List All Orders</a>
					</h2>
				</td>
			</tr>
			<tr>
				<td>
					<h2 align="center">
						<a href="customer.jsp">Customer Info</a>
					</h2>
				</td>
			</tr>
			<tr>
				<td>
					<h2 align="center">
						<a href="admin.jsp">Administrators</a>
					</h2>
				</td>
			</tr>
			<tr>
				<td>
					<h2 align="center">
						<a href="logout.jsp">Log out</a>
					</h2>
				</td>
			</tr>
			<%
				//  Checks if User is logged in as an Admin
				boolean authenticated = session.getAttribute("authenticatedUser") == null ? false : true;
				if (authenticated && ((String)session.getAttribute("authenticatedUser")).equalsIgnoreCase("admin")) {
					out.print("<tr><td>");
					out.print("<h2 align=\"center\"><a href=\"addProduct.jsp\">Add a Product<h2>");
					out.print("</td></tr>");
					out.print("<tr><td>");
					out.print("<h2 align=\"center\"><a href=\"lostPassword.jsp\">Forgot Password?<h2>");
					out.print("</td></tr>");
					out.print("<tr><td>");
					out.print("<h2 align=\"center\"><a href=\"uploadImage.jsp\">Upload Image - Currently Only functional on LocalHost<h2>");
					out.print("</td></tr></table>");
					out.print("<h4>Logged in as Administrator</h4>");
				} else if(authenticated){
					out.print("<tr><td>");
					out.print("<h2 align=\"center\"><a href=\"myorders.jsp\">My Orders<h2>");
					out.print("</td></td>");
					out.print("</table>");
					out.print("<h4>Logged in as "+session.getAttribute("authenticatedUser")+"</h4>");
				}
			%>

			</div>
</body>