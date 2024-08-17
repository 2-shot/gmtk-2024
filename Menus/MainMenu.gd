extends Control

@export var startScene: PackedScene
@onready var quit := $Panel/MarginContainer/PanelContainer/GridContainer/VBoxContainer/Quit

# Called when the node enters the scene tree for the first time.
func _ready():
	if OS.has_feature("web"):
		quit.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_start_pressed():
	if startScene and startScene.can_instantiate():
		get_tree().change_scene_to_packed(startScene)

func _on_info_pressed():
	get_tree().change_scene_to_file("res://Scenes/Info.tscn")

func _on_quit_pressed():
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()

func _input(event: InputEvent):
	if(event.is_action_pressed("Escape")):
		get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
