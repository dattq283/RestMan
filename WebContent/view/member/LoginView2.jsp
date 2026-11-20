<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
    import="dao.MemberDAO2, model.Member2, model.Customer2, model.Manager2"%>
<%@ include file="../common/Format2.jspf" %>
<%-- Thuộc module Đăng nhập (ngoài 2 module được giao): chỉ để đưa khách hàng / quản lí vào session khi chạy thử.
     Đăng nhập gửi mật khẩu nên dùng POST; GET chỉ hiện form. --%>
<%
    request.setCharacterEncoding("UTF-8");
    String msg = null;
    String msgOkAction = null;
    String err = request.getParameter("err");
    if ("timeout".equals(err)) msg = "Phiên đăng nhập đã hết hạn!";

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        if (request.getParameter("subLogout") != null) {
            session.invalidate();
            response.sendRedirect("LoginView2.jsp");
            return;
        }
        String username = request.getParameter("inUsername");
        String password = request.getParameter("inPassword");
        Member2 member = (username == null || password == null) ? null : new MemberDAO2().checkLogin(username.trim(), password);
        if (member instanceof Customer2) {
            session.setAttribute("customer", member);
            response.sendRedirect("../customer/CustomerHomeView2.jsp");
            return;
        } else if (member instanceof Manager2) {
            session.setAttribute("manager", member);
            response.sendRedirect("../manager/ManagerHomeView2.jsp");
            return;
        } else if (member != null) {
            msg = "Chức năng của nhân viên bán hàng chưa được cài đặt trong bản này!";
        } else {
            msg = "Sai tên đăng nhập hoặc mật khẩu!";
        }
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Đăng nhập</title>
<%@ include file="../common/Header2.jspf" %>
</head>
<body>
<header class="top"><div class="wrap"><span class="brand">RestMan</span><span class="tagline">Hệ thống quản lý nhà hàng</span></div></header>
<main style="max-width:480px">
    <h1>Đăng nhập</h1>
    <form class="card" method="post" action="LoginView2.jsp" style="display:flex;flex-direction:column;gap:16px">
        <div class="field" style="margin-bottom: 4px"}><label for="inUsername">Tên đăng nhập</label><input id="inUsername" name="inUsername" type="text" maxlength="50" required></div>
        <div class="field"><label for="inPassword">Mật khẩu</label><input id="inPassword" name="inPassword" type="password" required></div>
        <button type="submit" name="subLogin" class="btn">Đăng nhập</button>
    </form>
</main>
<%@ include file="../common/Message2.jspf" %>
</body>
</html>
