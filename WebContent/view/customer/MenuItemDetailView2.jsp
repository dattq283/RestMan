<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
    import="dao.MenuItemDAO2, model.Customer2, model.MenuItem2, model.Combo2"%>
<%@ include file="../common/Format2.jspf" %>
<%
    Customer2 customer = (Customer2) session.getAttribute("customer");
    if (customer == null) {                                   // ngoại lệ 7.2
        response.sendRedirect("../member/LoginView2.jsp?err=timeout");
        return;
    }
    String userLabel = customer.getFullName() + " (" + customer.getCustomerCode() + ")";
    String msg = null;
    String msgOkAction = null;
    MenuItem2 menuItem = null;
    try {
        // đọc lại món từ CSDL vì món có thể vừa bị ngừng kinh doanh (ngoại lệ 7.1)
        menuItem = new MenuItemDAO2().getMenuItemById(Integer.parseInt(request.getParameter("id")));
    } catch (NumberFormatException e) {
        menuItem = null;
    }
    // mở từ trang chi tiết combo: thuộc tính ẩn combo cho biết nút Quay lại về combo nào
    Combo2 combo = null;
    Combo2[] listCombo = (Combo2[]) session.getAttribute("listCombo");
    String comboIdParam = request.getParameter("comboId");
    if (comboIdParam != null && listCombo != null) {
        for (Combo2 c : listCombo) {
            if (String.valueOf(c.getId()).equals(comboIdParam)) combo = c;
        }
    }
    String backAction = combo == null ? "SearchMenuItemView2.jsp" : "ComboDetailView2.jsp";
    if (menuItem == null) {
        msg = "Món ăn này hiện không còn kinh doanh!";
        msgOkAction = combo == null ? "SearchMenuItemView2.jsp?reload=1" : "ComboDetailView2.jsp?id=" + combo.getId();
    } else if (combo == null && "Ngừng kinh doanh".equals(menuItem.getStatus())) { // ngoại lệ 7.1
        msg = "Món ăn này hiện không còn kinh doanh!";
        msgOkAction = "SearchMenuItemView2.jsp?reload=1";
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Chi tiết món ăn</title>
<%@ include file="../common/Header2.jspf" %>
</head>
<body>
<%@ include file="../common/UserBar2.jspf" %>
<main>
    <h1>Chi tiết món ăn</h1>
    <% if (msg == null) { %>
    <div class="row">
        <div style="flex:1 1 280px">
            <% if (menuItem.getImage() != null) { %>
            <img src="<%= request.getContextPath() %>/<%= esc(menuItem.getImage()) %>" alt="Ảnh món <%= esc(menuItem.getName()) %>" style="width:100%;border-radius:14px">
            <% } else { %>
            <div class="thumb" style="width:100%;height:220px;font-size:16px">Chưa có ảnh</div>
            <% } %>
        </div>
        <section class="card">
            <dl class="info">
                <dt>Mã món</dt><dd><%= esc(menuItem.getItemCode()) %></dd>
                <dt>Tên món</dt><dd><strong><%= esc(menuItem.getName()) %></strong></dd>
                <dt>Loại món</dt><dd><%= esc(menuItem.getCategory()) %></dd>
                <dt>Giá</dt><dd class="total"><%= money(menuItem.getPrice()) %> VNĐ/<%= esc(menuItem.getUnit()) %></dd>
                <dt>Khẩu phần</dt><dd><%= menuItem.getPortion() == null ? "---" : esc(menuItem.getPortion()) %></dd>
                <dt>Mô tả</dt><dd><%= menuItem.getDescription() == null ? "---" : esc(menuItem.getDescription()) %></dd>
                <dt>Tình trạng</dt><dd><%= "Tạm hết".equals(menuItem.getStatus()) ? "Tạm hết – vui lòng chọn món khác"
                        : "Ngừng kinh doanh".equals(menuItem.getStatus()) ? "Chỉ phục vụ trong combo " + esc(combo.getName())
                        : esc(menuItem.getStatus()) %></dd>
            </dl>
        </section>
    </div>
    <% } %>
    <form method="get" action="<%= backAction %>">
        <% if (combo != null) { %><input type="hidden" name="id" value="<%= combo.getId() %>"><% } %>
        <button type="submit" name="subBackToList" class="btn outline"><%= combo == null ? "Quay lại danh sách" : "Quay lại combo" %></button>
    </form>
</main>
<%@ include file="../common/Message2.jspf" %>
</body>
</html>
