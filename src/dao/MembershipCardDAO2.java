package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;

import model.MembershipCard2;

public class MembershipCardDAO2 extends DAO2 {

    public MembershipCardDAO2() {
        super();
    }

    /**
     * Lấy thẻ thành viên hiện tại của khách hàng.
     * @return thẻ, null nếu khách chưa đăng kí thẻ
     */
    public MembershipCard2 getCardOfCustomer(int customerId) {
        String sql = "SELECT * FROM tblMembershipCard2 WHERE tblCustomer2id = ?";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, customerId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                MembershipCard2 c = new MembershipCard2();
                c.setId(rs.getInt("id"));
                c.setCardCode(rs.getString("cardCode"));
                c.setIssueDate(rs.getDate("issueDate"));
                c.setRank(rs.getString("rank"));
                c.setPoint(rs.getInt("point"));
                c.setDiscountRate(rs.getFloat("discountRate"));
                return c;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
