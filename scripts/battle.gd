class_name Battle
extends Node2D

const GRID_SIZE: int = 8
const CELL_SIZE: int = 128
const GRID_PIXEL_SIZE: int = GRID_SIZE * CELL_SIZE
const GRID_ORIGIN: Vector2 = Vector2(28, 528)
const GRID_BACKGROUND_COLOR: Color = Color(0.16, 0.19, 0.22, 1.0)
const GRID_LINE_COLOR: Color = Color(0.55, 0.59, 0.62, 1.0)
const MOVE_HIGHLIGHT_COLOR: Color = Color(0.18, 0.62, 0.95, 0.42)
const MOVEMENT_RANGE: int = 3
const GridLogicScript = preload("res://scripts/grid_logic.gd")

var selected_unit: Unit = null
var reachable_cells: Array[Vector2i] = []


func _draw() -> void:
	draw_rect(
		Rect2(GRID_ORIGIN, Vector2(GRID_PIXEL_SIZE, GRID_PIXEL_SIZE)),
		GRID_BACKGROUND_COLOR
	)

	for cell: Vector2i in reachable_cells:
		var highlight_position: Vector2 = GRID_ORIGIN + Vector2(cell * CELL_SIZE)
		draw_rect(Rect2(highlight_position, Vector2(CELL_SIZE, CELL_SIZE)), MOVE_HIGHLIGHT_COLOR)

	for line_index: int in range(GRID_SIZE + 1):
		var line_offset: float = float(line_index * CELL_SIZE)
		var line_start: Vector2 = GRID_ORIGIN + Vector2(line_offset, 0.0)
		var line_end: Vector2 = GRID_ORIGIN + Vector2(line_offset, GRID_PIXEL_SIZE)
		draw_line(line_start, line_end, GRID_LINE_COLOR, 2.0)

		line_start = GRID_ORIGIN + Vector2(0.0, line_offset)
		line_end = GRID_ORIGIN + Vector2(GRID_PIXEL_SIZE, line_offset)
		draw_line(line_start, line_end, GRID_LINE_COLOR, 2.0)


func _input(event: InputEvent) -> void:
	var is_pressed_touch: bool = event is InputEventScreenTouch and event.pressed
	var is_pressed_mouse: bool = (
		event is InputEventMouseButton
		and event.pressed
		and event.button_index == MOUSE_BUTTON_LEFT
	)
	if not is_pressed_touch and not is_pressed_mouse:
		return

	var local_position: Vector2 = make_input_local(event).position
	var clicked_cell: Vector2i = pixel_to_cell(local_position)
	if not _is_inside_grid(clicked_cell):
		return

	if selected_unit != null and reachable_cells.has(clicked_cell):
		_move_selected_unit(clicked_cell)
		return

	_select_player_at_cell(clicked_cell)


func _select_player_at_cell(clicked_cell: Vector2i) -> void:
	for child: Node in get_children():
		if child is Unit:
			var unit: Unit = child
			var unit_cell: Vector2i = pixel_to_cell(unit.position)
			if unit.is_player and unit_cell == clicked_cell:
				selected_unit = unit
				_update_reachable_cells(unit_cell)
				queue_redraw()
				return


func _move_selected_unit(target_cell: Vector2i) -> void:
	if selected_unit == null:
		return

	selected_unit.position = cell_to_pixel(target_cell)
	selected_unit = null
	reachable_cells.clear()
	queue_redraw()


func _update_reachable_cells(start_cell: Vector2i) -> void:
	var occupied_cells: Array[Vector2i] = []
	for child: Node in get_children():
		if child is Unit:
			var unit: Unit = child
			var unit_cell: Vector2i = pixel_to_cell(unit.position)
			if unit != selected_unit:
				occupied_cells.append(unit_cell)

	reachable_cells = GridLogicScript.get_reachable_cells(
		start_cell,
		MOVEMENT_RANGE,
		occupied_cells
	)


func _is_inside_grid(cell: Vector2i) -> bool:
	return cell.x >= 0 and cell.x < GRID_SIZE and cell.y >= 0 and cell.y < GRID_SIZE


func cell_to_pixel(cell: Vector2i) -> Vector2:
	return GRID_ORIGIN + Vector2(cell * CELL_SIZE) + Vector2(CELL_SIZE / 2.0, CELL_SIZE / 2.0)


func pixel_to_cell(pixel: Vector2) -> Vector2i:
	var local_position: Vector2 = pixel - GRID_ORIGIN
	return Vector2i(floori(local_position.x / CELL_SIZE), floori(local_position.y / CELL_SIZE))
