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
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	// connection info
	String url = "jdbc:sqlserver://sql04.ok.ubc.ca:1433;DatabaseName=db_tvande;";
	String uid = "tvande";
	String pw = "33970138";

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	
		int id = 0;
		int result = 0;
		Connection con = null;
		String message = null;
		InputStream in = null;

		// id
		String idFromForm = request.getParameter("idForm");

		if (idFromForm != null) {
			// Parse the string from the form to an integer.
			try {
				id = Integer.parseInt(idFromForm);
			} catch (Exception e) {
				System.err.print("Could not convert product Id to integer.");
			}
			// Retrieve the file part 
			Part filePart = request.getPart("image");

			if (filePart != null) {
				// Get input stream for the file
				in = filePart.getInputStream();

				try {	
	
					// Make connection
					Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
					con = DriverManager.getConnection(url, uid, pw);

					// First verify the productId entered is for a valid product in the database.
					String SQL = "SELECT * FROM product WHERE productId =" + id;
					PreparedStatement pstmt = con.prepareStatement(SQL);
					ResultSet rst = pstmt.executeQuery();
					
					// If the resultSet returns a row the product exists in the relation
					if (rst.next()) {
						SQL = "UPDATE product SET productImage = ? WHERE productId = ? ";
						pstmt = con.prepareStatement(SQL);
						
						// The following sets the input stream as a blob 
						if (in != null)
							pstmt.setBlob(1, in);
						pstmt.setInt(2, id);
						result = pstmt.executeUpdate();

						// If result set returns 1 then success
						if (result > 0) {
							message = "<h1 align=\"center\">Image Succesfully Uploaded!</h1>";
						} else {
							message = "<h1 align=\"center\">Image Upload Error.</h1>";
						} 
						
					} else {
						message = "<h1 align=\"center\">Invalid Product Id!</h1>";
					}
				} catch (SQLException ex) {
					System.err.print(ex);
					message = "Error: " + ex.getMessage();
				}catch(Exception ex) {
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
					getServletContext().getRequestDispatcher("/Message.jsp").forward(request, response);
				}
			}
		}
	}
}
