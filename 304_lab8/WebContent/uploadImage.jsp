<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
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
		<form action="uploadImage.jsp" method="get"
			enctype="multipart/form-data">
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
		<%
			/*
			
				Reads in a File based upon the image chosen by the user. 
				Verifies it is a file then reads / write the file bytes into a 
				byte array. If the product Id is for a valid product the byte array is
				then saved to the database.
				
				Since the parameters received from the forms were overwriting each other
				and I wanted to keep the functionality of adding pictures for products already in
				the database, and because I don't want to make it more complicated than it has to be
				I've chosen to simply display the auto-generated key from a the product, if the user
				was redirected to this page from the add product page, hence the funky variable names, just
				for clarity I suppose.
			
			*/
			String url = "jdbc:sqlserver://sql04.ok.ubc.ca:1433;DatabaseName=db_tvande;";
			String uid = "tvande";
			String pw = "33970138";

			int id = 0;
			int result = 0;
			Connection con = null;

			// image path && id
			String imgUrl = request.getParameter("image");
			String idFromAddProduct = request.getParameter("id");
			String idFromForm = request.getParameter("idForm");

			if (idFromAddProduct != null) {
				out.print("<div class=\"div1\"><h3>The product you just entered has the Auto-Generated key: "
						+ idFromAddProduct + "</h3><div>");
			}

			if (imgUrl != null && idFromForm != null) {

				try {
					id = Integer.parseInt(idFromForm);
				} catch (Exception e) {
					System.err.print("Could not convert product Id to integer.");
				}

				ByteArrayOutputStream bos = null;
				File img = new File(imgUrl);

				if (img.isFile()) {

					try (FileInputStream in = new FileInputStream(img)) {

						int BUFFER_SIZE = 10000;
						byte[] buffer = new byte[BUFFER_SIZE];

						bos = new ByteArrayOutputStream();

						// Reads image / file Inputstream and writes it to ByteArrayOutputStream's buffer
						for (int len; (len = in.read(buffer)) != -1;)
							bos.write(buffer, 0, len);

					} catch (FileNotFoundException e) {
						System.err.print(e.getMessage());
					} catch (IOException e2) {
						System.err.print(e2.getMessage());
					}
				}

				byte[] byteArray = null;

				// All the bytes written to the buffer are all written to a new byteArray
				if (bos != null) {
					byteArray = bos.toByteArray();
				}

				try {
					Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
					con = DriverManager.getConnection(url, uid, pw);

					// First verify the productId entered is for a valid product in the database.
					String SQL = "SELECT * FROM product WHERE productId =" + id;
					PreparedStatement pstmt = con.prepareStatement(SQL);
					ResultSet rst = pstmt.executeQuery();
					if (rst.next()) {
						// If a new byteArray containing the contents was created write it to the db.
						if (byteArray != null) {
							SQL = "UPDATE product SET productImage = ? WHERE productId = " + id + ";";
							pstmt = con.prepareStatement(SQL);
							pstmt.setBytes(1, byteArray);
							result = pstmt.executeUpdate();

							if (result > 0) {
								out.print("<h1 align=\"center\">Image Succesfully Uploaded!</h1>");
							}
						}
					} else {
						out.print("<h1 align=\"center\">Invalid Product Id!</h1>");
					}

				} catch (Exception ex) {
					System.err.print(ex);
				} finally {
					con.close();
				}
			}
		%>
	</div>
</body>
</html>

