extends CanvasLayer
var paused = false
var upgrading: bool

func pause():
	paused = true
	upgrading = $"../UpgradesMenu".visible
	$"../UI".visible = false
	$"../UpgradesMenu".visible = false
	$".".visible = true
	
func unpause():
	paused = false
	$"../UI".visible = not upgrading
	$"../UpgradesMenu".visible = upgrading
	$".".visible = false
	get_tree().paused = upgrading

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
