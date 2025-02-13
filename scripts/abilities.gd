extends Node2D

var abilities = {}
var player

func _ready():
	player = get_node("../../Player")
	for ability in self.get_children():
		var front = ability.get_node("Front")
		var back = ability.get_node("Back")
		abilities[ability.name] = [front, back.size.y]

func _process(delta: float) -> void:
	for abilityName in abilities.keys():
		abilities[abilityName][0].size.y = abilities[abilityName][1] - abilities[abilityName][1]*(player.abilitiesDelta[abilityName]/player.abilitiesFrequency[abilityName])
		
