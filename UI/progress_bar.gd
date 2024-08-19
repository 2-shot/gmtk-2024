extends ProgressBar

func size_changed(size : int):
	value = size

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalSignals.hero_size.connect(size_changed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
