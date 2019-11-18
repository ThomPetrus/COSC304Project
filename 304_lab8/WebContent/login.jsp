<!DOCTYPE html>
<html>
<head>
<title>Login Screen</title>
<link href="css/mainstyle.css" rel="stylesheet">
</head>
<body>
<%@ include file="header.jsp"%>
<div style="margin:0 auto;text-align:center;display:inline">
	<div class="div1">
	<h3>Please Login to System</h3>

<%
	// Print prior error login message if present
	if (session.getAttribute("loginMessage") != null)
	out.println("<p>"+
	session.getAttribute("loginMessage").toString()+"</p>");
%>

<br>
	<form name="MyForm" method=post action="validateLogin.jsp">
		<table width="40%" border="0" cellspacing="0" cellpadding="0">
			<tr><td><div align="center">Username:</div></td>
			<td><input type="text" name="username" size=8 maxlength=8></td></tr>
			<tr><td><div align="center">Password:</div></td>
			<td><input type="password" name="password" size=8 maxlength=8"></td></tr>
		</table>
		
		<input class="submit" type="submit" name="Sub" value="Log In">
	</form>
<br/>
</div>
</body>
</html>

