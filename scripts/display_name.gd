extends LineEdit

func _ready() -> void:
	text_changed.connect(_on_text_changed)

func _on_text_changed(new_text: String):
	SignalBus.display_name = new_text
