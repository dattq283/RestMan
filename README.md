# RestMan2 – cài đặt 2 module (Search Menu Item 2, View Statistics 2)

Cấu trúc theo biểu đồ gói: `src/model` (lớp thực thể), `src/dao` (DAO2 + các DAO kế thừa), `WebContent/view/...` (JSP). Không có package controller vì thiết kế không có.

## Chạy trên máy (Eclipse hoặc IntelliJ, Tomcat 10.1, JDK 17, MySQL 8)
1. Tạo CSDL: `mysql -u root -p --default-character-set=utf8mb4 < db/restman2.sql`
2. Sửa mật khẩu MySQL trong `src/dao/DAO2.java` (hằng `DB_PASSWORD`, đang để `123456`).
3. `mysql-connector-j-8.0.33.jar` đã có sẵn trong `WebContent/WEB-INF/lib/`.
4. Eclipse: New > Dynamic Web Project tên RestMan2 (Tomcat 10.1), chép `src` và `WebContent` vào, Run on Server.
5. Mở http://localhost:8080/RestMan2/

## Chạy trên IntelliJ IDEA (macOS)

### Bước 1 – MySQL và CSDL
```bash
brew install mysql
brew services start mysql
cd RestMan2
mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '123456';"
mysql -u root -p123456 --default-character-set=utf8mb4 < db/restman2.sql
```
Chạy từng dòng, đừng dán chú thích `#` (zsh không hiểu). Máy đã có `mysql@8.4` thì dùng `brew services start mysql@8.4`. Lệnh ALTER USER bỏ qua nếu root đã có mật khẩu.
Nếu root dùng mật khẩu khác thì sửa `DB_PASSWORD` trong `src/dao/DAO2.java`. Phải có `--default-character-set=utf8mb4`, thiếu cờ này tiếng Việt sẽ bị lỗi font và tìm "lẩu" không ra.

### Bước 2 – Tomcat
Tải Tomcat **10.1** (bản Core, file zip) ở tomcat.apache.org rồi giải nén, ví dụ ra `~/apache-tomcat-10.1.x`. Không dùng Tomcat 9, vì web.xml đang dùng chuẩn jakarta. Máy cần JDK 17 trở lên.

### Bước 3 – Mở project
1. File > Open > chọn thư mục `RestMan2`.
2. File > Project Structure:
   - Project: SDK chọn 17, Language level 17.
   - Modules: nếu chưa có module thì bấm + > New Module, đặt Content root là `RestMan2`. Ở tab Sources, đánh dấu `src` là **Sources**.
   - Modules > Dependencies: bấm + > JARs, chọn `WebContent/WEB-INF/lib/mysql-connector-j-8.0.33.jar`.

### Bước 4a – Nếu dùng IntelliJ **Ultimate**
1. Project Structure > Facets: bấm + > Web, chọn module RestMan2.
   - Deployment Descriptor: `WebContent/WEB-INF/web.xml`
   - Web Resource Directory: `WebContent`, đường dẫn `/`
2. Project Structure > Artifacts: bấm + > Web Application: Exploded > From Modules > RestMan2. Kiểm tra có `WEB-INF/classes` (compile output) và `WEB-INF/lib/mysql-connector-j-8.0.33.jar`.
3. Run > Edit Configurations > + > Tomcat Server > Local:
   - Application server: chọn thư mục Tomcat 10.1 ở bước 2.
   - Tab Deployment: bấm + > Artifact > `RestMan2:war exploded`, Application context `/RestMan2`.
   - Tab Server: URL `http://localhost:8080/RestMan2/`.
4. Bấm Run, trình duyệt sẽ tự mở trang Đăng nhập.

### Bước 4b – Nếu dùng IntelliJ **Community** (bản này không có Tomcat sẵn)
1. Settings > Plugins: cài plugin **Smart Tomcat**, rồi khởi động lại IDE.
2. Run > Edit Configurations > + > Smart Tomcat:
   - Tomcat Server: chọn thư mục Tomcat 10.1.
   - Deployment directory: `RestMan2/WebContent`
   - Use classpath of module: RestMan2
   - Context path: `/RestMan2`, Server port: 8080
3. Bấm Run, rồi mở `http://localhost:8080/RestMan2/`.

### Lỗi hay gặp
- Trang báo "Không thể kết nối tới hệ thống": MySQL chưa chạy, sai mật khẩu trong DAO2, hoặc chưa chạy file sql.
- Lỗi 404: Application context/Context path phải là `/RestMan2`.
- Lỗi `ClassNotFoundException com.mysql.cj.jdbc.Driver`: artifact (hoặc classpath của module) chưa có file jar mysql-connector.
- Cổng 8080 bị chiếm: đổi cổng trong run configuration.

Tài khoản thử (mật khẩu đều `123456`): khách hàng `binh` (Trần Thị Bình, KH0012), quản lí `quanli` (Nguyễn Hoàng Nam, NV0001).

Dữ liệu mẫu khớp kịch bản: tìm "lẩu" ra 4 món + 1 combo; thống kê 01/08/2026–31/08/2026 ra 6 khách, tổng 10.199.000; hoá đơn HD260803-012 có cả combo (Set lẩu 2 người) và món lẻ (Coca-Cola), tổng thanh toán 423.000.

`view/member/LoginView2.jsp` và `dao/MemberDAO2.java` thuộc module Đăng nhập, ngoài 2 module được giao; chỉ để có người dùng trong session khi chạy.
