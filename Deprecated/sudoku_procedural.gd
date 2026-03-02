extends GridContainer

const BOARD_COLS = 16
const BOARD_ROWS = 16

const BIG_COLS = 4
const BIG_ROWS = 4

@warning_ignore("integer_division")
const HOUSE_COLS = BOARD_COLS / BIG_COLS
@warning_ignore("integer_division")
const HOUSE_ROWS = BOARD_ROWS / BIG_ROWS

var SELECTED = preload("uid://be5h05f4havy0")
var DEFAULT = preload("uid://dqqaua4my3ejj")

var config = ConfigFile.new()
var selected_cell: Button
var rng = RandomNumberGenerator.new()

var remembered_display_type

@onready var puzzle: GridContainer = $"."



# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	if config.load("user://game_settings.cfg") != OK:
		printerr("User didn't have a game_settings file")
	
	remembered_display_type = config.get_value("board_settings", "double_digit_numbers")

	if create_board() != OK:
		printerr("Board/Inner Rows/Cols initialized to non-divisible value")
		
	if remembered_display_type != true:
		change_board_display_type(true)
	#SELECTED.default_font_size = 10
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass

func create_board() -> Error:
	if BOARD_COLS % BIG_COLS != 0 or BOARD_ROWS % BIG_ROWS != 0:
		return 	ERR_PARAMETER_RANGE_ERROR
		
	puzzle.columns = BIG_COLS
	
	for house_ndx in range(BIG_COLS * BIG_ROWS):
		# setup house
		var house = GridContainer.new()
		house.columns = HOUSE_COLS
		house.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		house.size_flags_vertical = Control.SIZE_EXPAND_FILL
		
		for cell_ndx in range(HOUSE_COLS * HOUSE_ROWS):
			# setup button
			var btn = Button.new()
			if rng.randf() < 0.5:
				btn.text = "%d" % rng.randi_range(1, HOUSE_COLS * HOUSE_ROWS)
			else:
				btn.text = ""
			btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			btn.size_flags_vertical = Control.SIZE_EXPAND_FILL
			
			# connect to function for recognition
			btn.button_up.connect(cell_pressed.bind(btn))
			
			# add to house
			house.add_child(btn)
			
		# add to puzzle		
		puzzle.add_child(house)
		
	return OK

func highlight_similar() -> void:
	reset_highlights()
	
	if selected_cell == null or selected_cell.text == "":
		return
		
	selected_cell.theme = SELECTED
	
	# house
	if config.get_value("board_settings", "highlight_houses"):
		highlight_house(selected_cell.get_parent())
	
	# row / column
	if config.get_value("board_settings", "highlight_orthogonal"):
		highlight_orthogonal(selected_cell.get_parent().get_index(), selected_cell.get_index())
	
	# same number
	if config.get_value("board_settings", "highlight_same_value"):
		highlight_same_value(selected_cell.text)
	
	# candidates
	#if config.get_value("board_settings", "highlight_candidates"):
		#highlight_candidates(int(cell.text))
		
func highlight_house(house: GridContainer) -> void:
	var cells: Array[Node] = house.get_children()
	for cell in cells:
		cell.theme = SELECTED
	
func highlight_orthogonal(big_ndx: int, small_ndx: int) -> void:
	var to_highlight: Array[Button]
	
	# column
	for outer_ndx in range(big_ndx % BIG_COLS, BIG_ROWS * BIG_COLS, BIG_COLS):
		for inner_ndx in range(small_ndx % HOUSE_COLS, HOUSE_ROWS * HOUSE_COLS, HOUSE_COLS):
			to_highlight.append(puzzle.get_child(outer_ndx).get_child(inner_ndx))

	# row
	@warning_ignore("integer_division")
	for outer_ndx in range((big_ndx / BIG_COLS) * BIG_COLS, ((big_ndx / BIG_COLS) + 1) * BIG_COLS):
		@warning_ignore("integer_division")
		for inner_ndx in range((small_ndx / HOUSE_COLS) * HOUSE_COLS, ((small_ndx / HOUSE_COLS) + 1) * HOUSE_COLS):
			to_highlight.append(puzzle.get_child(outer_ndx).get_child(inner_ndx))
			
	for cell in to_highlight:
		cell.theme = SELECTED
	
	
func highlight_same_value(cell_number: String) -> void:
	var houses: Array[Node] = puzzle.get_children()
	for house in houses:
		var cells: Array[Node] = house.get_children()
		for cell in cells:
			if cell.text == cell_number:
				cell.theme = SELECTED

func reset_highlights() -> void:
	var houses: Array[Node] = puzzle.get_children()
	for house in houses:
		var cells: Array[Node] = house.get_children()
		for cell in cells:
			cell.theme = DEFAULT

func cell_pressed(cell: Button) -> void:
	# TODO: highlighting options for non-valued cells
	
	selected_cell = cell
	highlight_similar()
	
func update():
	if config.load("user://game_settings.cfg") != OK:
		printerr("User didn't have a game_settings file")
		
	if remembered_display_type != config.get_value("board_settings", "double_digit_numbers"):
		if remembered_display_type:
			change_board_display_type(true)
			remembered_display_type = false
		else:
			change_board_display_type(false)
			remembered_display_type = true

func convert_value_type_toggle(input: String) -> String:	
	if input.is_valid_int(): # int -> char
		return char(int(input) + 87)
	return str(ord(input) - 87)
	
func convert_digit_to_char(input: String) -> String:
	if 0 < int(input) and int(input) < 10:
		return input
	return char(int(input) + 87)
	
func convert_char_to_digit(input: String) -> String:
	if 0 < int(input) and int(input) < 10:
		return input
	return str(ord(input) - 87)

func change_board_display_type(from_double_digit: bool):
	var houses: Array[Node] = puzzle.get_children()
	for house in houses:
		var cells: Array[Node] = house.get_children()
		for cell in cells:
			if cell.text == "":
				continue
			
			if from_double_digit:
				cell.text = convert_digit_to_char(cell.text)
			else:
				cell.text = convert_char_to_digit(cell.text)

func _input(event):
	
	if event is InputEventKey and event.is_pressed():
		if selected_cell == null:
			return
			
		var cell_input = char(event.unicode)
		
		if event.keycode == KEY_DELETE:
			selected_cell.text = ""
			return
		elif event.keycode == KEY_BACKSPACE:
			selected_cell.text = selected_cell.text.substr(0, selected_cell.text.length() - 1)
			return

		if config.get_value("board_settings", "double_digit_numbers"):
			
			if not cell_input.is_valid_int():
				return
					
			if (
				0 < int(selected_cell.text + cell_input)
				and int(selected_cell.text + cell_input) <= HOUSE_ROWS * HOUSE_COLS
			):
				selected_cell.text += str(cell_input)
		else:
			if (
				(
					0 < int(cell_input)
					and int(cell_input) < 10
				)
				or
				(
					9 < event.unicode - 87
					and event.unicode - 87 <= HOUSE_ROWS * HOUSE_COLS
				)
			):
				selected_cell.text = cell_input
	

	
