extends Label

var debug_log := {}

func update(key : String, value: String):
	debug_log[key] = value
	text = ""
	for i in debug_log:
		text += "%s: %s\n" % [i, debug_log[i]]

func _ready():
	GlobalSignals.debug.connect(update)
