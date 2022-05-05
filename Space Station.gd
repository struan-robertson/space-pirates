extends Node2D

const Player = preload("res://Player/Player.tscn")

const ArmRobot = preload("res://Mobs/ArmRobot/ArmRobot.tscn")
const GreenPirate = preload("res://Mobs/GreenPirate/GreenPirate.tscn")
const RedPirate = preload("res://Mobs/RedPirate/RedPirate.tscn")
const FloatingRobot = preload("res://Mobs/FloatingRobot/FloatingRobot.tscn")

const SmallDoor = preload("res://Props/Doors/SmallDoor/SmallDoor.tscn")
const BigDoor = preload("res://Props/Doors/BigDoor/BigDoor.tscn")

const GridManager = preload("res://GridManager.gd")

var rng = RandomNumberGenerator.new()

var player = Player.instance()
var gm = GridManager.new()

var health_modifier = 1

func _on_Root_ready():

	add_child(gm)

	for tile in $Walls.get_used_cells():
		gm.reserve_cell($Walls.map_to_world(tile))

	player.position = $PlayerPlaceholder.position
	player.init(1000, 300, 100)
	
	player.gm = gm
	
	add_child(player)
	
	get_tree().get_root().add_child($CanvasLayer)
	
	
func _on_Root_tree_entered():
	var smallDoor = SmallDoor.instance()
	smallDoor.position = Vector2(1873, -1772)
	smallDoor.position.x = 1875
	smallDoor.position.y = -1775
	add_child(smallDoor)
	
	var bD1 = BigDoor.instance()
	bD1.position = Vector2(2115, -1295)
	add_child(bD1)

func spawn_mobs():
	rng.randomize()
	var rand = int(rng.randf_range(1, 5))
	
	match (rand):
		1:
			var arm = ArmRobot.instance()
			arm.init(500 * health_modifier, 50, 100)
			arm.position = Vector2(100, 0)
			arm.gm = gm
			arm.player = player
			
			add_child(arm)
		2:
			var flo = FloatingRobot.instance()
			flo.init(30 * health_modifier, 400, 30)
			flo.position = Vector2(100, 0)
			flo.gm = gm
			flo.player = player
			
			add_child(flo)
		3:
			var green = GreenPirate.instance()
			green.init(100 * health_modifier, 100, 25)
			green.position = Vector2(100, 0)
			green.gm = gm
			green.player = player
		
			add_child(green)
		4:
			var red = RedPirate.instance()
			red.init(150 * health_modifier, 75, 25)
			red.position = Vector2(100, 0)
			red.gm = gm
			red.player = player
			
			add_child(red)
			
func _unhandled_input(event: InputEvent) -> void:
	if not event is InputEventMouseButton:
		return
#	if event.button_index == BUTTON_RIGHT:
#		var new_path = gm.get_move_path(player.global_position, rob.global_position)
#		$Line2D.points = new_path
	if event.button_index == BUTTON_RIGHT:
		var pos = $Walls.world_to_map(get_global_mouse_position())
		var celltype = $Floors.get_cellv(pos)
		if celltype == 4:
			player.build($Walls.map_to_world(pos) + Vector2(0, 58), 0)
			return
		elif celltype == 1 || celltype == 2 || celltype == 5:
			player.build($Walls.map_to_world(pos) + Vector2(48, 48), 1)
			return
		
		pos = $Animated.world_to_map(get_global_mouse_position())
		celltype = $Animated.get_cellv(pos)
		if celltype == 0:
			player.heal(get_global_mouse_position())


func _on_Timer_timeout():
	spawn_mobs()
	health_modifier += 0.01
