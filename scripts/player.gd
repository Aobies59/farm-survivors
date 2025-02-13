extends CharacterBody2D

const SPEED = 10.0 * 1000.0

const FACING_UP = 0
const FACING_LEFT = 1
const FACING_RIGHT = 2
const FACING_DOWN = 3
var previousPosition = FACING_DOWN

const LINEAL = 0
const DIAGONAL = 1
var previousAction = LINEAL

var enemiesInRange = []

var bulletScene = preload("res://scenes/bullet.tscn")
@export var abilitiesDelta = {
	"SlimeBall": 0
}
@export var abilitiesFrequency = {
	"SlimeBall": 1
}
var shootingRange = 250

@export var health = 100

var idleAnimationMapper := {
	FACING_DOWN: "Idle - Facing front",
	FACING_UP: "Idle - Facing back",
	FACING_LEFT: "Idle - Facing left",
	FACING_RIGHT: "Idle - Facing right"
}

var stillAnimationMapper := {
	FACING_DOWN: "Still - Facing front",
	FACING_UP: "Still - Facing back",
	FACING_LEFT: "Still - Facing left",
	FACING_RIGHT: "Still - Facing right"
}

@onready var anim = get_node("AnimationPlayer")

func _ready() -> void:
	anim.play("Idle - Facing front")

func runLeft():
	previousPosition = FACING_LEFT
	anim.play("Run - Facing left")
	
func runRight():
	previousPosition = FACING_RIGHT
	anim.play("Run - Facing right")
	
func runDown():
	anim.play("Run - Facing front")
	previousPosition = FACING_DOWN
	
func runUp():
	anim.play("Run - Facing back")
	previousPosition = FACING_UP
	
var timeSinceAction = 0
func move(delta):
	var inputVector := Vector2(
		Input.get_axis("Move Left", "Move Right"),
		Input.get_axis("Move Up", "Move Down")
	).normalized()
	if inputVector:
		timeSinceAction = 0
		velocity.x = inputVector[0] * SPEED * delta
		velocity.y = inputVector[1] * SPEED * delta
		if inputVector[0] != 0 and inputVector[1] != 0:
			if previousAction == LINEAL:
				if velocity.x > 0 and previousPosition != FACING_RIGHT:
					runRight()
				elif velocity.x < 0 and previousPosition != FACING_LEFT:
					runLeft()
				elif velocity.y > 0 and previousPosition != FACING_DOWN:
					runDown()
				else:
					runUp()
			else:
				if velocity.x > 0 and previousPosition == FACING_RIGHT:
					runRight()
				elif velocity.x < 0 and previousPosition == FACING_LEFT:
					runLeft()
				elif velocity.y > 0 and previousPosition == FACING_DOWN:
					runDown()
				elif velocity.y < 0 and previousPosition == FACING_UP:
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
			previousAction = DIAGONAL
		else:
			previousAction = LINEAL
			if velocity.x > 0:
				runRight()
			elif velocity.x < 0:
				runLeft()
			elif velocity.y > 0:
				runDown()
			else:
				runUp()
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * delta)
		velocity.y = move_toward(velocity.y, 0, SPEED * delta)
		timeSinceAction += delta
		if timeSinceAction >= 1.5:
			anim.play(idleAnimationMapper[previousPosition])
		else:
			anim.play(stillAnimationMapper[previousPosition])
			
	move_and_slide()
	
func takeDamage(damage: int) -> void:
	health -= damage

func shoot():
	var closestEnemy
	var closestEnemyDistance = shootingRange + 1
	for currEnemy in enemiesInRange:
		var currDistance = (currEnemy.position - self.position).length()
		if currDistance < closestEnemyDistance:
			closestEnemy = currEnemy
			closestEnemyDistance = currDistance
	if not closestEnemy:
		return
	var direction = (closestEnemy.position - self.position).normalized()
	var bullet = bulletScene.instantiate()
	add_child(bullet)
	bullet.shoot(direction)

func _process(delta: float) -> void:
	abilitiesDelta["SlimeBall"] = min(abilitiesDelta["SlimeBall"] + delta, abilitiesFrequency["SlimeBall"])
	if abilitiesDelta["SlimeBall"] >= abilitiesFrequency["SlimeBall"] and len(enemiesInRange) > 0:
		abilitiesDelta["SlimeBall"] = 0
		shoot()
	
	if health <= 0:
		get_tree().change_scene_to_file("res://scenes/game_over.tscn")

func _physics_process(delta: float) -> void:
	move(delta)

func _on_hurt_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Damaging"):
		takeDamage(body.damage)


func _on_hurt_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("Damaging"):
		takeDamage(area.damage)


func _on_shooting_range_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		enemiesInRange.append(body)


func _on_shooting_range_body_exited(body: Node2D) -> void:
	if body in enemiesInRange:
		enemiesInRange.erase(body)
