<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="model.Manager2"%>
<%@ include file="../common/Format2.jspf" %>
<%-- Chọn loại thống kê bằng dropdown (select) + nút Chọn (submit). Chỉ chuyển trang nên dùng GET. --%>
<%
    Manager2 manager = (Manager2) session.getAttribute("manager");
    if (manager == null) {
        response.sendRedirect("../member/LoginView2.jsp?err=timeout");
        return;
    }
    String userLabel = manager.getFullName() + " (" + manager.getEmployeeCode() + ") – " + manager.getPosition();
    String msg = null;
    String msgOkAction = null;
    String type = request.getParameter("inStatisticsType");
    if (request.getParameter("subChoose") != null) {
        if ("customerRevenue".equals(type)) {
            response.sendRedirect("CustomerRevenueStatView2.jsp?new=1");
            return;
        } else if (type == null || type.isEmpty()) {
            msg = "Vui lòng chọn loại thống kê!";
        } else {
            msg = "Loại thống kê này thuộc module khác, chưa được cài đặt!";
        }
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Xem báo cáo</title>
<%@ include file="../common/Header2.jspf" %>
</head>
<body>
<%@ include file="../common/UserBar2.jspf" %>
<main>
    <h1>Xem báo cáo</h1>
    <div class="card">
        <form class="bar" method="get" action="SelectStatisticsView2.jsp">
            <div class="field" style="flex:1 1 360px">
                <label for="inStatisticsType">Loại thống kê</label>
                <select id="inStatisticsType" name="inStatisticsType">
                    <option value="">-- Chọn loại thống kê --</option>
                    <option value="menuItem">Thống kê món ăn</option>
                    <option value="ingredient">Thống kê nguyên liệu</option>
                    <option value="customerRevenue">Thống kê khách hàng theo doanh thu</option>
                    <option value="supplier">Thống kê nhà cung cấp</option>
                </select>
            </div>
            <button type="submit" name="subChoose" class="btn">Chọn</button>
        </form>
    </div>
    <form method="get" action="ManagerHomeView2.jsp">
        <button type="submit" name="subBack" class="btn outline">Quay lại</button>
    </form>
</main>
<%@ include file="../common/Message2.jspf" %>
</body>
</html>
