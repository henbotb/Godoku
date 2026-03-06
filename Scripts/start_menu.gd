extends Control

@onready var code_line_edit: LineEdit = $MultiplayerPanel/MarginContainer/VBoxContainer2/VBoxContainer/HBoxContainer/CodeLineEdit
@onready var multiplayer_panel: Panel = $MultiplayerPanel
@onready var new_game_panel: Panel = $NewGamePanel
@onready var difficulty_select_button: OptionButton = $NewGamePanel/MarginContainer/VBoxContainer2/VBoxContainer3/HBoxContainer/DifficultySelectButton
@onready var board_code_line_edit: LineEdit = $NewGamePanel/MarginContainer/VBoxContainer2/VBoxContainer/HBoxContainer/BoardCodeLineEdit



func _ready() -> void:
	print(_cell_char_to_val(" "))

func _on_quit_button_pressed() -> void:
	Settings.save()
	get_tree().quit()

func toggle_code_visibility():
	code_line_edit.secret = not code_line_edit.secret 

func paste_code():
	code_line_edit.text = DisplayServer.clipboard_get()

func toggle_multiplayer_visibility(on: bool):
	multiplayer_panel.visible = on


func _on_resume_game_button_pressed() -> void:
	pass # Replace with function body.

func _toggle_new_game_visibility(on: bool) -> void:
	new_game_panel.visible = on

	
func _load_new_game_difficulty() -> void:
	
	var board: Array = _convert_between_board_types("050703060007000800000816000000030000005000100730040086906000204840572093000409000", 3, 81, 9, 3, 9)
	
	match(difficulty_select_button.selected):
		0:
			print("easy")
		1:
			print("medium")
		2:
			print("hard")
	
	SceneLoader.load_scene(
		"uid://ceg2ys6ghalka", # puzzle_view.tscn
		SceneLoader.SceneType.Puzzle, 
		{
			"board": BoardResource.new(9, 9, 3, 3, board), 
			"candidates": CandidateResource.new(9, 9, 3, 3, board),
		}
	)


func _cell_char_to_val(character: String) -> int:
	# migrate this system to something more robust:
	# TODO: Add 10+ character handling (upper vs lower case, upper -> unlocked)
	# TODO: consider dropping 4x4...NxN support
	
	if character.is_valid_int():
		return -1 * character.to_int() # negative values indicate locked values
		
	elif character in "!@#$%^&*(":
		for c in range("!@#$%^&*(".length()):
			if "!@#$%^&*("[c] == character:
				return c + 1
	return 0 


func _load_new_game_code() -> void:
				
	# 050703060007000800000816000000030000005000100730040086906000204840572093000409000

	var board: Array = _convert_between_board_types("050703060007000800000816000000030000005000100730040086906000204840572093000409000", 3, 81, 9, 3, 9)

	SceneLoader.load_scene(
		"uid://ceg2ys6ghalka", # puzzle_view.tscn
		SceneLoader.SceneType.Puzzle, 
		{
			"board": BoardResource.new(9, 9, 3, 3, board), 
			"candidates": CandidateResource.new(9, 9, 3, 3, board),
		}
	)


func _convert_between_board_types(_board_string: String, num_block_cols: int, num_cells: int, num_cells_per_block: int, num_columns_per_block: int, num_board_cols: int) -> Array:
	if _board_string.length() != num_cells:
		printerr("Could not initialize converted board type, num_cells != _board_string length")
		return []
		
	var converted_board: Array = []
	
	# refer to test.py need be
	for r in range(0, num_cells, num_cells_per_block * num_block_cols): # 0, num_cells, num_cells_per_block * num_block_cols
		for k in range(0, num_board_cols, num_columns_per_block): # 0, num_board_cols, num_cols_per_block
			var converted_board_row: Array[int] = []
			for i in range(0, num_cells_per_block * num_block_cols, num_cells_per_block): # 0 num_cells_per_block * num_block_cols, num_cells_per_block
				for j in range(0, num_columns_per_block): # 0, num_cols_per_block
					converted_board_row.append(_cell_char_to_val(_board_string[i + j + k + r]))
			converted_board.append(converted_board_row)
			
	return converted_board


func _input(event: InputEvent):
	if event.is_action_pressed(&"settings"):
		toggle_multiplayer_visibility(false)
		_toggle_new_game_visibility(false)
		
