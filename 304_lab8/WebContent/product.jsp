<%@ page import="java.util.HashMap"%>
<%@ page import="java.text.NumberFormat"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp"%>

<html>
<head>
<title>MIT - Product Information</title>
<link href="css/mainstyle.css" rel="stylesheet">
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

<!-- TODO style sheet as opposed to internal CSS -->
<link href="css/mainstyle.css" rel="stylesheet">

</head>
<body>
	<%@ include file="header.jsp"%>

	<%
		// Get product name to search for
		// TODO: Retrieve and display info for the product
		String productId = request.getParameter("id");
		NumberFormat currFormat = NumberFormat.getCurrencyInstance();

		String SQL = "SELECT * FROM product WHERE productId = " + productId;
		getConnection();
		PreparedStatement pstmt = con.prepareStatement(SQL);
		ResultSet rst = pstmt.executeQuery();
		while (rst.next()) {
			
			int prodId = rst.getInt(1);
			String pname = rst.getString(2);
			double pr = rst.getDouble(3);
			String prodDescr = rst.getString(6);

			out.print("<div class=\"div1\">");
			//If there is a productImageURL, display using IMG tag			
			if (rst.getString(4) != null) {
				String imgUrl = rst.getString(4);
				out.print("<table align=\"center\" width=\"75%\" border=\"1\">");
				out.print("<tr><td align=\"center\" colspan=\"4\">" + "<img src=" + imgUrl + ">" + "</td></tr>");
				out.print("<tr><th>Product Id</th><th>Product Name</th><th>Product Price</th><th>Product Description</th></tr>");
				out.print("<tr><td>" + prodId + "</td><td>" + pname + "</td><td>" + currFormat.format(rst.getDouble(3)) + "</td><td>" + prodDescr + "</td></tr>");
			// Else if there is an image stored ont the database display it using the bianry file.
			} else if (rst.getBinaryStream(5) != null) {
				out.print("<table align=\"center\" width=\"75%\" border=\"1\">");
				out.print("<tr><td align=\"center\" colspan=\"4\">" + "<img src=\"displayImage.jsp?id=" + prodId + "\"></td></tr>");
				out.print("<tr><th>Product Id</th><th>Product Name</th><th>Product Price</th><th>Product Description</th></tr>");
				out.print("<tr><td>" + prodId + "</td><td>" + pname + "</td><td>" + currFormat.format(rst.getDouble(3)) + "</td><td>" + prodDescr + "</td></tr>");
			}

			// Add links to Add to Cart and Continue Shopping
			out.print("<tr><td colspan=\"2\" align=\"center\"><a href=\"addcart.jsp?id=" + rst.getInt(1) + "&name="
					+ rst.getString(2) + "&price=" + rst.getDouble(3) + "\">Add Cart</a></td>");
			out.print(
					"<td colspan=\"2\" align=\"center\"><a href=\"listprod.jsp\">Continue Shopping</a></td></tr>");
			out.print("</table>");
			out.print("</div>");
			closeConnection();
		}
	%>

</body>
</html>

