extends Node

signal hero_size(size : int)
signal scene_changed
signal debug(key : String, value)
signal request_scene(scene: String)

func debug_scene_changed():
	prints("scene_changed")

func debug_request_scene(scene = null):
	prints("request_scene", scene)

func _ready():
	scene_changed.connect(debug_scene_changed)
	request_scene.connect(debug_request_scene)
