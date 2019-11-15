<!DOCTYPE html>
<html>
<head>
<title>Customer Page</title>
<link href="css/mainstyle.css" rel="stylesheet">
</head>
<body>
<%@ include file="header.jsp"%>
<%@ include file="auth.jsp"%>
<%@ page import="java.text.NumberFormat" %>
<%@ include file="jdbc.jsp" %>

<%
	String userName = (String) session.getAttribute("authenticatedUser");
%>

<%

// TODO: Print Customer information
String sql = "";

// Make sure to close connection
%>

</body>
</html>

