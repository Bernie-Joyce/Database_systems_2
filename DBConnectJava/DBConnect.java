import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnect {

    // Path to the SQLite database file
    private static final String DB_URL = "jdbc:mysql://localhost:3306/Pokemon";
    private static final String USER = "root";
    private static final String PASS = "smiichyk";

    /**
     * Establishes and returns a connection to the SQLite database.
     *
     * @return Connection object if successful, null if connection fails
     */
    public static Connection connect() {
        try {
            // Attempt to establish a connection to the database
            return DriverManager.getConnection(DB_URL, USER, PASS);
        } catch (SQLException e) {
            // Print error message if connection fails
            System.out.println("Connection failed: " + e.getMessage());
            return null;
        }
    }
}
