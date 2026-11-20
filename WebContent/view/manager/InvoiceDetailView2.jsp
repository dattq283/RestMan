<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
    import="dao.OrderedMenuItemDAO2, dao.OrderedComboDAO2, model.Manager2, model.Invoice2, model.OrderedMenuItem2, model.OrderedCombo2"%>
<%@ include file="../common/Format2.jspf" %>
<%--
  Hoá đơn gồm cả combo và món lẻ. Mọi số tiền (thành tiền từng dòng, tổng tiền hàng, tổng thanh toán)
  đều do DAO tính bằng SQL và đóng gói trong thực thể; trang này chỉ hiển thị.
--%>
<%
    Manager2 manager = (Manager2) session.getAttribute("manager");
    Invoice2[] listInvoice = (Invoice2[]) session.getAttribute("listInvoice");
    if (manager == null || listInvoice == null) {
        response.sendRedirect("../member/LoginView2.jsp?err=timeout");
        return;
    }
    String userLabel = manager.getFullName() + " (" + manager.getEmployeeCode() + ") – " + manager.getPosition();
    String msg = null;
    String msgOkAction = null;
    Invoice2 invoice = null;
    String idParam = request.getParameter("id");
    for (Invoice2 inv : listInvoice) {
        if (String.valueOf(inv.getId()).equals(idParam)) invoice = inv;
    }
    if (invoice == null) {
        response.sendRedirect("CustomerOrderHistoryView2.jsp");
        return;
    }
    int orderId = invoice.getOrder().getId();
    OrderedMenuItem2[] menuItems = new OrderedMenuItemDAO2().getMenuItemsOfOrder(orderId);
    OrderedCombo2[] combos = new OrderedComboDAO2().getCombosOfOrder(orderId);
    if (menuItems == null || combos == null) {
        msg = "Không thể tải dữ liệu, vui lòng thử lại sau!";
        menuItems = new OrderedMenuItem2[0];
        combos = new OrderedCombo2[0];
    }
    invoice.getOrder().setMenuItems(menuItems);
    invoice.getOrder().setCombos(combos);
    int tt = 0; // số thứ tự dòng
%>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Hoá đơn <%= esc(invoice.getInvoiceCode()) %></title>
<%@ include file="../common/Header2.jspf" %>
</head>
<body>
<%@ include file="../common/UserBar2.jspf" %>
<main>
    <h1>Hoá đơn <span style="color:var(--green)"><%= esc(invoice.getInvoiceCode()) %></span></h1>
    <section class="card">
        <dl class="info">
            <dt>Mã hoá đơn</dt><dd><strong><%= esc(invoice.getInvoiceCode()) %></strong></dd>
            <dt>Khách hàng</dt><dd><%= esc(invoice.getOrder().getCustomer().getFullName()) %> (<%= esc(invoice.getOrder().getCustomer().getCustomerCode()) %>)<%= invoice.getMembershipCard() == null ? "" : " – thẻ " + esc(invoice.getMembershipCard().getCardCode()) %></dd>
            <dt>Bàn</dt><dd><%= invoice.getOrder().getTable() == null ? "---" : esc(invoice.getOrder().getTable().getName()) + " (sức chứa " + invoice.getOrder().getTable().getCapacity() + " người)" %></dd>
            <dt>Hình thức</dt><dd><%= esc(invoice.getOrder().getOrderType()) %></dd>
            <dt>Thời gian gọi</dt><dd><%= dateTime(invoice.getOrder().getOrderTime()) %></dd>
            <dt>Thời gian thanh toán</dt><dd><%= dateTime(invoice.getPaymentTime()) %></dd>
            <dt>Nhân viên lập</dt><dd><%= esc(invoice.getSalesStaff().getFullName()) %> (<%= esc(invoice.getSalesStaff().getEmployeeCode()) %>)</dd>
            <dt>Phương thức thanh toán</dt><dd><%= esc(invoice.getPaymentMethod()) %></dd>
        </dl>
    </section>
    <section style="display:flex;flex-direction:column;gap:12px">
        <h2>Danh sách món, combo đã gọi</h2>
        <div class="table-box">
            <table class="data">
                <thead><tr><th>TT</th><th>Tên món / combo</th><th class="num">Đơn giá (VNĐ)</th><th class="num">Số lượng</th><th class="num">Thành tiền (VNĐ)</th></tr></thead>
                <tbody>
                <% for (OrderedCombo2 oc : invoice.getOrder().getCombos()) { %>
                    <tr><td><%= ++tt %></td><td><strong><%= esc(oc.getCombo().getName()) %></strong><span class="pill combo">Combo</span></td>
                        <td class="num"><%= money(oc.getPrice()) %></td><td class="num"><%= oc.getQuantity() %></td><td class="num"><strong><%= money(oc.getAmount()) %></strong></td></tr>
                <% } %>
                <% for (OrderedMenuItem2 om : invoice.getOrder().getMenuItems()) { %>
                    <tr><td><%= ++tt %></td><td><strong><%= esc(om.getMenuItem().getName()) %></strong></td>
                        <td class="num"><%= money(om.getPrice()) %></td><td class="num"><%= om.getQuantity() %></td><td class="num"><strong><%= money(om.getAmount()) %></strong></td></tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </section>
    <section class="card summary">
        <dl class="info">
            <dt>Tổng tiền hàng</dt><dd class="num"><%= money(invoice.getTotalAmount()) %> VNĐ</dd>
            <dt>Giảm giá thẻ thành viên<%= invoice.getMembershipCard() == null ? "" : " (" + money(invoice.getMembershipCard().getDiscountRate()) + "%)" %></dt><dd class="num">−<%= money(invoice.getDiscountAmount()) %> VNĐ</dd>
            <dt><strong>Tổng thanh toán</strong></dt><dd class="num total"><%= money(invoice.getPaidAmount()) %> VNĐ</dd>
        </dl>
    </section>
    <form method="get" action="CustomerOrderHistoryView2.jsp">
        <button type="submit" name="subBack" class="btn outline">Quay lại</button>
    </form>
</main>
<%@ include file="../common/Message2.jspf" %>
</body>
</html>
