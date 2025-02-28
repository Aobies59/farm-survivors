extends Node

const SPEED_MULTIPLIER = 10000

# enemies
enum mobs { CHICKEN }
var spawnableMobs = [mobs.CHICKEN]
var spawnRates = {
	mobs.CHICKEN: 1
}

var damageMultiplier = 1.0
var healthMultiplier = 1.0
var chickenSpawnRate = 1.0

var levelUpExperience = {
	1 : 100,
	2 : 150,
	3 : 200,
	4 : 250,
	5 : 300,
	6 : 375,
	7 : 450,
	8 : 525,
	9 : 600,
	10 : 700,
	11 : 800,
	12 : 900,
	13 : 1050,
	14 : 1200,
	15 : 1350,
	16 : 1500,
	17 : 1700,
	18 : 1900,
	19 : 2100,
	20 : 2400,
	21 : 2700,
	22 : 3000,
	23 : 3400,
	24 : 3800,
	25 : 4200,
	26 : 4600,
	27 : 5000,
	28 : 5500,
	29 : 6000,
	30 : 6500,
	31 : 7100,
	32 : 7700,
	33 : 8300,
	34 : 9000,
	35 : 9700,
	36 : 10500,
	37 : 11300,
	38 : 12100,
	39 : 13000,
	40 : 14000,
	41 : 15000,
	42 : 16000,
	43 : 17000,
	44 : 18000,
	45 : 19000,
	46 : 20000,
	47 : 21000,
	48 : 22000,
	49 : 23000,
	50 : 24000
}

enum stats { DAMAGE, RANGE, SPEED, SHOOT_FREQUENCY}
enum rarities {NORMAL, RARE, EPIC, LEGENDARY}

class Upgrade:
	var Stat: stats
	var Amount: float
	
	func _init(stat: stats, amount: float):
		self.Stat = stat
		self.Amount = amount
		
class Boost:
	var Variable
	var Description: String
	
	func _init(variable, description: String):
		self.Variable = variable
		self.Description = description
		
class Active:
	var Name: String
	var Description: String
	var Delta: float = 0
	var Frequency: float
	var ShootingRange: float
	var RunFunction: Callable
	var Scene: PackedScene
	var Sprite: PackedScene
	
	func _init(name: String, description: String, frequency: float, scene: PackedScene, sprite: PackedScene, runFunction: Callable, shootingRange: float = 0):
		self.Name = name
		self.Description = description
		self.Frequency = frequency
		self.Scene = scene
		self.Sprite = sprite
		self.RunFunction = runFunction
		self.ShootingRange = shootingRange
			
	
# items
class Item:
	var Name: String
	var Description: String
	var Rarity: rarities
	var Upgrades: Array[Upgrade] = []
	var Boosts: Array[Boost] = []
	var Icon: String
	var ActiveObject: Active
	
	func _init(name: String, description: String, rarity:rarities, icon: String, upgrades: Array[Upgrade] = [], boosts: Array[Boost] = [], activeObject: Active = null):
		self.Name = name
		self.Description = description
		self.Rarity = rarity
		self.Upgrades = upgrades
		self.Boosts = boosts
		self.Icon = icon
		self.ActiveObject = activeObject
		
var defaultItem = Item.new(
	"Overall improvement",
	"Gives every stat a small boost",
	rarities.NORMAL,
	"res://resources/items/lightning-boots.png",  # TODO
	[Upgrade.new(stats.SPEED, 0.1), Upgrade.new(stats.SHOOT_FREQUENCY, 0.1), Upgrade.new(stats.DAMAGE, 0.1)]
)

var slimeBall = Active.new(
	"SlimeBall",
	"temp",
	0.8,
	preload("res://scenes/player-attacks/magic-ball.tscn"),
	preload("res://scenes/player-attacks/slime_ball_sprite.tscn"),
	func(object, playerPosition, enemies, parentNode, rangeMultiplier):
		if object.Delta < object.Frequency:
			return false
		var closestEnemy
		var closestEnemyDistance = object.ShootingRange * rangeMultiplier + 1
		for currEnemy in enemies:
			var currDistance = (currEnemy.position - playerPosition).length()
			if currDistance < closestEnemyDistance:
				closestEnemy = currEnemy
				closestEnemyDistance = currDistance
		if not closestEnemy:
			return false
		var direction = (closestEnemy.position - playerPosition).normalized()
		var bullet = object.Scene.instantiate()
		parentNode.add_child(bullet)
		bullet.shoot(direction)
		return true
		,
	250
)

var slimeBallItem = 	Item.new(
	"SlimeBall",
	"temp",
	rarities.LEGENDARY,
	"res://resources/items/sprite-ball-image.png",
	[],
	[],
	slimeBall
)

var items = {
	rarities.NORMAL: [
		Item.new(
			"Adrenalyne Syringe",
			"Feel the rush",
			rarities.NORMAL,
			"res://resources/items/lightning-boots.png",  # TODO
			[Upgrade.new(stats.SPEED, 0.1), Upgrade.new(stats.SHOOT_FREQUENCY, 0.1)]
		),
		Item.new(
			"Boxing Gloves",
			"Hit harder",
			rarities.NORMAL,
			"res://resources/items/boxing-gloves.png",
			[Upgrade.new(stats.DAMAGE, 0.5)]
		),
	],
	rarities.RARE: [
		Item.new(
			"Lightning Boots",
			"Move like lightning",
			rarities.RARE,
			"res://resources/items/lightning-boots.png",
			[Upgrade.new(stats.SPEED, 0.2)]
		)
	],
	rarities.EPIC: [],
	rarities.LEGENDARY: [
		slimeBallItem,
		Item.new(
			"Godmode",
			"For testing purposes",
			rarities.LEGENDARY,
			"res://resources/items/lightning-boots.png",  # TODO
			[Upgrade.new(stats.SPEED, 10), Upgrade.new(stats.SHOOT_FREQUENCY, 10), Upgrade.new(stats.DAMAGE, 10)]
		),
	]
}
