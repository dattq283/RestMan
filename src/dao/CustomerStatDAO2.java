package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Date;

import model.CustomerStat2;

public class CustomerStatDAO2 extends DAO2 {

    // các hoá đơn có gắn khách hàng, thanh toán trong kỳ; paid = tiền món + tiền combo - giảm giá
    private static final String PAID_INVOICES = "(SELECT o.tblCustomer2id AS customerId, "
            + "        COALESCE(mi.s, 0) + COALESCE(cb.s, 0) - i.discountAmount AS paid "
            + "      FROM tblInvoice2 i "
            + "      JOIN tblOrder2 o ON i.tblOrder2id = o.id "
            + "      LEFT JOIN (SELECT tblOrder2id, SUM(quantity * price) AS s FROM tblOrderedMenuItem2 GROUP BY tblOrder2id) mi ON mi.tblOrder2id = o.id "
            + "      LEFT JOIN (SELECT tblOrder2id, SUM(quantity * price) AS s FROM tblOrderedCombo2 GROUP BY tblOrder2id) cb ON cb.tblOrder2id = o.id "
            + "      WHERE o.tblCustomer2id IS NOT NULL AND DATE(i.paymentTime) BETWEEN ? AND ?) t ";

    public CustomerStatDAO2() {
        super();
    }

    /**
     * Thống kê khách hàng theo doanh thu trong kỳ.
     * Chỉ tính hoá đơn có gắn khách hàng, theo ngày thanh toán (ngoại lệ 9.2, 9.6);
     * lần gọi chưa có hoá đơn thì chưa thanh toán nên không tính (9.3, 9.5).
     * Doanh thu một hoá đơn = tổng (số lượng x đơn giá) các dòng món + dòng combo - giảm giá.
     * Sắp xếp: doanh thu giảm dần, số lần gọi giảm dần, mã khách hàng tăng dần (9.7).
     * @return mảng CustomerStat2 (rỗng nếu không có), null nếu lỗi CSDL
     */
    public CustomerStat2[] getCustomerRevenueStat(Date startDate, Date endDate) {
        String sql = "SELECT m.id, m.fullName, m.phoneNumber, m.email, c.customerCode, "
                + "COUNT(*) AS orderCount, SUM(t.paid) AS totalRevenue "
                + "FROM " + PAID_INVOICES
                + "JOIN tblCustomer2 c ON c.tblMember2id = t.customerId "
                + "JOIN tblMember2 m ON m.id = c.tblMember2id "
                + "GROUP BY m.id, m.fullName, m.phoneNumber, m.email, c.customerCode "
                + "ORDER BY totalRevenue DESC, orderCount DESC, c.customerCode ASC";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setDate(1, new java.sql.Date(startDate.getTime()));
            ps.setDate(2, new java.sql.Date(endDate.getTime()));
            ResultSet rs = ps.executeQuery();
            ArrayList<CustomerStat2> list = new ArrayList<CustomerStat2>();
            while (rs.next()) {
                CustomerStat2 cs = new CustomerStat2();
                cs.setId(rs.getInt("id"));
                cs.setFullName(rs.getString("fullName"));
                cs.setPhoneNumber(rs.getString("phoneNumber"));
                cs.setEmail(rs.getString("email"));
                cs.setCustomerCode(rs.getString("customerCode"));
                cs.setOrderCount(rs.getInt("orderCount"));
                cs.setTotalRevenue(rs.getFloat("totalRevenue"));
                list.add(cs);
            }
            return list.toArray(new CustomerStat2[0]);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    /**
     * Dòng Tổng cộng của bảng thống kê: tổng số lần gọi, tổng doanh thu của mọi khách trong kỳ
     * (tính trên cả danh sách, không riêng trang đang xem - ngoại lệ 9.8.3).
     * Trả về CustomerStat2 chỉ có orderCount, totalRevenue; null nếu lỗi CSDL.
     */
    public CustomerStat2 getTotalRevenueStat(Date startDate, Date endDate) {
        String sql = "SELECT COUNT(*) AS orderCount, COALESCE(SUM(t.paid), 0) AS totalRevenue FROM " + PAID_INVOICES;
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setDate(1, new java.sql.Date(startDate.getTime()));
            ps.setDate(2, new java.sql.Date(endDate.getTime()));
            ResultSet rs = ps.executeQuery();
            CustomerStat2 total = new CustomerStat2();
            if (rs.next()) {
                total.setOrderCount(rs.getInt("orderCount"));
                total.setTotalRevenue(rs.getFloat("totalRevenue"));
            }
            return total;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}
