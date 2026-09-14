# Không gian học tập — IT Sales

Workspace học IT Sales qua việc thật, dùng chung giữa Sếp và Huy: Sếp giao việc,
Huy cập nhật tiến độ, hai bên trao đổi ngay trên từng nhiệm vụ.

**Xem trực tiếp:** https://huyndx9.github.io/learning/

## Cấu trúc

```
.
├── index.html    — toàn bộ ứng dụng: HTML + CSS + JS trong một file
├── supabase.sql  — lược đồ cơ sở dữ liệu, dán vào Supabase để dùng chung
├── 404.html      — đường dẫn sai thì quay về trang chính
├── .nojekyll     — tắt Jekyll, để GitHub Pages phục vụ file nguyên trạng
└── README.md
```

Chỉ một file `index.html` duy nhất, không framework, không bước build.
Mở bằng trình duyệt là chạy — kể cả khi mở trực tiếp từ ổ đĩa.

## Tính năng

- Board Kanban 3 cột: Cần học / Đang học / Hoàn thành, kéo thả được bằng chuột và cảm ứng
- Modal chi tiết từng nhiệm vụ: người giao, hạn chót, ước tính, tiến độ, nội dung học tập,
  thẻ phân loại, ghi chú tự động lưu, tài liệu đính kèm, trao đổi Sếp ↔ Huy
- Mỗi lần vào trang phải chọn tên Sếp hay Huy trước; trong phiên không đổi được,
  muốn đổi thì tải lại trang. Sếp ra đề, Huy làm và báo tiến độ
- Tìm kiếm (⌘K), timeline hoạt động, Esc để đóng

## Dữ liệu

Có hai chế độ, quyết định bởi khối `CAU_HINH` ở đầu phần `<script>` trong
`index.html`.

**Để trống — chỉ máy này.** Dữ liệu nằm trong `localStorage` của từng
trình duyệt. Sếp và Huy mỗi người một bản riêng, không ai thấy của ai.
Đây là mặc định, mở file lên là chạy, không cần chuẩn bị gì.

**Điền vào — nối chung.** Sếp và Huy cùng một bảng, ai sửa thì màn hình
bên kia đổi theo trong vài giây, không cần tải lại trang. `localStorage`
lúc này chỉ còn là bản đệm: mất mạng vẫn xem và làm việc được, nối lại thì
đẩy tiếp.

### Bật chế độ nối chung

1. Tạo một dự án ở [supabase.com](https://supabase.com) — gói miễn phí là đủ
2. Mở **SQL Editor**, dán toàn bộ `supabase.sql` rồi bấm **Run**
3. Vào **Project Settings › API**, chép hai giá trị:
   - **Project URL** → `SUPABASE_URL`
   - **Project API keys › anon public** → `SUPABASE_ANON_KEY`
4. Điền vào khối `CAU_HINH` ở đầu `index.html`, commit và đẩy lên

Lần đầu mở trang, nếu bảng còn trống thì dữ liệu đang có trên máy sẽ được
đẩy lên làm điểm xuất phát.

Bước 2 tạo luôn kho `tai-lieu` để chứa nội dung thật của tệp đính kèm.
Chưa chạy phần đó thì đính kèm chỉ ghi được tên tệp, tải về sẽ không ra gì.

Pill ở đầu trang cho biết đang ở chế độ nào: **Live** (chấm xanh lá đang thở),
**Chỉ máy này** (chấm xám), hoặc **Mất kết nối** (chấm cam).

> Khoá `anon` là loại khoá công khai, nằm ngay trong mã nguồn trang — đó là
> thiết kế của Supabase. Đừng bao giờ dán khoá `service_role` vào đây.
> `supabase.sql` hiện mở quyền cho mọi người có link, vì repo này là board
> nội bộ hai người. Muốn siết lại thì sửa bốn policy `mo_*` ở cuối file đó.

### Xoá dữ liệu về mẫu ban đầu

Chế độ chỉ-máy-này: mở Console của trình duyệt, chạy
`localStorage.removeItem('learning.itsales.v1')` rồi tải lại trang.

Chế độ nối chung: xoá sạch ba bảng trong Supabase, rồi làm như trên.
