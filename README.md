# Không gian học tập — IT Sales

Workspace học IT Sales qua việc thật, dùng chung giữa Sếp và Huy: Sếp giao việc,
Huy cập nhật tiến độ, hai bên trao đổi ngay trên từng nhiệm vụ.

**Xem trực tiếp:** https://huyndx9.github.io/learning/

## Cấu trúc

```
.
├── index.html   — toàn bộ ứng dụng: HTML + CSS + JS trong một file
├── 404.html     — đường dẫn sai thì quay về trang chính
├── .nojekyll    — tắt Jekyll, để GitHub Pages phục vụ file nguyên trạng
└── README.md
```

Chỉ một file `index.html` duy nhất, không framework, không bước build.
Mở bằng trình duyệt là chạy — kể cả khi mở trực tiếp từ ổ đĩa.

## Tính năng

- Board Kanban 3 cột: Cần học / Đang học / Hoàn thành, kéo thả được bằng chuột và cảm ứng
- Modal chi tiết từng nhiệm vụ: người giao, hạn chót, ước tính, tiến độ, nội dung học tập,
  thẻ phân loại, ghi chú tự động lưu, tài liệu đính kèm, trao đổi Sếp ↔ Huy
- Chuyển vai trò SẾP / HUY — Sếp sửa được đề bài, Huy cập nhật tiến độ và ghi chú
- Tìm kiếm (⌘K), timeline hoạt động, Esc để đóng

## Dữ liệu

Hiện lưu bằng `localStorage` của trình duyệt, nên mỗi máy giữ dữ liệu riêng
và chưa đồng bộ giữa Sếp với Huy.

Muốn xoá hết để về dữ liệu mẫu ban đầu: mở Console của trình duyệt và chạy
`localStorage.removeItem('learning.itsales.v1')` rồi tải lại trang.

## Hướng phát triển

Bước tiếp theo là thay `localStorage` bằng Supabase để hai người dùng chung
một nguồn dữ liệu. Toàn bộ chỗ đọc ghi đã gom vào hai hàm `load()` và `save()`
trong `index.html`, nên chỉ cần sửa ở đó.
