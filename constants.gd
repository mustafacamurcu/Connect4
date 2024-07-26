extends Node

const HEXAGON_EDGE = 100
const HEXAGON_WIDTH = HEXAGON_EDGE*sqrt(3)
const HEXAGON_HEIGHT = HEXAGON_EDGE*2

static var GREEN : Color = Color.html("#8EA604")
static var GREEN2 : Color = Color.html("#333C02")
static var BLUE : Color = Color.html("#44ccff")
static var RED : Color = Color.html("#FF3A20")
static var RED2 : Color = Color.html("#520A00")
#static var WHITE : Color = Color.NAVAJO_WHITE
static var WHITE : Color = Color.html("#E5D4CE")
static var GRAY : Color = Color.DIM_GRAY

enum Type {
	Player1,
	Player2,
	Available,
	Unavailable
}

static var colors = {
	Type.Player1 : [GREEN, GREEN2],
	Type.Player2 : [RED, RED2],
	Type.Available: WHITE,
	Type.Unavailable: GRAY,
}
