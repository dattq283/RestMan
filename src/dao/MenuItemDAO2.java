package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import model.MenuItem2;

public class MenuItemDAO2 extends DAO2 {

    public MenuItemDAO2() {
        super();
    }

    /**
     * Tìm các món ăn đang bán có tên chứa từ khoá (bỏ dấu cách hai đầu, không phân biệt hoa thường).
     * @return mảng món ăn (rỗng nếu không có), null nếu lỗi kết nối CSDL
     */
    public MenuItem2[] searchMenuItemByName(String keyword) {
        String sql = "SELECT * FROM tblMenuItem2 WHERE LOWER(name) LIKE ? AND status <> 'Ngừng kinh doanh' ORDER BY CASE WHEN status = 'còn món' THEN 1 WHEN status = 'tạm hết' THEN 2 ELSE 3 END, itemCode ASC; ";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, "%" + keyword.trim().toLowerCase() + "%");
            ResultSet rs = ps.executeQuery();
            ArrayList<MenuItem2> list = new ArrayList<MenuItem2>();
            while (rs.next()) {
                list.add(readMenuItem(rs));
            }
            return list.toArray(new MenuItem2[0]);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    /**
     * Đọc lại một món ăn theo id (ngoại lệ 7.1: món có thể vừa bị ngừng kinh doanh).
     * @return món ăn, null nếu không còn món hoặc lỗi CSDL
     */
    public MenuItem2 getMenuItemById(int id) {
        String sql = "SELECT * FROM tblMenuItem2 WHERE id = ?";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return readMenuItem(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    private MenuItem2 readMenuItem(ResultSet rs) throws Exception {
        MenuItem2 m = new MenuItem2();
        m.setId(rs.getInt("id"));
        m.setItemCode(rs.getString("itemCode"));
        m.setName(rs.getString("name"));
        m.setCategory(rs.getString("category"));
        m.setPrice(rs.getFloat("price"));
        m.setUnit(rs.getString("unit"));
        m.setPortion(rs.getString("portion"));
        m.setDescription(rs.getString("description"));
        m.setImage(rs.getString("image"));
        m.setStatus(rs.getString("status"));
        return m;
    }
}
