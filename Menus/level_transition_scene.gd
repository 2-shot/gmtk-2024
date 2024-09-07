extends Control

@onready var next_button : SceneButton = $"MarginContainer/PanelContainer/GridContainer/VBoxContainer/VSplitContainer/Next Level Button"
@onready var completed_label := $MarginContainer/PanelContainer/GridContainer/Label
@onready var animation_player = $AnimationPlayer
@onready var sprite_2d = $Sprite2D

@export_file("*.tscn") var menu = "res://Menus/MainMenu.tscn"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("twerk")
	if GameManager.game_state.has("next_level"):
		var next_level = GameManager.game_state["next_level"]
		next_button.set_scene(next_level)
		GameManager.game_state.erase("next_level")
	else:
		next_button.set_scene(menu)
	if GameManager.game_state.has("level_number"):
		var level_number = GameManager.game_state["level_number"]
		completed_label.text = completed_label.text.format({"lvl" : level_number})
	else:
		completed_label.text = completed_label.text.format({"lvl" : 0})

func _on_grow_timeout() -> void:
	if sprite_2d.scale.x < 5:
		sprite_2d.scale +=  Vector2(0.05,0.05)

func _input(event):
	if event.is_action_pressed("skip"):
		next_button.load_scene()
