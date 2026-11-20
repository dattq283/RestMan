<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
    import="dao.ComboItemDAO2, model.Customer2, model.Combo2, model.ComboItem2"%>
<%@ include file="../common/Format2.jspf" %>
<%
    Customer2 customer = (Customer2) session.getAttribute("customer");
    Combo2[] listCombo = (Combo2[]) session.getAttribute("listCombo");
    if (customer == null || listCombo == null) {
        response.sendRedirect("../member/LoginView2.jsp?err=timeout");
        return;
    }
    String userLabel = customer.getFullName() + " (" + customer.getCustomerCode() + ")";
    String msg = null;
    String msgOkAction = null;
    // combo đã chọn lấy từ danh sách kết quả đang giữ (thuộc tính ẩn combo : Combo2)
    Combo2 combo = null;
    String idParam = request.getParameter("id");
    for (Combo2 c : listCombo) {
        if (String.valueOf(c.getId()).equals(idParam)) combo = c;
    }
    if (combo == null) {
        response.sendRedirect("SearchMenuItemView2.jsp");
        return;
    }
    ComboItem2[] items = new ComboItemDAO2().getItemsOfCombo(combo.getId());
    if (items == null) {
        msg = "Không thể kết nối tới hệ thống, vui lòng thử lại sau!";
        items = new ComboItem2[0];
    }
    combo.setItems(items);
%>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Chi tiết combo</title>
<%@ include file="../common/Header2.jspf" %>
</head>
<body>
<%@ include file="../common/UserBar2.jspf" %>
<main>
    <h1>Chi tiết combo</h1>
    <section class="card">
        <dl class="info">
            <dt>Tên combo</dt><dd><strong><%= esc(combo.getName()) %></strong></dd>
            <dt>Giá</dt><dd class="total"><%= money(combo.getPrice()) %> VNĐ</dd>
            <dt>Mô tả</dt><dd><%= combo.getDescription() == null ? "---" : esc(combo.getDescription()) %></dd>
            <dt>Tình trạng</dt><dd><%= esc(combo.getStatus()) %></dd>
        </dl>
    </section>
    <section style="display:flex;flex-direction:column;gap:12px">
        <h2>Các món trong combo</h2>
        <div class="table-box">
            <table class="data">
                <thead><tr><th>TT</th><th>Mã món</th><th>Tên món</th><th class="num">Số lượng</th><th>Tình trạng</th><th class="center">Chi tiết</th></tr></thead>
                <tbody>
                <% for (int i = 0; i < combo.getItems().length; i++) { ComboItem2 ci = combo.getItems()[i]; %>
                    <tr><td><%= i + 1 %></td><td><%= esc(ci.getMenuItem().getItemCode()) %></td><td><%= esc(ci.getMenuItem().getName()) %></td><td class="num"><%= ci.getQuantity() %></td>
                        <% String st = ci.getMenuItem().getStatus(); // món ngừng bán lẻ vẫn phục vụ trong combo (quy tắc mục 10) %>
                        <td><span class="pill<%= "Tạm hết".equals(st) ? " warn" : "" %>"><%= "Ngừng kinh doanh".equals(st) ? "Chỉ phục vụ trong combo" : esc(st) %></span></td>
                        <td class="center">
                            <form class="inline" method="get" action="MenuItemDetailView2.jsp">
                                <input type="hidden" name="id" value="<%= ci.getMenuItem().getId() %>">
                                <input type="hidden" name="comboId" value="<%= combo.getId() %>">
                                <button type="submit" class="btn">Xem</button>
                            </form>
                        </td></tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </section>
    <form method="get" action="SearchMenuItemView2.jsp">
        <button type="submit" name="subBackToList" class="btn outline">Quay lại danh sách</button>
    </form>
</main>
<%@ include file="../common/Message2.jspf" %>
</body>
</html>
