package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import model.ComboItem2;
import model.MenuItem2;

public class ComboItemDAO2 extends DAO2 {

    public ComboItemDAO2() {
        super();
    }

    /**
     * Lấy các món trong một combo.
     * @return mảng ComboItem2, null nếu lỗi CSDL
     */
    public ComboItem2[] getItemsOfCombo(int comboId) {
        String sql = "SELECT ci.id, ci.quantity, m.id AS menuItemId, m.itemCode, m.name, m.status "
                + "FROM tblComboItem2 ci JOIN tblMenuItem2 m ON ci.tblMenuItem2id = m.id "
                + "WHERE ci.tblCombo2id = ? ORDER BY m.itemCode";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, comboId);
            ResultSet rs = ps.executeQuery();
            ArrayList<ComboItem2> list = new ArrayList<ComboItem2>();
            while (rs.next()) {
                MenuItem2 m = new MenuItem2();
                m.setId(rs.getInt("menuItemId"));
                m.setItemCode(rs.getString("itemCode"));
                m.setName(rs.getString("name"));
                m.setStatus(rs.getString("status"));
                ComboItem2 ci = new ComboItem2();
                ci.setId(rs.getInt("id"));
                ci.setQuantity(rs.getInt("quantity"));
                ci.setMenuItem(m);
                list.add(ci);
            }
            return list.toArray(new ComboItem2[0]);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}
