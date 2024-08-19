@tool
class_name SceneButton

extends Button

@export_file("*.tscn") var scene_path : String : set = set_scene
@export var to_menu : bool = false

func set_scene(value : String) -> void:
	scene_path = value
	var scene_status = check_scene_path()
	disabled = not scene_status.is_empty()
	update_configuration_warnings()

func check_scene_path() -> String:
	if scene_path == null or scene_path.is_empty():
		return "scene path is empty"
	if not scene_path.ends_with(".tscn"):
		return "scene path incomplete"
	if not ResourceLoader.exists(scene_path):
		return "scene path does not exsist"
	
	return ""

func _get_configuration_warnings() -> PackedStringArray:
	var scene_status = check_scene_path()
	if not scene_status.is_empty():
		return [scene_status]
	return []

func load_scene() -> void:
	prints("Changing scene to", scene_path)
	GlobalSignals.request_scene.emit(scene_path)

func _ready():
	update_configuration_warnings()
	var scene_status = check_scene_path()
	disabled = not scene_status.is_empty()
	if not disabled:
		pressed.connect(load_scene)
	set_process(false)
