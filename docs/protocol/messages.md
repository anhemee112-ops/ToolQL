# Bảng mã lệnh (cmd)

Nguồn: `Dragonboy250 v3.5.jar` (xem `transport.md`). Mức tin cậy: **từ-mã** cho toàn bộ, chưa bắt gói, chưa thử với server.
Tên lớp/hàm là tên **trong jar** (đã làm rối). Mã lệnh gửi lấy từ mảng `an.bi` do chính lớp tính ra (`scripts/survey/DumpConst.java`), không tính tay.

## Cách đọc

- Mã lệnh là **byte có dấu**. Phần lớn gói dùng chung 3 "kênh" có byte phụ (sub) đứng đầu payload:
  - `-29`: nhóm đăng nhập (sub `0` = đăng nhập, `1` = đăng ký, `2` = khai báo thông tin client).
  - `-28`: nhóm "ngoài map" (sub `4` = phiên bản dữ liệu, `6/7/8` = cập nhật map/skill/item, ...). Client gọi là `messageNotMap`.
  - `-30`: thông tin nhân vật của mình (sub `0` = toàn bộ nhân vật).
- Bảng dưới là **kiểu trường theo thứ tự đọc/ghi trong mã**, lấy tự động bằng script từ bản dịch ngược. Với nhánh có `if`/vòng lặp, danh sách chỉ là các lần đọc xuất hiện, **không phải** một cấu trúc phẳng. Đừng cài đặt chỉ theo bảng này: mở hàm tương ứng đọc lại.
- Cột "Hàm con": nhánh giao cho hàm khác (cần đọc riêng); các nhánh `-30`, `-29`, `-28`, `-24`, `-107`, `-86`, `-44`, `-37..-35`, `66`, `90`... nằm ở đây.
- Chưa đặt tên ý nghĩa cho từng mã (tên thật phải suy từ chỗ dùng). Cột tên sẽ điền dần khi khảo sát trạng thái game.
- `ubyte`/`ushort` = `readUnsignedByte`/`readUnsignedShort`.

## Mã đã hiểu ý nghĩa

| Mã | Hướng | Ý nghĩa | Tin cậy |
|---|---|---|---|
| -27 | S↔C | khóa XOR (xem `transport.md`) | từ-mã |
| -29 sub 0 | C→S | đăng nhập: UTF tên, UTF mật khẩu, UTF phiên bản `"2.5.0"`, byte, byte (xem `login.md`) | từ-mã |
| -29 sub 1 | C→S | đăng ký: 4 UTF (chưa dùng, ToolQL không cần) | từ-mã |
| -29 sub 2 | C→S | khai báo thông tin client (xem `login.md`) | từ-mã |
| -29 sub 2 | S→C | `cj_0.h`: UTF thông báo (lưu `al.W`, hiển thị), rồi byte (bool). Có vẻ là thông báo/lỗi đăng nhập | đoán |
| -28 sub 4 | S→C | 4 byte phiên bản: dữ liệu, map, skill, item; rồi 1 byte bỏ; xem "Luồng sau đăng nhập" | từ-mã |
| -28 sub 6/7/8 | C→S | yêu cầu tải lại bảng map / skill / item | từ-mã |
| -28 sub 6/7/8 | S→C | trả về bảng map / skill / item (client lưu vào kho `NRmap`, `NRskill`, `NRitem*`) | từ-mã |
| -87 | C→S | yêu cầu tải lại bảng dữ liệu chung (`dW`); trả lời nằm ở nhánh nào chưa rõ | từ-mã |
| -28 sub 13 | C→S | báo "đã tải xong dữ liệu" (`dR`), không payload ngoài sub | đoán |
| -30 sub 0 | S→C | thông tin nhân vật của mình: xem bên dưới | từ-mã |
| -24 | S→C | thông tin map (log "MAP_INFO"), xử lý ở `cj_0.i` | từ-mã |
| -31 | S→C | danh sách vật phẩm (short số lượng; mỗi mục: short, byte, short, short, byte rồi mảng cặp byte) | từ-mã |

## Gói `-30` sub 0: nhân vật của mình (`cj_0.j`)

