extends Node2D

const HEXAGON = preload("res://hexagon.tscn")

@onready var start_container = $Start

const text = "Start"
var hexes : Array[Hexagon]

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(len(text)):
		var hex = Constants.create_hexagon(Constants.HEXAGON_EDGE)
		hex.position = Vector2(Constants.HEXAGON_WIDTH*(i*1.03+0.5), 0)
		start_container.add_child(hex)
