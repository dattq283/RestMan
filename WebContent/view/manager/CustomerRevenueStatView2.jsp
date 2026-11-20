<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
    import="java.util.Date, java.text.SimpleDateFormat, dao.CustomerStatDAO2, model.Manager2, model.CustomerStat2"%>
<%@ include file="../common/Format2.jspf" %>
<%--
  Thống kê khách hàng theo doanh thu. Ô ngày là ô chọn ngày thật (input type="date", bấm vào mở lịch).
  Chỉ đọc dữ liệu nên dùng GET. Giao diện chỉ kiểm tra hợp lệ ngày; số lần gọi, doanh thu, dòng Tổng cộng do
  CustomerStatDAO2 tính bằng SQL, giao diện không cộng trừ nhân chia tiền.
--%>
<%
    request.setCharacterEncoding("UTF-8");
    Manager2 manager = (Manager2) session.getAttribute("manager");
    if (manager == null) {
        response.sendRedirect("../member/LoginView2.jsp?err=timeout");
        return;
    }
    String userLabel = manager.getFullName() + " (" + manager.getEmployeeCode() + ") – " + manager.getPosition();
    final int PAGE_SIZE = 10;
    String msg = null;
    String msgOkAction = null;
    SimpleDateFormat iso = new SimpleDateFormat("yyyy-MM-dd");   // giá trị của input type="date"
    iso.setLenient(false);                                      // 31/02 là ngày không tồn tại

    if (request.getParameter("new") != null) {
        session.removeAttribute("listCustomerStat");
        session.removeAttribute("totalStat");
        session.removeAttribute("startDate");
        session.removeAttribute("endDate");
        session.removeAttribute("statPage");
    }
    Date startDate = (Date) session.getAttribute("startDate");
    Date endDate = (Date) session.getAttribute("endDate");
    String inStartDate = startDate == null ? "" : iso.format(startDate);
    String inEndDate = endDate == null ? "" : iso.format(endDate);

    if (request.getParameter("subStatistic") != null) {
        inStartDate = request.getParameter("inStartDate") == null ? "" : request.getParameter("inStartDate").trim();
        inEndDate = request.getParameter("inEndDate") == null ? "" : request.getParameter("inEndDate").trim();
        Date today = java.sql.Date.valueOf(java.time.LocalDate.now()); // 00:00 hôm nay
        Date s = null, e = null;
        if (inStartDate.isEmpty()) {
            msg = "Vui lòng chọn ngày bắt đầu!";                                  // 6.1
        } else if (!inStartDate.matches("\\d{4}-\\d{2}-\\d{2}")) {
            msg = "Ngày phải theo định dạng dd/mm/yyyy!"; inStartDate = "";        // 6.3
        } else {
            try { s = iso.parse(inStartDate); } catch (Exception ex) { msg = "Ngày bắt đầu không hợp lệ!"; inStartDate = ""; } // 6.2
            if (s != null && s.after(today)) { msg = "Ngày bắt đầu không được sau ngày hiện tại!"; inStartDate = ""; s = null; } // 6.4
        }
        if (msg == null) {
            if (inEndDate.isEmpty()) {
                msg = "Vui lòng chọn ngày kết thúc!";                             // 7.1
            } else if (!inEndDate.matches("\\d{4}-\\d{2}-\\d{2}")) {
                msg = "Ngày phải theo định dạng dd/mm/yyyy!"; inEndDate = "";
            } else {
                try { e = iso.parse(inEndDate); } catch (Exception ex) { msg = "Ngày kết thúc không hợp lệ!"; inEndDate = ""; }
                if (e != null && e.before(s)) { msg = "Ngày kết thúc không được trước ngày bắt đầu!"; inEndDate = ""; } // 7.2
                else if (e != null && e.after(today)) { msg = "Ngày kết thúc không được sau ngày hiện tại (" + date(today) + ")!"; inEndDate = ""; } // 7.3
            }
        }
        if (msg == null) {
            CustomerStatDAO2 statDAO = new CustomerStatDAO2();
            CustomerStat2[] result = statDAO.getCustomerRevenueStat(s, e);
            CustomerStat2 total = result == null ? null : statDAO.getTotalRevenueStat(s, e);
            if (result == null || total == null) {
                msg = "Không thể tải dữ liệu thống kê, vui lòng thử lại sau!";      // 8.1
            } else {
                session.setAttribute("listCustomerStat", result);
                session.setAttribute("totalStat", total);
                session.setAttribute("startDate", s);
                session.setAttribute("endDate", e);
                session.setAttribute("statPage", 1);
                if (result.length == 0) msg = "Không có khách hàng nào phát sinh doanh thu trong khoảng thời gian đã chọn!"; // 9.1
            }
        }
    }

    CustomerStat2[] listCustomerStat = (CustomerStat2[]) session.getAttribute("listCustomerStat");
    CustomerStat2 totalStat = (CustomerStat2) session.getAttribute("totalStat");
    startDate = (Date) session.getAttribute("startDate");
    endDate = (Date) session.getAttribute("endDate");
    int nRow = listCustomerStat == null ? 0 : listCustomerStat.length;
    int pageCount = Math.max(1, (nRow + PAGE_SIZE - 1) / PAGE_SIZE);
    int pageNo = session.getAttribute("statPage") == null ? 1 : (Integer) session.getAttribute("statPage");
    if (request.getParameter("subPrevPage") != null && pageNo > 1) pageNo--;
    if (request.getParameter("subNextPage") != null && pageNo < pageCount) pageNo++;
    session.setAttribute("statPage", pageNo);
