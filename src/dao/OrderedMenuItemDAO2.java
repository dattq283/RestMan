package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import model.MenuItem2;
import model.OrderedMenuItem2;

public class OrderedMenuItemDAO2 extends DAO2 {

    public OrderedMenuItemDAO2() {
        super();
    }

    /**
     * Lấy các món lẻ đã gọi của một lần gọi, đơn giá là giá lưu lúc gọi (ngoại lệ 15.2).
     * amount (thành tiền) tính bằng SQL, giao diện chỉ hiển thị.
     * @return mảng OrderedMenuItem2, null nếu lỗi CSDL
     */
    public OrderedMenuItem2[] getMenuItemsOfOrder(int orderId) {
        String sql = "SELECT om.id, om.quantity, om.price, om.note, om.quantity * om.price AS amount, "
                + "m.id AS menuItemId, m.itemCode, m.name, m.unit "
                + "FROM tblOrderedMenuItem2 om JOIN tblMenuItem2 m ON om.tblMenuItem2id = m.id "
                + "WHERE om.tblOrder2id = ? ORDER BY om.id";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            ArrayList<OrderedMenuItem2> list = new ArrayList<OrderedMenuItem2>();
            while (rs.next()) {
                MenuItem2 m = new MenuItem2();
                m.setId(rs.getInt("menuItemId"));
                m.setItemCode(rs.getString("itemCode"));
                m.setName(rs.getString("name"));
                m.setUnit(rs.getString("unit"));
                OrderedMenuItem2 om = new OrderedMenuItem2();
                om.setId(rs.getInt("id"));
                om.setQuantity(rs.getInt("quantity"));
                om.setPrice(rs.getFloat("price"));
                om.setNote(rs.getString("note"));
                om.setAmount(rs.getFloat("amount"));
                om.setMenuItem(m);
                list.add(om);
            }
            return list.toArray(new OrderedMenuItem2[0]);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}
