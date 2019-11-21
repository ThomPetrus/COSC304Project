<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import = "java.io.*,java.util.*,javax.mail.*"%>
<%@ page import = "javax.mail.internet.*,javax.activation.*"%>
<%@ page import = "javax.servlet.http.*,javax.servlet.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
<%
String result;
final String to = request.getParameter("email");
final String subject = "Administrator Password Recovery";
final String messg = "Your password is:\n test";

//  Uses a test email acount Ian set up
//  It worked with my personal email bu that is super problematic
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
	
	result = "Message sent succesfully!";
	response.sendRedirect("index.jsp");
} catch(MessagingException mex) {
	mex.printStackTrace();
	result = "Error: Message did not send";
	response.sendRedirect("index.jsp");
}
%>
</body>
</html>