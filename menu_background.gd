extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(-20, 20):
		for j in range(-20, 10):
			var hex = Constants.create_hexagon(Constants.HEXAGON_EDGE)
			add_child(hex)
			var coord = Coord.new(i, j)
			hex.position = coord.to_position()
			hex.scale.x = 0.92
			hex.scale.y = 0.92
			hex.color = [
				Constants.GREEN,
				Constants.GREEN2,
				Constants.RED,
				Constants.RED2].pick_random()