class_name Game
extends Node2D

const HEXAGON = preload("res://hexagon.tscn")

@onready var camera_2d = $Camera2D
@onready var hex_container = $HexContainer
@onready var game_end_menu = $CanvasLayer/GameEndMenu
@onready var wins = $CanvasLayer/GameEndMenu/MarginContainer/Wins

var players: Array[Player] = []
var active_player_index: int = 0
var hexes: Dictionary = {}

var showing_label = false

var GRID_WIDTH = 15
var GRID_HEIGHT = 10

func _ready():
	game_end_menu.hide()
	explore_hex(Coord.new(0, 0))
	
	var p1 = Player.new(Constants.Type.Player1)
	var p2 = Player.new(Constants.Type.Player2)
	players.append(p1)
	players.append(p2)
	
	SignalBus.clicked_on.connect(_on_clicked_on)
	SignalBus.hovered_in.connect(_on_hovered_in)
	SignalBus.hovered_out.connect(_on_hovered_out)

	SignalBus.restart_pressed.connect(restart)

func _unhandled_key_input(event):
	if event.is_action('escape'):
		SignalBus.escape_pressed.emit()

func is_player_controlled(hex: Hexagon):
	return hex.type == Constants.Type.Player1 or hex.type == Constants.Type.Player2

func restart():
	active_player_index = 0
	hexes = {}
	for child in hex_container.get_children():
		child.queue_free()
	
	game_end_menu.hide()
	explore_hex(Coord.new(0, 0))

func check_for_win(hex: Hexagon):
	for direction: Coord in Coord.directions():
		for start in range(-3, 0):
			var all_good = true
			for offset in range(start, start + 4):
				var coord: Coord = hex.coord.add(direction.mult(offset))
				if not str(coord) in hexes or hexes[str(coord)].type != hex.type or hexes[str(coord)].get_color() != hex.get_color():
					all_good = false
					break
			if all_good:
				print_debug("Win")
				game_end_menu.show()
				if hex.type == Constants.Type.Player1:
					wins.text = "Player 1 Wins!"
				else:
					wins.text = "Player 2 Wins!"
				return

func play_hex(hex: Hexagon):
	hex.deactivate_hover()
	hex.set_player(players[active_player_index])

	# Explore neighbors
	var neighbors = hex.neighbors()
	for neighbor in neighbors:
		if not str(neighbor) in hexes:
			explore_hex(neighbor)
	check_for_win(hex)

func explore_hex(coord: Coord):
	# Create and add new hex to grid
	var hex: Hexagon = HEXAGON.instantiate()
	hex.coord = coord
	hexes[str(coord)] = hex
	hex_container.add_child(hex)
	SignalBus.grid_updated.emit(hex_container)


func _on_clicked_on(hex: Hexagon):
	if (hex.type == Constants.Type.Available):
		play_hex(hex)
		advance_player()

func _on_hovered_in(hex: Hexagon):
	if hex.type == Constants.Type.Available:
		var c = players[active_player_index].get_color()
		hex.activate_hover(c)

func _on_hovered_out(hex: Hexagon):
	hex.deactivate_hover()

func advance_player():
	players[active_player_index].advance()
	active_player_index = (active_player_index + 1) % players.size()
