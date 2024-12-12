extends Node


# Input Events
signal clicked_on(hex: String)
signal hovered_in(hex: Hexagon)
signal hovered_out(hex: Hexagon)

signal grid_updated(hex_grid)

# Server Events
signal load_game

signal clicked_on_accepted(hex: String)
signal hovered_in_accepted(hex: Hexagon)
signal hovered_out_accepted(hex: Hexagon)

# Client Events
signal joined_to_server

# UI Events
signal local_multiplayer_pressed
signal host_online_multiplayer_pressed
signal restart_pressed

signal quit_pressed
signal options_pressed
signal escape_pressed
signal bgm_toggled
