extends Node

var config = ConfigFile.new()

# DISPLAY AND AUDIO SETTINGS
var fullscreen: bool:
	set (value):
		if value:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

var master_percentage: float
var music_percentage: float
var effect_percentage: float

# BOARD SETTINGS
var highlight_block: bool
var highlight_orthogonal: bool
var highlight_same_value: bool
var highlight_candidates: bool
var highlight_empty_cells: bool
var highlight_all: bool

var highlight_color: Color:
	set(value):
		HIGHLIGHTED.get_stylebox("normal", "Button").bg_color = value
		highlight_color = value

# KEYBIND SETTINSG

# settings that don't rely on the menu
const HIGHLIGHTED = preload("uid://be5h05f4havy0")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	# TODO: delete these lines, resets config for testing purpose
	#var dir = DirAccess.open("user://")
	#dir.remove("game_settings.cfg")
	
	if config.load("user://game_settings.cfg") != OK:
		printerr("User didn't have a game_settings.cfg")
	
	load_settings()
	save()

func load_settings():	
	# DISPLAY AND AUDIO SETTINGS
	fullscreen = config.get_value("game_settings", "fullscreen", false)
	master_percentage = config.get_value("game_settings", "master_percentage", 0.75)
	music_percentage = config.get_value("game_settings", "music_percentage", 0.75)
	effect_percentage = config.get_value("game_settings", "effect_percentage", 0.75)
	
	# BOARD SETTINGS
	highlight_block = config.get_value("board_settings", "highlight_block", true)
	highlight_orthogonal = config.get_value("board_settings", "highlight_orthogonal", true)
	highlight_same_value= config.get_value("board_settings", "highlight_same_value", true)
	highlight_candidates = config.get_value("board_settings", "highlight_candidates", true)
	highlight_empty_cells = config.get_value("board_settings", "highlight_empty_cells", true)
	highlight_all = config.get_value("board_settings", "highlight_all", false)
	
	highlight_color = config.get_value("board_settings", "highlight_color", Color.ROYAL_BLUE)

	# KEYBIND SETTINGS


func save():
	# DISPLAY AND AUDIO SETTINGS
	config.set_value("game_settings", "fullscreen", fullscreen)
	config.set_value("game_settings", "master_percentage", master_percentage)
	config.set_value("game_settings", "music_percentage", music_percentage)
	config.set_value("game_settings", "effect_percentage", effect_percentage)
	
	# BOARD SETTINGS
	config.set_value("board_settings", "highlight_block", highlight_block)
	config.set_value("board_settings", "highlight_orthogonal", highlight_orthogonal)
	config.set_value("board_settings", "highlight_same_value", highlight_same_value)
	config.set_value("board_settings", "highlight_candidates", highlight_candidates)
	config.set_value("board_settings", "highlight_empty_cells", highlight_empty_cells)
	config.set_value("board_settings", "highlight_all", highlight_all)
	
	config.set_value("board_settings", "highlight_color", highlight_color)
	
	# KEYBIND SETTINGS

	config.save("user://game_settings.cfg")
	
func _notifications(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save()
