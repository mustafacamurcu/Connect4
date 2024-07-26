class_name Coord
extends Resource

const Q_VECTOR = Vector2(sqrt(3),0) * Constants.HEXAGON_EDGE
const R_VECTOR = Vector2(sqrt(3)/2,3./2) * Constants.HEXAGON_EDGE

var q
var r

func _init(qq,rr):
	q = qq
	r = rr

func _to_string():
	return '(' + str(r) + ', ' + str(q) + ')'

func add(other: Coord):
	return Coord.new(q+other.q, r+other.r)

func mult(factor: int):
	return Coord.new(q*factor, r*factor)

static func directions():
	return [
		Coord.new(1, 0),
		Coord.new(1, -1),
		Coord.new(0, -1),
		Coord.new(0, 1),
		Coord.new(-1, 0),
		Coord.new(-1, 1)]

func neighbors():
	var n = []
	for dir in Coord.directions():
		n.append(self.add(dir))
	return n

func to_position():
	return q * Q_VECTOR + r * R_VECTOR
