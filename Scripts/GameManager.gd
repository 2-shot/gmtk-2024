extends Node

const main_menu := "res://Menus/MainMenu.tscn"
const pause_menu := "res://Menus/PauseMenu.tscn"
var pause := preload(pause_menu).instantiate()

var in_menu := false

func toggle_menu():
	if pause.is_inside_tree():
		get_tree().root.remove_child(pause)
	else:
		get_tree().root.add_child(pause)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event: InputEvent):
	if(event.is_action_pressed("escape")):
		if in_menu:
			get_tree().change_scene_to_file(main_menu)
		else:
			toggle_menu()
