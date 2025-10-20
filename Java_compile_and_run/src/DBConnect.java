import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnect {

// Change database name in the url to whatever it's named is in MySQL
    private static final String DB_URL = "jdbc:mysql://127.0.0.1:3306/pokemon";

    // User root by default has no password, change user and password as needed
    private static final String USER = "root";
    private static final String PASSWORD = "";

    public static Connection connect() {
        Connection conn = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(DB_URL, USER, PASSWORD);
        } catch (ClassNotFoundException e) {
            System.out.println("MySQL JDBC driver not found. Make sure the .jar file is added to project dependencies.");
        } catch (SQLException e) {
            System.out.println("Connection failed: " + e.getMessage());
        }
        return conn;
    }
}
