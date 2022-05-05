extends "res://Projectiles/Projectile.gd"

func _on_BlueLaser_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if !body:
		return
	if body.is_in_group("detector") || body.is_in_group("friendly") || body.is_in_group("barricade"):
		return
	if body.is_in_group("mobs"):
		body.take_damage(damage)
	queue_free()
