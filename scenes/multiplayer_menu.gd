extends Node2D

@onready
var games_list: ItemList = $GameList

func _ready() -> void:
	# Server Commands
	SignalBus.games_list_updated.connect(_on_games_list_updated)
	games_list.item_selected.connect(_on_item_selected)

# {game_id -> {game_id, player_count, players: {peer_id -> {display_name}}, lobby_name}}
func _on_games_list_updated(games: Dictionary):
	games_list.clear()
	for game in games.values():
		games_list.add_item(str(game.game_id))
		print(game.game_id)

func _on_item_selected(index: int):
	var text = games_list.get_item_text(index)
	print(text)
	print(str(int(text)))
	SignalBus.lobby_selected.emit(int(text))
