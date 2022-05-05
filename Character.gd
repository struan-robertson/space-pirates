extends KinematicBody2D

var velocity = Vector2()

var health
var speed
var attack_damage

var projectile: PackedScene

# 0 => right
# 1 => left
var direction = 0

func take_damage(damage):
	health -= damage
	if health <= 0:
		get_node("AnimatedSprite").play("death")

func shoot(target: Vector2):
	if global_position.x - target.x > 0:
		look_left()
	elif global_position.x - target.x < 0:
		look_right()
		
	var p = projectile.instance()

	p.init(1000, attack_damage)
	
	get_tree().get_root().add_child(p)

	p.transform = Transform2D(target.angle_to_point($Muzzle.global_position), $Muzzle.global_position)
	
	$Timer.start(0.4)

func look_right():
	if direction != 0:
		set_global_transform(Transform2D(Vector2(1,0),Vector2(0,1),Vector2(position.x,position.y)))
		direction = 0
		
func look_left():
	if direction != 1:
		set_global_transform(Transform2D(Vector2(-1,0),Vector2(0,1),Vector2(position.x,position.y)))
		direction = 1

func init(health:int, speed:int, attack_damage:int):
	self.health = health
	self.speed = speed
	self.attack_damage = attack_damage
