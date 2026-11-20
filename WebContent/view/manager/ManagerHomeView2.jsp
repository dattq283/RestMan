<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="model.Manager2"%>
<%@ include file="../common/Format2.jspf" %>
<%
    Manager2 manager = (Manager2) session.getAttribute("manager");
    if (manager == null) {
        response.sendRedirect("../member/LoginView2.jsp?err=timeout");
        return;
    }
    String userLabel = manager.getFullName() + " (" + manager.getEmployeeCode() + ") – " + manager.getPosition();
%>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Trang chủ quản lí</title>
<%@ include file="../common/Header2.jspf" %>
</head>
<body>
<%@ include file="../common/UserBar2.jspf" %>
<main>
    <h1>Xin chào, <%= esc(userLabel) %></h1>
    <div class="actions">
        <form class="inline" method="get" action="SelectStatisticsView2.jsp">
            <button type="submit" name="subViewReport" class="btn">Xem báo cáo</button>
        </form>
        <button type="button" name="subManageMenuItem" class="btn outline" disabled title="Thuộc module khác, chưa cài đặt">Quản lí món ăn</button>
        <button type="button" name="subCreateComboMenu" class="btn outline" disabled title="Thuộc module khác, chưa cài đặt">Lên menu combo</button>
    </div>
</main>
</body>
</html>
