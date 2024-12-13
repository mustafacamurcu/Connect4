extends Button

func _ready():
	pressed.connect(_on_pressed)

func _on_pressed():
	SignalBus.local_multiplayer_pressed.emit()