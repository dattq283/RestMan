<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
    import="java.util.Date, dao.InvoiceDAO2, model.Manager2, model.CustomerStat2, model.Invoice2"%>
<%@ include file="../common/Format2.jspf" %>
<%
    Manager2 manager = (Manager2) session.getAttribute("manager");
    CustomerStat2 customerStat = (CustomerStat2) session.getAttribute("customerStat");
    Date startDate = (Date) session.getAttribute("startDate");
    Date endDate = (Date) session.getAttribute("endDate");
    if (manager == null || customerStat == null || startDate == null) {      // ngoại lệ 12.1
        response.sendRedirect("../member/LoginView2.jsp?err=timeout");
        return;
    }
    String userLabel = manager.getFullName() + " (" + manager.getEmployeeCode() + ") – " + manager.getPosition();
    String msg = null;
    String msgOkAction = null;
    Invoice2[] listInvoice = new InvoiceDAO2().getInvoicesOfCustomer(customerStat.getId(), startDate, endDate);
    if (listInvoice == null) {
        msg = "Không thể tải dữ liệu, vui lòng thử lại sau!";
        listInvoice = new Invoice2[0];
    }
    session.setAttribute("listInvoice", listInvoice);
%>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Các lần gọi món của khách hàng</title>
<%@ include file="../common/Header2.jspf" %>
</head>
<body>
<%@ include file="../common/UserBar2.jspf" %>
<main>
    <h1>Các lần gọi món</h1>
    <p style="margin:0">Khách hàng <strong><%= esc(customerStat.getFullName()) %> (<%= esc(customerStat.getCustomerCode()) %>)</strong> · từ <%= date(startDate) %> đến <%= date(endDate) %></p>
    <div class="table-box">
        <table class="data">
            <thead><tr><th>TT</th><th>Mã hoá đơn</th><th>Thời gian gọi</th><th>Bàn</th><th>Hình thức</th><th class="num">Tổng thanh toán (VNĐ)</th><th class="center">Chi tiết</th></tr></thead>
            <tbody>
            <% for (int i = 0; i < listInvoice.length; i++) { Invoice2 inv = listInvoice[i]; %>
                <tr>
                    <td><%= i + 1 %></td>
                    <td><strong><%= esc(inv.getInvoiceCode()) %></strong></td>
                    <td><%= dateTime(inv.getOrder().getOrderTime()) %></td>
                    <td><%= inv.getOrder().getTable() == null ? "---" : esc(inv.getOrder().getTable().getName()) %></td>
                    <td><%= esc(inv.getOrder().getOrderType()) %></td>
                    <td class="num"><strong><%= money(inv.getPaidAmount()) %></strong></td>
                    <td class="center">
                        <form class="inline" method="get" action="InvoiceDetailView2.jsp">
                            <input type="hidden" name="id" value="<%= inv.getId() %>">
                            <button type="submit" class="btn">Xem</button>
                        </form>
                    </td>
                </tr>
            <% } %>
            </tbody>
        </table>
    </div>
    <form method="get" action="CustomerDetailView2.jsp">
        <button type="submit" name="subBack" class="btn outline">Quay lại</button>
    </form>
</main>
<%@ include file="../common/Message2.jspf" %>
</body>
</html>
