extends Control

var board: BoardResource
var candidates: CandidateResource

var selected_cell: Button = null
var selected_cell_pos: Vector2i = Vector2i.ZERO

@onready var board_visual: GridContainer = $AspectRatioContainer/Board

func _initialize_board_data() -> void:
	board_visual.columns = board.NUM_BLOCK_COLS
	
	for y in range(board.board_array.size()):
		var block = board.board_array[y]
		
		var block_new = GridContainer.new()
		block_new.add_to_group("block")
		block_new.columns = board.NUM_COLUMNS_PER_BLOCK
		block_new.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		block_new.size_flags_vertical = Control.SIZE_EXPAND_FILL
		
		for x in range(block.size()):
			var cell = block[x]
			
			var cell_new = Button.new()
			cell_new.text = str(cell) if cell != 0 else ""
			cell_new.add_to_group("cell")
			cell_new.add_to_group("candidate_%s" % cell_new.text if cell_new.text != "" else "empty") # idk
			cell_new.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			cell_new.size_flags_vertical = Control.SIZE_EXPAND_FILL
			
			cell_new.pressed.connect(_cell_pressed.bind(cell_new, Vector2i(x, y)))

			block_new.add_child(cell_new)
		board_visual.add_child(block_new)


func _ready() -> void:
	_initialize_board_data()

#SELECTED.get_stylebox("normal", "Button").bg_color = Settings.highlight_color

func _cell_pressed(cell: Button, cell_pos: Vector2i) -> void:
	selected_cell = cell
	selected_cell_pos = cell_pos
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
	var highlighted_cells: Array[Node] = get_tree().get_nodes_in_group("highlighted")
	for cell in highlighted_cells:
		cell.theme = null
		cell.remove_from_group("highlighted")

func highlight_orthogonal(cell: Button):
	pass
	
	
# maybe name all parameter variables "_thing"
func highlight_block(_cell: Button):
	for cell in _cell.get_parent().get_children():
		cell.theme = Settings.HIGHLIGHTED
		cell.add_to_group("highlighted")
	
func highlight_same_value(_cell: Button):
	for cell: Button in get_tree().get_nodes_in_group("candidate_%s" % _cell.text):
		cell.theme = Settings.HIGHLIGHTED
		cell.add_to_group("highlighted")
	
func highlight_candidates(cell: Button): 
	# TODO
	pass

func highlight_all(cell: Button):
	pass


# convert from string to this format
func _2d_to_block_index(cell_ndx: Vector2i) -> Vector2i:
	return Vector2i(cell_ndx.y, cell_ndx.x)
	
func _block_to_2d_index(cell_ndx: Vector2i) -> Vector2i:
	return Vector2i(cell_ndx.y, cell_ndx.x)
