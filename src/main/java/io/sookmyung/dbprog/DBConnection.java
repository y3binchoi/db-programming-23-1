package io.sookmyung.dbprog;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    private static final String DB_DRIVER = "oracle.jdbc.driver.OracleDriver";
    private static final String DB_URL = "jdbc:oracle:thin:@localhost:1521:XE";
    private static final String DB_USERNAME = "user2023";
    private static final String DB_PASSWORD = "pwd2023";

    public static Connection getConnection() throws SQLException, ClassNotFoundException {

        Class.forName(DB_DRIVER);
        Connection conn = DriverManager.getConnection(DB_URL, DB_USERNAME, DB_PASSWORD);

        return conn;
    }
}
