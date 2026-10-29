# Đăng nhập (phần đã đọc được)

Nguồn: `Dragonboy250 v3.5.jar`. Mức tin cậy: **từ-mã**, chưa thử với server. Chi tiết khung gói xem `transport.md`.

## Gói đăng nhập client → server

Hàm gửi: `an_0.a(String, String, String, byte)` (lớp `an`), mã lệnh `an.bi[4]` = **0**.

| Thứ tự | Kiểu | Nội dung |
|---|---|---|
| 1 | UTF | tên đăng nhập |
| 2 | UTF | mật khẩu (gửi nguyên văn trong payload; chỉ được che bởi khóa XOR của tầng truyền) |
| 3 | UTF | phiên bản giao thức, client dùng cứng `"2.5.0"` |
| 4 | byte | chưa rõ; client truyền `bg[6]` (từ `al`) hoặc 0/1 theo cờ `bd` (từ `cK`) |
| 5 | byte | `aM.Z`; đoán là mã ngôn ngữ (`aM` chứa bản dịch Việt, Anh, Indonesia) |

Không thấy xử lý captcha ở phía client: không có chuỗi "captcha" nào trong mã đã giải chuỗi. Điều này **không chứng minh** server không đòi captcha. Nếu server đòi thì dừng và báo "Cần captcha" (rule trong `CLAUDE.md`).

## Gói thông tin client (đoán là `setType` / ClientInfo)

Nguồn: `cj_0` quanh dòng 338. Payload theo thứ tự: byte (`bQ.bB`), byte (`aA.bH`), boolean (false), int (`cs_0.cl`), int (`cs_0.dj`), boolean (`av_0.bo`), boolean (`cs_0.cS`), UTF `"<microedition.platform>|2.5.0"`. Mã lệnh là `cj.dN[0]`, **chưa tính** (lớp `cj` nạp được cần thư viện MIDP; chưa có giả lập).

## Gói server → client liên quan

Bộ xử lý gói: `cj_0.b(cN)` (dòng 1999), một `switch` trên mã lệnh với 169 nhánh. Một số nhánh cho thấy:

- `-29` → `cj_0.h`: nhánh con `2` đọc UTF (lưu `al.W`, gọi `al.l`) rồi byte; có vẻ là thông báo/trả lời đăng nhập, **chưa phân tích**.
- `-28` → `this.f`: chưa đọc. `-30` → `this.j`: chưa đọc.
- `-31`: danh sách vật phẩm (số lượng short, mỗi mục short, byte, short, short, rồi mảng byte cặp).
- `-26`: nhận một UTF thông báo (`cs_0.l`).

Bảng mã lệnh và luồng sau đăng nhập (`-28` sub 4, tải bảng dữ liệu, `-30` sub 0) đã ghi ở `messages.md`.

## Chưa biết

- Phản hồi đăng nhập thành công/thất bại, mã lỗi, luồng chọn nhân vật/vào game.
- Server có chấp nhận chuỗi `"2.5.0"` từ client mới không (mục "Việc còn mở" trong `docs/decisions.md`).
