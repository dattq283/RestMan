package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import model.Combo2;
import model.OrderedCombo2;

public class OrderedComboDAO2 extends DAO2 {

    public OrderedComboDAO2() {
        super();
    }

    /**
     * Lấy các combo đã gọi của một lần gọi, đơn giá là giá lưu lúc gọi.
     * amount (thành tiền) tính bằng SQL, giao diện chỉ hiển thị.
     * @return mảng OrderedCombo2, null nếu lỗi CSDL
     */
    public OrderedCombo2[] getCombosOfOrder(int orderId) {
        String sql = "SELECT oc.id, oc.quantity, oc.price, oc.quantity * oc.price AS amount, "
                + "c.id AS comboId, c.name "
                + "FROM tblOrderedCombo2 oc JOIN tblCombo2 c ON oc.tblCombo2id = c.id "
                + "WHERE oc.tblOrder2id = ? ORDER BY oc.id";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            ArrayList<OrderedCombo2> list = new ArrayList<OrderedCombo2>();
            while (rs.next()) {
                Combo2 c = new Combo2();
                c.setId(rs.getInt("comboId"));
                c.setName(rs.getString("name"));
                OrderedCombo2 oc = new OrderedCombo2();
                oc.setId(rs.getInt("id"));
                oc.setQuantity(rs.getInt("quantity"));
                oc.setPrice(rs.getFloat("price"));
                oc.setAmount(rs.getFloat("amount"));
                oc.setCombo(c);
                list.add(oc);
            }
            return list.toArray(new OrderedCombo2[0]);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}
