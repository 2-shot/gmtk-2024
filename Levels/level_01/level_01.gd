extends Node2D
@export var size_target: int = 400


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalSignals.hero_size.connect(check_level_finished)

func check_level_finished(hero_size: int):
	if hero_size >= size_target:
		print("YOU'RE WINNER")
		GlobalSignals.request_scene.emit("res://Menus/Level_Transistion_Scene.tscn")
		get_tree().change_scene_to_file("res://Menus/Level_Transition_Scene.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
