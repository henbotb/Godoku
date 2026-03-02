extends GridContainer
class_name Board

# maybe migrate these to a singleton that candidates / cell can read from as well?
const BOARD_COLS = 9
const BOARD_ROWS = 9
const BIG_COLS = 3
const BIG_ROWS = 3
const NUM_CELLS = BOARD_COLS * BOARD_ROWS
const NUM_HOUSES = BIG_COLS * BIG_ROWS
const HOUSE_COLS = BOARD_COLS / BIG_COLS
const HOUSE_ROWS = BOARD_ROWS / BIG_ROWS
const HOUSE_SIZE = HOUSE_COLS * HOUSE_ROWS

var selected_cell: Cell = null
var config = Settings.config
var rng = RandomNumberGenerator.new()

# INITIALIZATION STUFF

func _ready() -> void:

	if initialize_board() != OK:
		printerr("Board didn't initialize correctly")
		
	render_board()



# TODO: Refactor this to support custom boards,
# maybe make it so that it takes in the default values then appends to the string special things:
# 000.102..182 + etc.
func initialize_board(board := "0".repeat(NUM_CELLS)) -> Error:
	if board == "0".repeat(NUM_CELLS) or board == "":
		board = "none_provided"
	
	self.columns = BIG_COLS
	
	for house_ndx in range(NUM_HOUSES):
		# setup house
		# TODO: house borders / highlighting
		var house = GridContainer.new()
		house.columns = HOUSE_COLS
		house.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		house.size_flags_vertical = Control.SIZE_EXPAND_FILL
		
		for cell_ndx in range(HOUSE_SIZE):
			# setup button
			var cell: Cell
			if board == "none_provided":
				cell = Cell.new(house_ndx, cell_ndx, rng.randi_range(1, HOUSE_SIZE) if rng.randf() > 0.5 else 0)
			else:
				cell = Cell.new(house_ndx, cell_ndx, int(board[house_ndx * 9 + cell_ndx]), false, true)
				
			# connect to function for recognition
			cell.button_up.connect(cell_pressed.bind(cell))
			
			cell.initialize_candidates(HOUSE_COLS, HOUSE_SIZE)
				
			# add to house
			house.add_child(cell)
			
		# add to puzzle		
		self.add_child(house)
	
	return OK
	
func cell_pressed(cell: Cell) -> void:
	selected_cell = cell
	highlight()
	
# HIGHLIGHTING STUFF

func highlight():
	reset_highlights()
	
	if (
		selected_cell == null 
		or (selected_cell.value == 0 and not config.get_value("board_settings", "highlight_empty_cells"))
	):
		return
		
	selected_cell.highlight()
	
	# house
	if config.get_value("board_settings", "highlight_houses"):
		highlight_house(selected_cell.get_parent())
	
	# row / column
	if config.get_value("board_settings", "highlight_orthogonal"):
		highlight_orthogonal(selected_cell.big_index, selected_cell.small_index)
	
	# same number
	if config.get_value("board_settings", "highlight_same_value"):
		highlight_same_value(selected_cell.value)
	
	if config.get_value("board_settings", "highlight_candidates"):
		highlight_candidates(selected_cell.value)
		
	if config.get_value("board_settings", "highlight_all"):
		highlight_all(selected_cell.value)

func reset_highlights():
	get_tree().call_group("highlighted", "unhighlight")
	for candidate: Label in get_tree().get_nodes_in_group("highlighted_candidates"):
		candidate.remove_from_group("highlighted_candidates")
		candidate.remove_theme_color_override("font_color")
	
func highlight_house(house: GridContainer):
	for cell in house.get_children():
		cell.highlight()
	
func highlight_orthogonal(big_index: int, small_index: int):
	var to_highlight = get_row(big_index, small_index) + get_column(big_index, small_index)
	for cell in to_highlight:
		cell.highlight()
	
func highlight_same_value(value: int):
	if(value == 0):
		return
	get_tree().call_group(str(value), "highlight")

func highlight_candidates(value: int):
	var candidates: Array[Node] = get_tree().get_nodes_in_group("candidate_%d" % value)
	for c in candidates:
		var candidate := c as Label
		if candidate.text == "":
			continue
			
		if candidate.get_parent().get_parent().is_in_group("highlighted"):
			candidate.add_theme_color_override("font_color", Color.BLACK)
		else:
			candidate.add_theme_color_override("font_color", Settings.config.get_value("board_settings", "highlight_color"))
		candidate.add_to_group("highlighted_candidates")

func highlight_all(value: int):
	var cells: Array[Node] = get_tree().get_nodes_in_group(str(value))
	for cell in cells:
		highlight_orthogonal(cell.big_index, cell.small_index)
		highlight_house(cell.get_parent())
		



func render_board():
	var cells: Array[Node] = get_tree().get_nodes_in_group("cell")

	for cell in cells:
		cell.render()

func _input(event):
	if event.is_action_pressed("toggle_candidate_marking"):
		if GameState.marking_mode == GameState.MarkingMode.CELL_CANDIDATE:
			GameState.marking_mode = GameState.MarkingMode.ADD
		else:
			GameState.marking_mode = GameState.MarkingMode.CELL_CANDIDATE

	if event is InputEventKey and event.pressed:
		if selected_cell == null:
			return

		if selected_cell.is_locked:
			return

		if event.is_action_pressed("delete") or event.is_action_pressed("backspace"):
			if selected_cell.value != 0:
				selected_cell.value = 0

		if KEY_1 <= event.keycode and event.keycode <= KEY_9:
			if GameState.marking_mode == GameState.MarkingMode.CELL_CANDIDATE:
				selected_cell.candidates.toggle_candidate(event.keycode - KEY_0)
			else:
				selected_cell.value = event.keycode - KEY_0 #

		elif KEY_A <= event.keycode and event.keycode < KEY_A - 9 + HOUSE_SIZE:
			if GameState.marking_mode == GameState.MarkingMode.CELL_CANDIDATE:
				selected_cell.candidates.toggle_candidate(event.keycode - KEY_A + 10)
			else:
				selected_cell.value = event.keycode - KEY_A + 10
		
		
		selected_cell.render()
		highlight()


# HELPER FUNCTION STUFF

func get_row(big_index: int, small_index: int) -> Array[Cell]:
	var row: Array[Cell] = []
	
	for outer_ndx in range((big_index / BIG_COLS) * BIG_COLS, ((big_index / BIG_COLS) + 1) * BIG_COLS):
		for inner_ndx in range((small_index / HOUSE_COLS) * HOUSE_COLS, ((small_index / HOUSE_COLS) + 1) * HOUSE_COLS):
			row.append(get_child(outer_ndx).get_child(inner_ndx))
	
	return row

func get_column(big_index: int, small_index: int) -> Array[Cell]:
	var column: Array[Cell] = []
	
	for outer_ndx in range(big_index % BIG_COLS, NUM_HOUSES, BIG_COLS):
		for inner_ndx in range(small_index % HOUSE_COLS, HOUSE_SIZE, HOUSE_COLS):
			column.append(get_child(outer_ndx).get_child(inner_ndx))
	
	return column
	

func update_settings():
	render_board()
