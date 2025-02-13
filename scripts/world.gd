extends Node2D

var chickenScene = preload("res://characters/chicken.tscn")
var player 
var rng
const X_RANGE = Vector2(16, 1456)
const Y_RANGE = Vector2(16, 656)

const CHICKEN_SPAWN_RATE = 1
var timeSinceChickenSpawn = 0

@export var paused = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	player = get_node("Player")
	
func spawnChicken():
	var positionBlocked = true
	var testArea = Area2D.new()
	var collisionShape = CircleShape2D.new()
	collisionShape.radius = 15
	var collision = CollisionShape2D.new()
	collision.shape = collisionShape
	testArea.add_child(collision)
	self.add_child(testArea)
	
	var xCoordinate
	var yCoordinate
	
	while positionBlocked:
		var minX = min(X_RANGE[0], player.position.x - 200)
		var maxX = min(X_RANGE[1], player.position.x + 200)
		xCoordinate = randi_range(minX, maxX)
		var minY = min(X_RANGE[1], player.position.y - 200)
		var maxY = min(X_RANGE[1], player.position.y + 200)
		yCoordinate = randi_range(minY, maxY)
		testArea.position = Vector2(xCoordinate, yCoordinate)
		if len(testArea.get_overlapping_areas()) > 0 or len(testArea.get_overlapping_bodies()) > 0:
			positionBlocked = true
		else:
			positionBlocked = false

	testArea.queue_free()
	
	var chicken = chickenScene.instantiate()
	$Mobs.add_child(chicken)
	chicken.position = Vector2(xCoordinate, yCoordinate)
	

func _process(delta: float) -> void:
	timeSinceChickenSpawn += delta
	if timeSinceChickenSpawn >= CHICKEN_SPAWN_RATE:
		timeSinceChickenSpawn -= CHICKEN_SPAWN_RATE
		spawnChicken()
