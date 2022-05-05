# Adapted from https://github.com/Harrk/godot-astar-microadventure/blob/master/Entities/Managers/GridManager.gd

extends Node

class_name GridManager

var astar: AStar2D

var tilesize = 96

signal grid_refreshed

onready var walls = get_parent().get_node("Floors")

func center(left_pos: Vector2) -> Vector2:
	return left_pos + Vector2(48, -48)

func _ready():
	astar = AStar2D.new()
	generate_grid()
	
func generate_grid():
	astar.clear()
	
	# Get the used area of the tilemap
	var size: Vector2 = walls.get_used_rect().size
	
	# Prepare astar area
	astar.reserve_space(size.x * size.y)

	for cell in walls.get_used_cells():
		
		var cell_id = get_tile_id(cell)
		if cell_id == 62 || cell_id == 98:
			print(" ")
		
		
		if walls.get_cellv(cell) >= 6:
			continue
		
		astar.add_point(cell_id, center(walls.map_to_world(cell)), 1)
	
		var peek_tile_id 
			
		# Neighbours (UP, DOWN, LEFT, RIGHT)\
		var up = Vector2(cell.x, cell.y-1)
		var down = Vector2(cell.x, cell.y+1)
		var left = Vector2(cell.x - 1, cell.y)
		var right = Vector2(cell.x + 1, cell.y)
		
		if walls.get_cell(up.x, up.y) != TileMap.INVALID_CELL:
			peek_tile_id = get_tile_id(up)
			if astar.has_point(peek_tile_id):
				astar.connect_points(cell_id, peek_tile_id, true)
		
		if walls.get_cell(down.x, down.y) != TileMap.INVALID_CELL:
			peek_tile_id = get_tile_id(down)
			if astar.has_point(peek_tile_id):
				astar.connect_points(cell_id, peek_tile_id, true)
		
		if walls.get_cell(left.x, left.y) != TileMap.INVALID_CELL:
			peek_tile_id = get_tile_id(left)
			if astar.has_point(peek_tile_id):
				astar.connect_points(cell_id, peek_tile_id, true)

		if walls.get_cell(right.x, right.y) != TileMap.INVALID_CELL:
			peek_tile_id = get_tile_id(right)
			if astar.has_point(peek_tile_id):
				astar.connect_points(cell_id, peek_tile_id, true)
	
	emit_signal("grid_refreshed")
	
func get_tile_id(tile_pos: Vector2) -> int:
	tile_pos = tile_pos - walls.get_used_rect().position
	return int(tile_pos.x + (tile_pos.y * walls.get_used_rect().size.x))
	
func tile_used(pos: Vector2):
	var mapPos = walls.world_to_map(pos)
	var point_id = get_tile_id(mapPos)
	
	if astar.is_point_disabled(point_id):
		return true
	else:
		return false

func free_cell(pos: Vector2):
	var mapPos = walls.world_to_map(pos)
	var point_id = get_tile_id(mapPos)
	
	if astar.has_point(point_id):
		astar.set_point_disabled(point_id, false)
		
	emit_signal("grid_refreshed")

func reserve_cell(pos: Vector2):
	var mapPos = walls.world_to_map(pos)
	var point_id = get_tile_id(mapPos)
	
	if astar.has_point(point_id):
		astar.set_point_disabled(point_id, true)
		
	emit_signal("grid_refreshed")
	
	
func can_move_to(pos: Vector2) -> bool:
	var mapPos = walls.world_to_map(pos)
	var point_id = get_tile_id(mapPos)
	
	return astar.has_point(point_id) and ! astar.is_point_disabled(point_id)
	
func get_move_path(current_pos: Vector2, target_pos: Vector2) -> Array:
	var start_id = get_tile_id(walls.world_to_map(current_pos))
	var target_id = get_tile_id(walls.world_to_map(target_pos))
	
	if astar.has_point(start_id) && astar.has_point(target_id):
		var p = Array(astar.get_point_path(start_id, target_id))
		
		#super hacky but works perfectly lol
		#not sure why the path is one tile too high
		var corrected: Array
		for v in p:
			v = v + Vector2(0, 96)
			corrected.append(v)
		return corrected
		
	return []
