# AGENTS.md

Game mobile 2D tactical theo lượt "Mini Tactics", **Godot 4.x + GDScript**.
Người làm là junior. Giải thích ngắn gọn bạn đã làm gì.
Luật chơi và danh sách bước nằm trong `game-design-document.md`: **chỉ đọc khi bắt đầu một bước mới**, không đọc lại mỗi lần.

## Quy tắc

1. Mỗi lần **chỉ làm đúng một bước** người dùng yêu cầu. Không làm trước bước sau, không thêm tính năng ngoài yêu cầu.
2. Yêu cầu mơ hồ hoặc mâu thuẫn với GDD thì **hỏi lại**.
3. Code đơn giản, dễ đọc. Không dùng plugin/thư viện ngoài khi chưa hỏi.
4. Không đổi tên hay chuyển file hàng loạt khi chưa được yêu cầu.
5. Làm xong thì nói cách kiểm tra: mở scene nào, bấm Run, kỳ vọng thấy gì.
6. Khi có lỗi: đọc kỹ thông báo, sửa đúng nguyên nhân, không viết lại cả file.

## Cú pháp Godot 4 (bắt buộc)

- `@export`, `@onready`; `CharacterBody2D`, `Node2D`, `Area2D`.
- Tín hiệu: `node.signal_name.connect(callable)`.
- `await` thay cho `yield`.
- Có static typing: `var hp: int = 10`, `func take_damage(amount: int) -> void:`.
- `snake_case` cho biến/hàm, `PascalCase` cho class/node, `UPPER_SNAKE_CASE` cho hằng số.
- Nếu tham khảo code/tutorial Godot 3 thì **phải chuyển sang Godot 4**, không chép nguyên.

## Thiết kế code

- Màn hình 1080x1920 portrait, stretch `canvas_items`, aspect `expand`. Bản đồ 8x8, ô 128 px.
- **Tách logic khỏi hiển thị**: lưới, tìm đường (BFS theo bước ngang/dọc), tính sát thương nằm trong script riêng, không trộn vào code vẽ.
- Trạng thái trận đấu dùng `enum`: `PLAYER_SELECT`, `PLAYER_MOVE`, `PLAYER_ACTION`, `ENEMY_TURN`, `GAME_OVER`. Không cần mẫu thiết kế phức tạp hơn.
- Chỉ số quân (HP, ATK, MOV, RANGE) khai báo bằng `@export` hoặc `const`, không viết cứng rải rác.
- Giai đoạn đầu chưa dùng ảnh: vẽ bằng ColorRect/Polygon2D.

## Thư mục

`scenes/` (.tscn), `scripts/` (.gd cùng tên scene), `assets/`. Mỗi scene một script cùng tên.

## Git

Đề xuất commit message ngắn sau mỗi bước chạy được. Không tự `git push`, không sửa thư mục `.godot/`.

## Ngoài phạm vi

Cốt truyện, lên cấp, trang bị, multiplayer, quảng cáo, mua trong app. Khi một bước xong và được xác nhận, đánh `[x]` trong GDD.