extends Control

var board: BoardResource
var candidates: CandidateResource

var selected_cell := Vector2i(0, 0)


func initialize_board_data() -> void:

	for block in board.board_array:
		var block_new = GridContainer.new()
		block_new.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		block_new.size_flags_vertical = Control.SIZE_EXPAND_FILL
		
		for cell in block:
			# TODO: move this to cell class maybe?
			var cell_new = Button.new()
			cell_new.text = str(cell)
			cell_new.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			cell_new.size_flags_vertical = Control.SIZE_EXPAND_FILL

			block_new.add_child(cell_new)
				
		add_child(block_new)


# convert from string to this format
func _2d_to_block_index(cell_ndx: Vector2i) -> Vector2i:
	return Vector2i(cell_ndx.y, cell_ndx.x)
	
func _block_to_2d_index(cell_ndx: Vector2i) -> Vector2i:
	return Vector2i(cell_ndx.y, cell_ndx.x)
