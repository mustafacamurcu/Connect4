extends Button

func _ready():
	pressed.connect(_on_pressed)

func _on_pressed():
	SignalBus.host_online_multiplayer_pressed.emit()