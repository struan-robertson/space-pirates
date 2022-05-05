extends StaticBody2D

const projectile = preload("res://Projectiles/GreenBall/GreenBall.tscn")

var target = []
var health = 1500
var attack_damage = 20

var gm: GridManager

# 0 => right
# 1 => left
var direction = 0

func look_right():
	if direction != 0:
		set_global_transform(Transform2D(Vector2(1,0),Vector2(0,1),Vector2(position.x,position.y)))
		global_position += Vector2(-96, 0)
		direction = 0
		
func look_left():
	if direction != 1:
		set_global_transform(Transform2D(Vector2(-1,0),Vector2(0,1),Vector2(position.x,position.y)))
		global_position += Vector2(96, 0)
		direction = 1

func take_damage(damage):
	health -= damage
	if health <= 0:
		gm.free_cell(global_position)
		queue_free()

func lineOfSight(aim: Vector2) -> bool:	
	var space_state = get_world_2d().direct_space_state
	
	var excludes = get_tree().get_nodes_in_group("fiendly")
	excludes.append_array(get_tree().get_nodes_in_group("projectile"))
	excludes.append_array(get_tree().get_nodes_in_group("barricade"))
	excludes.append(self)
	
	var result = space_state.intersect_ray(global_position, aim, excludes)
	
	if !result:
		return false
	
	if result["collider"].is_in_group("mobs"):
		return true
	else:
		return false

func shoot(aim: Vector2):
	
	if !lineOfSight(aim):
		return
		
	$AnimatedSprite.play("shoot")
	
	if global_position.x - aim.x > 0:
		look_left()
	elif global_position.x - aim.x < 0:
		look_right()
		
	var p = projectile.instance()

	p.init(1000, attack_damage)
	
	get_tree().get_root().add_child(p)

	p.transform = Transform2D(aim.angle_to_point($Muzzle.global_position), $Muzzle.global_position)
	
	$Timer.start(0.6)

func flame(first: Vector2):
	if global_position.x - first.x > 0:
		look_left()
	elif global_position.x - first.x < 0:
		look_right()
		
	$AnimatedSprite.play("fire")
	
	for mob in target:
		if global_position.distance_to(mob.global_position) < 150:
			mob.take_damage(50)
	
	$Timer.start(1)

func _on_Area2D_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body.is_in_group("mobs"):
		target.append(body)

func _on_Area2D_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	if !body || body.is_in_group("mobs"):
		for mob in target:
			if mob == body:
				target.remove(target.find(mob))

func _physics_process(delta):
	if health <= 0:
		return
	
	if $Timer.time_left == 0:
		if target.size() > 0:
			if global_position.distance_to(target[0].global_position) < 150:
				flame(target[0].global_position)
			else:
				shoot(target[0].global_position)
		else:
			$AnimatedSprite.play("idle")
		
