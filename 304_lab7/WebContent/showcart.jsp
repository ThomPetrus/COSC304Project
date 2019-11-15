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
<style>
body {
	background-image: url("clewwwds.jpg");
	background-repeat: no-repeat;
	background-position: right top;
	background-attachment: fixed;
	background-size: 100%;
}

a:link, a:visited {
  text-align: center;
  text-decoration: none;
  color: #674B4B;
}

a:hover, a:active {
  color:lightSlateGray;
}

.div1 {
	font-size: 22px;
	margin-top: 100px;
	margin-bottom: 70px;
	margin-left:70px;
	margin-right:70px;
	text-align: center;
	font-family:;
}
</style>

</head>
<body>
	<nav class="navbar navbar-expand-md navbar-light bg-light fixed-top">
		<a class="navbar-brand" href="shop.html">MIT</a>
		<button class="navbar-toggler" type="button" data-toggle="collapse"
			data-target="#navbarsExampleDefault"
			aria-controls="navbarsExampleDefault" aria-expanded="false"
			aria-label="Toggle navigation">
			<span class="navbar-toggler-icon"></span>
		</button>

		<div class="collapse navbar-collapse" id="navbarsExampleDefault">
			<ul class="navbar-nav mr-auto">
				<li class="nav-item active"><a class="nav-link"
					href="shop.html">Home <span class="sr-only">(current)</span>
				</a></li>
				<!-- <li class="nav-item"><a class="nav-link" href="#">Link</a></li> -->
				<li class="nav-item dropdown"><a
					class="nav-link dropdown-toggle" href="#" id="dropdown01"
					data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">Menu</a>
					<div class="dropdown-menu" aria-labelledby="dropdown01">
						<a class="dropdown-item" href="listprod.jsp">List Products</a> <a
							class="dropdown-item" href="listorder.jsp">List Orders</a> <a
							class="dropdown-item" href="showcart.jsp">Show Cart</a>
					</div></li>
			</ul>
			<form class="form-inline my-2 my-lg-0" method="get"
				action="listprod.jsp">
				<input class="form-control mr-sm-2" type="text" placeholder="Search"
					aria-label="Search" name="productName">
				<button class="btn btn-secondary my-2 my-sm-0 white" type="submit">Search</button>
			</form>
		</div>
	</nav>

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