Thứ tự đọc (sau byte sub): int `id`, byte, byte `ht` (chưa rõ, dùng làm chỉ số bảng `cu_0.b.h`; có thể là hành tinh), short `đầu`, UTF `tên`, byte, byte, long `sức mạnh?`, short, short, byte (chỉ số `cu_0.a[...]`, có thể là loại/phái), byte `n` rồi `n` short (danh sách skill/phần thân), long, int, int, byte `nTrangBị` rồi mỗi mục: short mã vật phẩm (`-1` = trống), int số lượng, 2 UTF, ubyte `nOption` rồi mỗi option đọc bằng `cj_0.a(cN)`; tương tự cho túi (`a[]`) và rương (`b[]`); sau đó short `m` rồi `m` cặp short, 3 short, byte, int (giờ server, giây), byte; rồi client **gửi lại một gói** (mã `dN[80]`, chưa tính) mang `ht`. Cuối cùng short, byte, short (bọc `try`, có thể thiếu).
Tên các trường (HP, MP, vàng, ngọc...) **chưa gán**: cần đối chiếu với nơi hiển thị.

## Luồng sau đăng nhập (đọc từ mã, chưa chạy)

1. C→S `-29` sub 0 (đăng nhập) và `-29` sub 2 (thông tin client). Xem thứ tự thật ở `login.md`.
2. S→C `-28` sub 4: server báo 4 phiên bản dữ liệu. Client so với bản đã lưu (kho `NRdata`, `NRmap`, `NRskill`, `NRitem0/1/100/101`).
3. Nếu lệch: C→S yêu cầu `-87` (dữ liệu chung), `-28` sub 6 (map), 7 (skill), 8 (item); S→C trả cùng sub; client lưu lại.
4. Khi đủ: C→S `-28` sub 13 (`dR`); S→C `-30` sub 0 (nhân vật) và `-24` (map).
5. Cuối gói `-28` sub 4 còn `byte n` rồi `n` long (`cu_0.h`, nhãn log "CAPTION").

Hệ quả cho ToolQL: **bảng map/skill/item không nằm trong jar mà do server gửi**, ToolQL phải tự tải và lưu cục bộ (xem `resources.md` khi viết). Chưa khảo sát định dạng.

## Server → client (`cj_0.b`, dòng 1999+)

