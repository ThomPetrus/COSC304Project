import java.io.*;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

@WebServlet("/uploadServlet")
@MultipartConfig(maxFileSize = 16177215)
public class uploadServlet extends HttpServlet {
	//connection info
	private String url = "jdbc:sqlserver://sql04.ok.ubc.ca:1433;DatabaseName=db_tvande;";
	private String uid = "tvande";
	private String pw = "33970138";

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	
		int id = 0;
		int result = 0;
		Connection con = null;
		String message = null;
		InputStream in = null;

		// id
		String idFromForm = request.getParameter("idForm");

		if (idFromForm != null) {

			try {
				id = Integer.parseInt(idFromForm);
			} catch (Exception e) {
				System.err.print("Could not convert product Id to integer.");
			}

			Part filePart = request.getPart("image");

			if (filePart != null) {
				in = filePart.getInputStream();

				try {
					//Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
					con = DriverManager.getConnection(url, uid, pw);

					// First verify the productId entered is for a valid product in the database.
					String SQL = "SELECT * FROM product WHERE productId =" + id;
					PreparedStatement pstmt = con.prepareStatement(SQL);
					ResultSet rst = pstmt.executeQuery();
					if (rst.next()) {
						SQL = "UPDATE product SET productImage = ? WHERE productId = " + id + ";";
						pstmt = con.prepareStatement(SQL);
						if (in != null)
							pstmt.setBlob(1, in);
						result = pstmt.executeUpdate();

						if (result > 0) {
							message = "<h1 align=\"center\">Image Succesfully Uploaded!</h1>";
						} else {
							message = "<h1 align=\"center\">Invalid Product Id!</h1>";
						}
					}
				} catch (SQLException ex) {
					System.err.print(ex);
					message = "Error: " + ex.getMessage();
				} finally {
					if (con != null) {
						try {
							con.close();
						} catch (SQLException ex) {
							ex.printStackTrace();
						}
					}
					request.setAttribute("Message", message);
					getServletContext().getRequestDispatcher("/uploadMessage.jsp").forward(request, response);
				}
			}
		}
	}
}