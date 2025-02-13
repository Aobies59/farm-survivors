extends CanvasLayer
var paused = false

func pause():
	paused = true
	$"../UI".visible = false
	$".".visible = true
	get_tree().paused = true
	
func unpause():
	paused = false
	$"../UI".visible = true
	$".".visible = false
	get_tree().paused = false

func _input(event):
	if event.is_action_pressed("Pause"):
		if paused:
			unpause()
		else:
			pause()

func _on_continue_pressed() -> void:
	unpause()

func _on_quit_pressed() -> void:
	get_tree().quit()