%>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Thống kê khách hàng theo doanh thu</title>
<%@ include file="../common/Header2.jspf" %>
</head>
<body>
<%@ include file="../common/UserBar2.jspf" %>
<main>
    <h1>Thống kê khách hàng theo doanh thu</h1>
    <div class="card">
        <form class="bar" method="get" action="CustomerRevenueStatView2.jsp">
            <div class="field"><label for="inStartDate">Ngày bắt đầu</label>
                <input id="inStartDate" name="inStartDate" type="date" value="<%= esc(inStartDate) %>"></div>
            <div class="field"><label for="inEndDate">Ngày kết thúc</label>
                <input id="inEndDate" name="inEndDate" type="date" value="<%= esc(inEndDate) %>"></div>
            <button type="submit" name="subStatistic" class="btn">Thống kê</button>
        </form>
    </div>

    <% if (nRow > 0) { %>
    <section style="display:flex;flex-direction:column;gap:12px">
        <h2>Thống kê khách hàng theo doanh thu từ <%= date(startDate) %> đến <%= date(endDate) %></h2>
        <div class="table-box">
            <table class="data">
                <thead><tr><th>TT</th><th>Mã KH</th><th>Họ tên</th><th class="num">Số lần gọi</th><th class="num">Tổng doanh thu (VNĐ)</th><th class="center">Chi tiết</th></tr></thead>
                <tbody>
                <% for (int i = (pageNo - 1) * PAGE_SIZE; i < Math.min(pageNo * PAGE_SIZE, nRow); i++) { CustomerStat2 cs = listCustomerStat[i]; %>
                    <tr>
                        <td><%= i + 1 %></td>
                        <td><%= esc(cs.getCustomerCode()) %></td>
                        <td><strong><%= esc(cs.getFullName()) %></strong></td>
                        <td class="num"><%= cs.getOrderCount() %></td>
                        <td class="num"><strong><%= money(cs.getTotalRevenue()) %></strong></td>
                        <td class="center">
                            <form class="inline" method="get" action="CustomerDetailView2.jsp">
                                <input type="hidden" name="id" value="<%= cs.getId() %>">
                                <button type="submit" class="btn">Xem</button>
                            </form>
                        </td>
                    </tr>
                <% } %>
                </tbody>
                <tfoot>
                    <%-- số liệu do CustomerStatDAO2.getTotalRevenueStat() tính bằng SQL, giao diện không tự cộng --%>
                    <tr><th colspan="3" style="text-align:left">Tổng cộng</th>
                        <td class="num"><strong><%= totalStat.getOrderCount() %></strong></td>
                        <td class="num"><strong style="color:var(--green)"><%= money(totalStat.getTotalRevenue()) %></strong></td><td></td></tr>
                </tfoot>
            </table>
        </div>
        <form class="pager" method="get" action="CustomerRevenueStatView2.jsp">
            <span>Trang <%= pageNo %>/<%= pageCount %></span>
            <button type="submit" name="subPrevPage" class="btn outline" <%= pageNo <= 1 ? "disabled" : "" %>>Trang trước</button>
            <button type="submit" name="subNextPage" class="btn outline" <%= pageNo >= pageCount ? "disabled" : "" %>>Trang sau</button>
        </form>
    </section>
    <% } %>

    <form method="get" action="SelectStatisticsView2.jsp">
        <button type="submit" name="subBack" class="btn outline">Quay lại</button>
    </form>
</main>
<%@ include file="../common/Message2.jspf" %>
</body>
</html>
