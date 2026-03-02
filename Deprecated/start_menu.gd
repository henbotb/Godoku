extends Control

@onready var color_rect: ColorRect = $ColorRect
@onready var text_edit: TextEdit = $ColorRect/TextEdit
@onready var option_button: OptionButton = $ColorRect/OptionButton

var rng = RandomNumberGenerator.new()

func _on_button_generate_button_up() -> void:
	if option_button.selected == -1:
		text_edit.text = text_edit.text.lstrip(" ").rstrip(" ")
		if( 
			text_edit.text.length() == 81
			and text_edit.text.is_valid_int()
		):
			GameState.puzzle_base_board = text_edit.text
		else:
			return
	else:
		match option_button.selected:
			1:
				get_puzzle_from_difficulty("easy", 100000)
			3:
				get_puzzle_from_difficulty("hard", 321592)
			4:
				get_puzzle_from_difficulty("diabolical", 119681)
			2, _:
				get_puzzle_from_difficulty("medium", 352643)
				
		
				
	get_tree().change_scene_to_file("res://Scenes/Game.tscn")

func _on_button_copy_button_up() -> void:
	text_edit.text = DisplayServer.clipboard_get()

func _on_button_start_button_up() -> void:
	color_rect.visible = true
	
func _on_button_quit_button_up() -> void:
	get_tree().quit()

func _input(event):
	if event.is_action(&"settings"):
		color_rect.visible = false
		
func get_puzzle_from_difficulty(difficulty: String, lines: int):
	var file = FileAccess.open("res://Assets/Puzzles/%s.txt" % difficulty, FileAccess.READ)
	var puzzle_num = rng.randi_range(0, lines) - 1
	var current_line: int = 1
	
	while not file.eof_reached() and puzzle_num != current_line:
		file.get_line()
		
	var puzzle_code = file.get_line().substr(13, 81)
	print("Puzzle code:", puzzle_code)
	#GameState.puzzle_base_board = file.get_line().substr(13, 81)
	#print(GameState.puzzle_base_board)
	
		
