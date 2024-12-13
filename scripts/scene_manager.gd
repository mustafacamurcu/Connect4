extends Node2D

const MENU = preload("res://scenes/menu_screen.tscn")
const GAME = preload("res://scenes/game.tscn")
const LOBBY = preload("res://scenes/lobby.tscn")

var menu
var game
var lobby

# Called when the node enters the scene tree for the first time.
func _ready():
	menu = MENU.instantiate()
	lobby = LOBBY.instantiate()

	add_child(menu)
	add_child(lobby)

	lobby.hide()

	SignalBus.local_multiplayer_pressed.connect(_on_local_multiplayer_pressed)
	SignalBus.online_multiplayer_pressed.connect(_on_online_multiplayer_pressed)
	SignalBus.load_game.connect(_on_load_game)
	SignalBus.quit_pressed.connect(_on_quit_pressed)
	SignalBus.options_pressed.connect(_on_options_pressed)
	SignalBus.escape_pressed.connect(_on_escape_pressed)

func _on_local_multiplayer_pressed():
	menu.hide()
	if is_instance_valid(game):
		game.queue_free()
	game = GAME.instantiate()
	add_child(game)

func _on_online_multiplayer_pressed():
	menu.hide()
	lobby.show()

func _on_load_game():
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
