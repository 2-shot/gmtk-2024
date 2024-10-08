extends CanvasLayer

@export var hunger_goal : int = 800
@export var show_debug : bool = false
@export var show_joystick : bool = false

@onready var hunger_bar = $Control/HBoxContainer/HungerBar
@onready var joystick = $Joystick
@onready var debug = $Control/Debug
@onready var window : Window = get_window()
@onready var viewport : Viewport = get_viewport()
@onready var pause_button = $Control/HBoxContainer/PauseButton

var is_mobile : bool = false

func resize():
	var joystick_height = joystick.maxLength * 2
	joystick.global_position.y = viewport.size.y - joystick_height

func _ready():
	hunger_bar.max_value = hunger_goal
	debug.visible = show_debug

	if OS.has_feature("mobile"):
		is_mobile = true

	if OS.has_feature("web") and JavaScriptBridge.eval("navigator.maxTouchPoints > 0", true):
		is_mobile = true

	joystick.visible = is_mobile
	pause_button.visible = is_mobile

	if get_tree().root.content_scale_mode == Window.CONTENT_SCALE_MODE_DISABLED:
		resize()
		get_tree().get_root().size_changed.connect(resize)

func _input(event):
	if event.is_action_pressed("terminal"):
		debug.visible = not debug.visible
		joystick.visible = true
		pause_button.visible = true

	if event is InputEventScreenTouch:
		joystick.visible = true
		pause_button.visible = true
		is_mobile = true
