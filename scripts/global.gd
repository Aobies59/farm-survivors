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

# player
enum abilities { SLIMEBALL }
var abilitiesFrequency = {
	abilities.SLIMEBALL: 0.8
}
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

# items
class Item:
	var Name: String
	var Description: String
	var Rarity: rarities
	var Upgrades: Array[Upgrade] = []
	var Boosts: Array[Boost] = []
	var Icon: String
	
	func _init(name: String, description: String, rarity:rarities, icon: String, upgrades: Array[Upgrade] = [], boosts: Array[Boost] = []):
		self.Name = name
		self.Description = description
		self.Rarity = rarity
		self.Upgrades = upgrades
		self.Boosts = boosts
		self.Icon = icon
		
var defaultItem = Item.new(
	"Overall improvement",
	"Gives every stat a small boost",
	rarities.NORMAL,
	"res://resources/items/lightning-boots.png",  # TODO
	[Upgrade.new(stats.SPEED, 0.1), Upgrade.new(stats.SHOOT_FREQUENCY, 0.1), Upgrade.new(stats.DAMAGE, 0.1)]
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
		Item.new(
			"Godmode",
			"For testing purposes",
			rarities.LEGENDARY,
			"res://resources/items/lightning-boots.png",  # TODO
			[Upgrade.new(stats.SPEED, 10), Upgrade.new(stats.SHOOT_FREQUENCY, 10), Upgrade.new(stats.DAMAGE, 10)]
		),
	]
}
