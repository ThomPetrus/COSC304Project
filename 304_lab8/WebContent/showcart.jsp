<%@ page import="java.util.HashMap"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.text.NumberFormat"%>
<%@ page import="java.util.Map"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>Your Shopping Cart</title>
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
	<%@ include file="header.jsp"%>
	<div class="div1">
		<%
			// Get the current list of products
			@SuppressWarnings({ "unchecked" })
			HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session
					.getAttribute("productList");

			if (productList == null) {
				out.println("<H1>Your shopping cart is empty!</H1>");
				productList = new HashMap<String, ArrayList<Object>>();
			} else {
				NumberFormat currFormat = NumberFormat.getCurrencyInstance();

				out.println("<h1>Your Shopping Cart</h1>");
				out.print("<table align=\"center\" width=\"90%\"><tr><th>Product Id</th><th>Product Name</th><th>Quantity</th>");
				out.println("<th>Price</th><th>Subtotal</th><th>Change Quantity</th></tr>");

				double total = 0;
				Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
				while (iterator.hasNext()) {
					Map.Entry<String, ArrayList<Object>> entry = iterator.next();
					ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
					if (product.size() < 4) {
						out.println("Expected product with four entries. Got: " + product);
						continue;
					}

					out.print("<tr><td>" + product.get(0) + "</td>");
					out.print("<td>" + product.get(1) + "</td>");

					out.print("<td align=\"center\">" + product.get(3) + "</td>");
					Object price = product.get(2);
					Object itemqty = product.get(3);
					double pr = 0;
					int qty = 0;

					try {
						pr = Double.parseDouble(price.toString());
					} catch (Exception e) {
						out.println("Invalid price for product: " + product.get(0) + " price: " + price);
					}
					try {
						qty = Integer.parseInt(itemqty.toString());
					} catch (Exception e) {
						out.println("Invalid quantity for product: " + product.get(0) + " quantity: " + qty);
					}

					out.print("<td align=\"right\">" + currFormat.format(pr) + "</td>");
					out.print("<td align=\"right\">" + currFormat.format(pr * qty) + "</td>");

					// Changing the quantity of items.
					out.print("<td><a href=\"changecart.jsp?id=" + product.get(0) + "&name=" + product.get(1)
							+ "&price=" + price + "&qty=" + "addOne" + "\">  +  </a>/");
					out.print("<a href=\"changecart.jsp?id=" + product.get(0) + "&name=" + product.get(1)
							+ "&price=" + price + "&qty=" + "removeOne" + "\">  -  </a></td>");
					out.print("<td><a href=\"changecart.jsp?id=" + product.get(0) + "&name=" + product.get(1)
							+ "&price=" + price + "&qty=" + "removeAll" + "\">Remove from Cart</a></td></tr>");
					total = total + pr * qty;
				}
				out.println("<tr><td colspan=\"4\" align=\"right\"><b>Order Total</b></td>" + "<td align=\"right\">"
						+ currFormat.format(total) + "</td></tr>");
				out.println("</table>");

				out.println("<h2><a href=\"checkout.jsp\">Check Out</a></h2>");
			}
		%>
		<h2>
			<a href="listprod.jsp">Continue Shopping</a>
		</h2>

	</div>
	>
</body>
</html>

