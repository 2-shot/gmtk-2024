extends Control

@onready var quit := $Panel/MarginContainer/PanelContainer/GridContainer/VBoxContainer/Quit

# Called when the node enters the scene tree for the first time.
func _ready():
	var is_web : bool = OS.has_feature("web")
	quit.visible = not is_web

	if is_web:
		quit.queue_free()

func _on_quit_pressed():
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()