| Mã | Dòng | Trường đọc trực tiếp (theo thứ tự trong mã) | Hàm con |
|---|---|---|---|
| -112 | 2008 | byte, byte, byte, short |  |
| -107 | 2020 | byte, short, ubyte, short, int, utf, utf, ubyte, long, long, long, long, long, utf, utf, long, long,… (27 trường) | cj_0.a |
| -99 | 2096 | byte, ubyte, int, short, short, short, short, short, utf, utf, boolean |  |
| -98 | 2124 | byte, utf, utf |  |
| -97 | 2131 | int |  |
| -96 | 2135 | byte, utf, byte, int, int, short, short, short, short, utf, utf, utf |  |
| -95 | 2166 | byte, int, short, long, int, byte, int, int, long, long, int, int, long, long, int, byte, int, long,… (21 trường) |  |
| -94 | 2338 | short, int |  |
| -93 | 2350 | short, byte |  |
| -92 | 2358 | byte |  |
| -91 | 2369 | byte, utf, utf |  |
| -90 | 2382 | byte, int, short, short, short, byte |  |
| -88 | 2441 |  |  |
| -87 | 2446 | (đọc hết) |  |
| -86 | 2462 | byte, int, int, byte, int, byte, short, int, ubyte | cj_0.a |
| -85 | 2534 | byte, ushort, utf |  |
| -84 | 2556 | ubyte, long |  |
| -83 | 2569 | byte, short, short, ubyte, int, utf, short, short, byte |  |
| -82 | 2607 | byte, byte, int, byte, byte |  |
| -81 | 2626 | byte, utf, utf, byte, byte, short, short, short, short, short, short, short, short |  |
| -80 | 2710 | byte, ubyte, int, short, short, short, short, short, utf, boolean, utf, utf, int, boolean, int |  |
| -79 | 2760 | int, long, utf |  |
| -77 | 2771 | short, byte |  |
| -76 | 2781 | byte, byte, utf, utf, short, boolean, boolean, ubyte |  |
| -70 | 2806 | short, utf |  |
| -69 | 2816 | short |  |
| -68 | 2820 | short |  |
| -67 | 2824 | int |  |
| -66 | 2847 | short, byte |  |
| -65 | 2861 | int, byte |  |
| -64 | 2890 | int, short |  |
| -63 | 2904 | short, byte, short |  |
| -62 | 2919 | ubyte, byte, short |  |
| -61 | 2932 | int, int, int |  |
| -60 | 2945 | int, byte, byte, int, ubyte, byte, int, byte, byte, long, boolean, boolean, long, boolean, boolean |  |
| -59 | 3028 | byte, int, int, utf |  |
| -57 | 3036 | utf, int, int |  |
| -53 | 3043 | int, utf, utf, short, utf, utf, ubyte, ubyte, byte, int, byte, int, short, short, short, short, utf,… (25 trường) |  |
| -52 | 3102 | byte, int, short, short, short, short, utf, byte, utf, int, int, int, int, byte, int, short, short, … (26 trường) |  |
| -51 | 3155 |  |  |
| -50 | 3162 | byte, int, short, short, short, short, utf, byte, utf, int, int, int, int |  |
| -47 | 3189 | byte, int, utf, utf, short, utf, utf, ubyte, ubyte, int |  |
| -46 | 3219 | byte, short, short, utf, int, int, short, utf |  |
| -45 | 3251 | byte, int, short, byte, byte, short, byte, byte, byte, short, short, short, short, byte, byte, byte,… (29 trường) |  |
| -44 | 3486 | byte, ubyte, utf, ubyte, ubyte, short, int, int, int, utf, int, int, long, short, int, int, byte, in… (29 trường) | cj_0.a |
| -43 | 3591 | byte, byte, byte, utf |  |
| -42 | 3599 | int, long, long, long, long, byte, byte, byte, byte, long, long, byte, long, short, int, byte, byte, short |  |
| -41 | 3623 | byte, utf |  |
| -37 | 3631 | byte, short, ubyte, short, int, utf, utf, ubyte | cj_0.a |
| -36 | 3672 | byte, ubyte, short, int, utf, utf, ubyte, byte, int | cj_0.a |
| -35 | 3736 | byte, ubyte, short, int, utf, utf, ubyte, byte, byte, int | cj_0.a |
| -34 | 3786 | byte, short, utf, short, short, byte, short, short, utf, int, byte, byte, byte, boolean, utf, short, int |  |
| -32 | 3836 | short, int |  |
| -31 | 3857 | short, short, byte, short, short, byte, byte, byte |  |
| -30 | 3879 |  | this.j |
| -29 | 3883 |  | cj_0.h |
| -28 | 3887 |  | this.f |
| -26 | 3891 | utf |  |
| -25 | 3901 | utf |  |
| -24 | 3905 | ubyte, byte, byte, byte, byte, utf, byte, byte | this.i |
| -22 | 3946 |  |  |
| -21 | 3966 | short |  |
| -20 | 3975 | short, utf, short, short, short, short |  |
| -19 | 4042 | short, int |  |
| -18 | 4062 | byte, short, short, short |  |
| -14 | 4068 | int, short, short, short, short |  |
| -4 | 4076 | int, ubyte, ubyte, byte, byte, int |  |
| 0 | 4117 |  | cj_0.l |
| 1 | 4121 | boolean, utf |  |
| 2 | 4134 |  |  |
| 6 | 4145 | long, int, int |  |
| 7 | 4155 | byte, short, utf |  |
| 11 | 4162 | short, byte, byte |  |
| 12 | 4199 |  | this.d |
| 20 | 4207 |  | this.k |
| 24 | 4211 |  | this.n |
| 27 | 4215 | utf, byte, utf, short |  |
| 29 | 4227 |  |  |
| 32 | 4231 | short, utf, byte, utf, utf, byte, utf, short |  |
| 33 | 4270 | utf |  |
| 38 | 4295 |  |  |
| 39 | 4298 |  |  |
| 40 | 4303 | short, byte, utf, utf, byte, utf, byte, short, utf, short, short |  |
| 41 | 4342 |  |  |
| 43 | 4351 | short, short, short |  |
| 46 | 4366 | short, short |  |
| 47 | 4371 |  |  |
| 50 | 4375 | byte, short, utf, utf |  |
| 54 | 4389 | int, ubyte, byte |  |
| 56 | 4424 | int, long, long, boolean, byte, long, long, boolean, byte |  |
| 57 | 4482 | utf |  |
| 58 | 4488 | int, short, short, int |  |
| 62 | 4508 | int |  |
| 63 | 4520 | int |  |
| 64 | 4529 | int |  |
| 65 | 4540 | byte, utf, short |  |
| 66 | 4563 |  | this.e |
| 68 | 4567 | short, short, short, short, int, short |  |
| 69 | 4589 | byte |  |
| 81 | 4593 | ubyte, boolean |  |
| 82 | 4598 | ubyte, boolean |  |
| 83 | 4602 | int, ubyte |  |
| 84 | 4613 | int, short, short |  |
| 85 | 4630 | ubyte, boolean |  |
| 86 | 4635 | ubyte, ubyte, boolean |  |
| 87 | 4642 | ubyte, boolean |  |
| 88 | 4646 | utf, short |  |
| 90 | 4652 |  | this.g |
| 92 | 4656 | utf, utf, int, short, short, short, short, short, byte |  |
| 94 | 4688 | utf |  |
| 112 | 4692 | byte, short, utf, byte, utf, byte, short, utf, ubyte, byte, byte, byte, byte, short, short, long, ub… (117 trường) |  |

