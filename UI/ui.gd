extends CanvasLayer

@export var hunger_goal : int = 800
@onready var hunger_bar = $Control/HBoxContainer/HungerBar
@onready var joystick = $Joystick

func _ready():
	hunger_bar.max_value = hunger_goal

func _process(_delta):
	var window_size = get_window().size
	var joystick_height = joystick.maxLength * 2
	
	joystick.global_position.y = window_size.y - joystick_height
