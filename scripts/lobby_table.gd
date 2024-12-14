extends Tree

var lobby_list = {}

var root: TreeItem

func _ready() -> void:
	select_mode = SELECT_ROW
	root = create_item()
	hide_root = true
	columns = 3
	column_titles_visible = true
	set_column_title(0, "Lobby Name")
	set_column_title(1, "Player Count")
	set_column_title(2, "Lobby ID")

	set_column_expand(1, false)
	set_column_expand(2, false)
	
	for i in range(3):
		var row = root.create_child()
		row.set_text(0, str(i))
		row.set_text(1, str(i * i))
	
	item_selected.connect(_on_item_selected)

	SignalBus.games_list_updated.connect(_on_games_list_updated)

# {game_id -> {game_id, player_count, players: {peer_id -> {display_name}}, lobby_name}}
func _on_games_list_updated(games: Dictionary):
	lobby_list = games
	root.free()
	root = create_item()
	for lobby in lobby_list.values():
		var row = root.create_child()
		row.set_text(0, lobby.lobby_name)
		row.set_text(1, str(lobby.player_count))
		row.set_text(2, str(lobby.game_id))


func _on_item_selected():
	var item: TreeItem = get_selected()
	var lobby_id = item.get_text(2)
	SignalBus.selected_lobby_id = int(lobby_id)
