<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>MIT - ADMIN - Add Product</title>

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
	<%@ include file="auth.jsp"%>
	<%@ include file="jdbc.jsp"%>

	<div class="div1">
		<h1>Add a Product!</h1>
		<form action="addProduct.jsp" method="post">
			<table align="center">
				<tr>
					<td>Product Name:</td>
					<td><input type="text" name="productName" size="50"></td>
				</tr>
				<tr>
					<td colspan="2"></td>
				</tr>
				<tr>
					<td>Product Price:</td>
					<td><input type="text" name="productPrice" size="50"></td>
				</tr>
				<tr>
					<td></td>
					<td>(Just the number)</td>
					<td></td>
				</tr>
				<tr>
					<td>Product Description</td>
					<td><input type="text" name="productDescr" size="50"></td>
				</tr>
				<tr>
					<td colspan="2"></td>
				</tr>
				<tr>
					<td>Category</td>
					<td><input type="text" name="category" size="50"></td>
				</tr>
				<tr>
					<td></td>
					<td>(Number or Category Name)</td>
				</tr>
				<tr>
					<td><input type="reset" value="Reset"></td>
					<td><input type="submit" value="Submit"></td>
				</tr>
			</table>
		</form>
		<%
			boolean validInput = true;

			// Retrieve User input.
			String pname = request.getParameter("productName");
			String price = request.getParameter("productPrice");
			String descr = request.getParameter("productDescr");
			String category = request.getParameter("category");

			out.write("<div class=\"div1\">");

			// Once the user submits a product
			if (pname != null && price != null && descr != null && category != null) {

				// Parse double value for price
				double pr = 0;
				if (price != "") {
					try {
						pr = Double.parseDouble(price);
					} catch (Exception e) {
						out.print("<h1>Error: Enter a valid price. <h1>");
						validInput = false;
					}
				}

				// Check whether category input was numeric or String.
				// If String value - convert when connection is made.
				int catg = 0;
				boolean catgIsNumeric = false;
				if (category != "") {
					try {
						catg = Integer.parseInt(category);
						catgIsNumeric = true;
					} catch (Exception e) {
						System.err.println("Needed to convert String to catgId");
					}
				}

				// Make Connection
				String url = "jdbc:sqlserver://sql04.ok.ubc.ca:1433;DatabaseName=db_tvande;";
				String uid = "tvande";
				String pw = "33970138";

				try {
					Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
					con = DriverManager.getConnection(url, uid, pw);

					String SQL = "";
					PreparedStatement pstmt = null;
					ResultSet rst = null;

					// Convert categoryName to categoryId / check if valid category name.
					if (!catgIsNumeric) {
						SQL = "SELECT categoryId FROM category WHERE categoryName = '" + category + "'";
						pstmt = con.prepareStatement(SQL);
						rst = pstmt.executeQuery();
						if (rst.next()) {
							catg = rst.getInt(1);
						} else {
							out.print("<h1>Invalid Category Name</h1>");
							validInput = false;
						}
					}

					if (validInput) {
						SQL = "INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('" + pname
								+ "'," + catg + ",'" + descr + "'," + pr + ");";
						pstmt = con.prepareStatement(SQL, Statement.RETURN_GENERATED_KEYS);
						int result = pstmt.executeUpdate();
						ResultSet keys = pstmt.getGeneratedKeys();
						keys.next();
						int productId = keys.getInt(1);

						if (result > 0) {
							out.print("<h1>Product Added Succesfully!</h1>");
							out.write("<h3><a href=\"uploadImage.jsp?id=" + productId + "\">Upload an Image?</a></h3>");
							out.write("</div>");
						}
					}
				} catch (SQLException ex) {
					System.err.println(ex.getMessage());
				} catch (Exception ex) {
					System.err.println("Error during insertion into database");
				} finally {
					con.close();
				}
			}
		%>
	</div>
</body>
</html>

