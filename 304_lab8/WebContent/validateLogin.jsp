<%@ page language="java" import="java.io.*,java.sql.*"%>
<%@ include file="jdbc.jsp" %>
<%@ page language="java" import="java.io.*" %>
<%
	String authenticatedUser = null;
	session = request.getSession(true);// May create new session
	try {
		authenticatedUser = validateLogin(out,request,session);
	} catch(IOException e) {
		out.println(e); 
	}
	if (authenticatedUser != null) {
		// Redirect to the admin page if succesful
		response.sendRedirect("admin.jsp");
	} else {
		// Else, send user back to login.
		response.sendRedirect("login.jsp"); 
	}
%>

<%!
	String validateLogin(JspWriter out,HttpServletRequest request, HttpSession session) throws IOException {
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		String retStr = null;
		if(username == null || password == null) {
			return null;
		}
		if((username.length() == 0) || (password.length() == 0)) {
			return null;
		}
		// Ideally, this would be a database connection. For now, just hardcode the username and password
		if (username.equals("test") && password.equals("test")) {
			retStr = username;
		}
		if(retStr != null) {
			session.removeAttribute("loginMessage");
			session.setAttribute("authenticatedUser",username);
		}
		else {
			session.setAttribute("loginMessage","Could not connect to the system using that username/password.");
		}
		return retStr;
} %>