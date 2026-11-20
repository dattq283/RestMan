<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
    import="java.util.Date, dao.MembershipCardDAO2, model.Manager2, model.CustomerStat2, model.MembershipCard2"%>
<%@ include file="../common/Format2.jspf" %>
<%
    Manager2 manager = (Manager2) session.getAttribute("manager");
    CustomerStat2[] listCustomerStat = (CustomerStat2[]) session.getAttribute("listCustomerStat");
    if (manager == null || listCustomerStat == null) {
        response.sendRedirect("../member/LoginView2.jsp?err=timeout");
        return;
    }
    String userLabel = manager.getFullName() + " (" + manager.getEmployeeCode() + ") – " + manager.getPosition();
    String msg = null;
    String msgOkAction = null;

    CustomerStat2 customerStat = (CustomerStat2) session.getAttribute("customerStat");
    String idParam = request.getParameter("id");
    if (idParam != null) { // vào từ bảng thống kê: lấy khách đã chọn trong danh sách đang giữ
        customerStat = null;
        for (CustomerStat2 cs : listCustomerStat) {
            if (String.valueOf(cs.getId()).equals(idParam)) customerStat = cs;
        }
        if (customerStat == null) {
            response.sendRedirect("CustomerRevenueStatView2.jsp");
            return;
        }
        session.setAttribute("customerStat", customerStat);
        session.setAttribute("card", new MembershipCardDAO2().getCardOfCustomer(customerStat.getId()));
    } else if (customerStat == null) {
        response.sendRedirect("CustomerRevenueStatView2.jsp");
        return;
    }
    MembershipCard2 card = (MembershipCard2) session.getAttribute("card");
    Date startDate = (Date) session.getAttribute("startDate");
    Date endDate = (Date) session.getAttribute("endDate");
    // khách gọi món trước rồi mới đăng kí thẻ: so ngày cấp thẻ với kỳ thống kê (chỉ so ngày, không tính tiền)
    boolean cardAfterPeriod = card != null && endDate != null && card.getIssueDate().after(endDate);
    boolean cardInPeriod = card != null && startDate != null && !cardAfterPeriod && card.getIssueDate().after(startDate);
%>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Chi tiết khách hàng</title>
<%@ include file="../common/Header2.jspf" %>
</head>
<body>
<%@ include file="../common/UserBar2.jspf" %>
<main>
    <h1>Chi tiết khách hàng</h1>
    <div class="row">
        <section class="card">
            <h2 style="margin-bottom:8px color: red">Khách hàng</h2>
            <dl class="info">
                <dt>Mã khách hàng</dt><dd><%= esc(customerStat.getCustomerCode()) %></dd>
                <dt>Họ tên</dt><dd><strong><%= esc(customerStat.getFullName()) %></strong></dd>
                <dt>Số điện thoại</dt><dd><%= esc(customerStat.getPhoneNumber()) %></dd>
                <dt>Email</dt><dd><%= customerStat.getEmail() == null ? "---" : esc(customerStat.getEmail()) %></dd>
                <dt>Số lần gọi trong kỳ</dt><dd><%= customerStat.getOrderCount() %></dd>
                <dt>Tổng doanh thu trong kỳ</dt><dd class="total"><%= money(customerStat.getTotalRevenue()) %> VNĐ</dd>
            </dl>
        </section>
        <section class="member-card">
            <h2>Thẻ thành viên</h2>
            <% if (card == null) { %>
            <p style="margin:0">Chưa đăng kí</p>
            <% } else if (cardAfterPeriod) { %>
            <p style="margin:0">Chưa đăng kí trong kỳ thống kê</p>
            <p style="margin:0">Thẻ <%= esc(card.getCardCode()) %> cấp ngày <%= date(card.getIssueDate()) %>, sau kỳ thống kê</p>
            <% } else { %>
            <p class="code" style="margin:0"><%= esc(card.getCardCode()) %></p>
            <p style="margin:0">Hạng <%= esc(card.getRank()) %> – giảm <%= money(card.getDiscountRate()) %>% hoá đơn</p>
            <p style="margin:0">Cấp ngày <%= date(card.getIssueDate()) %></p>
            <% if (cardInPeriod) { %>
            <p style="margin:0">Các hoá đơn trước ngày cấp thẻ không được giảm giá</p>
            <% } %>
            <% } %>
        </section>
    </div>
    <div class="actions">
        <form class="inline" method="get" action="CustomerOrderHistoryView2.jsp">
            <button type="submit" name="subViewOrderHistory" class="btn">Xem các lần gọi món</button>
        </form>
        <form class="inline" method="get" action="CustomerRevenueStatView2.jsp">
            <button type="submit" name="subBack" class="btn outline">Quay lại</button>
        </form>
    </div>
</main>
</body>
</html>
