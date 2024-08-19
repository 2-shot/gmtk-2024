extends Label

var text_log = {}

func update(key : String, value: String):
	text_log[key] = value
	text = ""
	for i in text_log:
		text += "%s: %s\n" % [i, text_log[i]]

func _ready():
	GlobalSignals.debug.connect(update)
