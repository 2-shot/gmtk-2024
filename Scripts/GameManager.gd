extends Node

const main_menu := "res://Menus/MainMenu.tscn"
const pause_menu := "res://Menus/PauseMenu.tscn"
var pause := preload(pause_menu).instantiate()

signal in_menu(value : bool)
var is_menu := true

var scene_path : String

var game_state = {}

# ---
# Pause Menu
# ---

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

# ---
# Scene Change
# ---

func check_scene_path() -> String:
	if scene_path == null or scene_path.is_empty():
		return "scene path is empty"
	if not scene_path.ends_with(".tscn") or not scene_path.begins_with("res://"):
		return "scene path incomplete"
	if not ResourceLoader.exists(scene_path):
		return "scene path does not exsist"
	
	return ""

func valid_scene_path() -> bool:
	var scene_status = check_scene_path()
	if scene_status:
		push_warning(scene_status, ": ", scene_path)
		print_rich("[color=yellow]%s: [b]'%s'[/b][/color]" % [scene_status, scene_path])
		return false

	return true

func do_scene_change():
	var resource = ResourceLoader.load_threaded_get(scene_path)
	var err = get_tree().change_scene_to_packed(resource)
	if err:
		push_error("failed to change scenes: %d" % err)
		get_tree().quit(1)
	scene_path = ""
	GlobalSignals.change_scene.emit()

func load_scene() -> void:
	if ResourceLoader.has_cached(scene_path):
		do_scene_change()
		return
	ResourceLoader.load_threaded_request(scene_path)
	set_process(true)

func change_scene(scene: String):
	scene_path = scene
	prints("Changing scene to", scene_path)
	if not valid_scene_path():
		return
	load_scene()

func get_scene_status() -> ResourceLoader.ThreadLoadStatus:
	if not valid_scene_path():
		return ResourceLoader.THREAD_LOAD_INVALID_RESOURCE
	return ResourceLoader.load_threaded_get_status(scene_path)

func check_scene_status():
	var resource_status = get_scene_status()
	match(resource_status):
		ResourceLoader.THREAD_LOAD_INVALID_RESOURCE, ResourceLoader.THREAD_LOAD_FAILED:
			push_error("failed to change scenes")
			set_process(false)
		ResourceLoader.THREAD_LOAD_LOADED:
			do_scene_change()
			set_process(false)

# ---
# Setup
# ---

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	GlobalSignals.change_scene.connect(hide_menu)
	GlobalSignals.request_scene.connect(change_scene)
	in_menu.connect(func(value): is_menu = value)
	set_process(false)

func _input(event: InputEvent):
	if(event.is_action_pressed("escape")):
		# TODO: check if menu using root
		#print(get_tree().root.get_child(0))
		if is_menu:
			get_tree().change_scene_to_file(main_menu)
		else:
			toggle_menu()

func _process(_delta):
	check_scene_status()
