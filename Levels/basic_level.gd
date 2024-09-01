extends Node2D
@export var size_target : int = 400
@export var level_number : int = 1
@export var win_timeout : int = 1

@export_file("*.tscn") var level_complete : String
@export_file("*.tscn") var next_level : String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalSignals.hero_size.connect(check_level_finished)

func check_level_finished(hero_size: int):
	if hero_size >= size_target:
		print("YOU'RE WINNER")
		GameManager.game_state["next_level"] = next_level
		GameManager.game_state["level_number"] = level_number
		get_tree().create_timer(win_timeout).timeout.connect(func(): GlobalSignals.request_scene.emit(level_complete))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
