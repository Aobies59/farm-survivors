extends Node2D



func _on_try_again_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/world.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
