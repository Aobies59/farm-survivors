extends Area2D

@export var damage = 10 * Global.damageMultiplier
@onready var anim = get_node("AnimationPlayer")
	
func activate(attackDamage):
	damage = attackDamage
	anim.play("Slash")

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	self.queue_free()
