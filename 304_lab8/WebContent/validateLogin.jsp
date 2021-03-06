<%@ page language="java" import="java.io.*,java.sql.*"%>
<%@ include file="jdbc.jsp"%>
<%@ page language="java" import="java.io.*"%>
<%
	String authenticatedUser = null;
	session = request.getSession(true);// May create new session
	try {
		authenticatedUser = validateLogin(out, request, session);
	} catch (IOException e) {
		out.println(e);
	}
	
	if(authenticatedUser == null){
		response.sendRedirect("login.jsp");
	} else if (authenticatedUser.equalsIgnoreCase("admin")) {
		// Redirect to the admin page if logged in with test / test
		response.sendRedirect("admin.jsp");
		// else if logged in with valid customer TODO ADD ID
	} else if (authenticatedUser != null) {
		response.sendRedirect("customer.jsp");
	} 
		
%>

<%!String validateLogin(JspWriter out, HttpServletRequest request, HttpSession session) throws IOException {
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		String retStr = null;

		if (username == null || password == null) {
			return null;
		}
		if ((username.length() == 0) || (password.length() == 0)) {
			return null;
		}

		// Ideally, this would be a database connection. For now, just hardcode the username and password
		if (username.equals("admin") && password.equals("test")) {
			retStr = "ADMIN";
		} else {
			String SQL = "SELECT userid, password FROM customer WHERE userid = '" + username + "' AND password = '"+password+"';";
			try{
			getConnection();
			PreparedStatement pstmt = con.prepareStatement(SQL);
			ResultSet rst = pstmt.executeQuery();
			
			if(rst.next()){
				retStr = username;
			}
			
			closeConnection();
			} catch(SQLException e){
				System.err.println(e.getMessage());
			}
		}
		if (retStr != null) {
			session.removeAttribute("loginMessage");
			session.setAttribute("authenticatedUser", username);
		} else {
			session.setAttribute("loginMessage", "Could not connect to the system using that username/password.");
		}
		return retStr;
			
		
	}%>