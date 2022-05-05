extends Area2D

var speed
var damage

func _physics_process(delta):
	position += transform.x * speed * delta

func init(speed:int, damage:int):
	self.speed = speed
	self.damage = damage
