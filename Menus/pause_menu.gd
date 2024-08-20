extends CanvasLayer


func _on_restart_level_pressed():
	get_tree().reload_current_scene()
	GameManager.hide_menu()

func _on_continue_pressed():
	GameManager.hide_menu()
