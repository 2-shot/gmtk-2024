@tool
class_name SceneButton

extends Button

@export_file("*.tscn") var scene_path : String : set = set_scene

func set_scene(value : String) -> void:
	scene_path = value
	disabled = valid_scene_path()
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

func valid_scene_path() -> bool:
	var scene_status = check_scene_path()
	if scene_status:
		prints(scene_status, scene_path)
		push_warning(scene_path)
		push_warning(scene_status)

	return scene_status.is_empty()

func change_scene() -> void:
	var resource = ResourceLoader.load_threaded_get(scene_path)
	var err = get_tree().change_scene_to_packed(resource)
	if err:
		push_error("failed to change scenes: %d" % err)
		get_tree().quit()

func load_scene() -> void:
	prints("Changing scene to", scene_path)
	if not valid_scene_path():
		push_error("\"%s\" failed to change scenes: %s" % [text, scene_path])
		return
	if ResourceLoader.has_cached(scene_path):
		change_scene()
		return
	ResourceLoader.load_threaded_request(scene_path)
	set_process(true)

func _ready():
	update_configuration_warnings()
	disabled = not valid_scene_path()
	if not disabled:
		pressed.connect(load_scene)
	set_process(false)

func get_status() -> ResourceLoader.ThreadLoadStatus:
	if not valid_scene_path():
		return ResourceLoader.THREAD_LOAD_INVALID_RESOURCE
	return ResourceLoader.load_threaded_get_status(scene_path)

func _process(_delta):
	var resource_status = get_status()
	match(resource_status):
		ResourceLoader.THREAD_LOAD_INVALID_RESOURCE, ResourceLoader.THREAD_LOAD_FAILED:
			push_error("failed to change scenes")
			set_process(false)
		ResourceLoader.THREAD_LOAD_LOADED:
			change_scene()
			set_process(false)
