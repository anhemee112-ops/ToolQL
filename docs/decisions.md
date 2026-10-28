# Quyết định và việc còn mở

## Vì sao viết lại (2026-10-27)

Bản ToolQL cũ (client Java 2.3.7 trong JavaHost + WPF) bị chủ repo đánh giá không phù hợp:
- Treo **2 tab** mà CPU và RAM đã nhảy liên tục (nghi: mỗi acc một cửa sổ MicroEmulator có vòng vẽ riêng, trong cùng một JVM).
- Gói build quá lớn (zip 101 MB, vì kèm JRE 8 và exe .NET tự đóng gói).
- Phần lớn tính năng chưa kiểm chứng trên server thật vì môi trường Linux cũ không kết nối được server. Môi trường mới (máy ảo Windows) giải quyết điểm này.

## Các hướng đã cân nhắc

| Hướng | Kết luận |
|---|---|
| Giữ Java, lõi không giao diện + bộ vẽ bật/tắt | Ít viết lại nhất nhưng phải kèm JRE; **không chọn** |
| **Viết lại C# (.NET 8) + SkiaSharp** | **Chọn** (nhẹ nhất; mốc: Tool 2 của ToolCikey là client .NET + Skia, gói 42 MB, chỉ để tham chiếu kích thước) |
| Rust / C++ | Nhẹ nhất nhưng tốn công, khó bảo trì; không chọn |
| Giao diện web cục bộ (WebView2) | WebView2 không hỗ trợ Server 2012 R2; loại cho phần chạy trên VPS |

## Kiến trúc dự kiến (bản nháp, chưa là spec)

1. **Khảo sát** (không có mã sản phẩm): Recaf → giao thức gói tin, định dạng tài nguyên (sprite, map, dữ liệu), quy tắc game.
2. **Lõi** (`net8.0`): kết nối, đăng nhập, trạng thái, ngủ/thức. Chạy và test được cả trên Linux/Ubuntu.
3. **Bộ vẽ** (SkiaSharp): vẽ theo yêu cầu cho acc đang xem; lưới xem tốc độ thấp.
4. **Giao diện quản lý**: công nghệ chọn sau.
5. **Auto**: port logic từ repo cũ khi đến lượt.

## Việc còn mở

- [x] Chốt phạm vi bản đầu (2026-10-28): lõi + xem màn hình + ngủ + nhận captcha; Xmap/Train để v0.2. Xem `docs/superpowers/specs/2026-10-28-v0.1-pham-vi.md`.
- [x] Công nghệ giao diện (2026-10-28): WPF thuần, không thư viện UI nặng.
- [ ] Cách đóng gói: framework-dependent (nhỏ, nhưng VPS phải cài .NET Runtime 8) hay self-contained trimmed (không cần cài, lớn hơn). Cả hai đều cần VC++ 2015-2022 x64 Redistributable trên VPS 2012 R2 (xem `docs/dev-setup.md` mục 6).
- [ ] Giấy phép client/tài nguyên được dùng; quyết định trước khi push công khai.
- [ ] Server có chấp nhận phiên bản client mà lõi mới khai báo không (cần thử bằng acc thử). (xử lý ở cột mốc 0 của spec v0.1)
- [ ] Cách đo RAM/CPU: máy ảo cho xu hướng, VPS thật cho số chốt.

## Tài liệu tham chiếu từ repo cũ

Xem `docs/reference/README.md`.
