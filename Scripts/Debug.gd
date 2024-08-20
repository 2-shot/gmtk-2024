extends Label

@export var show_debug : bool = false

var debug_log := {}

func update(key : String, value: String):
	debug_log[key] = value
	text = ""
	for i in debug_log:
		text += "%s: %s\n" % [i, debug_log[i]]

func _ready():
	GlobalSignals.debug.connect(update)

func _process(_delta):
	visible = show_debug

func _input(event):
	if event.is_action_pressed("terminal"):
		show_debug = not show_debug;
