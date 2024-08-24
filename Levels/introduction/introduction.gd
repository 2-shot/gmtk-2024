extends Control

@onready var skip : SceneButton = $"Skip Introduction"
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var enemy_intro : AnimationPlayer = $Sprite2D/enemy_intro/AnimationPlayer
@onready var hero_intro : AnimationPlayer = $Sprite2D/hero_intro/AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("intro_animation")
	enemy_intro.play("idle")
	hero_intro.play("idle")

func _process(_delta: float) -> void:
	pass


#func _on_grow_timeout() -> void:
	#if $Sprite2D.scale.x < 5:
		#$Sprite2D.scale +=  Vector2(0.05,0.05)
	#

func _input(event):
	if event.is_action_pressed("skip"):
		skip.load_scene()
	if event is InputEventScreenTouch or event is InputEventMouseButton:
		animation_player.seek(animation_player.current_animation_length, true)
