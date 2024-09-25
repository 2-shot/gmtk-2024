@tool
extends Node2D

@export var total_size : int
@export var size_target : int = 400
@export var level_number : int = 1
@export var win_timeout : int = 1

@export_file("*.tscn") var level_complete : String
@export_file("*.tscn") var next_level : String

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	GlobalSignals.hero_size.connect(check_level_finished)

func check_level_finished(hero_size: int):
	if hero_size >= size_target:
		print("YOU'RE WINNER")
		GameManager.game_state["next_level"] = next_level
		GameManager.game_state["level_number"] = level_number
		get_tree().create_timer(win_timeout).timeout.connect(func(): GlobalSignals.request_scene.emit(level_complete))

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		total_size = 100 # Hero Size
		var enemies = get_tree().get_nodes_in_group("Enemy")
		for enemy in enemies:
			set_size(enemy)
			total_size += enemy.slime_size

func set_size(node: Node2D):
	var scale_size = pow(float(node.slime_size) / 100.0, 1.0/3.0)
	node.scale = Vector2(scale_size, scale_size)
