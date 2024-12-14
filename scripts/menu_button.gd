extends Button

@export var font_size: int = 100
@export var signal_name: String

func _ready() -> void:
	add_theme_font_size_override("font_size", font_size)
	add_theme_constant_override("outline_size", int(font_size / 3.0))
	flat = true

func _pressed():
	SignalBus[signal_name + "_pressed"].emit()