<!DOCTYPE html>
<html>
<head>
<title>Login Screen</title>
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
	<div style="margin: 0 auto; text-align: center; display: inline">
		<div class="div1">
			<h3>Please Login to System</h3>

			<%
				// Print prior error login message if present
				if (session.getAttribute("loginMessage") != null)
					out.println("<p>" + session.getAttribute("loginMessage").toString() + "</p>");
			%>

			<br>
			<form name="MyForm" method=post action="validateLogin.jsp">
				<table width="40%" border="0" cellspacing="0" cellpadding="0" align="center">
					<tr>
						<td><div align="center">Username:</div></td>
						<td><input type="text" name="username" size=8 maxlength=8></td>
					</tr>
					<tr>
						<td><div align="center">Password:</div></td>
						<td><input type="password" name="password" size=8 maxlength=8"></td>
					</tr>
				</table>

				<input class="submit" type="submit" name="Sub" value="Log In">
			</form>
			<br />
		</div>
</body>
</html>

