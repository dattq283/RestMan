<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="model.Customer2"%>
<%@ include file="../common/Format2.jspf" %>
<%
    Customer2 customer = (Customer2) session.getAttribute("customer");
    if (customer == null) {
        response.sendRedirect("../member/LoginView2.jsp?err=timeout");
        return;
    }
    String userLabel = customer.getFullName() + " (" + customer.getCustomerCode() + ")";
%>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Trang chủ khách hàng</title>
<%@ include file="../common/Header2.jspf" %>
</head>
<body>
<%@ include file="../common/UserBar2.jspf" %>
<main>
    <h1>Xin chào, <%= esc(userLabel) %></h1>
    <div class="actions">
        <%-- subSearchMenuItem : submit, GET vì chỉ chuyển trang, không gửi dữ liệu thay đổi --%>
        <form class="inline" method="get" action="SearchMenuItemView2.jsp">
            <input type="hidden" name="new" value="1">
            <button type="submit" name="subSearchMenuItem" class="btn">Tìm món ăn</button>
        </form>
        <button type="button" name="subReserveTable" class="btn outline" disabled title="Thuộc module khác, chưa cài đặt">Đặt bàn trực tuyến</button>
        <button type="button" name="subOrderFoodOnline" class="btn outline" disabled title="Thuộc module khác, chưa cài đặt">Đặt món trực tuyến</button>
    </div>
</main>
</body>
</html>
