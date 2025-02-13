extends Area2D

var shooting = false
var shootingDirection
const SPEED = 500.0
@export var damage = 20
var durability = 1

func shoot(direction: Vector2):
	shooting = true
	shootingDirection = direction
	self.rotation = atan2(direction.y, direction.x)
	
func hit():
	durability -= 1
	if durability <= 0:
		queue_free()
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if shooting:
		position += shootingDirection * SPEED * delta
	
