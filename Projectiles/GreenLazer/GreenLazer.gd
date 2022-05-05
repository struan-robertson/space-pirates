extends "res://Projectiles/Projectile.gd"

func _on_GreenLazer_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if !body:
		return
	if body.is_in_group("detector") || body.is_in_group("mobs") || body.name == "Wall":
		return
	if body.is_in_group("friendly") || body.name == "Barricade":
		body.take_damage(damage)
	queue_free()
