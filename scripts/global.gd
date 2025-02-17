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
	2: 150,
	3: 200
}
