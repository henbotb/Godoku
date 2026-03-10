extends Control

enum MarkingMode {
	ADD,
	CELL_CANDIDATE,
	BLOCK_CANDIDATE,
	COLOR,
}

@export var board: BoardResource
@export var candidates: CandidateResource

var marking_mode: MarkingMode = MarkingMode.ADD
var selected_cell: Cell = null
var selected_cell_pos: Vector2i = Vector2i.ZERO

@onready var pause_menu: Control = $PauseMenu
@onready var settings_menu: Control = $PauseMenu/Settings
@onready var board_visual: GridContainer = $AspectRatioContainer/Board

func _initialize_board_data() -> void:
	
	board_visual.columns = board.NUM_BLOCK_COLS
	Candidates.cols = board.NUM_COLUMNS_PER_BLOCK
	Candidates.block_size = board.NUM_CELLS_PER_BLOCK
	
	for y in range(board.board_array.size()):
		var block_array = board.board_array[y]
		var block = _generate_block()
		
		for x in range(block_array.size()):
			var cell_value = block_array[x]
			var cell = Cell.new(Vector2i(x, y), cell_value)
			
			cell.candidates.initialize_candidates()
			cell.pressed.connect(_cell_pressed.bind(cell))
			block.add_child(cell)
			
		board_visual.add_child(block)


func _ready() -> void:
	settings_menu.highlighting_updated.connect(highlight)
	_initialize_board_data()

func debug_print(cell: Cell):
	if Settings.debug_mode:
		print(cell.get_groups())


func _cell_pressed(cell: Cell) -> void:
	if Settings.debug_mode:
		debug_print(cell)
	if selected_cell == cell:
		return

	selected_cell = cell
	highlight()


func highlight():
	reset_highlights()
	
	if (
		selected_cell == null or
		(
			selected_cell.value == 0 and
			not Settings.highlight_empty_cells
		)
	):
		return
	
	selected_cell.theme = Settings.HIGHLIGHTED
	selected_cell.add_to_group("highlighted")
	
	# house
	if Settings.highlight_block:
		highlight_block(selected_cell)
	
	# row / column
	if Settings.highlight_orthogonal:
		highlight_orthogonal(selected_cell)
	
	# same number
	if Settings.highlight_same_value:
		highlight_same_value(selected_cell)
	
	# candidates of same value
	if Settings.highlight_candidates:
		highlight_candidates(selected_cell)
		
	# all highlight lines for all numbers of the same type
	if Settings.highlight_all:
		highlight_all(selected_cell)
	

func reset_highlights():
	get_tree().call_group("highlighted", "unhighlight")
	for candidate in get_tree().get_nodes_in_group("highlighted_candidates"):
		candidate.remove_theme_color_override("font_color")


func highlight_orthogonal(cell: Cell):
	var to_highlight = _get_row(cell.pos) + _get_column(cell.pos)
	for _cell in to_highlight:
		_cell.highlight()


# maybe name all parameter variables "_thing"
func highlight_block(_cell: Cell):
	for cell in _cell.get_parent().get_children():
		cell.theme = Settings.HIGHLIGHTED
		cell.add_to_group("highlighted")


func highlight_same_value(_cell: Cell):
	get_tree().call_group("value_%s" % abs(_cell.value), "highlight")
	
	
func highlight_candidates(_cell: Cell):
	var _candidates: Array[Node] = get_tree().get_nodes_in_group("candidate_%d" % abs(_cell.value))
	for candidate in _candidates:
		if candidate.text == "":
			continue
		
		# TODO: do this as well because this is bad
		if candidate.get_parent().get_parent().is_in_group("highlighted"):
			candidate.add_theme_color_override("font_color", Color.BLANCHED_ALMOND)
		else:
			candidate.add_theme_color_override("font_color", Settings.highlight_color)
		candidate.add_to_group("highlighted_candidates")


func highlight_all(_cell: Button):
	var cells: Array[Node] = get_tree().get_nodes_in_group("value_%d" % abs(_cell.value))
	for cell in cells:
		highlight_orthogonal(cell)
		highlight_block(cell)


func _input(event):
	if event.is_action_pressed("toggle_candidate_marking"):
		if marking_mode == MarkingMode.CELL_CANDIDATE:
			marking_mode = MarkingMode.ADD
		else:
			marking_mode = MarkingMode.CELL_CANDIDATE
		return

	if event is InputEventKey and event.pressed:
		if selected_cell == null:
			return

		if selected_cell.value < 0:
			return

		if event.is_action_pressed("delete") or event.is_action_pressed("backspace"):
			if selected_cell.value != 0:
				selected_cell.value = 0

		var in_numeric_range = KEY_1 <= event.keycode and event.keycode <= KEY_9
		var in_alphabetic_range = KEY_A <= event.keycode and event.keycode < KEY_A - 9 + board.NUM_CELLS_PER_BLOCK

		if (
			in_numeric_range or 
			in_alphabetic_range
			):
			if marking_mode == MarkingMode.CELL_CANDIDATE:
				selected_cell.candidates.toggle_candidate(event.keycode - KEY_0 if in_numeric_range else KEY_A + 10)
			else:
				selected_cell.value = event.keycode - (KEY_0 if in_numeric_range else KEY_A + 10)

		selected_cell.render()
		highlight()


func _generate_block() -> GridContainer:
	var block_new = GridContainer.new()
	block_new.add_to_group("block")
	block_new.columns = board.NUM_COLUMNS_PER_BLOCK
	block_new.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	block_new.size_flags_vertical = Control.SIZE_EXPAND_FILL
	return block_new


func _get_row(pos: Vector2i) -> Array[Cell]:
	var row: Array[Cell] = []
	
	for outer_ndx in range((pos.y / board.NUM_BLOCK_COLS) * board.NUM_BLOCK_COLS, ((pos.y / board.NUM_BLOCK_COLS) + 1) * board.NUM_BLOCK_COLS):
		for inner_ndx in range((pos.x / board.NUM_BLOCK_COLS) * board.NUM_BLOCK_COLS, ((pos.x / board.NUM_BLOCK_COLS) + 1) * board.NUM_BLOCK_COLS):
			row.append(board_visual.get_child(outer_ndx).get_child(inner_ndx))
			
	return row

func _get_column(pos: Vector2i) -> Array[Cell]:
	var column: Array[Cell] = []
	
	for outer_ndx in range(pos.y % board.NUM_BLOCK_COLS, board.NUM_BLOCKS, board.NUM_BLOCK_COLS):
		for inner_ndx in range(pos.x % board.NUM_COLUMNS_PER_BLOCK, board.NUM_CELLS_PER_BLOCK, board.NUM_COLUMNS_PER_BLOCK):
			column.append(board_visual.get_child(outer_ndx).get_child(inner_ndx))

	return column


# convert from string to this format
func _2d_to_block_index(cell_ndx: Vector2i) -> Vector2i:
	return Vector2i(cell_ndx.y, cell_ndx.x)
	
func _block_to_2d_index(cell_ndx: Vector2i) -> Vector2i:
	return Vector2i(cell_ndx.y, cell_ndx.x)
