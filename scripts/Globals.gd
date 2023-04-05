extends Node


# debug
# remember to change this lol
# I ALMOST FORGOT WHEN I RELEASED LMAO
var DEBUG_ON := false

var DEBUG_ROOM := DEBUG_ON and false
var DEBUG_SETTINGS := DEBUG_ON and true


# state
var paused := false
var is_main_menu := true
var inside_end_zone := false # jank hack
var player_collected := 0 # hack to avoid signals
var school_collected := 0 # hack to avoid signals


# settings
var invert_y := false


func _ready() -> void:
	DisplayServer.window_set_title("checking out")
	if not DEBUG_SETTINGS:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		DisplayServer.window_set_position(Vector2i(0, 0)) # sadly necessary
