class_name Unit
extends Node2D

@export var is_player: bool = true
@export var max_hp: int = 15
@export var hp: int = 15

const BODY_SIZE: Vector2 = Vector2(72.0, 72.0)
const HP_BAR_SIZE: Vector2 = Vector2(88.0, 12.0)
const PLAYER_COLOR: Color = Color(0.20, 0.55, 0.95, 1.0)
const ENEMY_COLOR: Color = Color(0.88, 0.24, 0.22, 1.0)
const HP_BACKGROUND_COLOR: Color = Color(0.18, 0.18, 0.18, 1.0)
const HP_COLOR: Color = Color(0.25, 0.85, 0.35, 1.0)
const OUTLINE_COLOR: Color = Color(0.95, 0.95, 0.95, 1.0)


func _draw() -> void:
	var team_color: Color = PLAYER_COLOR if is_player else ENEMY_COLOR
	var body_rect: Rect2 = Rect2(-BODY_SIZE / 2.0, BODY_SIZE)
	draw_rect(body_rect, team_color)
	draw_rect(body_rect, OUTLINE_COLOR, false, 3.0)

	var bar_position: Vector2 = Vector2(-HP_BAR_SIZE.x / 2.0, -BODY_SIZE.y / 2.0 - 22.0)
	draw_rect(Rect2(bar_position, HP_BAR_SIZE), HP_BACKGROUND_COLOR)
	var hp_ratio: float = clampf(float(hp) / float(max_hp), 0.0, 1.0)
	draw_rect(Rect2(bar_position, Vector2(HP_BAR_SIZE.x * hp_ratio, HP_BAR_SIZE.y)), HP_COLOR)
	draw_rect(Rect2(bar_position, HP_BAR_SIZE), OUTLINE_COLOR, false, 2.0)
