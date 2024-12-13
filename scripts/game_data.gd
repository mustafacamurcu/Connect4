class_name GameData
extends Resource

# Online Multiplayer Data
# {peer_id -> {display_name}}
var players = {}
var host
var lobby_name
var game_id

# {game_id, player_count, players: {peer_id -> {display_name}}, lobby_name}
func to_dict() -> Dictionary:
	return {
		"game_id": game_id,
		"player_count": players.size(),
		"players": players,
		"lobby_name": lobby_name
	}
