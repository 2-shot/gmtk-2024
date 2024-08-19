extends ProgressBar

# Get a local copy of your fill StyleBoxFlat
@onready var progress_style : StyleBoxFlat = get_theme_stylebox("fill").duplicate()

func size_changed(size : int):
	value = size
	var percent = (value - min_value) / (max_value - min_value)
	modulate = Color.RED.lerp(Color.GREEN, percent)

	GlobalSignals.debug.emit("Hunger percent", str(percent) + str(modulate))

# Called when the node enters the scene tree for the first time.
func _ready():
	var percent = (value - min_value) / (max_value - min_value) 
	modulate = Color.RED.lerp(Color.GREEN, percent)
	GlobalSignals.hero_size.connect(size_changed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
