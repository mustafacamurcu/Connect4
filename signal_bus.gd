extends Node


# Game Events
signal clicked_on(hex: Hexagon)
signal hovered_in(hex: Hexagon)
signal hovered_out(hex: Hexagon)

signal grid_updated(hex_grid)


# Settings
signal start_pressed
signal quit_pressed
signal options_pressed
signal escape_pressed
signal bgm_toggled
