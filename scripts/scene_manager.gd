extends Node2D

const MAIN_MENU = preload("res://scenes/main_menu.tscn")
const MULTIPLAYER_MENU = preload("res://scenes/multiplayer_menu.tscn")
const LOBBY_MENU = preload("res://scenes/lobby_menu.tscn")

var main_menu = MAIN_MENU.instantiate()
var multiplayer_menu = MULTIPLAYER_MENU.instantiate()
var lobby_menu = LOBBY_MENU.instantiate()

var menus = [main_menu, multiplayer_menu, lobby_menu]

const GAME = preload("res://scenes/game.tscn")
var game

var lobby = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	for menu in menus:
		add_child(menu)
		menu.hide()
	
	main_menu.show()

	# Main Menu Buttons
	SignalBus.local_multiplayer_pressed.connect(_on_local_multiplayer_pressed)
	SignalBus.online_multiplayer_pressed.connect(_on_online_multiplayer_pressed)

	# Multiplayer Menu Buttons
	SignalBus.host_game_pressed.connect(_on_host_game_pressed)
	SignalBus.join_game_pressed.connect(_on_join_game_pressed)
	SignalBus.quit_pressed.connect(_on_quit_pressed)
	SignalBus.options_pressed.connect(_on_options_pressed)
	SignalBus.escape_pressed.connect(_on_escape_pressed)

	# Lobby Menu Buttons
	SignalBus.lobby_selected.connect(_on_lobby_selected)

	# Server Commands
	SignalBus.joined_lobby.connect(_on_joined_lobby)
	SignalBus.connected_to_server.connect(_on_connected_to_server)


func hide_menus():
	for menu in menus:
		menu.hide()

func _on_host_game_pressed():
	Connect.create_game()

func _on_lobby_selected(lobby_id: int):
	lobby = lobby_id

func _on_joined_lobby(_lobby_data: Dictionary):
	hide_menus()
	lobby_menu.show()

func _on_join_game_pressed():
	if lobby > 0:
		Connect.join_game(lobby)
	else:
		print("no lobby selected")

func _on_local_multiplayer_pressed():
	hide_menus()
	if is_instance_valid(game):
		game.queue_free()
	game = GAME.instantiate()
	add_child(game)

func _on_connected_to_server():
	hide_menus()
	Connect.get_games_list()
	multiplayer_menu.show()

func _on_online_multiplayer_pressed():
	Connect.connect_to_server()

func _on_load_game():
	hide_menus()
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
	main_menu.show()
