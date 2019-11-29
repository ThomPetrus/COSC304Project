<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>

<%@ page import="javax.servlet.ServletException"%>
<%@ page import="javax.servlet.annotation.MultipartConfig"%>
<%@ page import="javax.servlet.annotation.WebServlet"%>
<%@ page import="javax.servlet.http.HttpServlet"%>
<%@ page import="javax.servlet.http.HttpServletRequest"%>
<%@ page import="javax.servlet.http.HttpServletResponse"%>
<%@ page import="javax.servlet.http.Part"%>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>MIT - ADMIN - Upload Image</title>

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
	<%@ include file="auth.jsp"%>
	<%@ include file="jdbc.jsp"%>
	<%@ include file="header.jsp"%>

	<div class="div1">
		<form method="post" action="uploadServlet" enctype="multipart/form-data"> 
		<!--  <form method="post" action="uploadServlet" enctype="multipart/form-data"> <!-- Local Host-->

			<%
				out.print("<p>" + application.getContextPath() + "</p>");
				String idFromAddProduct = request.getParameter("id");
				if (idFromAddProduct != null && !idFromAddProduct.equals(""))
					out.print("<div class=\"div1\"><h3>The product you just entered has the Auto-Generated key: "
							+ idFromAddProduct + "</h3><div>");
			%>

			<table border="1" align="center">
				<tr>
					<th align="center" bgcolor="lightGrey" colspan="4">
						<h2>Upload an Image for the Product.</h2>
					</th>
				</tr>
				<tr>
					<th>Select Image:</th>
					<td><input type="file" name="image"></td>
				</tr>

				<tr>
					<th>Enter ProductId:</th>
					<td><input type="text" name="idForm" /></td>
				</tr>
				<tr>
					<td colspan="1"><input type="reset" value="Reset"></td>
					<td colspan="1"><input type="submit" value="Submit"></td>
				</tr>
			</table>
		</form>
	</div>
</body>
</html>
