extends "res://Props/Doors/Door.gd"

func take_damage(damage):
	health -= damage
	$TextureProgress.value = health
	if health <= 0:
		$AnimatedSprite.play("open")
		open = true

func _on_AnimatedSprite_animation_finished():
	if open == true:
		$AnimatedSprite.play("open")
		$CollisionShape2D.disabled = true
	else:
		$AnimatedSprite.play("idle")
		$CollisionShape2D.disabled = false
	

func _on_Area2D_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body.name == "Player":
		$AnimatedSprite.play("opening")
		open = true

func _on_Area2D_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	if body == null:
		return
	if body.name == "Player":
		$AnimatedSprite.play("opening", true)
		open = false
