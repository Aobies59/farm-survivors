extends Node2D

var spawnerThread = Thread.new()


var chickenScene = preload("res://characters/chicken.tscn")
var rng
const X_RANGE = Vector2(16, 1456)
const Y_RANGE = Vector2(16, 656)

var mobScenes = {
	Global.mobs.CHICKEN: chickenScene
}
var mobDeltas = {
	Global.mobs.CHICKEN: 0
}

var timeSinceChickenSpawn = 0

@export var paused = false

func _ready() -> void:
	randomize()
	
func spawnMob(mobName):
	var testArea = Area2D.new()
	var collisionShape = CircleShape2D.new()
	collisionShape.radius = 100
	var collision = CollisionShape2D.new()
	collision.shape = collisionShape
	testArea.add_child(collision)
	self.add_child(testArea)
	
	var xCoordinate
	var yCoordinate

	xCoordinate = randf_range(X_RANGE[0], X_RANGE[1])
	yCoordinate = randf_range(Y_RANGE[0], Y_RANGE[1])
	testArea.position = Vector2(xCoordinate, yCoordinate)
	if len(testArea.get_overlapping_areas()) > 0 or len(testArea.get_overlapping_bodies()) > 0:
		mobDeltas[mobName] = Global.spawnRates[mobName]
		return

	testArea.queue_free()
	
	var mob = mobScenes[mobName].instantiate()
	$Mobs.add_child(mob)
	mob.position = Vector2(xCoordinate, yCoordinate)


func _process(delta: float) -> void:
	for currMob in Global.spawnableMobs:
		mobDeltas[currMob] += delta
		if mobDeltas[currMob] >= Global.chickenSpawnRate:
			mobDeltas[currMob] -= Global.chickenSpawnRate
			spawnMob(currMob)
