extends MultiplayerApi

# const SERVER_URL = "wss://connect4-956952065457.us-central1.run.app";
const SERVER_URL = "ws://localhost:8080";
const SERVER_PORT = 8080;

# Setup
func _ready():
	if DisplayServer.get_name() == "headless": # or OS.has_feature("dedicated_server"):
		start_server()
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)

func start_server():
	var socket := WebSocketMultiplayerPeer.new()
	var error = socket.create_server(SERVER_PORT)
	if error:
		print("create server failed with error code " + str(error))
		return
	print("server online at " + SERVER_URL)
	multiplayer.multiplayer_peer = socket

func connect_to_server():
	var socket := WebSocketMultiplayerPeer.new()
	var error = socket.create_client(SERVER_URL)
	print(error)
	if error:
		print("host server failed with error code " + str(error))
		return
	multiplayer.multiplayer_peer = socket
	print("joined server")


# Multiplayer API
func set_display_name(display_name: String):
	_set_display_name.rpc_id(1, display_name)

func create_game():
	_create_game.rpc_id(1, SignalBus.display_name)

func join_game(game_id: int):
	_join_game.rpc_id(1, game_id, SignalBus.display_name)

func get_games_list():
	_get_games_list.rpc_id(1);

func start_game():
	push_error("not implemented")

func send_move():
	push_error("not implemented")


# Runs on Clients
@rpc("reliable")
func _player_added_to_lobby(player_id, display_name):
	SignalBus.player_added_to_lobby.emit(player_id, display_name)

@rpc("reliable")
func _player_left(player_id):
	SignalBus.player_left.emit(player_id)

@rpc("reliable")
func _games_list_updated(list: Dictionary):
	SignalBus.games_list_updated.emit(list)

@rpc("reliable")
func _joined_lobby(lobby_data: Dictionary):
	SignalBus.joined_lobby.emit(lobby_data)


# Server variables
var peers = {} # {peer_id -> display_name}
var games = {} # {game_id -> GameData}

# Runs on Server
@rpc("any_peer", "reliable")
func _set_display_name(display_name: String):
	if _not_server(): return
	var peer_id = multiplayer.get_remote_sender_id()
	peers[peer_id].display_name = display_name

@rpc("any_peer", "reliable")
func _create_game(display_name: String):
	if _not_server(): return
	# get peer_id and display name for host
	var peer_id = multiplayer.get_remote_sender_id()
	peers[peer_id].display_name = display_name
	# create game, use peer_id of host as game_id
	var game = GameData.new()
	games[peer_id] = game
	game.game_id = peer_id
	game.host = peer_id
	game.lobby_name = display_name + "'s Lobby"
	_add_player_to_game(peer_id, game.game_id)

@rpc("any_peer", "reliable")
func _join_game(game_id: int, display_name: String):
	if _not_server(): return
	# get peer_id and game
	var peer_id = multiplayer.get_remote_sender_id()
	peers[peer_id].display_name = display_name
	_add_player_to_game(peer_id, game_id)

@rpc("any_peer", "reliable")
func _get_games_list():
	if _not_server(): return
	var peer_id = multiplayer.get_remote_sender_id()
	_games_list_updated.rpc_id(peer_id, games_list())


# Server Util
func _add_player_to_game(peer_id: int, game_id: int):
	var display_name = peers[peer_id].display_name
	# create player
	var player = {"display_name": display_name}
	# add player to game
	var game = games[game_id]
	game.players[peer_id] = player
	peers[peer_id].game = game
	# notify all players
	for all in game.players.keys():
		_player_added_to_lobby.rpc_id(all, peer_id, display_name)
	# tell player about the game
	_joined_lobby.rpc_id(peer_id, game.to_dict())
	_games_list_updated.rpc(games_list())

func _not_server():
	if not multiplayer.is_server():
		push_error("this shouldn't be called on a client")
		return true
	return false

func games_list() -> Dictionary:
	var list = {}
	for game_id in games:
		list[game_id] = games[game_id].to_dict()
	return list


# Signals
func _on_connected_to_server():
	SignalBus.connected_to_server.emit()
	print("connected to server")

func _on_peer_connected(peer_id):
	print("peer connected: " + str(peer_id))
	if not multiplayer.is_server():
		return
	peers[peer_id] = {"display_name": Constants.DISPLAY_NAMES.pick_random()}

func _on_peer_disconnected(peer_id):
	print("peer disconnected: " + str(peer_id))
	if not multiplayer.is_server():
		return
	# remove player from game. If game is empty now, remove it.
	if "game" in peers[peer_id]:
		var game = peers[peer_id].game
		game.players.erase(peer_id)
		var player_count = game.players.size()
		# if the game is now empty, remove it.
		if player_count == 0:
			games.erase(game.game_id)
			_player_left.rpc(peer_id)
		# notify remaining players.
		for player in game.players.keys():
			_player_left.rpc_id(player, peer_id)
		_games_list_updated.rpc(games_list())
	# remove peer from peers
	peers.erase(peer_id)
