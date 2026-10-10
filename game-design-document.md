# Game Design Document: Mini Tactics

## 1. Tổng quan

- **Thể loại:** Tactical RPG theo lượt trên ô lưới (kiểu Fire Emblem / Tear Ring Saga, bản rút gọn).
- **Nền tảng:** Mobile (Android + iOS), màn hình dọc.
- **Engine:** Godot 4.x, GDScript, 2D.
- **Ý tưởng một câu:** Điều khiển 3 quân trên bản đồ 8x8, lần lượt di chuyển và tấn công để tiêu diệt 3 quân địch trước khi bị diệt hết.
- **Một ván chơi:** khoảng 3 đến 5 phút.
- **Nguyên tắc:** làm bản nhỏ nhất chơi được trước, mở rộng sau. Phiên bản đầu KHÔNG có cốt truyện, cấp độ, trang bị.

## 2. Luật chơi (phiên bản đầu, giai đoạn 1)

### Bản đồ
- Lưới **8 cột x 8 hàng**, mỗi ô 128 px (bản đồ rộng 1024 px, nằm giữa màn hình 1080 x 1920).
- Phía trên bản đồ: thanh thông tin (lượt hiện tại). Phía dưới: bảng thông tin quân đang chọn và nút "Kết thúc lượt".
- Giai đoạn 1: bản đồ trống, không vật cản. Vật cản thêm ở giai đoạn 2.

### Quân
Mỗi quân có: máu (HP), sức tấn công (ATK), số ô di chuyển (MOV), tầm đánh (RANGE).

| Phe | Số quân | HP | ATK | MOV | RANGE |
|---|---|---|---|---|---|
| Người chơi (xanh) | 3 | 15 | 5 | 3 | 1 |
| Địch (đỏ) | 3 | 12 | 4 | 3 | 1 |

- Sát thương = ATK của bên tấn công. Chưa có phòng thủ, né, chí mạng.
- HP về 0 thì quân biến mất khỏi bản đồ.
- Vị trí xuất phát: người chơi ở hàng dưới cùng, địch ở hàng trên cùng.

### Lượt chơi
1. **Lượt người chơi:** mỗi quân được hành động đúng 1 lần (di chuyển, rồi tấn công hoặc chờ).
2. Khi tất cả quân đã hành động hoặc người chơi bấm "Kết thúc lượt", chuyển sang **lượt địch**.
3. **Lượt địch:** từng quân địch lần lượt hành động (có độ trễ ngắn giữa các quân để người chơi theo dõi được).
4. Hết lượt địch thì quay lại lượt người chơi, tất cả quân được hành động lại.

### Hành động của một quân (người chơi)
1. Chạm vào quân của mình: các ô có thể đi tới sáng lên (màu xanh). Tầm đi tính theo số bước (đi ngang/dọc, không đi chéo), không đi xuyên qua quân khác.
2. Chạm vào một ô sáng: quân di chuyển tới đó.
3. Sau khi di chuyển: các quân địch trong tầm đánh sáng đỏ. Chạm vào địch để tấn công, hoặc bấm nút **"Chờ"** để kết thúc hành động mà không đánh.
4. Có thể tấn công mà không di chuyển: chạm quân, rồi chạm địch trong tầm (hoặc "Chờ" ngay).
5. Chạm ra ngoài trước khi di chuyển để hủy chọn.

### AI địch (giản lược)
Với từng quân địch:
1. Tìm quân người chơi gần nhất (khoảng cách ngang + dọc).
2. Nếu đã trong tầm đánh thì tấn công.
3. Nếu chưa, đi về phía quân đó, dùng hết MOV (chọn ô gần mục tiêu nhất trong tầm đi được), rồi tấn công nếu giờ đã trong tầm.
4. Không có chiến thuật phức tạp: không bao vây, không rút lui.

### Thắng / thua
- **Thắng:** tiêu diệt hết quân địch.
- **Thua:** mất hết quân của mình.

## 3. Điều khiển

- Chỉ cảm ứng: chạm để chọn quân, chạm ô để đi, chạm địch để đánh.
- Khi test trên máy tính: bật "Emulate Touch From Mouse".
- Không cần kéo hay cử chỉ phức tạp.

