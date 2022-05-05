extends "res://Character.gd"

const Sentry = preload("res://Defenses/Sentry/Sentry.tscn")
const Barricade = preload("res://Defenses/Barricade/Barricade.tscn")

var gm :GridManager

var points = 0

func add_points(amount: int):
	points += amount
	PlayerScore.score += amount

func get_input():
	velocity = Vector2()
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
		look_right()
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
		look_left()
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	velocity = velocity.normalized() * speed

func heal(aim: Vector2):
	if global_position.distance_to(aim) <= 200:
		var amount = 1000 - health
		print(amount)
		if amount >= 0:
			health += amount
			points -= amount

func build(aim: Vector2, type: int):
	if global_position.distance_to(aim) <= 200:
		if gm.tile_used(aim):
			return
		if type == 0 && points >= 200:
			var sentry = Sentry.instance()
			sentry.global_position = aim
			sentry.gm = gm
			get_parent().add_child(sentry)
			gm.reserve_cell(aim)
			points -= 200
		elif points >= 50 && type == 1:
			var barricade = Barricade.instance()
			barricade.global_position = aim
			get_parent().add_child(barricade)
			gm.reserve_cell(aim)
			points -= 50

func _physics_process(delta):
	
	$Label.text = str(points)
	
	$TextureProgress.value = health 
	
	if health <= 0:
		get_tree().change_scene("res://UI/EndGame.tscn")
	if $Timer.time_left == 0:
		get_input()
		velocity = move_and_slide(velocity)
		if Input.is_action_pressed("ui_shoot"):
			velocity.x = 0
			velocity.y = 0
			$AnimatedSprite.play("shoot")
			shoot(get_global_mouse_position())
			return
		elif velocity.x != 0 || velocity.y != 0:
			$AnimatedSprite.play("run")
		else:
			$AnimatedSprite.play("idle")


func _on_Player_tree_entered():
	projectile = preload("res://Projectiles/BlueLaser/BlueLaser.tscn")
	get_tree().get_root().add_child($CanvasLayer)


func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "death":
		queue_free()
