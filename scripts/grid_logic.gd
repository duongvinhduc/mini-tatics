class_name GridLogic
extends RefCounted

const GRID_SIZE: int = 8
const DIRECTIONS: Array[Vector2i] = [
	Vector2i.RIGHT,
	Vector2i.LEFT,
	Vector2i.UP,
	Vector2i.DOWN,
]


static func get_reachable_cells(
	start: Vector2i,
	movement_range: int,
	occupied_cells: Array[Vector2i]
) -> Array[Vector2i]:
	var reachable: Array[Vector2i] = []
	var visited: Dictionary = {start: 0}
	var cells_to_check: Array[Vector2i] = [start]
	var cell_index: int = 0

	while cell_index < cells_to_check.size():
		var current_cell: Vector2i = cells_to_check[cell_index]
		var steps_taken: int = visited[current_cell]
		cell_index += 1

		if steps_taken >= movement_range:
			continue

		for direction: Vector2i in DIRECTIONS:
			var next_cell: Vector2i = current_cell + direction
			if not _is_inside_grid(next_cell):
				continue
			if visited.has(next_cell) or occupied_cells.has(next_cell):
				continue

			visited[next_cell] = steps_taken + 1
			reachable.append(next_cell)
			cells_to_check.append(next_cell)

	return reachable


static func _is_inside_grid(cell: Vector2i) -> bool:
	return cell.x >= 0 and cell.x < GRID_SIZE and cell.y >= 0 and cell.y < GRID_SIZE
