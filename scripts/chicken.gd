extends CharacterBody2D

const ATTACKING_DISTANCE = 20
const ATTACKING_RATE = 0.6
var timeSinceAttack = 0
var attackDamage = 10

var health = 10 * Global.healthMultiplier
const experience = 10

var player
var attacking = false
@onready var anim = get_node("AnimationPlayer")
var slashAttack = preload("res://scenes/slash_attack.tscn")

const FACING_LEFT = 0
const FACING_RIGHT = 1
var previousPosition = FACING_RIGHT

const PLAYER_NAME = "Player"
const SPEED = 1 * Global.SPEED_MULTIPLIER

func _ready():
	player = get_node("../../Player")

func _physics_process(delta: float) -> void:
	chaseAndAttack(delta)
	
func attack(angleToPlayer):
	var attackInstance = slashAttack.instantiate()
	add_child(attackInstance)
	attackInstance.rotation = angleToPlayer
	attackInstance.activate(attackDamage)
	
func chaseAndAttack(delta: float):
	var direction = (player.position - self.position).normalized()
	var distanceToPlayer = (player.position - self.position).length()
	
	timeSinceAttack = min(ATTACKING_RATE, timeSinceAttack + delta)
	if distanceToPlayer <= ATTACKING_DISTANCE or (timeSinceAttack != 0 and timeSinceAttack != ATTACKING_RATE) :
		attacking = true
	else:
		attacking = false
		
	if attacking:
		if previousPosition == FACING_LEFT:
			anim.play("StoppedLeft")
		else:
			anim.play("StoppedRight")
		if timeSinceAttack >= ATTACKING_RATE:
			attack(atan2(direction.y, direction.x))
			timeSinceAttack = 0
		velocity.x = 0
		velocity.y = 0
	else:
		if direction.x >= 0:
			anim.play("MoveRight")
			previousPosition = FACING_RIGHT
		else:
			anim.play("MoveLeft")
			previousPosition = FACING_LEFT
		velocity.x = direction.x * SPEED * delta
		velocity.y = direction.y * SPEED * delta
		
	move_and_slide()

func die():
	player.get_experience(experience)
	queue_free()

func _on_hurt_box_area_entered(area: Area2D) -> void:
	if area.is_in_group("Attack"):
		health -= area.damage
		area.hit()
		if health <= 0:
			die()
