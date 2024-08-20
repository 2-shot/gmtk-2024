extends Control

@onready var next_button := $"MarginContainer/PanelContainer/GridContainer/VBoxContainer/VSplitContainer/Next Level Button"
@onready var completed_label := $MarginContainer/PanelContainer/GridContainer/Label
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("twerk")
	var next_level = GameManager.game_state["next_level"]
	var level_number = GameManager.game_state["level_number"]
	if next_level:
		next_button.scene_path = next_level
		GameManager.game_state.erase("next_level")
	if level_number:
		completed_label.text = completed_label.text % level_number
	else:
		completed_label.text = completed_label.text % ""

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_grow_timeout() -> void:
	if $Sprite2D.scale.x < 5:
		$Sprite2D.scale +=  Vector2(0.05,0.05)
	#
