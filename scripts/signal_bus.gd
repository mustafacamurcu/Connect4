extends Node

# Input Events
signal clicked_on(hex: String)
signal hovered_in(hex: Hexagon)
signal hovered_out(hex: Hexagon)

signal grid_updated(hex_grid)

# Server Events
signal clicked_on_accepted(hex: String)

signal player_added_to_lobby(player_id: int, display_name: String)
signal player_left(player_id: int)
# {game_id, player_count, players: {peer_id -> {display_name}}, lobby_name}
signal joined_lobby(lobby_data: Dictionary)
# {game_id -> lobby_data}
signal games_list_updated(games: Dictionary)
signal connected_to_server

# UI Events
signal local_multiplayer_pressed
signal online_multiplayer_pressed
signal restart_pressed
signal host_game_pressed
signal join_game_pressed
signal lobby_selected(lobby_id: int)

signal quit_pressed
signal options_pressed
signal escape_pressed
