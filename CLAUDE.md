# ToolQL (bản viết lại): quản lý nhiều tài khoản Ngọc Rồng Online, nhẹ và có xem màn hình

**Việc đầu tiên khi mở repo trong máy ảo mới:** làm theo `docs/dev-setup.md` (dựng môi trường; máy ảo dựng theo `docs/vm-setup.md`), rồi đọc `docs/decisions.md`. Setup môi trường là ưu tiên số một.

Giao tiếp bằng tiếng Việt; comment, XML doc và chuỗi hiển thị trong code cũng bằng tiếng Việt.

> Các rule frontend (Blade, SCSS, BEM, Core Web Vitals) trong `~/.claude/CLAUDE.md` **không áp dụng**. Đây là dự án C# (.NET 8).

## Chủ repo (ngữ cảnh để làm việc đúng ý)

- Giao tiếp tiếng Việt, ngắn gọn, dễ hiểu; giải thích việc quan trọng trước, chi tiết sau.
- Chủ repo treo acc trên **VPS thật** (Windows Server 2012 R2, 1 GB RAM, 1 CPU, khoảng 10 acc/máy) qua Remote Desktop, chép bản build sang bằng tay (zip qua Google Drive) và tự thử. Hay gửi ảnh chụp màn hình. Cần hướng dẫn **từng lệnh** khi bắt họ làm việc trên VPS (nói rõ PowerShell hay CMD, `cd` vào thư mục nào).
- Muốn: nhẹ, mượt, đẹp, dễ dùng; không lag, gói nhỏ. Không muốn tool tốn CPU/RAM khi chỉ treo vài acc.
- Việc lớn: brainstorming → spec → plan trước khi viết mã. Khi chưa chắc thì nói rõ là chưa chắc, đừng khẳng định.
- Gọi sản phẩm là **ToolQL**. Đây là bản viết lại; bản cũ (tên nội bộ QLTK, repo `quyenlei/Dragonboy`) chỉ còn là nguồn tham chiếu.
- Báo cáo trung thực: test fail thì nói, bước bỏ qua thì nói, phần chưa kiểm chứng thì ghi rõ.

## Dự án là gì

Viết lại từ đầu công cụ treo nhiều tài khoản Ngọc Rồng Online, thay bản ToolQL cũ (repo `quyenlei/Dragonboy`: client Java 2.3.7 + JavaHost + WPF) vì bản cũ **lag, tốn CPU/RAM (2 tab đã nhảy liên tục) và gói quá lớn (zip 101 MB)**.

## Quyết định đã chốt (2026-10-27, chủ repo)

- Ngôn ngữ **C# (.NET 8)**. Lõi **không có cửa sổ**: một tiến trình giữ mọi tài khoản (kết nối, trạng thái nhân vật/map/quái/túi, auto).
- **Xem màn hình bắt buộc**, thường 3-4 acc cùng lúc. Chỉ **vẽ acc đang xem** (SkiaSharp); acc không xem thì **ngủ**. Lưới nhiều acc vẽ tốc độ thấp.
- Client tham chiếu lấy từ **jar do chủ repo cung cấp**, đọc bằng **Recaf** (`github.com/Col-E/Recaf`). Giao thức và định dạng tài nguyên được ghi lại trước khi viết mã.
- **Phạm vi bản đầu CHƯA chốt**: chốt sau khi phân tích client. Bản nháp (chỉ là đoán): quản lý acc, đăng nhập, xem màn hình, ngủ, Xmap, Train; làm sau: Bò Mộng, hồng ngọc, Capsule, cờ đen, ăn đùi gà.
- Công nghệ giao diện quản lý **chưa chốt** (đề cử WPF gọn, không thư viện UI nặng; hoặc Avalonia). Tiêu chí: nhẹ, mượt, đẹp, dễ dùng.
- Phát triển trong **máy ảo Windows** (khuyên Windows 10 Enterprise LTSC 2021; Claude chạy trong đó, Claude Code cần Windows 10 1809+/Server 2019+); đích chạy thật là **VPS Windows Server 2012 R2, 1 GB RAM, 1 CPU, ~10 acc/máy**, không nâng cấp Windows. Lõi nhắm `net8.0` thuần.
- Mục tiêu gói: nhỏ hơn 50 MB (mốc tham chiếu: bộ ToolCikey 42 MB), không kèm JRE.

## Rule không thương lượng

- **Không viết code đọc, giải hay né captcha.** Gặp captcha thì dừng và báo "Cần captcha".
- **Không ghi mật khẩu** vào log, file trong repo, commit hay hội thoại.
- **Tài khoản thử:** tên/mật khẩu nằm ở `%USERPROFILE%\.config\toolql\test-account.env` (ngoài repo). Mỗi lần một acc, báo chủ repo trước khi đăng nhập thật, server từ chối thì dừng không thử lại. Tự động hóa trên server chính thức có thể bị khóa acc: nhắc khi liên quan.
- **ToolCikey** là sản phẩm thương mại: chỉ đọc tài liệu hướng dẫn, không decompile, không chép binary/asset.
- Mã/tài nguyên từ bên ngoài: chủ repo cho phép đọc và decompile những gì họ cung cấp, họ chịu trách nhiệm bản quyền; ghi nguồn trong commit; file tải về để ngoài repo; không commit `.jar`.
- Hành động ra ngoài (push `master`, tạo release, đổi chế độ công khai, gửi dữ liệu ra dịch vụ ngoài) phải hỏi trước. **Giấy phép client/tài nguyên chưa rõ**: hỏi trước khi push công khai.
- Số phiên bản phát hành: chỉ tăng một bước khi chủ repo yêu cầu bản để đăng (bài học từ repo cũ: nút cập nhật cần tag lớn hơn bản đang chạy).

## Quy trình

- Việc lớn: `superpowers:brainstorming` → spec (`docs/superpowers/specs/`) → `superpowers:writing-plans` → thực hiện.
- TDD cho phần hàm thuần. Chỉ báo "xong" khi đã chạy lệnh kiểm tra và đọc kết quả; nói rõ phần **chưa kiểm chứng**.
- Máy ảo cho phép Claude build, chạy và kiểm giao diện; đăng nhập server thật vẫn theo rule acc thử ở trên.
- Commit nhỏ, thông điệp tiếng Việt (`feat(core): ...`, `fix(ui): ...`). Không commit `bin/`, `obj/`, `*.jar`, `jre/`.
- Vòng đọc socket chạy trên luồng riêng, không chiếm thread pool (VPS 1 CPU). Lỗi mạng: chờ tăng dần; server từ chối đăng nhập: không thử lại.

## Việc tiếp theo

1. Dựng môi trường (`docs/dev-setup.md`).
2. Khảo sát client bằng Recaf theo `docs/survey-checklist.md`, ghi vào `docs/protocol/`. Dữ liệu ID game (vật phẩm, quái, map, NPC, skill) đã có ở `docs/data/` (nguồn và lưu ý trong `docs/data/README.md`).
3. Cùng chủ repo chốt phạm vi bản đầu và công nghệ giao diện, rồi viết spec và plan.