## 4. Màn hình

| Màn hình | Nội dung |
|---|---|
| **Menu chính** | Tên game, nút "Chơi" |
| **Trận đấu** | Bản đồ, quân, thanh thông tin, bảng quân đang chọn (HP/ATK/MOV), nút "Kết thúc lượt" |
| **Kết quả** | "Thắng" hoặc "Thua", nút "Chơi lại", nút "Về menu" |

## 5. Hiển thị

- **Giai đoạn đầu: không dùng ảnh.** Ô lưới và quân vẽ bằng hình đơn giản của Godot (ColorRect, Polygon2D): quân xanh, quân đỏ, ô sáng xanh (đi được), ô sáng đỏ (đánh được).
- Mỗi quân có thanh máu nhỏ phía trên.
- Sau khi game chạy ổn mới thay bằng sprite miễn phí (Kenney.nl, OpenGameArt) và thêm âm thanh.

## 6. Thông số kỹ thuật

- Độ phân giải thiết kế: **1080 x 1920**, stretch mode `canvas_items`, aspect `expand`, portrait.
- Kích thước ô: 128 px. Số ô: 8 x 8.
- Trạng thái trận đấu quản lý bằng một `enum` đơn giản: `PLAYER_SELECT`, `PLAYER_MOVE`, `PLAYER_ACTION`, `ENEMY_TURN`, `GAME_OVER`.
- Tách logic (lưới, tìm đường, tính sát thương) khỏi phần vẽ để dễ sửa lỗi.

## 7. Kế hoạch làm theo từng bước

Mỗi bước là một lần nhắn cho AI. Xong bước nào thì chạy thử, rồi commit Git trước khi sang bước tiếp.

**Giai đoạn 1: bản chơi được**
- [x] **Bước 1:** Tạo project 1080x1920 portrait, bật emulate touch, một scene Battle trống.
- [x] **Bước 2:** Vẽ lưới 8x8 (ô 128 px), có hàm đổi qua lại giữa toạ độ ô và toạ độ pixel.
- [x] **Bước 3:** Đặt 3 quân xanh và 3 quân đỏ lên đúng ô xuất phát (hình khối đơn giản, có thanh máu).
- [x] **Bước 4:** Chạm quân xanh để chọn: hiện các ô đi được (không đi xuyên quân khác).
- [ ] **Bước 5:** Chạm ô sáng để di chuyển quân tới đó.
- [ ] **Bước 6:** Sau khi đi: hiện địch trong tầm đánh, chạm để tấn công, trừ máu, quân hết máu thì biến mất. Thêm nút "Chờ".
- [ ] **Bước 7:** Mỗi quân chỉ hành động một lần mỗi lượt. Nút "Kết thúc lượt", chuyển sang lượt địch.
- [ ] **Bước 8:** AI địch (đi về phía quân gần nhất, đánh nếu trong tầm), có độ trễ giữa các quân.
- [ ] **Bước 9:** Điều kiện thắng/thua và màn hình kết quả, nút chơi lại.
- [ ] **Bước 10:** Menu chính.

**Giai đoạn 2: mở rộng (chỉ làm sau khi giai đoạn 1 chạy ổn)**
- [ ] **Bước 11:** Thêm vật cản trên bản đồ (quân không đi xuyên qua).
- [ ] **Bước 12:** Thêm loại quân: Cung thủ (RANGE 2, đánh được từ xa), Kỵ sĩ (MOV 4).
- [ ] **Bước 13:** Thay hình khối bằng sprite, thêm âm thanh và hiệu ứng khi đánh.
- [ ] **Bước 14:** Test trên điện thoại thật, export Android rồi iOS.

## 8. Ngoài phạm vi (không làm trong phiên bản đầu)

Cốt truyện và hội thoại, nhiều màn chơi, lên cấp và kinh nghiệm, trang bị và vật phẩm, đòn đánh đặc biệt, sương mù chiến trường, tấn công chéo/địa hình tác động, multiplayer, mua trong app, quảng cáo.
