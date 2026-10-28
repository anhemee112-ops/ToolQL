# Giao thức và định dạng tài nguyên (kết quả khảo sát)

Thư mục này chứa kết quả đọc client. Điền khi làm theo `docs/survey-checklist.md`. Mỗi sự kiện cần có **nguồn** và **mức tin cậy**.

## Quy ước ghi

- Mức tin cậy: `bắt-gói` (đã thấy trên đường truyền thật), `từ-mã` (đọc từ mã client, chưa thử), `đoán`.
- Nguồn: tên lớp/hàm trong bản dịch ngược (kèm tên jar và phiên bản), ví dụ `Session_ME.read()`.
- Không dán mật khẩu, token hay dữ liệu cá nhân. Không dán mã dịch ngược dài; mô tả cấu trúc bằng lời và bảng.

## Các file cần có

| File | Nội dung | Trạng thái |
|---|---|---|
| `naming.md` | Quy tắc đổi tên lớp/hàm đã đặt trong Recaf, ánh xạ tên gốc ↔ tên mới | chưa có |
| `transport.md` | Socket, khung gói, kiểu số, khóa XOR, ping, nối lại | chưa có |
| `login.md` | Trình tự đăng nhập từng gói, trường, lỗi server trả | chưa có |
| `messages.md` | Bảng mã lệnh: mã, tên, hướng, cấu trúc trường, nơi xử lý | chưa có |
| `game-state.md` | Trạng thái cần giữ: nhân vật, map, quái, túi đồ, skill | chưa có |
| `resources.md` | Nơi chứa và định dạng sprite, map, dữ liệu | chưa có |
| `render.md` | Hệ tọa độ, vòng lặp, thứ tự vẽ, hoạt ảnh | chưa có |
| `risks.md` | Chỗ server kiểm tra client, captcha, giấy phép | chưa có |

## Khuôn bảng `messages.md`

| Mã | Tên (đặt) | Hướng | Trường (theo thứ tự) | Xử lý ở | Tin cậy | Ghi chú |
|---|---|---|---|---|---|---|
| -28 | | S→C | byte loại, ... | `Controller.messageNotMap` | từ-mã | byte đầu `04` = đăng nhập thành công (kết quả từ repo cũ) |

## Kết quả đã biết từ repo cũ (chưa chép sang đây)

Xem `docs/reference/README.md`. Gồm khung gói tin, khóa XOR và trình tự đăng nhập 2.3.7 đã chạy thật. Khi chép sang, ghi rõ là `bắt-gói`.
