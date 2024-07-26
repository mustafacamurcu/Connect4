extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.grid_updated.connect(_on_grid_updated)

func _on_grid_updated(hex_container):
	var min_x = INF
	var min_y = INF
	var max_x = -INF
	var max_y = -INF
	for hex in hex_container.get_children():
		if hex != null:
			var x = hex.global_position.x
			var y = hex.global_position.y
			if x < min_x:
				min_x = x
			if x > max_x:
				max_x = x
			if y < min_y:
				min_y = y
			if y > max_y:
				max_y = y
	
	var min_width = Constants.HEXAGON_WIDTH*5
	var min_height = Constants.HEXAGON_HEIGHT*5
	
	var width = max_x - min_x + Constants.HEXAGON_WIDTH*2
	var height = max_y - min_y + Constants.HEXAGON_HEIGHT*2
	
	width = max(min_width, width)
	height = max(min_height, height)
	
	var size : Vector2 = get_viewport().size
	zoom.x = 1/min(width/size.x, height/size.y) * 0.5
	zoom.y = 1/min(width/size.x, height/size.y) * 0.5
	position = Vector2((min_x+max_x)/2, (min_y+max_y)/2)
