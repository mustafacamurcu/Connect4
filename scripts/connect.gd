extends Node

# const SERVER_URL = "wss://connect4-956952065457.us-central1.run.app";
const SERVER_URL = "ws://localhost:8080";
const SERVER_PORT = 8080;

# server variables
var players = {}

# client variables

func _ready():
	print("ready")
	if DisplayServer.get_name() == "headless" or OS.has_feature("dedicated_server"):
		create_server()

	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	
	SignalBus.clicked_on.connect(_on_clicked_on)

func create_server():
	var socket := WebSocketMultiplayerPeer.new()
	var error = socket.create_server(SERVER_PORT)
	if error:
		print("create server failed with error code " + str(error))
		return
	
	print("server online at " + SERVER_URL)
	multiplayer.multiplayer_peer = socket

func join_server():
	var socket := WebSocketMultiplayerPeer.new()
	var error = socket.create_client(SERVER_URL)
	if error:
		print("host server failed with error code " + str(error))
		return
	
	multiplayer.multiplayer_peer = socket
	print("joined server")


@rpc("call_local", "reliable")
func load_game():
	SignalBus.load_game.emit()

@rpc("reliable")
func accept_click(hex: String):
	SignalBus.clicked_on_accepted.emit(hex)

@rpc("any_peer", "reliable")
func request_click(hex: String):
	accept_click.rpc(hex)

func _on_clicked_on(hex: String):
	request_click.rpc_id(1, hex)

func _on_connected_to_server():
	print("connected to server")

func _on_peer_connected(peer_id):
	players[peer_id] = peer_id
	print("peer connected: " + str(peer_id))

	if multiplayer.is_server() and players.size() >= 2:
		load_game.rpc()

func _on_peer_disconnected(peer_id):
	players.erase(peer_id)
	print("peer disconnected: " + str(peer_id))
