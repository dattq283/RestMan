package dao;

import java.sql.Connection;
import java.sql.DriverManager;

/**
 * Lớp cha của mọi lớp DAO: giữ một kết nối CSDL dùng chung cho toàn hệ thống.
 */
public class DAO2 {
    // protected (không phải private) để các lớp DAO con dùng được kết nối
    protected static Connection con;

    private static final String DB_URL = "jdbc:mysql://localhost:3306/restman2?useUnicode=true&characterEncoding=UTF-8&allowPublicKeyRetrieval=true";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "your_password"; // sửa theo MySQL trên máy bạn
    private static final String DB_CLASS = "com.mysql.cj.jdbc.Driver";

    public DAO2() {
        try {
            if (con == null || !con.isValid(2)) {
                Class.forName(DB_CLASS);
                con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            }
        } catch (Exception e) {
            e.printStackTrace();
            con = null;
        }
    }
}
