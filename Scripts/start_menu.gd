extends Control

@onready var code_line_edit: LineEdit = $MultiplayerPanel/MarginContainer/VBoxContainer2/VBoxContainer/HBoxContainer/CodeLineEdit
@onready var multiplayer_panel: Panel = $MultiplayerPanel
@onready var new_game_panel: Panel = $NewGamePanel
@onready var difficulty_select_button: OptionButton = $NewGamePanel/MarginContainer/VBoxContainer2/VBoxContainer3/HBoxContainer/DifficultySelectButton
@onready var board_code_line_edit: LineEdit = $NewGamePanel/MarginContainer/VBoxContainer2/VBoxContainer/HBoxContainer/BoardCodeLineEdit
@onready var paste_code_button: Button = $NewGamePanel/MarginContainer/VBoxContainer2/VBoxContainer/HBoxContainer/PasteCodeButton

enum Difficulty {
	EASY = 0,
	MEDIUM,
	HARD,
	DIABOLICAL,
}


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
	
	var board_unconverted: String = _get_puzzle_string(difficulty_select_button.selected)
	var board_converted: Array = _convert_between_board_types(board_unconverted, 3, 81, 9, 3, 9)

	SceneLoader.load_scene(
		"uid://ceg2ys6ghalka", # puzzle_view.tscn
		SceneLoader.SceneType.PuzzleSingleplayer, 
		{
			"board": BoardResource.new(9, 9, 3, 3, board_converted), 
			"candidates": CandidateResource.new(9, 9, 3, 3, board_converted),
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

	var board: Array = _convert_between_board_types(board_code_line_edit.text.lstrip(" ").rstrip(" "), 3, 81, 9, 3, 9)
	if board == []:
		board_code_line_edit.placeholder_text = "Invalid Code!"
		board_code_line_edit.add_theme_color_override(&"font_placeholder_color", Color.RED)
		board_code_line_edit.clear()
		return

	SceneLoader.load_scene(
		"uid://ceg2ys6ghalka", # puzzle_view.tscn
		SceneLoader.SceneType.PuzzleSingleplayer, 
		{
			"board": BoardResource.new(9, 9, 3, 3, board), 
			"candidates": CandidateResource.new(9, 9, 3, 3, board),
		}
	)

# format will eventually support removing the need for the excess parameters
func _convert_between_board_types(_board_string: String, num_block_cols: int, num_cells: int, num_cells_per_block: int, num_columns_per_block: int, num_board_cols: int) -> Array:
	if _board_string.length() != num_cells:
		printerr("Could not initialize converted board type, num_cells != _board_string length")
		return []
		
	var converted_board: Array = []
	
	# refer to test.py need be
	# wack indexing math
	for r in range(0, num_cells, num_cells_per_block * num_block_cols): # 0, num_cells, num_cells_per_block * num_block_cols
		for k in range(0, num_board_cols, num_columns_per_block): # 0, num_board_cols, num_cols_per_block
			var converted_board_row: Array[int] = []
			for i in range(0, num_cells_per_block * num_block_cols, num_cells_per_block): # 0 num_cells_per_block * num_block_cols, num_cells_per_block
				for j in range(0, num_columns_per_block): # 0, num_cols_per_block
					converted_board_row.append(_cell_char_to_val(_board_string[i + j + k + r]))
			converted_board.append(converted_board_row)
			
	return converted_board


func _paste_code_button_clicked():
	board_code_line_edit.text = DisplayServer.clipboard_get()


func _get_puzzle_string(difficulty: Difficulty) -> String:
	var upper_bound: int
	var difficulty_string: String
	
	match difficulty:
		Difficulty.EASY:
			upper_bound = 100000
			difficulty_string = "easy"
		Difficulty.HARD:
			upper_bound = 321592
			difficulty_string = "hard"
		Difficulty.DIABOLICAL:
			upper_bound = 119681
			difficulty_string = "diabolical"
		_, Difficulty.MEDIUM:
			upper_bound = 352643
			difficulty_string = "medium"
	
	var current_line: int = 1
	var file: FileAccess = FileAccess.open("res://Assets/Puzzles/%s.txt" % difficulty_string, FileAccess.READ)
	
	var puzzle_num: int = randi_range(0, upper_bound)
	
	# TODO: Migrate to better system for extracting lines, tsv or csv, when generating puzzles
	while not file.eof_reached() and current_line <= puzzle_num:
		file.get_line()
		current_line += 1

	return file.get_line().substr(13, 81)

func _input(event: InputEvent):
	if event.is_action_pressed(&"settings"):
		toggle_multiplayer_visibility(false)
		_toggle_new_game_visibility(false)
		
