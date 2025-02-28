extends CharacterBody2D


@export var level = 1

# stats
var playerSpeed = 1
var playerRangeMultiplier = 1
var playerDamageMultiplier = 1
var playerShootingFrequencyMultiplier = 1

var speeds = playerSpeed * Global.SPEED_MULTIPLIER

var items: Array[Global.Item] = []
var actives: Array[Global.Active] = []

enum positions { UP, LEFT, RIGHT, DOWN }
var previousPosition = positions.DOWN

enum actions { LINEAL, DIAGONAL }
var previousAction = actions.LINEAL

var enemies = []

var bulletScene = preload("res://scenes/player-attacks/magic-ball.tscn")

@export var health = 100
@export var experience = 0.0

var idleAnimationMapper := {
	positions.DOWN: "Idle - Facing front",
	positions.UP: "Idle - Facing back",
	positions.LEFT: "Idle - Facing left",
	positions.RIGHT: "Idle - Facing right"
}

var stillAnimationMapper := {
	positions.DOWN: "Still - Facing front",
	positions.UP: "Still - Facing back",
	positions.LEFT: "Still - Facing left",
	positions.RIGHT: "Still - Facing right"
}

@onready var anim = get_node("AnimationPlayer")

func lateReady():
	self.getItem(Global.slimeBallItem)

func _ready() -> void:
	anim.play("Idle - Facing front")
	await get_tree().process_frame
	lateReady()

func runLeft():
	previousPosition = positions.LEFT
	anim.play("Run - Facing left")
	
func runRight():
	previousPosition = positions.RIGHT
	anim.play("Run - Facing right")
	
func runDown():
	anim.play("Run - Facing front")
	previousPosition = positions.DOWN
	
func runUp():
	anim.play("Run - Facing back")
	previousPosition = positions.UP
	
var timeSinceAction = 0
func move(delta):
	var inputVector := Vector2(
		Input.get_axis("Move Left", "Move Right"),
		Input.get_axis("Move Up", "Move Down")
	).normalized()
	if inputVector:
		timeSinceAction = 0
		velocity.x = inputVector[0] * playerSpeed * Global.SPEED_MULTIPLIER * delta
		velocity.y = inputVector[1] * playerSpeed * Global.SPEED_MULTIPLIER * delta
		if inputVector[0] != 0 and inputVector[1] != 0:
			if previousAction == actions.LINEAL:
				if velocity.x > 0 and previousPosition != positions.RIGHT:
					runRight()
				elif velocity.x < 0 and previousPosition != positions.LEFT:
					runLeft()
				elif velocity.y > 0 and previousPosition != positions.DOWN:
					runDown()
				else:
					runUp()
			else:
				if velocity.x > 0 and previousPosition == positions.RIGHT:
					runRight()
				elif velocity.x < 0 and previousPosition == positions.LEFT:
					runLeft()
				elif velocity.y > 0 and previousPosition == positions.DOWN:
					runDown()
				elif velocity.y < 0 and previousPosition == positions.UP:
					runUp()
				else:
					if velocity.x > 0:
						runRight()
					elif velocity.x < 0:
						runLeft()
					elif velocity.y > 0:
						runDown()
					elif velocity.y < 0:
						runUp()
			previousAction = actions.DIAGONAL
		else:
			previousAction = actions.LINEAL
			if velocity.x > 0:
				runRight()
			elif velocity.x < 0:
				runLeft()
			elif velocity.y > 0:
				runDown()
			else:
				runUp()
	else:
		velocity.x = move_toward(velocity.x, 0, playerSpeed * Global.SPEED_MULTIPLIER * delta)
		velocity.y = move_toward(velocity.y, 0, playerSpeed * Global.SPEED_MULTIPLIER * delta)
		timeSinceAction += delta
		if timeSinceAction >= 1.5:
			anim.play(idleAnimationMapper[previousPosition])
		else:
			anim.play(stillAnimationMapper[previousPosition])
			
	move_and_slide()
	
func get_experience(amount):
	experience += amount
	if experience >= Global.levelUpExperience[level]:
		if Global.levelUpExperience.get(level + 1):
			levelUp()
			
func levelUp():
	experience -= Global.levelUpExperience[level]
	level += 1
	$"../UpgradesMenu".start()
	
func die():
	get_tree().change_scene_to_file("res://scenes/screens/game-over.tscn")
	
func takeDamage(damage: int) -> void:
	health -= damage
	if health <= 0:
		call_deferred("die")

func triggerActives(delta: float):
	for active in actives:
		active.Delta = min(active.Delta + delta * playerShootingFrequencyMultiplier, active.Frequency)
		if active.RunFunction.call(active, self.position, enemies, self, playerRangeMultiplier):
			active.Delta = 0

func getActive(active: Global.Active):
	actives.append(active)
	$"../UI/Abilities".addAbility(active)

func getItem(item: Global.Item):
	if item.ActiveObject:
		getActive(item.ActiveObject)
	for upgrade in item.Upgrades:
		if upgrade.Stat == Global.stats.DAMAGE:
			playerDamageMultiplier += upgrade.Amount
		elif upgrade.Stat == Global.stats.RANGE:
			playerRangeMultiplier += upgrade.Amount
		elif upgrade.Stat == Global.stats.SPEED:
			playerSpeed += upgrade.Amount
		elif upgrade.Stat == Global.stats.SHOOT_FREQUENCY:
			playerShootingFrequencyMultiplier += upgrade.Amount
	# TODO: activate boosts
	items.append(item)
	$"../UI/Items".updateInventory()

func _process(delta: float) -> void:
	enemies = get_node("../Mobs").get_children()
	triggerActives(delta)

func _physics_process(delta: float) -> void:
	move(delta)

func _on_hurt_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Damaging"):
		takeDamage(body.damage)

func _on_hurt_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("Damaging"):
		takeDamage(area.damage)
