<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
    import="dao.MenuItemDAO2, dao.ComboDAO2, model.Customer2, model.MenuItem2, model.Combo2"%>
<%@ include file="../common/Format2.jspf" %>
<%--
  Tìm kiếm món ăn. Mọi thao tác ở trang này chỉ ĐỌC dữ liệu nên form dùng method="get"
  (tìm kiếm, chuyển trang có thể tải lại / quay lại an toàn). Không có thao tác ghi nên không cần POST.
  Thuộc tính ẩn (listMenuItem, listCombo, page, customer) giữ trong session để quay lại vẫn giữ kết quả cũ.
--%>
<%
    request.setCharacterEncoding("UTF-8");
    Customer2 customer = (Customer2) session.getAttribute("customer");
    if (customer == null) {
        response.sendRedirect("../member/LoginView2.jsp?err=timeout");
        return;
    }
    String userLabel = customer.getFullName() + " (" + customer.getCustomerCode() + ")";
    final int PAGE_SIZE = 10;
    String msg = null;
    String msgOkAction = null;

    if (request.getParameter("new") != null) { // vào từ trang chủ: xoá kết quả cũ, ô từ khoá trống
        session.removeAttribute("keyword");
        session.removeAttribute("listMenuItem");
        session.removeAttribute("listCombo");
        session.removeAttribute("page");
        session.removeAttribute("searchType");
    }
    String keyword = (String) session.getAttribute("keyword");
    String inKeyword = keyword == null ? "" : keyword;
    String searchKeyword = null;
    String searchType = session.getAttribute("searchType") == null ? "all" : (String) session.getAttribute("searchType");

    if (request.getParameter("subSearch") != null) {
        String type = request.getParameter("subSearch"); // giá trị của nút được bấm: all / item / combo
        if ("item".equals(type) || "combo".equals(type)) searchType = type; else searchType = "all";
        String raw = request.getParameter("inKeyword");
        inKeyword = raw == null ? "" : raw;
        String k = inKeyword.trim();
        if (k.isEmpty()) {                                   // để trống: liệt kê tất cả theo loại đang chọn
            searchKeyword = "";
            inKeyword = "";
        } else if (k.length() > 50) {                        // ngoại lệ 4.3
            msg = "Tên món ăn không được dài quá 50 ký tự!";
        } else if (!k.matches("[\\p{L}\\p{M}\\p{N} ]+")) {   // ngoại lệ 4.2
            msg = "Tên món ăn không được chứa ký tự đặc biệt!";
        } else {
            searchKeyword = k;
        }
    } else if (request.getParameter("reload") != null && keyword != null) { // ngoại lệ 7.1: tải lại kết quả
        searchKeyword = keyword;
    } else if (keyword == null) { // mới vào trang (từ trang chủ): hiện ngay toàn bộ thực đơn, loại Tất cả
        searchKeyword = "";
    }

    if (searchKeyword != null) {
        // bộ lọc: chỉ gọi DAO của loại được chọn, loại còn lại là danh sách rỗng
        MenuItem2[] foundItems = "combo".equals(searchType) ? new MenuItem2[0] : new MenuItemDAO2().searchMenuItemByName(searchKeyword);
        Combo2[] foundCombos = "item".equals(searchType) ? new Combo2[0] : new ComboDAO2().searchComboByName(searchKeyword);
        if (foundItems == null || foundCombos == null) {     // ngoại lệ 5.2
            msg = "Không thể kết nối tới hệ thống, vui lòng thử lại sau!";
        } else {
            session.setAttribute("keyword", searchKeyword);
            session.setAttribute("searchType", searchType);
            session.setAttribute("listMenuItem", foundItems);
            session.setAttribute("listCombo", foundCombos);
            session.setAttribute("page", 1);
            if (foundItems.length + foundCombos.length == 0) { // ngoại lệ 6.1
                msg = "Không tìm thấy " + ("combo".equals(searchType) ? "combo" : "món ăn") + " nào có tên chứa '" + searchKeyword + "'";
            }
        }
    }

    MenuItem2[] listMenuItem = (MenuItem2[]) session.getAttribute("listMenuItem");
    Combo2[] listCombo = (Combo2[]) session.getAttribute("listCombo");
    int nItem = listMenuItem == null ? 0 : listMenuItem.length;
    int nCombo = listCombo == null ? 0 : listCombo.length;
    int nRow = nItem + nCombo;
    int pageCount = Math.max(1, (nRow + PAGE_SIZE - 1) / PAGE_SIZE);
    int pageNo = session.getAttribute("page") == null ? 1 : (Integer) session.getAttribute("page");
    if (request.getParameter("subPrevPage") != null && pageNo > 1) pageNo--;
    if (request.getParameter("subNextPage") != null && pageNo < pageCount) pageNo++;
    session.setAttribute("page", pageNo);
    String shownKeyword = (String) session.getAttribute("keyword");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Tìm kiếm món ăn</title>
