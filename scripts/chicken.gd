extends CharacterBody2D

const ATTACKING_DISTANCE = 20
const ATTACKING_RATE = 0.6
var timeSinceAttack = 0
var attackDamage = 10
var health = 20

var player
var angleToPlayer
var chasing = false
var attacking = false
var stopped = true
@onready var anim = get_node("AnimationPlayer")
var slashAttack = preload("res://scenes/slash_attack.tscn")

const FACING_LEFT = 0
const FACING_RIGHT = 1
var previousPosition = FACING_RIGHT

const PLAYER_NAME = "Player"
const SPEED = 8 * 1000

func _ready():
	player = get_node("../../Player")
	angleToPlayer = self.rotation

func _physics_process(delta: float) -> void:
	chaseAndAttack(delta)
	
	move_and_slide()
	
func attack():
	var attackInstance = slashAttack.instantiate()
	add_child(attackInstance)
	attackInstance.rotation = angleToPlayer
	attackInstance.activate(attackDamage)
	
func chaseAndAttack(delta: float):
	var direction = (player.position - self.position).normalized()
	angleToPlayer = atan2(direction.y, direction.x)
	var distanceToPlayer = (player.position - self.position).length()
	
	timeSinceAttack = min(ATTACKING_RATE, timeSinceAttack + delta)
	if distanceToPlayer <= ATTACKING_DISTANCE:
		attacking = true
	else:
		attacking = false
		
	if attacking:
		if previousPosition == FACING_LEFT:
			anim.play("StoppedLeft")
		else:
			anim.play("StoppedRight")
		if timeSinceAttack >= ATTACKING_RATE:
			attack()
			timeSinceAttack = 0
		velocity.x = 0
		velocity.y = 0
	elif chasing:
		if direction.x >= 0:
			anim.play("MoveRight")
			previousPosition = FACING_RIGHT
		else:
			anim.play("MoveLeft")
			previousPosition = FACING_LEFT
		velocity.x = direction.x * SPEED * delta
		velocity.y = direction.y * SPEED * delta
	else:
		velocity.x = 0
		velocity.y = 0
		if previousPosition == FACING_RIGHT:
			anim.play("IdleRight")
		else:
			anim.play("IdleLeft")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == PLAYER_NAME:
		chasing = true
		

func _on_player_exited_body_exited(body: Node2D) -> void:
	if body.name == PLAYER_NAME:
		chasing = false


func _on_hurt_box_area_entered(area: Area2D) -> void:
	if area.is_in_group("Attack"):
		health -= area.damage
		area.hit()
		if health <= 0:
			queue_free()
