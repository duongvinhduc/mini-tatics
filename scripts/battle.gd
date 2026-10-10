class_name Battle
extends Node2D

const GRID_SIZE: int = 8
const CELL_SIZE: int = 128
const GRID_PIXEL_SIZE: int = GRID_SIZE * CELL_SIZE
const GRID_ORIGIN: Vector2 = Vector2(28, 528)
const GRID_BACKGROUND_COLOR: Color = Color(0.16, 0.19, 0.22, 1.0)
const GRID_LINE_COLOR: Color = Color(0.55, 0.59, 0.62, 1.0)


func _draw() -> void:
	draw_rect(
		Rect2(GRID_ORIGIN, Vector2(GRID_PIXEL_SIZE, GRID_PIXEL_SIZE)),
		GRID_BACKGROUND_COLOR
	)

	for line_index: int in range(GRID_SIZE + 1):
		var line_offset: float = float(line_index * CELL_SIZE)
		var line_start: Vector2 = GRID_ORIGIN + Vector2(line_offset, 0.0)
		var line_end: Vector2 = GRID_ORIGIN + Vector2(line_offset, GRID_PIXEL_SIZE)
		draw_line(line_start, line_end, GRID_LINE_COLOR, 2.0)

		line_start = GRID_ORIGIN + Vector2(0.0, line_offset)
		line_end = GRID_ORIGIN + Vector2(GRID_PIXEL_SIZE, line_offset)
		draw_line(line_start, line_end, GRID_LINE_COLOR, 2.0)


func cell_to_pixel(cell: Vector2i) -> Vector2:
	return GRID_ORIGIN + Vector2(cell * CELL_SIZE) + Vector2(CELL_SIZE / 2.0, CELL_SIZE / 2.0)


func pixel_to_cell(pixel: Vector2) -> Vector2i:
	var local_position: Vector2 = pixel - GRID_ORIGIN
	return Vector2i(floori(local_position.x / CELL_SIZE), floori(local_position.y / CELL_SIZE))
