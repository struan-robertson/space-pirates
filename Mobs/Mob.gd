extends "res://Character.gd"

var path: Array
var targets: Array

var gm: GridManager
var player: KinematicBody2D

class_name Mob

func _on_AnimatedSprite_animation_finished():
	if get_node("AnimatedSprite").animation == "death":
		player.add_points(100)
		queue_free()

func lineOfSight(target: Vector2) -> bool:	
	
	var excludes = get_tree().get_nodes_in_group("mobs")
	excludes.append_array(get_tree().get_nodes_in_group("projectile"))
	
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray(global_position, target, excludes)

	if !result:
		return false
	
	if result["collider"] == targets[0]:
		return true
	else:
		return false

func what_can_i_see():
	for target in targets:
		if target != null:
			if target.name == "Sentry":
				if lineOfSight(target.get_global_position() + Vector2(48, 48)):
					return target
		if lineOfSight(target.get_global_position()):
			return target

func _physics_process(delta):
	if health <= 0:
		return
	if $Timer.time_left == 0:
		if global_position.y < -1850:
			shoot(Vector2(1875, -2251))
			return
			
		if targets.size() > 0:
			var visible = what_can_i_see()
			if visible:
				velocity = 0
				shoot(visible.global_position)
				$AnimatedSprite.play("shoot")
				return
	
		if path.size() != 0:
			velocity = (path[0] - global_position).normalized() * speed
			if (path[0] - global_position).length() >= 20:
				velocity = move_and_slide(velocity)
				$AnimatedSprite.play("run")
				return
			else:
				path.remove(0)
				return
				
		$AnimatedSprite.play("idle")

func on_map_changed():
	path = gm.get_move_path(global_position, Vector2(1875, -2251))

func _on_Mob_ready():
	gm.connect("grid_refreshed", self, "on_map_changed")
	path = gm.get_move_path(global_position, Vector2(1875, -2251))
