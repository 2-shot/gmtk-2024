extends Node

const main_menu := "res://Menus/MainMenu.tscn"
const pause_menu := "res://Menus/PauseMenu.tscn"
var pause := preload(pause_menu).instantiate()

signal in_menu(value : bool)

var is_menu := true

func hide_menu():
	if pause.is_inside_tree():
		get_tree().root.remove_child(pause)
		get_tree().paused = false

func toggle_menu():
	pause.process_mode = Node.PROCESS_MODE_ALWAYS
	if pause.is_inside_tree():
		get_tree().root.remove_child(pause)
		get_tree().paused = false
	else:
		get_tree().root.add_child(pause)
		get_tree().paused = true

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	GlobalSignals.change_scene.connect(hide_menu)
	in_menu.connect(func(value): is_menu = value)

func _input(event: InputEvent):
	if(event.is_action_pressed("escape")):
		print(get_tree().root.get_child(0))
		#get_tree().root.get_node()
		if is_menu:
			get_tree().change_scene_to_file(main_menu)
		else:
			toggle_menu()
