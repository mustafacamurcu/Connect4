extends Node2D

@onready
var players_container: VBoxContainer = $Players
var labels = {}

func _ready() -> void:
	# Server Commands
	SignalBus.joined_lobby.connect(_on_joined_lobby)
	SignalBus.player_added_to_lobby.connect(_on_player_added_to_lobby)
	SignalBus.player_left.connect(_on_player_left)

# {game_id, player_count, players: {peer_id -> {display_name}}, lobby_name}
func _on_joined_lobby(lobby_data: Dictionary):
	# Reset Lobby Data
	labels = {}
	for child in players_container.get_children():
		child.free()
	# Add all players to lobby data
	for player_id in lobby_data.players.keys():
		var display_name = lobby_data.players[player_id].display_name
		_on_player_added_to_lobby(player_id, display_name)

func _on_player_added_to_lobby(player_id, display_name):
	if player_id in labels:
		return
	var label = Label.new()
	labels[player_id] = label
	players_container.add_child(label)
	label.text = display_name

func _on_player_left(player_id):
	labels[player_id].free()
	labels.erase(player_id)
