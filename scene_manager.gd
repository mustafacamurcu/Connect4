extends Node2D

const OPENING = preload("res://opening.tscn")
const GAME = preload("res://game.tscn")
@onready var audio_stream_player = $AudioStreamPlayer

var opening
var game

var first_time = true

# Called when the node enters the scene tree for the first time.
func _ready():
	opening = OPENING.instantiate()
	add_child(opening)

	SignalBus.start_pressed.connect(_on_start_pressed)
	SignalBus.quit_pressed.connect(_on_quit_pressed)
	SignalBus.options_pressed.connect(_on_options_pressed)
	SignalBus.escape_pressed.connect(_on_escape_pressed)
	
	SignalBus.bgm_toggled.connect(_on_bgm_toggled)
	
func _on_bgm_toggled(on):
	audio_stream_player.stream_paused = not on

func _on_start_pressed():
	opening.hide()
	if is_instance_valid(game):
		game.queue_free()
	game = GAME.instantiate()
	add_child(game)
	if not first_time:
		game.disable_tutorial()
	else:
		first_time = false
func _on_quit_pressed():
	get_tree().quit()

func _on_options_pressed():
	pass

func _on_escape_pressed():
	game.queue_free()
	opening.show()
	
