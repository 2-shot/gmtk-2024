extends Control

@onready var skip : SceneButton = $"Skip Introduction"
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var enemy_intro : AnimationPlayer = $Sprite2D/enemy_intro/AnimationPlayer
@onready var hero_intro : AnimationPlayer = $Sprite2D/hero_intro/AnimationPlayer

func _ready() -> void:
	animation_player.play("intro_animation")
	enemy_intro.play("idle")
	hero_intro.play("idle")

func _process(_delta: float) -> void:
	pass

func _input(event):
	if event.is_action_pressed("skip"):
		print(animation_player.current_animation_position)
		if not animation_player.is_playing():
			skip.load_scene()
		animation_player.speed_scale = 100
