<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import = "java.io.*,java.util.*,javax.mail.*"%>
<%@ page import = "javax.mail.internet.*,javax.activation.*"%>
<%@ page import = "javax.servlet.http.*,javax.servlet.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Mail Message</title>
</head>
<body>
<%@ include file="jdbc.jsp"%>
<%
try { // Load driver class
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
} catch (java.lang.ClassNotFoundException e) {
	out.println("ClassNotFoundException: " + e);
}

// Defining login information.
String url = "jdbc:sqlserver://sql04.ok.ubc.ca:1433;DatabaseName=db_tvande;";
String uid = "tvande";
String pw = "33970138";

//Make connection.
try (Connection con = DriverManager.getConnection(url, uid, pw);) {

	//  Query to grab user password based on email
	String SQL = "SELECT password FROM customer WHERE email = ?";
	PreparedStatement pstmt = con.prepareStatement(SQL);
	pstmt.setString(1, request.getParameter("email"));
	ResultSet rst = pstmt.executeQuery();

	// Variables to hold password and flags for verification
	String password = "";
	while (rst.next()) {
			password = rst.getString("password");
		}
	
	if (password == "") {
		response.sendRedirect("lostPassword.jsp");
	} else {
	
	String result;
	final String to = request.getParameter("email");
	final String subject = "Administrator Password Recovery";
	final String messg = "Your password is: " + password;

	//  Uses a test email acount Ian set up
	final String from = "mittestemail2019@gmail.com";
	final String pass = "ianmichealtom2019";

	String host = "smtp.gmail.com";

	Properties properties = new Properties();

	properties.put("mail.smtp.host", host);
	properties.put("mail.transport.protocol", "smtp");
	properties.put("mail.smtp.auth", "true");
	properties.put("mail.smtp.starttls.enable", "true");
	properties.put("mail.user", from); 
	properties.put("mail.password", pass);
	properties.put("mail.port", "465");

	Session mailSession = Session.getInstance(properties, new javax.mail.Authenticator() {
		@Override
		
		protected PasswordAuthentication getPasswordAuthentication() {
			return new PasswordAuthentication(from, pass);
		}
	});

	try {
		MimeMessage message = new MimeMessage(mailSession);
		
		message.setFrom(new InternetAddress(from));
		
		message.addRecipient(Message.RecipientType.TO,
		
		new InternetAddress(to));
		
		message.setSubject(subject);
		
		message.setText(messg);
		
		Transport.send(message);
		
		result = "";
		response.sendRedirect("index.jsp");
	} catch (MessagingException mex) {
		mex.printStackTrace();
		result = "Error: Message did not send";
		response.sendRedirect("lostPassword.jsp");
	}
	}
}
catch (SQLException ex) {
	System.err.print(ex);
	response.sendRedirect("admin.jsp");
}
%>	
</body>
</html>