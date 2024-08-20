extends Node2D

@onready var knob = $Knob

var pressing := false
var posVector : Vector2
var show_debug := false

@export var maxLength = 64
@export var deadzone = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	maxLength *= scale.x
	prints(OS.has_feature("mobile"), show_debug)
	visible = OS.has_feature("mobile") or show_debug
	set_process(visible)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if pressing:
		if get_global_mouse_position().distance_to(global_position) <= maxLength:
			knob.global_position = get_global_mouse_position()
		else:
			var angle = global_position.angle_to_point(get_global_mouse_position())
			knob.global_position.x = global_position.x + cos(angle)*maxLength
			knob.global_position.y = global_position.y + sin(angle)*maxLength
		calculateVector()
	else:
		knob.global_position = lerp(knob.global_position, global_position, delta*10)
		posVector = Vector2.ZERO
	GameManager.game_state["joystick"] = posVector

func calculateVector():
	if abs((knob.global_position.x - global_position.x)) - deadzone:
		posVector.x = (knob.global_position.x - global_position.x)/maxLength
	if abs((knob.global_position.y - global_position.y)) - deadzone:
		posVector.y = (knob.global_position.y - global_position.y)/maxLength

func _on_button_button_down():
	pressing = true

func _on_button_button_up():
	pressing = false


func _input(event):
	if event.is_action_pressed("terminal"):
		show_debug = not show_debug;
		if show_debug:
			visible = true
			set_process(true)
		else:
			posVector = Vector2.ZERO
			GameManager.game_state.erase("joystick")
