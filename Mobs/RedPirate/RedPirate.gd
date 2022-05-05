extends Mob

func _on_RedPirate_tree_entered():
	projectile = preload("res://Projectiles/BlueBall/BlueBall.tscn")

func _on_Area2D_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body.is_in_group("friendly") || body.is_in_group("ship"):
		targets.append(body)

func _on_Area2D_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	if !body || body.is_in_group("friendly") && !body.is_in_group("door") || body.is_in_group("ship"):
		for mob in targets:
			if mob == body:
				targets.remove(targets.find(mob))