## Client → server (lớp `an`)

| Mã | Sub | Hàm gửi (tên trong jar) | Trường ghi |
|---|---|---|---|
| -127 |  | `b(byte by, byte by2)` | byte, byte |
| -125 |  | `a(av_0[] av_0Array)` | byte, utf |
| -121 |  | `dO()` |  |
| -120 |  | `dE()` |  |
| -118 |  | `O(int n)` | int |
| -114 |  | `dC()` |  |
| -113 |  | `b(byte[] byArray)` | byte |
| -111 |  | `b(cT cT2)` | short, utf |
| -110 |  | `a(byte by, int n, byte[] byArray)` | byte, int, short |
| -108 |  | `g(byte by)` | byte |
| -107 |  | `dG()` |  |
| -105 |  | `dH()` |  |
| -104 |  | `v(int n)` | int |
| -103 |  | `d(byte by, byte by2)` | byte, byte |
| -101 |  | `o(String string)` | utf, byte |
| -100 |  | `a(byte by, int n, byte by2, int n2, int n3)` | byte, short, byte, int, int, short, short, byte, int, byte, byte, short |
| -99 |  | `b(byte by, int n)` | byte, int |
| -96 |  | `a(String string, byte by)` | utf, byte |
| -91 |  | `E(int n)` | byte |
| -87 |  | `dW()` |  |
| -86 |  | `a(byte by, int n, byte by2, int n2)` | byte, int, byte, int, byte |
| -85 |  | `a(char c)` | char |
| -81 |  | `a(byte by, cT cT2)` | byte, byte, byte |
| -80 |  | `a(byte by, int n)` | byte, int |
| -79 |  | `u(int n)` | int |
| -78 |  | `K(int n)` | int |
| -76 |  | `H(int n)` | byte |
| -74 |  | `b(byte by, cT cT2)` | byte |
| -72 |  | `c(String string, int n)` | int, utf |
| -71 |  | `p(String string)` | utf |
| -67 |  | `w(int n)` | int |
| -66 |  | `b(short s)` | short |
| -63 |  | `B(int n)` | short |
| -62 |  | `d(byte by)` | byte |
| -59 |  | `a(byte by, byte by2, int n)` | byte, byte, int |
| -57 |  | `a(byte by, int n, int n2, int n3)` | byte, int, int, int |
| -56 |  | `b(int n, byte by)` | int, byte |
| -55 |  | `dN()` |  |
| -54 |  | `J(int n)` | int |
| -51 |  | `a(int n, String string, int n2)` | byte, utf, int |
| -50 |  | `P(int n)` | int |
| -49 |  | `a(int n, byte by)` | int, byte |
| -47 |  | `r(String string)` | utf |
| -46 |  | `a(byte by, int n, String string)` | byte, short, utf |
| -45 |  | `a(byte by, byte by2, short s, short s2)` | byte, byte, short, short, byte, short, short |
| -45 |  | `b(byte by)` | byte |
| -43 |  | `a(byte by, byte by2, byte by3, short s)` | byte, byte, byte, short |
| -40 |  | `c(byte by, byte by2)` | byte, byte |
| -39 |  | `dS()` |  |
| -38 |  | `dI()` |  |
| -38 |  | `z(int n)` | int |
| -34 |  | `c(byte by)` | byte |
| -34 |  | `f(byte by)` | byte |
| -33 |  | `dQ()` |  |
| -32 |  | `c(short s)` | short |
| -30 |  | `N(int n)` | byte, int |
| -30 |  | `a(int n, short s)` | byte, int, short |
| -30 |  | `f(int n, int n2)` | byte, byte, short |
| -29 |  | `a(byte by)` | byte |
| -29 | 0 | `a(String string, String string2, String string3, byte by)` | utf, utf, utf, byte, byte |
| -29 | 1 | `a(String string, String string2, String string3, String string4)` | utf, utf, utf, utf |
| -29 | 2 | `dF()` | byte, byte, boolean, int, int, boolean, boolean, utf, short |
| -28 |  | `a(String string, int n, int n2)` | byte, utf, byte, byte |
| -28 |  | `b(byte by)` | byte |
| -28 | 6 | `dB()` |  |
| -28 | 7 | `dT()` |  |
| -28 | 8 | `dU()` |  |
| -28 | 10 | `s(int n)` | byte |
| -28 | 13 | `dR()` |  |
| -28 | 16 | `c(String string, String string2)` | utf, utf |
| -28 | 18 | `b(String string, int n)` | int, utf |
| -28 | 37 | `M(int n)` | int |
| -28 | 39 | `y(int n)` | int |
| -28 | 41 | `I(int n)` | int |
| -23 |  | `dD()` |  |
| -20 |  | `A(int n)` | short |
| -16 |  | `dK()` |  |
| -15 |  | `dX()` |  |
| -7 |  | `dJ()` | byte, byte, short, short |
| -4 |  | `a(cT cT2, cT cT3, int n)` | byte, byte, int, int, byte, byte, int, int, byte |
| 6 |  | `a(byte by, int n, int n2)` | byte, short |
| 7 |  | `a(byte by, byte by2, short s)` | byte, byte, short |
| 11 |  | `t(int n)` | short |
| 13 |  | `a(cE[] cEArray)` | byte |
| 17 |  | `s(String string)` | utf |
| 18 |  | `L(int n)` | int |
| 21 |  | `G(int n)` | byte |
| 22 |  | `a(int n, int n2, int n3)` | byte, byte, byte |
| 27 |  | `a(short s)` | short |
| 29 |  | `dV()` |  |
| 32 |  | `a(short s, byte by)` | short, byte |
| 33 |  | `F(int n)` | short |
| 34 |  | `C(int n)` | short |
| 37 |  | `D(int n)` | int |
| 42 |  | `a(String string, String string2, String string3, String string4, String string5, String string6, String string7, String string8, String string9)` | utf, utf, utf, utf, utf, utf, utf, utf, utf |
| 44 |  | `n(String string)` | utf |
| 50 |  | `dL()` |  |
| 53 |  | `m(String string)` | utf |
| 66 |  | `q(String string)` | utf |
| 69 |  | `dP()` |  |
| 76 |  | `Q(int n)` | int |
| 77 |  | `x(int n)` | int |
| 88 |  | `a(short s, String string)` | short, utf |
| 112 |  | `e(byte by)` | byte |
| 125 |  | `h(byte by)` | byte |
| 127 |  | `e(int n, int n2)` | byte, short |
