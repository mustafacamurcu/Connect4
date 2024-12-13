extends Button

@export var signal_name: String

func _pressed():
	SignalBus[signal_name + "_pressed"].emit()