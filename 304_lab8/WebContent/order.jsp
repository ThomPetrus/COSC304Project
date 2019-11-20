<%@page import="java.time.LocalTime"%>
<%@page import="java.util.Calendar"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.text.NumberFormat"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Map"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>Welcome to MIT Inc and Sons Ltd - Order Processing</title>
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

	<div class="div1">

		<%
			/*
				Bare bones done as per Lawrence Example.
					
				Ideas:
				Update orderSummary with all customer info
				aesthetics
				...
				
			*/
			NumberFormat currFormat = NumberFormat.getCurrencyInstance();

			// Get customer id
			String custId = request.getParameter("customerId");

			@SuppressWarnings({ "unchecked" })
			HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session
					.getAttribute("productList");

			// login info
			String url = "jdbc:sqlserver://sql04.ok.ubc.ca:1433;DatabaseName=db_tvande;";
			String uid = "tvande";
			String pw = "33970138";

			// Determine if valid customer id was entered
			// Determine if there are products in the shopping cart
			// If either are not true, display an error message
			boolean isValid = true;

			// Pre connection check whether customer id was numeric - redundant catch clauses - remove?
			try {
				Integer.parseInt(custId);
			} catch (NumberFormatException e) {
				isValid = false;
			} catch (NullPointerException e) {
				isValid = false;
			} catch (Exception e) {
				isValid = false;
			}

			// Pre connection check whether cart is empty. 
			if (productList != null && productList.isEmpty()) {
				out.print("<h1>Your Cart is Empty!</h1>");
			} else if (!isValid) {
				out.print("<h1>Invalid Customer Id</h1>");
				out.print("<p>Go back to the previous page and try again.</p>");
			} else {

				// Make connection
				try (Connection con = DriverManager.getConnection(url, uid, pw)) {

					//First query to check whether customerId is a listed customer
					String SQL = "SELECT customerId FROM customer WHERE customerId =" + custId;
					PreparedStatement pstmt = con.prepareStatement(SQL);
					ResultSet rst = pstmt.executeQuery();

					if (!rst.next()) {
						out.print("<h1>Invalid Customer Id</h1>");
						out.print("<p>Go back to the previous page and try again.</p>");
					} else {

						// header for now
						out.print("<h1>Order Summary</h1>");

						// Save order information to database
						// TODO: There must be a better way of retreiving date and time for orderDate		
						long millis = System.currentTimeMillis();
						String orderDate = new java.sql.Date(millis).toString() + " "
								+ (LocalTime.now()).toString().substring(0, 8);

						SQL = "SELECT address, city, state, postalCode, country FROM customer WHERE customerId = "
								+ custId;
						pstmt = con.prepareStatement(SQL);
						rst = pstmt.executeQuery();

						if (rst.next()) {
							String address = rst.getString(1);
							String city = rst.getString(2);
							String state = rst.getString(3);
							String pc = rst.getString(4);
							String country = rst.getString(5);

							// Query to update order into order summary on database
							SQL = "INSERT INTO ordersummary(orderDate, shiptoAddress, shiptoCity, shiptoState, shiptoPostalCode, shiptoCountry, customerId) "
									+ "VALUES ('" + orderDate + "', '" + address + "', '" + city + "', '" + state
									+ "', '" + pc + "', '" + country + "', " + custId + ");";
							pstmt = con.prepareStatement(SQL, Statement.RETURN_GENERATED_KEYS);
							pstmt.executeUpdate();

							// Use retrieval of auto-generated keys.
							// Insert each item into OrderProduct table using OrderId from previous INSERT.
							ResultSet keys = pstmt.getGeneratedKeys();
							keys.next();
							int orderId = keys.getInt(1);

							// Iterate through order print / add to OrderProduct  / retrieve total.	
							out.print(
									"<table align=\"center\" width=\"90%\"><tr><th>Product Id</th><th>Product Name</th><th>Quantity</th>");
							out.println("<th>Price</th><th>Subtotal</th></tr>");

							// Same code used in showcart to display order - used to add products to database
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
									out.println(
											"Invalid quantity for product: " + product.get(0) + " quantity: " + qty);
								}

								out.print("<td align=\"right\">" + currFormat.format(pr) + "</td>");
								out.print("<td align=\"right\">" + currFormat.format(pr * qty) + "</td></tr>");
								out.println("</tr>");

								SQL = "INSERT into OrderProduct(orderId, productId, quantity, price) VALUES (" + orderId
										+ ", " + product.get(0) + ", " + qty + ", " + pr + ");";

								pstmt = con.prepareStatement(SQL);
								pstmt.executeUpdate();

								// Update total - to be updated in OrderSummary after while loop.
								total += pr * qty;
							}

							// Update total amount for order record
							SQL = "UPDATE OrderSummary SET totalAmount = " + total + " WHERE orderId = " + orderId;
							pstmt = con.prepareStatement(SQL);
							pstmt.executeUpdate();

							// Print out order summary
							SQL = "SELECT firstName, LastName, address, city, state, postalcode, country FROM customer WHERE customerId = "
									+ custId;
							pstmt = con.prepareStatement(SQL);
							rst = pstmt.executeQuery();

							out.println("<tr><td colspan=\"4\" align=\"right\"><b>Order Total</b></td>"
									+ "<td align=\"right\">" + currFormat.format(total) + "</td></tr>");
							out.println("</table>");

							out.print("<h1>Order Completed. Will be shipped ASAP. We Swear. Dont sue.</h1>");
							out.print("<h1>Your order Reference number is: " + orderId + "</h1>");

							if (rst.next()) {
								out.print("<h1>Shipping to: " + rst.getString(1) + " " + rst.getString(2) + "</h1>");
								out.print("<h2>Address: " + rst.getString(3) + ", " + rst.getString(4) + ", "
										+ rst.getString(5) + ", " + rst.getString(6) + ", " + rst.getString(7)
										+ "</h2>");
							}

							// At this point order is succesfull - Clear cart.
							productList.clear();

						}
					}
				} catch (SQLException e) {
					System.err.println(e.getMessage());
				}
			}
		%>
	</div>
</BODY>
</HTML>

