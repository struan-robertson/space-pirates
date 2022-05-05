extends Mob

func _on_Area2D_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body.is_in_group("door") || body.is_in_group("ship"):
		targets.append(body)

func _on_Area2D_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	if !body || body.is_in_group("door"):
		for mob in targets:
			if mob == body:
				targets.remove(targets.find(mob))

func _on_FloatingRobot_ready():
	projectile = preload("res://Projectiles/GreenLazer/GreenLazer.tscn")
