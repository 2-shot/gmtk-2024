extends CanvasLayer

@export var show_debug := false : set = set_debug
@onready var debug_log := $Control/Label

func set_debug(value: bool):
	show_debug = value
	if debug_log:
		debug_log.show_debug = show_debug

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
