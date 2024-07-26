class_name Hexagon
extends Area2D
@onready var collision_polygon_2d = $CollisionPolygon2D
@onready var polygon_2d : Polygon2D = $Polygon2D
@onready var hover : Polygon2D = $Hover
@onready var debug_label = $DebugLabel

var ratio = 0.90
var mouse_in = false
var pressed = false
var type: Constants.Type
var coord : Coord:
	set(c):
		coord = c
		position = c.to_position()

func neighbors():
	return coord.neighbors()

func show_debug():
	debug_label.show()
	debug_label.text = "(" + coord.q + ", " + coord.r + ")"

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group('Hexes')
	scale.x = Constants.HEXAGON_EDGE * ratio
	scale.y = Constants.HEXAGON_EDGE * ratio
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	set_type(Constants.Type.Available)

func _on_mouse_entered():
	SignalBus.hovered_in.emit(self)
	mouse_in = true
	
func _on_mouse_exited():
	SignalBus.hovered_out.emit(self)
	mouse_in = false

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			if mouse_in:
				pressed = true
		else:
			if mouse_in and pressed:
				SignalBus.clicked_on.emit(self)
			pressed = false

func set_type(t: Constants.Type):
	type = t
	set_color(Constants.colors[type])

func set_player(player: Player):
	type = player.type
	set_color(player.get_color())

func set_color(c: Color):
	polygon_2d.color = c

func get_color():
	return polygon_2d.color

func activate_hover(c: Color):
	hover.color = c
	hover.show()

func deactivate_hover():
	hover.hide()
