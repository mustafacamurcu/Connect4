extends Node2D

@onready
var display_names_container: Node2D = $DisplayNames

func _ready() -> void:
	# Server Commands
	SignalBus.joined_lobby.connect(_on_joined_lobby)
	SignalBus.player_added_to_lobby.connect(_on_player_added_to_lobby)
	SignalBus.player_left.connect(_on_player_left)

# {game_id, player_count, players: {peer_id -> {display_name}}, lobby_name}
func _on_joined_lobby(lobby_data: Dictionary):
	for player in lobby_data.players.values():
		var label = Label.new()
		display_names_container.add_child(label)
		label.text = player.display_name
		print(player.display_name)

func _on_player_added_to_lobby(player_id, display_name):
	var label = Label.new()
	display_names_container.add_child(label)
	label.text = display_name
	print(display_name)

func _on_player_left(player_id):
	pass
