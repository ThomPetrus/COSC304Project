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
					href="index.jsp">Home <span class="sr-only">(current)</span>
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

