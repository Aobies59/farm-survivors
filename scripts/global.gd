extends Node

const SPEED_MULTIPLIER = 10000

# enemies
enum mobs { CHICKEN }
var spawnableMobs = [mobs.CHICKEN]
var spawnRates = {
	mobs.CHICKEN: 1
}

var damageMultiplier = 1
var healthMultiplier = 1
var chickenSpawnRate = 1

# player
var playerSpeed = 1
var abilitiesFrequency = {
	"SlimeBall": 0.8
}
var playerRangeMultiplier = 1
