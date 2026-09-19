-- =====================================================================
-- Không gian học tập — lược đồ cơ sở dữ liệu Supabase
-- Dán toàn bộ file này vào SQL Editor của Supabase rồi bấm Run.
-- Chạy lại nhiều lần vẫn an toàn.
-- =====================================================================

-- ---------- BẢNG NHIỆM VỤ ----------
create table if not exists public.tasks (
  id          text primary key,
  status      text not null default 'todo',
  pos         double precision not null default 0,   -- thứ tự trong cột
  title       text not null default '',
  descr       text not null default '',
  tags        jsonb not null default '[]'::jsonb,
  priority    text not null default 'Bình thường',
  assignee    text not null default 'Sếp giao',
  due         text not null default '',
  estimate    text not null default '',
  progress    int  not null default 0,
  content     jsonb not null default '[]'::jsonb,
  goal        text not null default '',
  criteria    text not null default '',
  customer    text not null default '',
  note        text not null default '',
  files       jsonb not null default '[]'::jsonb,
  suggests    jsonb not null default '[]'::jsonb,
  author      text not null default 'sep',           -- ai thêm: sep hoặc huy
  updated_at  timestamptz not null default now()
);

-- ---------- BẢNG TRAO ĐỔI ----------
create table if not exists public.comments (
  id       text primary key,
  task_id  text not null references public.tasks(id) on delete cascade,
  who      text not null default 'sep',
  body     text not null default '',
  at       timestamptz not null default now()
);
create index if not exists comments_task_idx on public.comments(task_id, at);

-- ---------- BẢNG NHẬT KÝ HOẠT ĐỘNG ----------
create table if not exists public.activity (
  id    text primary key,
  body  text not null default '',
  at    timestamptz not null default now()
);
create index if not exists activity_at_idx on public.activity(at desc);

-- Gộp hoạt động trùng: akey là loại việc + mã nhiệm vụ, lan là số lần đã gộp.
alter table public.activity add column if not exists akey text not null default '';
alter table public.activity add column if not exists lan  int  not null default 1;

-- =====================================================================
-- QUYỀN TRUY CẬP
-- Đã chọn: không khoá — ai có link đều đọc và ghi được.
-- Muốn siết lại sau thì xoá bốn policy "mo_*" bên dưới và thay bằng
-- điều kiện auth.role() = 'authenticated'.
-- =====================================================================
alter table public.tasks    enable row level security;
alter table public.comments enable row level security;
alter table public.activity enable row level security;

drop policy if exists mo_tasks    on public.tasks;
drop policy if exists mo_comments on public.comments;
drop policy if exists mo_activity on public.activity;

create policy mo_tasks    on public.tasks    for all using (true) with check (true);
create policy mo_comments on public.comments for all using (true) with check (true);
create policy mo_activity on public.activity for all using (true) with check (true);

-- =====================================================================
-- ĐỒNG BỘ THỜI GIAN THỰC
-- Để màn hình bên kia tự đổi khi một người sửa, không cần tải lại trang.
-- =====================================================================
do $$
begin
  begin execute 'alter publication supabase_realtime add table public.tasks';    exception when others then null; end;
  begin execute 'alter publication supabase_realtime add table public.comments'; exception when others then null; end;
  begin execute 'alter publication supabase_realtime add table public.activity'; exception when others then null; end;
end $$;

-- =====================================================================
-- KHO TÀI LIỆU
-- Chứa nội dung thật của các tệp đính kèm trong nhiệm vụ.
-- Gói miễn phí cho 1GB, mỗi tệp tối đa 50MB.
-- =====================================================================
insert into storage.buckets (id, name, public)
values ('tai-lieu', 'tai-lieu', true)
on conflict (id) do nothing;

drop policy if exists mo_doc_tep  on storage.objects;
drop policy if exists mo_ghi_tep  on storage.objects;
drop policy if exists mo_xoa_tep  on storage.objects;

create policy mo_doc_tep on storage.objects
  for select using (bucket_id = 'tai-lieu');
create policy mo_ghi_tep on storage.objects
  for insert with check (bucket_id = 'tai-lieu');
create policy mo_xoa_tep on storage.objects
  for delete using (bucket_id = 'tai-lieu');
