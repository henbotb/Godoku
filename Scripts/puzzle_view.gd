extends Control

var board: BoardResource
var candidates: CandidateResource

var selected_cell: Cell = null
var selected_cell_pos: Vector2i = Vector2i.ZERO

@onready var board_visual: GridContainer = $AspectRatioContainer/Board

func _initialize_board_data() -> void:
	board_visual.columns = board.NUM_BLOCK_COLS
	
	for y in range(board.board_array.size()):
		var block_array = board.board_array[y]
		var block = _generate_block()
		
		for x in range(block_array.size()):
			var cell_value = block_array[x]
			var cell = Cell.new(Vector2i(x, y), cell_value)
			
			cell.pressed.connect(_cell_pressed.bind(cell))
			block.add_child(cell)
			
		board_visual.add_child(block)


func _ready() -> void:
	_initialize_board_data()

#SELECTED.get_stylebox("normal", "Button").bg_color = Settings.highlight_color

func _cell_pressed(cell: Cell) -> void:
	selected_cell = cell
	highlight()

func highlight():
	reset_highlights()
	
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

func highlight_orthogonal(cell: Cell):
	pass
	
	
# maybe name all parameter variables "_thing"
func highlight_block(_cell: Cell):
	for cell in _cell.get_parent().get_children():
		cell.theme = Settings.HIGHLIGHTED
		cell.add_to_group("highlighted")
	
func highlight_same_value(_cell: Cell):
	get_tree().call_group("%d" % _cell.value, "highlight")
	
func highlight_candidates(cell: Button): 
	# TODO
	pass

func highlight_all(cell: Button):
	pass


func _generate_block() -> GridContainer:
	var block_new = GridContainer.new()
	block_new.add_to_group("block")
	block_new.columns = board.NUM_COLUMNS_PER_BLOCK
	block_new.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	block_new.size_flags_vertical = Control.SIZE_EXPAND_FILL
	return block_new


# convert from string to this format
func _2d_to_block_index(cell_ndx: Vector2i) -> Vector2i:
	return Vector2i(cell_ndx.y, cell_ndx.x)
	
func _block_to_2d_index(cell_ndx: Vector2i) -> Vector2i:
	return Vector2i(cell_ndx.y, cell_ndx.x)
