package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Date;

import model.Customer2;
import model.Invoice2;
import model.MembershipCard2;
import model.Order2;
import model.SalesStaff2;
import model.Table2;

public class InvoiceDAO2 extends DAO2 {

    public InvoiceDAO2() {
        super();
    }

    /**
     * Lấy các hoá đơn của khách hàng thanh toán trong kỳ, kèm lần gọi (Order2), bàn,
     * nhân viên lập, thẻ đã dùng. totalAmount, paidAmount tính bằng SQL (không lưu CSDL).
     * @return mảng Invoice2 (rỗng nếu không có), null nếu lỗi CSDL
     */
    public Invoice2[] getInvoicesOfCustomer(int customerId, Date startDate, Date endDate) {
        String sql = "SELECT i.id, i.invoiceCode, i.paymentTime, i.discountAmount, i.paymentMethod, "
                + "  COALESCE(mi.s, 0) + COALESCE(cb.s, 0) AS totalAmount, "
                + "  COALESCE(mi.s, 0) + COALESCE(cb.s, 0) - i.discountAmount AS paidAmount, "
                + "  o.id AS orderId, o.orderTime, o.orderType, o.note, "
                + "  t.id AS tableId, t.name AS tableName, t.capacity, "
                + "  cm.id AS customerId, cm.fullName AS customerName, c.customerCode, "
                + "  sm.id AS staffId, sm.fullName AS staffName, e.employeeCode, e.position, "
                + "  mc.id AS cardId, mc.cardCode, mc.discountRate "
                + "FROM tblInvoice2 i "
                + "JOIN tblOrder2 o ON i.tblOrder2id = o.id "
                + "JOIN tblCustomer2 c ON o.tblCustomer2id = c.tblMember2id "
                + "JOIN tblMember2 cm ON cm.id = c.tblMember2id "
                + "JOIN tblEmployee2 e ON i.tblEmployee2id = e.tblMember2id "
                + "JOIN tblMember2 sm ON sm.id = e.tblMember2id "
                + "LEFT JOIN tblTable2 t ON o.tblTable2id = t.id "
                + "LEFT JOIN tblMembershipCard2 mc ON i.tblMembershipCard2id = mc.id "
                + "LEFT JOIN (SELECT tblOrder2id, SUM(quantity * price) AS s FROM tblOrderedMenuItem2 GROUP BY tblOrder2id) mi ON mi.tblOrder2id = o.id "
                + "LEFT JOIN (SELECT tblOrder2id, SUM(quantity * price) AS s FROM tblOrderedCombo2 GROUP BY tblOrder2id) cb ON cb.tblOrder2id = o.id "
                + "WHERE o.tblCustomer2id = ? AND DATE(i.paymentTime) BETWEEN ? AND ? "
                + "ORDER BY i.paymentTime";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, customerId);
            ps.setDate(2, new java.sql.Date(startDate.getTime()));
            ps.setDate(3, new java.sql.Date(endDate.getTime()));
            ResultSet rs = ps.executeQuery();
            ArrayList<Invoice2> list = new ArrayList<Invoice2>();
            while (rs.next()) {
                Customer2 customer = new Customer2();
                customer.setId(rs.getInt("customerId"));
                customer.setFullName(rs.getString("customerName"));
                customer.setCustomerCode(rs.getString("customerCode"));

                Table2 table = null;
                if (rs.getObject("tableId") != null) { // đặt món trực tuyến thì không có bàn
                    table = new Table2();
                    table.setId(rs.getInt("tableId"));
                    table.setName(rs.getString("tableName"));
                    table.setCapacity(rs.getInt("capacity"));
                }

                Order2 order = new Order2();
                order.setId(rs.getInt("orderId"));
                order.setOrderTime(rs.getTimestamp("orderTime"));
                order.setOrderType(rs.getString("orderType"));
                order.setNote(rs.getString("note"));
                order.setCustomer(customer);
                order.setTable(table);

                SalesStaff2 staff = new SalesStaff2();
                staff.setId(rs.getInt("staffId"));
                staff.setFullName(rs.getString("staffName"));
                staff.setEmployeeCode(rs.getString("employeeCode"));
                staff.setPosition(rs.getString("position"));

                MembershipCard2 card = null;
                if (rs.getObject("cardId") != null) { // khách không dùng thẻ khi thanh toán
                    card = new MembershipCard2();
                    card.setId(rs.getInt("cardId"));
                    card.setCardCode(rs.getString("cardCode"));
                    card.setDiscountRate(rs.getFloat("discountRate"));
                    card.setCustomer(customer);
                }

                Invoice2 inv = new Invoice2();
                inv.setId(rs.getInt("id"));
                inv.setInvoiceCode(rs.getString("invoiceCode"));
                inv.setPaymentTime(rs.getTimestamp("paymentTime"));
                inv.setTotalAmount(rs.getFloat("totalAmount"));
                inv.setDiscountAmount(rs.getFloat("discountAmount"));
                inv.setPaidAmount(rs.getFloat("paidAmount"));
                inv.setPaymentMethod(rs.getString("paymentMethod"));
                inv.setOrder(order);
                inv.setSalesStaff(staff);
                inv.setMembershipCard(card);
                list.add(inv);
            }
            return list.toArray(new Invoice2[0]);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}
