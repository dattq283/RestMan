package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;

import model.Customer2;
import model.Employee2;
import model.Manager2;
import model.Member2;
import model.SalesStaff2;

/**
 * Thuộc module Đăng nhập (ngoài 2 module được giao), chỉ để có người dùng trong session khi chạy thử.
 */
public class MemberDAO2 extends DAO2 {

    public MemberDAO2() {
        super();
    }

    /**
     * Kiểm tra đăng nhập.
     * @return Customer2 / Manager2 / SalesStaff2 tuỳ vai trò, null nếu sai tài khoản hoặc lỗi CSDL
     */
    public Member2 checkLogin(String username, String password) {
        String sql = "SELECT m.*, c.customerCode, e.employeeCode, e.position "
                + "FROM tblMember2 m "
                + "LEFT JOIN tblCustomer2 c ON c.tblMember2id = m.id "
                + "LEFT JOIN tblEmployee2 e ON e.tblMember2id = m.id "
                + "WHERE m.username = ? AND m.password = ?";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            if (!rs.next()) {
                return null;
            }
            Member2 member;
            if (rs.getString("customerCode") != null) {
                Customer2 c = new Customer2();
                c.setCustomerCode(rs.getString("customerCode"));
                member = c;
            } else {
                String position = rs.getString("position");
                Employee2 e = "Quản lí".equals(position) ? new Manager2() : new SalesStaff2();
                e.setEmployeeCode(rs.getString("employeeCode"));
                e.setPosition(position);
                member = e;
            }
            member.setId(rs.getInt("id"));
            member.setUsername(rs.getString("username"));
            member.setFullName(rs.getString("fullName"));
            member.setPhoneNumber(rs.getString("phoneNumber"));
            member.setEmail(rs.getString("email"));
            return member;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}
