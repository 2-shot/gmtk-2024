extends CanvasLayer

@export var hunger_goal : int = 800
@onready var hunger_bar = $Control/HBoxContainer/HungerBar

func _ready():
	hunger_bar.max_value = hunger_goal

func _process(_delta):
	pass
