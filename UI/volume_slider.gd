extends HSlider

@export var bus_name: String

var bus_index: int

func on_value_changed(new_value: float):
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(new_value))

func _ready():
	bus_index = AudioServer.get_bus_index(bus_name)
	value_changed.connect(on_value_changed)
	value = db_to_linear(AudioServer.get_bus_volume_db(bus_index))
