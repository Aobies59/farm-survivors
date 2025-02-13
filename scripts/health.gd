extends Node2D

var player
var initialHealthBarWidth
const MAX_PLAYER_HEALTH = 100.0  # TODO: have this in player instead, as it can change

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initialHealthBarWidth = $Full.size.x


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	$Label.text = str($"../../Player".health) + "/100"
	$Full.size.x = initialHealthBarWidth*($"../../Player".health/MAX_PLAYER_HEALTH)