<%@ include file="../common/Header2.jspf" %>
</head>
<body>
<%@ include file="../common/UserBar2.jspf" %>
<main>
    <h1>Tìm kiếm món ăn</h1>
    <div class="card">
        <form class="bar" method="get" action="SearchMenuItemView2.jsp">
            <div class="field" style="flex:1 1 320px">
                <label for="inKeyword">Tên món ăn</label>
                <input id="inKeyword" name="inKeyword" type="text" maxlength="50" value="<%= esc(inKeyword) %>" placeholder="Nhập tên món ăn cần tìm">
            </div>
            <button type="submit" name="subSearch" value="<%= searchType %>" class="btn">Tìm kiếm</button>
            <div class="field" style="flex-basis:100%">
                <span style="font-size:15px;font-weight:600">Lọc theo loại</span>
                <div style="display:flex;gap:8px;flex-wrap:wrap">
                    <% String[][] types = {{"all", "Tất cả"}, {"item", "Món ăn"}, {"combo", "Combo"}};
                       for (String[] tp : types) { boolean on = tp[0].equals(searchType); %>
                    <button type="submit" name="subSearch" value="<%= tp[0] %>" class="btn<%= on ? "" : " outline" %>" aria-pressed="<%= on %>"><%= tp[1] %></button>
                    <% } %>
                </div>
            </div>
        </form>
    </div>

    <% if (shownKeyword != null && nRow > 0) { %>
    <section style="display:flex;flex-direction:column;gap:12px">
        <div class="table-box">
            <table class="data">
                <thead><tr><th>TT</th><th>Tên món / combo</th><th>Hình ảnh</th><th class="num">Giá (VNĐ)</th><th>Tình trạng</th><th class="center">Chi tiết</th></tr></thead>
                <tbody>
                <% for (int i = (pageNo - 1) * PAGE_SIZE; i < Math.min(pageNo * PAGE_SIZE, nRow); i++) {
                       if (i < nCombo) { // combo đặt trước vì số combo ít, không bị dồn xuống trang cuối
                           Combo2 c = listCombo[i]; %>
                    <tr>
                        <td><%= i + 1 %></td>
                        <td><strong><%= esc(c.getName()) %></strong><span class="pill combo">Combo</span></td>
                        <td><div class="thumb">Combo</div></td>
                        <td class="num"><%= money(c.getPrice()) %></td>
                        <td><span class="pill<%= "Tạm hết".equals(c.getStatus()) ? " warn" : "" %>"><%= esc(c.getStatus()) %></span></td>
                        <td class="center">
                            <form class="inline" method="get" action="ComboDetailView2.jsp">
                                <input type="hidden" name="id" value="<%= c.getId() %>">
                                <button type="submit" class="btn">Xem</button>
                            </form>
                        </td>
                    </tr>
                <%     } else {
                           MenuItem2 m = listMenuItem[i - nCombo]; %>
                    <tr>
                        <td><%= i + 1 %></td>
                        <td><strong><%= esc(m.getName()) %></strong></td>
                        <td><% if (m.getImage() != null) { %><img class="thumb" src="<%= request.getContextPath() %>/<%= esc(m.getImage()) %>" alt="Ảnh món <%= esc(m.getName()) %>"><% } else { %><div class="thumb">Chưa có ảnh</div><% } %></td>
                        <td class="num"><%= money(m.getPrice()) %></td>
                        <td><span class="pill<%= "Tạm hết".equals(m.getStatus()) ? " warn" : "" %>"><%= esc(m.getStatus()) %></span></td>
                        <td class="center">
                            <form class="inline" method="get" action="MenuItemDetailView2.jsp">
                                <input type="hidden" name="id" value="<%= m.getId() %>">
                                <button type="submit" class="btn">Xem</button>
                            </form>
                        </td>
                    </tr>
                <%     }
                   } %>
                </tbody>
            </table>
        </div>
        <form class="pager" method="get" action="SearchMenuItemView2.jsp">
            <span>Trang <%= pageNo %>/<%= pageCount %></span>
            <button type="submit" name="subPrevPage" class="btn outline" <%= pageNo <= 1 ? "disabled" : "" %>>Trang trước</button>
            <button type="submit" name="subNextPage" class="btn outline" <%= pageNo >= pageCount ? "disabled" : "" %>>Trang sau</button>
        </form>
    </section>
    <% } %>

    <form method="get" action="CustomerHomeView2.jsp">
        <button type="submit" name="subBack" class="btn outline">Quay lại</button>
    </form>
</main>
<%@ include file="../common/Message2.jspf" %>
</body>
</html>
