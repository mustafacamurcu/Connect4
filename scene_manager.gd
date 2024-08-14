extends Node2D

const MENU = preload("res://menu_screen.tscn")
const GAME = preload("res://game.tscn")
@onready var audio_stream_player = $AudioStreamPlayer

var menu
var game

# Called when the node enters the scene tree for the first time.
func _ready():
	menu = MENU.instantiate()
	add_child(menu)

	SignalBus.local_multiplayer_pressed.connect(_on_local_multiplayer_pressed)
	SignalBus.quit_pressed.connect(_on_quit_pressed)
	SignalBus.options_pressed.connect(_on_options_pressed)
	SignalBus.escape_pressed.connect(_on_escape_pressed)
	
	SignalBus.bgm_toggled.connect(_on_bgm_toggled)
	
func _on_bgm_toggled(on):
	audio_stream_player.stream_paused = not on

func _on_local_multiplayer_pressed():
	menu.hide()
	if is_instance_valid(game):
		game.queue_free()
	game = GAME.instantiate()
	add_child(game)

func _on_quit_pressed():
	get_tree().quit()

func _on_options_pressed():
	pass

func _on_escape_pressed():
	game.queue_free()
	menu.show()
