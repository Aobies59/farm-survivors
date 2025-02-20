extends Node2D

var spawnerThread = Thread.new()


var chickenScene = preload("res://scenes/characters/chicken.tscn")
var rng
const X_RANGE = Vector2(16, 1456)
const Y_RANGE = Vector2(12, 656)

const INCREASE_DIFICULTY_INTERVAL = 10
var timeSinceIncreasedDificulty = 0.0

var mobScenes = {
	Global.mobs.CHICKEN: chickenScene
}
var mobDeltas = {
	Global.mobs.CHICKEN: 0
}

var timeSinceChickenSpawn = 0

@export var paused = false

var player: CharacterBody2D
var camera: Camera2D
var testArea: Area2D

var viewportSize: Vector2
var cameraZoom: Vector2

func _ready() -> void:
	player = get_node("Player")	
	camera = player.get_node("Camera2D")
	viewportSize = Vector2(get_viewport_rect().size)
	cameraZoom = Vector2(camera.zoom)
	randomize()
	
	testArea = Area2D.new()
	var collisionShape = CircleShape2D.new()
	collisionShape.radius = 15
	var collision = CollisionShape2D.new()
	collision.shape = collisionShape
	testArea.add_child(collision)
	self.add_child(testArea)
	
func spawnMob(mobName):
	var smallXRange = range(X_RANGE[0], player.position.x - viewportSize.x/2/camera.zoom.x)
	var bigXRange = range(player.position.x + viewportSize.x/2/camera.zoom.x, X_RANGE[1])
	var smallYRange = range(Y_RANGE[0], player.position.y - viewportSize.y/2/camera.zoom.y)
	var bigYRange = range(player.position.y + viewportSize.y/2/camera.zoom.y, Y_RANGE[1])
	
	var xRange = smallXRange + bigXRange
	var yRange = smallYRange + bigYRange
	
	var enemyPosition = Vector2(
		xRange[randi() % xRange.size()],
		yRange[randi() % yRange.size()],
	)
	testArea.position = enemyPosition
	if testArea.has_overlapping_areas() or testArea.has_overlapping_bodies():
		mobDeltas[mobName] = Global.spawnRates[mobName]
	else:
		mobDeltas[mobName] = 0
		var mob = mobScenes[mobName].instantiate()
		$Mobs.add_child(mob)
		mob.position = enemyPosition


func _process(delta: float) -> void:
	for currMob in Global.spawnableMobs:
		mobDeltas[currMob] += delta
		if mobDeltas[currMob] >= Global.chickenSpawnRate:
			spawnMob(currMob)
			
	timeSinceIncreasedDificulty += delta
	if timeSinceIncreasedDificulty >= INCREASE_DIFICULTY_INTERVAL:
		Global.chickenSpawnRate -= 0.1
		Global.damageMultiplier += 0.1
		Global.healthMultiplier += 0.1
		timeSinceIncreasedDificulty -= INCREASE_DIFICULTY_INTERVAL
