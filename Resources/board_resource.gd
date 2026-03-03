class_name BoardResource
extends Resource

# TESTING: remove exports
@export var NUM_COLS := 0
@export var NUM_ROWS := 0
@export var NUM_BLOCK_COLS := 0
@export var NUM_BLOCK_ROWS := 0
@export var BOARD_STRING := ""
var NUM_CELLS := 0
var NUM_BLOCKS := 0
var NUM_COLUMNS_PER_BLOCK := 0
var NUM_ROWS_PER_BLOCK := 0
var NUM_CELLS_PER_BLOCK := 0

var board_array: Array = []

# unsure: string in format: #...# (1-9, a-whatever)
#determine string format when programming the sudoku generator
#maybe something like: difficulty(?), rows, cols, big rows, big cols, board string
var board_string: String


# < 0 = locked cell
# > 0 = user placed cell
# = 0 = empty cell


func _init(board_cols: int, board_rows: int, big_cols: int, big_rows: int) -> void:
	NUM_COLS = board_cols
	NUM_ROWS = board_rows
	NUM_BLOCK_COLS = big_cols
	NUM_BLOCK_ROWS = big_rows
	NUM_CELLS = NUM_COLS * NUM_ROWS
	NUM_BLOCKS = NUM_BLOCK_COLS * NUM_BLOCK_ROWS
	NUM_COLUMNS_PER_BLOCK = NUM_COLS / NUM_BLOCK_COLS
	NUM_ROWS_PER_BLOCK = NUM_ROWS / NUM_BLOCK_ROWS
	NUM_CELLS_PER_BLOCK = NUM_COLUMNS_PER_BLOCK * NUM_ROWS_PER_BLOCK
	
	for y in range(NUM_ROWS):
		var row: Array[int] = []
		for x in range(NUM_COLS):
			# TODO: Add string read-in
			#if string[y * BLOCK_SIZE + x] != 0:
			#	row.append(-1 * int(string[y * BLOCK_SIZE + x]))
			row.append(0 if randf() > 0.6 else randi_range(-9, 9))
		board_array.append(row)
