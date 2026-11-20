-- Kiểm tra tính hợp lệ của dữ liệu RestMan2. Mỗi câu trả về số dòng vi phạm, đúng phải là 0.
-- Chạy: mysql -u root -p --default-character-set=utf8mb4 restman2 < db/kiem_tra_du_lieu.sql
USE restman2;

-- 1. Một bàn bị 2 lần gọi món dùng chồng thời gian (giờ gọi/giờ nhận bàn -> giờ thanh toán)
WITH occ AS (
  SELECT o.id, o.tblTable2id AS t, COALESCE(b.checkInTime, o.orderTime) AS s, i.paymentTime AS e
  FROM tblOrder2 o JOIN tblInvoice2 i ON i.tblOrder2id = o.id
  LEFT JOIN tblBooking2 b ON b.id = o.tblBooking2id
  WHERE o.tblTable2id IS NOT NULL)
SELECT COUNT(*) AS trung_ban FROM occ a JOIN occ c ON a.t = c.t AND a.id < c.id AND a.s < c.e AND c.s < a.e;

-- 2. Hoá đơn dùng thẻ thành viên trước ngày cấp thẻ
SELECT COUNT(*) AS the_truoc_ngay_cap FROM tblInvoice2 i JOIN tblMembershipCard2 k ON k.id = i.tblMembershipCard2id
WHERE DATE(i.paymentTime) < k.issueDate;

-- 3. Hoá đơn có thẻ nhưng thẻ không phải của khách gọi món
SELECT COUNT(*) AS the_sai_khach FROM tblInvoice2 i JOIN tblOrder2 o ON o.id = i.tblOrder2id
JOIN tblMembershipCard2 k ON k.id = i.tblMembershipCard2id WHERE k.tblCustomer2id <> o.tblCustomer2id OR o.tblCustomer2id IS NULL;

-- 4. Đơn đặt trực tuyến đã thanh toán nhưng thiếu khách/đặt bàn/bàn, hoặc bàn khác bàn đã đặt, hoặc sai thứ tự giờ
SELECT COUNT(*) AS dat_truc_tuyen_sai FROM tblOrder2 o JOIN tblInvoice2 i ON i.tblOrder2id = o.id
LEFT JOIN tblBooking2 b ON b.id = o.tblBooking2id
WHERE o.orderType = 'Đặt trực tuyến' AND (o.tblCustomer2id IS NULL OR b.id IS NULL OR o.tblTable2id IS NULL
  OR b.tblTable2id <> o.tblTable2id OR NOT (b.bookingTime <= b.arrivalTime AND b.checkInTime < i.paymentTime));

-- 5. Thanh toán trước giờ gọi món
SELECT COUNT(*) AS thanh_toan_truoc_khi_goi FROM tblOrder2 o JOIN tblInvoice2 i ON i.tblOrder2id = o.id
WHERE i.paymentTime <= o.orderTime;

-- 6. Hạng thẻ không khớp mức giảm (Bạc 5%, Vàng 10%, Kim cương 15%)
SELECT COUNT(*) AS hang_the_sai FROM tblMembershipCard2
WHERE NOT ((`rank` = 'Bạc' AND discountRate = 5) OR (`rank` = 'Vàng' AND discountRate = 10) OR (`rank` = 'Kim cương' AND discountRate = 15));
