<%@ page import="java.util.HashMap"%>
<%@ page import="java.util.ArrayList"%>
<%
	// Get the current list of products 
	@SuppressWarnings({ "unchecked" })
	HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session
			.getAttribute("productList");

	// remove new product selected
	// Get product information
	String id = request.getParameter("id");
	String name = request.getParameter("name");
	String price = request.getParameter("price");
	String quantity = request.getParameter("qty"); // If qty > 1 qty--; else remove

	ArrayList<Object> product = new ArrayList<Object>();
	product.add(id);
	product.add(name);
	product.add(price);
	product.add(quantity);

	if (productList.containsKey(id)) {
		product = (ArrayList<Object>) productList.get(id);
		int curAmount = ((Integer) product.get(3)).intValue();

		if (quantity.equals("removeOne")) {
			product.set(3, new Integer(curAmount - 1));
			if (--curAmount == 0)
				quantity = "removeAll";
		} else if (quantity.equals("addOne")) {
			product.set(3, new Integer(curAmount + 1));
		}

		if (quantity.equals("removeAll"))
			productList.remove(id, product);
	}

	if (productList.isEmpty())
		session.setAttribute("productList", null);
	else
		session.setAttribute("productList", productList);
%>
<jsp:forward page="showcart.jsp" />