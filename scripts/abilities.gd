extends Node2D

var abilities = {}
var player: CharacterBody2D

var nextPosition = Vector2(25, 941)
const MARGIN = 20.0

func _ready():
	player = get_node("../../Player")
	"""
	for ability in self.get_children():
		var front = ability.get_node("Front")
		var back = ability.get_node("Back")
		var active: Global.Active
		for currActive: Global.Active in player.actives:
			if currActive.Name == ability.abilityName:
				active = currActive
		abilities[ability.abilityName] = [front, back.size.y, active]
	"""
		
func addAbility(active: Global.Active):
	var ability = Node2D.new()
	ability.name = active.Name
	var size = Vector2(120, 120)
	ability.position = nextPosition
	nextPosition.x += size.x + MARGIN
	
	var front = ColorRect.new()
	front.size = size
	front.color = Color(0.1, 0.1, 0.1, 0.5)
	front.z_index = 2
	ability.add_child(front)
	
	var back = ColorRect.new()
	back.size = size
	back.color = Color(1, 1, 1, 1)
	back.z_index = 0
	ability.add_child(back)
	
	var sprite: Node2D = active.Sprite.instantiate()
	sprite.position = size / 2
	sprite.z_index = 1
	ability.add_child(sprite)
	
	self.add_child(ability)
	
	abilities[active.Name] = [front, back.size.y, active]

func _process(_delta: float) -> void:
	for abilityName in abilities.keys():
		var currAbility = abilities[abilityName]
		if len(currAbility) != 3 or not currAbility[0] or not currAbility[1] or not currAbility[2]:
			continue
		currAbility[0].size.y = currAbility[1] - currAbility[1]*(currAbility[2].Delta/currAbility[2].Frequency)
		
