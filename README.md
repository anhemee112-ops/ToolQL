# ToolQL

Công cụ quản lý và treo nhiều tài khoản Ngọc Rồng Online, viết lại bằng C# (.NET 8): nhẹ, mượt, có xem màn hình cho tài khoản đang chọn, tài khoản không xem thì ngủ.

**Trạng thái:** giai đoạn thiết kế. Chưa có mã sản phẩm. Hiện repo chỉ có tài liệu.

## Bắt đầu

1. Dựng máy ảo Windows: [`docs/vm-setup.md`](docs/vm-setup.md)
2. Dựng môi trường phát triển: [`docs/dev-setup.md`](docs/dev-setup.md), rồi chạy `scripts\setup-dev.ps1`
3. Đọc bối cảnh và quy tắc: [`CLAUDE.md`](CLAUDE.md), [`docs/decisions.md`](docs/decisions.md)
4. Khảo sát client: [`docs/survey-checklist.md`](docs/survey-checklist.md)

## Cấu trúc

| Đường dẫn | Nội dung |
|---|---|
| `docs/` | Tài liệu thiết kế, môi trường, khảo sát |
| `docs/data/` | Dữ liệu ID game (vật phẩm, quái, map, NPC, skill) |
| `docs/protocol/` | Giao thức và định dạng tài nguyên (điền khi khảo sát) |
| `docs/reference/` | Chỉ dẫn tới tài liệu của repo cũ |
| `scripts/` | Script dựng môi trường |

## Giấy phép

**Chưa quyết định.** Chủ repo phải chọn trước khi đưa repo lên công khai (repo cũ dùng AGPLv3). Giấy phép của client và tài nguyên game cũng cần làm rõ.
