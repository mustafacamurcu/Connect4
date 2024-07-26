class_name Player
extends RefCounted

var colors: Array
var points = 0
var color_index = 0
var type : Constants.Type

func _init(type_ : Constants.Type):
	type = type_
	colors = Constants.colors[type]

func get_color():
	return colors[color_index]

func advance():
	color_index = (color_index + 1) % colors.size()
