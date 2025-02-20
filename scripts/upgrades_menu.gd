extends CanvasLayer

var item1: Global.Item
var item2: Global.Item
var item3: Global.Item

var player: CharacterBody2D

var itemContainer1: Node2D
var itemContainer2: Node2D
var itemContainer3: Node2D

func getRandomItems():
	var possibleItems = Global.items.duplicate()
	possibleItems.shuffle()
	item1 = possibleItems[0]
	item2 = possibleItems[1]
	item3 = possibleItems[2]

func _ready() -> void:
	itemContainer1 = get_node("Items/Item1")
	itemContainer2 = get_node("Items/Item2")
	itemContainer3 = get_node("Items/Item3")
	player = get_node("../Player")
	
func displayItems():
	var itemContainers = [itemContainer1, itemContainer2, itemContainer3]
	var items = [item1, item2, item3]
	for i in range(0, 3):
		itemContainers[i].get_node("Button").icon = load(items[i].Icon)
		itemContainers[i].get_node("Title").text = items[i].Name


func _on_button_1_pressed() -> void:
	player.getItem(item1)
	exit()

func _on_button_2_pressed() -> void:
	player.getItem(item2)
	exit()

func _on_button_3_pressed() -> void:
	player.getItem(item3)
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
