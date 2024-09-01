extends Node

signal hero_size(size : int)
signal scene_changed(status : int)
signal debug(key : String, value)
signal request_scene(scene: String)

func debug_scene_changed(status : int):
	prints("scene_changed", error_string(status))

func debug_request_scene(scene = null):
	prints("request_scene", scene)

func _ready():
	hero_size.connect(func(_size): pass)
	scene_changed.connect(debug_scene_changed)
	debug.connect(func(_key, _value): pass)
	request_scene.connect(debug_request_scene)
