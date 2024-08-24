extends Node

signal hero_size(size : int)
signal change_scene
signal debug(key : String, value)
signal request_scene(scene: String)

func debug_signal(arg1 = null, arg2 = null):
	pass

func _ready():
	hero_size.connect(debug_signal)
	change_scene.connect(debug_signal)
	debug.connect(debug_signal)
	request_scene.connect(debug_signal)
