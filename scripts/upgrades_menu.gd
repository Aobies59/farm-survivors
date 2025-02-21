extends CanvasLayer

var item1: Global.Item
var item2: Global.Item
var item3: Global.Item

var player: CharacterBody2D

var itemContainer1: Node2D
var itemContainer2: Node2D
var itemContainer3: Node2D

var RARE_ITEM_PROBABILITY = 30
var EPIC_ITEM_PROBABILITY = 10
var LEGENDARY_ITEM_PROBABILITY = 5

var colors = {
	Global.rarities.NORMAL: Color(0.5, 0.5, 0.5),  # Grey
	Global.rarities.RARE: Color(0.0, 0.5, 1.0),    # Blue
	Global.rarities.EPIC: Color(0.5, 0.0, 1.0),    # Purple
	Global.rarities.LEGENDARY: Color(1.0, 1.0, 0.0) # Yellow
}

func getRandomItem(items: Dictionary):
	var randomNumber = randi_range(1, 100)
	if randomNumber <= LEGENDARY_ITEM_PROBABILITY:
		if len(items[Global.rarities.LEGENDARY]) > 0:
			return items[Global.rarities.LEGENDARY].pop_front()
	if randomNumber <= EPIC_ITEM_PROBABILITY:
		if len(items[Global.rarities.EPIC]) > 0:
			return items[Global.rarities.EPIC].pop_front()
	if randomNumber <= RARE_ITEM_PROBABILITY:
		if len(items[Global.rarities.RARE]) > 0:
			return items[Global.rarities.RARE].pop_front()
	if len(items[Global.rarities.NORMAL]) > 0:
		return items[Global.rarities.NORMAL].pop_front()
	return Global.defaultItem

func getRandomItems():
	var possibleItems = Global.items.duplicate(true)
	item1 = getRandomItem(possibleItems)
	item2 = getRandomItem(possibleItems)
	item3 = getRandomItem(possibleItems)

func _ready() -> void:
	randomize()
	for currRarity in Global.items.keys():
		Global.items[currRarity].shuffle()
	itemContainer1 = get_node("Items/Item1")
	itemContainer2 = get_node("Items/Item2")
	itemContainer3 = get_node("Items/Item3")
	player = get_node("../Player")
	
func displayItems():
	var itemContainers = [itemContainer1, itemContainer2, itemContainer3]
	var items = [item1, item2, item3]
	for i in range(0, 3):
		var currButton: Button = itemContainers[i].get_node("Button")
		currButton.icon = load(items[i].Icon)
		
		var baseColor = colors[items[i].Rarity]
		var normalStyle := StyleBoxFlat.new()
		normalStyle.bg_color = baseColor
		currButton.add_theme_stylebox_override("normal", normalStyle)
		
		var hoverColor = baseColor.darkened(0.2)
		var hoverStyle := StyleBoxFlat.new()
		hoverStyle.bg_color = hoverColor
		currButton.add_theme_stylebox_override("hover", hoverStyle)
		
		var pressedColor = hoverColor.darkened(0.2)
		var pressedStyle := StyleBoxFlat.new()
		pressedStyle.bg_color = pressedColor
		currButton.add_theme_stylebox_override("pressed", pressedStyle)
		
		itemContainers[i].get_node("Title").text = items[i].Name


func _on_button_1_pressed() -> void:
	player.getItem(item1)
	Global.items[item1.Rarity].erase(item1)
	exit()

func _on_button_2_pressed() -> void:
	player.getItem(item2)
	Global.items[item2.Rarity].erase(item2)
	exit()

func _on_button_3_pressed() -> void:
	player.getItem(item3)
	Global.items[item3.Rarity].erase(item3)
	exit()
	
func start():
	randomize()
	get_tree().paused = true
	self.visible = true
	$"../UI".visible = false
	getRandomItems()
	displayItems()

func exit():
	get_tree().paused = false
	self.visible = false
	$"../UI".visible = true
