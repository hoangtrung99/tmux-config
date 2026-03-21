# Hướng Dẫn Sử Dụng tmux - Tài Liệu Tham Khảo Đầy Đủ

> Dành cho developer đã cấu hình đầy đủ tmux với 11 plugins. Tài liệu này bao gồm mọi keybinding, plugin, và workflow thực tế.

---

## Mục Lục

1. [Tổng Quan](#1-tổng-quan)
2. [Bắt Đầu Nhanh](#2-bắt-đầu-nhanh-5-phút-đầu)
3. [Tham Khảo Keybinding](#3-tham-khảo-keybinding-đầy-đủ)
4. [Hướng Dẫn Plugins](#4-hướng-dẫn-plugins)
5. [Thanh Trạng Thái](#5-thanh-trạng-thái-status-bar)
6. [Workflow Thực Tế](#6-workflow-thực-tế)
7. [Hướng Dẫn Copy & Paste](#7-hướng-dẫn-copy--paste)
8. [Lưu & Khôi Phục Session](#8-lưu--khôi-phục-session)
9. [Xử Lý Sự Cố](#9-xử-lý-sự-cố)
10. [Tùy Chỉnh Cấu Hình](#10-tùy-chỉnh-cấu-hình)

---

## 1. Tổng Quan

tmux là **terminal multiplexer** - cho phép bạn chạy nhiều terminal trong một cửa sổ, giữ session sống khi disconnect, và chia màn hình thành nhiều pane làm việc song song.

### Cấu Hình Hiện Tại

| Thông Số | Giá Trị |
|----------|---------|
| Prefix key | `C-b` (Ctrl + b) |
| Mouse | Bật |
| Base index | 1 (window đầu tiên là 1, không phải 0) |
| Mode keys | vi |
| History limit | 50,000 dòng |
| Theme | Catppuccin Mocha |
| Auto-save | Mỗi 15 phút (tmux-continuum) |

### 3 Khái Niệm Cốt Lõi

```
SERVER (tmux server)
└── SESSION (phiên làm việc, ví dụ: "myproject")
    ├── WINDOW 1: editor    (tab)
    ├── WINDOW 2: terminal  (tab)
    └── WINDOW 3: logs      (tab)
        ├── PANE trái
        └── PANE phải
```

- **Session**: Một phiên làm việc, tồn tại kể cả khi bạn detach
- **Window**: Như tab trong trình duyệt, mỗi window chiếm toàn màn hình
- **Pane**: Chia nhỏ một window thành nhiều vùng terminal

---

## 2. Bắt Đầu Nhanh (5 Phút Đầu)

### Khởi Động

```bash
# Tạo session mới với tên
tmux new -s myproject

# Hoặc attach vào session đã có
tmux attach -t myproject
```

### Các Thao Tác Thiết Yếu

Mọi keybinding trong tmux đều bắt đầu bằng **Prefix** (`C-b`), tức là nhấn `Ctrl+b` rồi thả, sau đó nhấn phím tiếp theo.

| Muốn làm gì | Nhấn gì |
|-------------|---------|
| Chia đôi màn hình trái/phải | `C-b %` |
| Chia đôi màn hình trên/dưới | `C-b "` |
| Di chuyển giữa các pane | `C-h` / `C-j` / `C-k` / `C-l` |
| Tạo tab (window) mới | `C-b c` |
| Chuyển sang tab tiếp | `C-b n` |
| Thoát tmux (session vẫn sống) | `C-b d` |
| Quay lại session | `tmux attach -t myproject` |
| Xem help | `C-b ?` |

### Workflow 5 Phút

```
1. tmux new -s myproject
2. C-b %         → chia đôi trái/phải
3. C-l           → sang pane phải
4. C-b c         → tạo window mới cho logs
5. C-b 1         → quay về window 1
6. C-b d         → detach (session vẫn chạy)
7. tmux attach -t myproject → quay lại
```

---

## 3. Tham Khảo Keybinding Đầy Đủ

### 3.1 Session

| Keybinding | Hành Động |
|------------|-----------|
| `C-b d` | Detach khỏi session (session vẫn sống) |
| `C-b s` | Xem danh sách tất cả sessions (dạng cây) |
| `C-b $` | Đổi tên session hiện tại |
| `C-b (` | Chuyển sang session trước |
| `C-b )` | Chuyển sang session tiếp |
| `C-b w` | Xem tất cả sessions + windows |
| `C-b : new -s ten` | Tạo session mới với tên |
| `C-b : new -ds ten` | Tạo session trong nền (không switch sang) |

### 3.2 Window (Tab)

| Keybinding | Hành Động |
|------------|-----------|
| `C-b c` | Tạo window mới |
| `C-b n` | Chuyển sang window tiếp theo |
| `C-b p` | Chuyển sang window trước đó |
| `C-b 1` - `C-b 9` | Nhảy thẳng đến window theo số |
| `C-b ,` | Đổi tên window hiện tại |
| `C-b &` | Đóng window hiện tại |
| `C-b l` | Toggle qua lại giữa window hiện tại và window trước |

> **Lưu ý**: Window tự động đánh số lại khi đóng (`renumber-windows on`). Tên window không tự đổi sau khi đặt thủ công (`allow-rename off`).

### 3.3 Pane

| Keybinding | Hành Động |
|------------|-----------|
| `C-b %` | Chia pane theo chiều dọc (trái/phải) |
| `C-b "` | Chia pane theo chiều ngang (trên/dưới) |
| `C-b x` | Đóng pane hiện tại |
| `C-b z` | Zoom/unzoom pane (phóng to toàn màn hình) |
| `C-b q` | Hiển thị số thứ tự các pane |
| `C-b {` | Hoán đổi pane hiện tại sang trái |
| `C-b }` | Hoán đổi pane hiện tại sang phải |
| `C-b Space` | Chuyển đổi layout (even-horizontal, tiled, v.v.) |
| `C-b o` | Cycle qua các pane |
| `C-h` | Di chuyển sang pane trái (không cần prefix) |
| `C-j` | Di chuyển sang pane dưới (không cần prefix) |
| `C-k` | Di chuyển sang pane trên (không cần prefix) |
| `C-l` | Di chuyển sang pane phải (không cần prefix) |

> `C-h/j/k/l` hoạt động xuyên suốt tmux, vim, neovim, và fzf nhờ **vim-tmux-navigator**.

### 3.4 Copy Mode (Vi)

| Keybinding | Hành Động |
|------------|-----------|
| `C-b [` | Vào copy mode |
| `v` | Bắt đầu chọn văn bản |
| `y` | Yank (copy) vùng đã chọn vào clipboard |
| `/` | Tìm kiếm xuống |
| `?` | Tìm kiếm lên |
| `n` | Kết quả tìm kiếm tiếp theo |
| `N` | Kết quả tìm kiếm trước đó |
| `q` | Thoát copy mode |
| `C-b y` | Copy dòng hiện tại vào system clipboard (tmux-yank) |
| `C-b Y` | Copy đường dẫn thư mục của pane (tmux-yank) |
| `C-b C-y` | Copy toàn bộ nội dung pane vào macOS clipboard |

### 3.5 Plugin Keybindings

| Keybinding | Hành Động | Plugin |
|------------|-----------|--------|
| `C-b Space` | Bật chế độ thumbs - hiện hints để copy nhanh | tmux-thumbs |
| `C-b \` | Menu chính | tmux-menus |
| `C-b <` | Menu window | tmux-menus |
| `C-b >` | Menu pane | tmux-menus |
| `Right-click` | Context menu | tmux-menus |
| `C-b F` | Fuzzy find sessions/windows/panes | tmux-fzf |
| `C-b p` | Toggle floating terminal | tmux-floax |
| `C-b P` | Floax menu | tmux-floax |
| `C-b C-s` | Lưu session (tmux-resurrect) | tmux-resurrect |
| `C-b C-r` | Khôi phục session (tmux-resurrect) | tmux-resurrect |
| `C-b I` | Cài đặt plugins mới (tpm) | tpm |
| `C-b U` | Cập nhật tất cả plugins (tpm) | tpm |
| `C-b r` | Reload file cấu hình | custom |
| `C-b ?` | Hiển thị popup help cheatsheet | custom |

### 3.6 Terminal Commands

```bash
tmux new -s ten          # Tạo session mới với tên
tmux ls                  # Liệt kê tất cả sessions
tmux attach -t ten       # Attach vào session
tmux kill-session -t ten # Xóa session
tmux kill-session -a     # Xóa tất cả session ngoại trừ session hiện tại
tmux kill-server         # Tắt hoàn toàn tmux server
```

---

## 4. Hướng Dẫn Plugins

### 4.1 tpm - Plugin Manager

**Chức năng**: Quản lý cài đặt và cập nhật plugins.

```
C-b I   → Cài đặt plugins mới (sau khi thêm vào .tmux.conf)
C-b U   → Cập nhật tất cả plugins
C-b u   → Gỡ bỏ plugins không còn dùng
```

**Quy trình thêm plugin mới:**
1. Thêm dòng `set -g @plugin 'ten/plugin'` vào `.tmux.conf`
2. Nhấn `C-b I` để cài đặt

### 4.2 tmux-sensible

**Chức năng**: Áp dụng các cài đặt mặc định hợp lý mà hầu hết mọi người đều muốn. Chạy tự động, không cần thao tác.

Bao gồm: escape time ngắn hơn, history lớn hơn, prefix dễ dùng hơn, v.v.

### 4.3 tmux-yank - Copy Sang System Clipboard

**Chức năng**: Đồng bộ copy từ tmux sang clipboard của macOS.

```
Trong copy mode:
y       → Copy vùng chọn sang system clipboard
Y       → Copy đường dẫn thư mục hiện tại

Ngoài copy mode:
C-b y   → Copy dòng command hiện tại
C-b Y   → Copy pwd của pane
C-b C-y → Copy toàn bộ nội dung pane sang macOS clipboard
```

### 4.4 tmux-resurrect - Lưu/Khôi Phục Session

**Chức năng**: Lưu trạng thái toàn bộ tmux (sessions, windows, panes, layout, thư mục, processes) và khôi phục sau khi restart máy.

```
C-b C-s  → Lưu session ngay bây giờ
C-b C-r  → Khôi phục session đã lưu
```

**Những gì được lưu:**
- Tất cả sessions và tên của chúng
- Tất cả windows và layout
- Tất cả panes và thư mục làm việc
- Tiến trình đang chạy (vim, nvim, less, v.v.)

### 4.5 tmux-continuum - Tự Động Lưu

**Chức năng**: Tự động gọi tmux-resurrect để lưu mỗi 15 phút. Tự động khôi phục khi khởi động tmux server.

Không cần thao tác thủ công - hoạt động hoàn toàn ngầm. Chỉ cần `C-b C-r` một lần sau khi restart máy là mọi thứ trở lại.

### 4.6 vim-tmux-navigator - Di Chuyển Xuyên Suốt

**Chức năng**: Cho phép dùng `C-h/j/k/l` để di chuyển giữa tmux panes VÀ vim/neovim splits mà không cần nhận ra ranh giới giữa chúng.

```
C-h  → Sang trái  (tmux pane hoặc vim split)
C-j  → Xuống dưới
C-k  → Lên trên
C-l  → Sang phải
```

**Hoạt động với**: vim, neovim, fzf

> Không cần prefix. Đây là một trong những tính năng tiết kiệm thời gian nhất.

### 4.7 tmux-thumbs - Copy Nhanh Với Hints

**Chức năng**: Giống như Vimium cho browser - hiển thị chữ cái gợi ý (hints) trên các đoạn văn bản (URL, file path, hash, IP, v.v.) để copy chỉ bằng 1-2 phím.

```
C-b Space  → Bật thumbs mode
           → Màn hình hiển thị các chữ cái gợi ý màu vàng
           → Nhấn chữ cái tương ứng để copy đoạn đó
```

**Ví dụ thực tế:**
- Output có chứa `https://example.com/very/long/url` → nhấn `C-b Space` rồi nhấn hint letter → URL được copy vào clipboard
- Commit hash `a3f2c1d` → tương tự, không cần highlight thủ công

### 4.8 tmux-menus - Context Menus

**Chức năng**: Cung cấp menu trực quan để thực hiện các thao tác mà không cần nhớ keybinding.

```
C-b \       → Menu chính (tổng hợp các tác vụ)
C-b <       → Menu window (đổi tên, đóng, chia, v.v.)
C-b >       → Menu pane (zoom, swap, layout, v.v.)
Right-click → Context menu tùy theo vị trí chuột
```

**Hữu ích khi**: Bạn quên keybinding hoặc muốn khám phá các tùy chọn có sẵn.

### 4.9 tmux-fzf - Fuzzy Find

**Chức năng**: Giao diện fuzzy search để tìm kiếm và chuyển đổi nhanh giữa sessions, windows, panes.

```
C-b F  → Mở tmux-fzf
       → Chọn loại: Session / Window / Pane / Command
       → Gõ để filter
       → Enter để chuyển đến
```

**Ví dụ**: Có 5 sessions và 20 windows, gõ `proj` để lọc ngay những thứ liên quan đến "project".

### 4.10 tmux-floax - Floating Terminal

**Chức năng**: Terminal nổi (popup) có thể mở/đóng nhanh, tồn tại độc lập với layout hiện tại.

```
C-b p  → Toggle floating terminal (mở/đóng)
C-b P  → Mở Floax menu (thay đổi kích thước, vị trí)
```

**Use case điển hình:**
- Chạy lệnh nhanh mà không muốn mở window mới
- Tra cứu, chạy git command, kiểm tra file
- Đóng lại ngay khi xong, layout cũ không bị ảnh hưởng

### 4.11 Catppuccin/tmux - Theme

**Chức năng**: Theme Catppuccin Mocha với màu sắc nhất quán, dễ đọc. Tự động, không cần thao tác.

---

## 5. Thanh Trạng Thái (Status Bar)

Thanh trạng thái thay đổi màu sắc và nội dung tùy theo chế độ hiện tại, giúp bạn biết mình đang ở trạng thái nào.

### Chế Độ Bình Thường (Normal)

```
[ myproject ]                              ?:help · Spc:copy · F:fzf | 14:30
  ^                                         ^                           ^
  Màu xanh                              Gợi ý phím                   Giờ
  Tên session
```

- Bên trái: Tên session - màu **xanh lam**
- Bên phải: Gợi ý `?:help · Spc:copy · F:fzf` + giờ hiện tại

### Chế Độ PREFIX (Sau Khi Nhấn C-b)

```
[ PREFIX ]                                 c:win · d:detach · ?:help | 14:30
  ^                                         ^
  Màu cam                               Gợi ý thay đổi - phím thường dùng
```

- Bên trái: Chữ **PREFIX** - màu **cam**
- Gợi ý: `c:win · d:detach · ?:help` (nhắc bạn các phím hay dùng nhất)
- Trạng thái này tự biến mất sau khi nhấn phím tiếp theo hoặc nhấn `Escape`

### Chế Độ COPY

```
[ COPY ]                                   v:sel · y:yank · q:quit | 14:30
  ^                                         ^
  Màu đỏ                               Gợi ý thao tác trong copy mode
```

- Bên trái: Chữ **COPY** - màu **đỏ**
- Gợi ý: `v:sel · y:yank · q:quit` (nhắc bạn các phím trong vi copy mode)
- Thoát bằng `q`

---

## 6. Workflow Thực Tế

### Scenario 1: Phát Triển Web App

```
Session: webapp

Window 1: editor     → nvim src/
Window 2: server     → npm run dev
Window 3: git        → git operations
Window 4: logs       → tail -f logs/app.log
```

**Cách thiết lập:**

```bash
tmux new -s webapp

# Window 1 - editor
# (đã ở window 1 mặc định)
nvim src/

# Window 2 - server
C-b c
# đổi tên: C-b ,  → gõ "server" → Enter
npm run dev

# Window 3 - git
C-b c
C-b ,  → "git"

# Window 4 - logs
C-b c
C-b ,  → "logs"
tail -f logs/app.log

# Di chuyển nhanh:
C-b 1  → editor
C-b 2  → server
C-b F  → fuzzy find bất kỳ
```

### Scenario 2: Debug Với Split Panes

```
┌─────────────────────┬───────────────────┐
│                     │                   │
│   nvim (editor)     │   test output     │
│                     │                   │
├─────────────────────┴───────────────────┤
│          application logs               │
└─────────────────────────────────────────┘
```

**Cách thiết lập:**

```bash
# Bắt đầu với một pane
nvim .

# Chia đôi phải: C-b %
# Pane phải: chạy tests
npm test --watch

# Từ pane phải, chia xuống: C-b "
# Pane dưới: xem logs
tail -f app.log

# Di chuyển:
C-h  → sang editor
C-l  → sang test output
C-j  → xuống logs

# Zoom vào editor khi cần đọc kỹ:
C-h  → vào editor pane
C-b z  → zoom toàn màn hình
C-b z  → unzoom
```

### Scenario 3: Làm Việc Với Nhiều Projects

```
Session: frontend   → React app
Session: backend    → Node.js API
Session: infra      → Terraform, kubectl
```

```bash
# Tạo các sessions
tmux new -s frontend
# detach: C-b d

tmux new -s backend
# detach: C-b d

tmux new -s infra

# Chuyển đổi:
C-b s    → xem dạng cây, chọn session
C-b (    → session trước
C-b )    → session tiếp theo
C-b F    → fuzzy find theo tên
```

### Scenario 4: Dùng Floating Terminal

```bash
# Đang làm việc trong editor
nvim src/components/Button.tsx

# Cần chạy git command nhanh
C-b p   → floating terminal mở ra

git log --oneline -10
git diff HEAD~1

C-b p   → đóng floating terminal, quay về editor
# Layout không thay đổi gì cả
```

### Scenario 5: SSH Và Remote Work

```bash
# Local terminal
tmux new -s remote-work

# SSH vào server
ssh user@server.example.com

# Trên server, tạo tmux session riêng
tmux new -s deploy

# Chạy deployment (kể cả mất kết nối, session vẫn chạy)
./deploy.sh

# Detach: C-b d
# Đóng laptop...

# Ngày hôm sau, SSH lại
ssh user@server.example.com
tmux attach -t deploy
# Xem kết quả deploy
```

---

## 7. Hướng Dẫn Copy & Paste

Có 3 phương pháp copy, mỗi phương pháp phù hợp với use case khác nhau.

### Phương Pháp 1: Chuột (Nhanh Nhất)

1. Giữ chuột và kéo để chọn văn bản
2. Văn bản tự động được copy vào clipboard
3. Paste bằng `Cmd+V` (macOS)

**Khi nào dùng**: Copy nhanh đoạn ngắn, URL, tên file.

> **Mẹo**: Nếu muốn dùng chuột của terminal thay vì tmux (ví dụ để copy trong vim), giữ `Option` khi click để bypass tmux mouse mode.

### Phương Pháp 2: Vi Copy Mode (Chính Xác Nhất)

```
1. C-b [          → vào copy mode (góc phải hiển thị vị trí con trỏ)
2. Dùng hjkl      → di chuyển đến điểm bắt đầu
3. v              → bắt đầu chọn (visual mode)
4. hjkl/w/b/e    → mở rộng vùng chọn
5. y              → copy sang system clipboard
6. (tự động thoát copy mode)
7. Cmd+V          → paste ở bất kỳ đâu
```

**Shortcuts hữu ích trong copy mode:**

| Phím | Di Chuyển |
|------|-----------|
| `0` | Đầu dòng |
| `$` | Cuối dòng |
| `w` | Tiến một từ |
| `b` | Lùi một từ |
| `gg` | Đầu buffer |
| `G` | Cuối buffer |
| `C-u` | Lên nửa trang |
| `C-d` | Xuống nửa trang |
| `/tu-khoa` | Tìm kiếm (nhấn Enter, dùng n/N) |

**Khi nào dùng**: Copy nhiều dòng, copy chính xác từ vị trí A đến B, copy kết quả command dài.

### Phương Pháp 3: tmux-thumbs (Thông Minh Nhất)

```
1. C-b Space      → bật thumbs mode
2.                → màn hình overlay hiện hints (chữ cái màu vàng)
3. Nhấn hint      → đoạn tương ứng được copy ngay
```

**Tự động nhận diện và đặt hints cho:**
- URLs (`https://...`, `http://...`)
- File paths (`/home/user/file.txt`, `./src/component.tsx`)
- Git hashes (`a3f2c1d`)
- IP addresses
- Hex codes
- Số version (`1.2.3`)
- Và nhiều pattern khác

**Khi nào dùng**: Copy URL trong terminal output, copy commit hash, copy path từ error message. Nhanh hơn copy mode vì không cần navigate.

### Phương Pháp Đặc Biệt: Copy Toàn Bộ Pane

```bash
C-b C-y    # Copy toàn bộ nội dung pane vào macOS clipboard
```

**Khi nào dùng**: Muốn lưu toàn bộ output của một lệnh dài, copy toàn bộ log để paste vào editor hoặc gửi cho người khác.

---

## 8. Lưu & Khôi Phục Session

### Lưu Thủ Công

```
C-b C-s   → lưu ngay lập tức
```

Hiển thị thông báo ở cuối màn hình xác nhận đã lưu. Session được lưu vào `~/.local/share/tmux/resurrect/`.

### Lưu Tự Động

tmux-continuum tự động lưu **mỗi 15 phút**. Không cần làm gì.

### Khôi Phục

```
C-b C-r   → khôi phục session đã lưu lần gần nhất
```

**Workflow sau khi restart máy:**
```
1. Mở terminal
2. tmux           → tmux-continuum tự động khôi phục
   HOẶC
   tmux new       → rồi C-b C-r để khôi phục thủ công
3. Tất cả sessions, windows, panes, thư mục được phục hồi
```

### Kiểm Tra Files Đã Lưu

```bash
ls ~/.local/share/tmux/resurrect/
# last → symlink đến file lưu gần nhất
```

---

## 9. Xử Lý Sự Cố

### "Prefix key không hoạt động"

**Triệu chứng**: Nhấn `C-b` rồi phím khác nhưng không có gì xảy ra.

**Nguyên nhân thường gặp:**
- Đang ở trong vim/neovim và vim đang nhận `C-b`
- Terminal focus đang ở chỗ khác

**Giải pháp:**
1. Nhấn `Escape` trước để thoát các chế độ input
2. Click vào pane tmux để đảm bảo focus đúng
3. Thử `C-b C-b` để gửi `C-b` thật sự vào terminal (nếu cần prefix trong chương trình)

### "C-h/j/k/l không di chuyển được giữa panes"

**Nguyên nhân**: vim-tmux-navigator chưa được cài trong vim/neovim.

**Giải pháp:**
- Cài plugin `christoomey/vim-tmux-navigator` trong vim/neovim config
- Dùng `C-b q` để xem số pane rồi `C-b q <số>` để nhảy thủ công

### "Copy không vào system clipboard"

**Triệu chứng**: Nhấn `y` trong copy mode nhưng không paste được ở nơi khác.

**Giải pháp:**
1. Kiểm tra tmux-yank đã được cài: `C-b I` để cài lại
2. Thử `C-b C-y` để copy toàn pane và kiểm tra
3. Reload config: `C-b r`

### "Session bị mất sau khi restart"

**Nguyên nhân**: tmux-continuum chưa khôi phục, hoặc lưu chưa kịp.

**Giải pháp:**
1. Kiểm tra file lưu: `ls ~/.local/share/tmux/resurrect/`
2. Nếu có file: `C-b C-r` để khôi phục thủ công
3. Đảm bảo `.tmux.conf` có: `set -g @continuum-restore 'on'`

### "Màn hình bị vỡ/chữ bị lệch"

**Giải pháp:**
```
C-b r      → reload config
```
Hoặc trong terminal:
```bash
tmux refresh-client -S
```

### "Không thấy plugin hoạt động sau khi thêm vào .tmux.conf"

**Giải pháp:**
1. Lưu `.tmux.conf`
2. `C-b r` để reload config
3. `C-b I` để cài plugin mới
4. Chờ tải xong, nhấn `Enter`

### "tmux-thumbs không hiện hints"

**Nguyên nhân**: Không có pattern nào khớp trên màn hình.

**Giải pháp**: Đảm bảo có URL, path, hoặc hash trên màn hình trước khi nhấn `C-b Space`.

### Reload Config

```bash
C-b r        # Trong tmux - cách nhanh nhất

# Hoặc từ terminal:
tmux source-file ~/.tmux.conf
```

---

## 10. Tùy Chỉnh Cấu Hình

File cấu hình: `~/.tmux.conf`

Sau mỗi thay đổi: `C-b r` để reload.

### Đổi Prefix Key

```bash
# Đổi sang C-a (phổ biến, dễ nhấn hơn C-b)
unbind C-b
set -g prefix C-a
bind C-a send-prefix
```

> **Lưu ý**: Nếu đổi prefix, vim-tmux-navigator vẫn dùng `C-h/j/k/l` không đổi.

### Thêm Keybinding Tùy Chỉnh

```bash
# Ví dụ: C-b e để mở editor nhanh
bind e new-window -n "editor" nvim

# Ví dụ: C-b g để mở lazygit
bind g new-window -n "git" lazygit

# Ví dụ: split và giữ thư mục hiện tại (đã có sẵn trong config)
bind % split-window -h -c "#{pane_current_path}"
bind '"' split-window -v -c "#{pane_current_path}"
```

### Thay Đổi Thời Gian Auto-Save

```bash
# Lưu mỗi 5 phút thay vì 15 phút
set -g @continuum-save-interval '5'
```

### Tăng/Giảm History

```bash
# Tăng lên 100,000 dòng
set -g history-limit 100000
```

### Thêm Plugin Mới

```bash
# Thêm vào ~/.tmux.conf:
set -g @plugin 'author/plugin-name'

# Lưu file, sau đó:
# C-b r  (reload)
# C-b I  (cài plugin)
```

### Kiểm Tra Cấu Hình Hiện Tại

```bash
# Xem tất cả options đang active
tmux show-options -g

# Xem keybindings đang active
tmux list-keys

# Xem thông tin session/window/pane
tmux display-message -p "#{session_name}:#{window_index}.#{pane_index}"
```

---

## Tham Khảo Nhanh - Cheat Sheet

```
SESSION
  C-b d        detach          C-b s        list sessions
  C-b $        rename          C-b ( / )    prev/next session
  C-b w        sessions+windows tree

WINDOW
  C-b c        new             C-b ,        rename
  C-b n / p    next/prev       C-b 1-9      jump to #
  C-b &        close           C-b l        last window

PANE
  C-b %        split right     C-b "        split down
  C-b x        close           C-b z        zoom toggle
  C-h/j/k/l   navigate        C-b q        show numbers
  C-b { / }    swap            C-b Space    cycle layout

COPY MODE
  C-b [        enter           q            exit
  v            select          y            yank
  / ?          search fwd/bck  n / N        next/prev

PLUGINS
  C-b Space    thumbs hints    C-b F        fzf find
  C-b p        float toggle    C-b \        main menu
  C-b C-s      save session    C-b C-r      restore session
  C-b r        reload config   C-b ?        help popup
  C-b I        install plugins C-b U        update plugins
```

---

*Tài liệu này được tạo cho cấu hình tmux với 11 plugins trên macOS. Cập nhật lần cuối: 2026-03-21.*
