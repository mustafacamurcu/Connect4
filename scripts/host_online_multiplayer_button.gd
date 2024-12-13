extends Button

func _ready():
	pressed.connect(_on_pressed)

func _on_pressed():
	SignalBus.online_multiplayer_pressed.emit()