package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import model.Combo2;

public class ComboDAO2 extends DAO2 {

    public ComboDAO2() {
        super();
    }

    /**
     * Tìm các combo đang bán có tên chứa từ khoá.
     * @return mảng combo (rỗng nếu không có), null nếu lỗi kết nối CSDL
     */
    public Combo2[] searchComboByName(String keyword) {
        // combo đang "Còn món" nhưng có món thành phần "Tạm hết" thì trả về "Tạm hết" (không gọi được đủ combo)
        String sql = "SELECT c.*, CASE WHEN c.status = 'Còn món' AND EXISTS ("
                + "  SELECT 1 FROM tblComboItem2 ci JOIN tblMenuItem2 m ON m.id = ci.tblMenuItem2id"
                + "  WHERE ci.tblCombo2id = c.id AND m.status = 'Tạm hết') THEN 'Tạm hết' ELSE c.status END AS shownStatus "
                + "FROM tblCombo2 c WHERE LOWER(c.name) LIKE ? AND c.status <> 'Ngừng kinh doanh' ORDER BY c.name";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, "%" + keyword.trim().toLowerCase() + "%");
            ResultSet rs = ps.executeQuery();
            ArrayList<Combo2> list = new ArrayList<Combo2>();
            while (rs.next()) {
                Combo2 c = new Combo2();
                c.setId(rs.getInt("id"));
                c.setName(rs.getString("name"));
                c.setPrice(rs.getFloat("price"));
                c.setDescription(rs.getString("description"));
                c.setStatus(rs.getString("shownStatus"));
                list.add(c);
            }
            return list.toArray(new Combo2[0]);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}
