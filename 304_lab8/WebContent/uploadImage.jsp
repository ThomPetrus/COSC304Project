<%@page import="javax.imageio.ImageIO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="javax.servlet.ServletException"%>
<%@ page import="javax.servlet.annotation.MultipartConfig"%>
<%@ page import="javax.servlet.annotation.WebServlet"%>
<%@ page import="javax.servlet.http.HttpServlet"%>
<%@ page import="javax.servlet.http.HttpServletRequest"%>
<%@ page import="javax.servlet.http.HttpServletResponse"%>
<%@ page import="javax.servlet.http.Part"%>
<%@ page import="javax.sql.rowset.serial.SerialBlob" %>


<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>MIT - ADMIN - Upload Image</title>
</head>
<body>
	<form action="uploadImage.jsp" method="get"
		enctype="multipart/form-data">
		<table border="1" align="center">
			<tr>
				<th align="center" bgcolor="lightGrey" style="color: white;"
					colspan="5">
					<h2>Upload an Image for a product.</h2>
				</th>
			</tr>
			<tr>
				<th align="right">Select Image:</th>
				<td><input type="file" name="image"></td>
			</tr>
			<tr>
				<th align="right">Enter ProductId:</th>
				<td><input type="text" name="id" /></td>
			</tr>
			<tr>
				<td></td>
				<td colspan="0.5"><input type="submit" value="Submit"></td>
				<td colspan="0.5"><input type="reset" value="Reset"></td>
				
			</tr>
		</table>
	</form>
</body>
</html>


<%
	 
	String url = "jdbc:sqlserver://sql04.ok.ubc.ca:1433;DatabaseName=db_tvande;";
	String uid = "tvande";
	String pw = "33970138";

	int id = 0;
	int result = 0;
	Connection con = null;

	// image path
	String imgUrl = request.getParameter("image");
	String idString = request.getParameter("id");
	out.print("<h1>" + id + "</h1>");

	//product id

	if (imgUrl != null && idString != null) {

		try {
			id = Integer.parseInt(idString);
		} catch (Exception e) {
			System.err.print("couldnt convert product Id to integer.");
		}

		// TODO : Ensure id exists in db 

		// byte i/o
		ByteArrayOutputStream bos = null;
		File img = new File(imgUrl);

		if (img.isFile()) {
			try (FileInputStream in = new FileInputStream(img);) {
				byte[] buffer = new byte[1024];
				bos = new ByteArrayOutputStream();
				for (int len; (len = in.read(buffer)) != -1;)
					bos.write(buffer, 0, len);
			} catch (FileNotFoundException e) {
				System.err.print(e.getMessage());
			} catch (IOException e2) {
				System.err.print(e2.getMessage());
			}
		}

		byte[] imgBin = null;
		Blob blob=null;
		
		if (bos != null){
			imgBin = bos.toByteArray();
			blob = new SerialBlob(imgBin);
		}
		try {
			Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
			con = DriverManager.getConnection(url, uid, pw);
			
			if (imgBin != null) {
				String SQL = "UPDATE product SET productImage = CONVERT(VARBINARY(MAX),'" + blob + "') WHERE productId = " + id+";";
				
				PreparedStatement pstmt = con.prepareStatement(SQL);
				result = pstmt.executeUpdate();

				if (result > 0)
					out.print("<h1>Image Succesfully Uploaded!</h1>");
				
			}
		} catch (Exception ex) {
			System.err.print(ex);
		}
	}
%>