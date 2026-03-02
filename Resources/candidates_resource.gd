class_name CandidateResource
extends Resource

signal candidates_loaded

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

var candidate_array = []

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
	
func _ready() -> void:
	for y in range(NUM_ROWS):
		var row: Array[bool] = []
		for x in range(NUM_COLS):
			# TODO: Add string read-in
			#if string[y * BLOCK_SIZE + x] != 0:
			#	row.append([])
			row.append(false)
		candidate_array.append(row)
		
	candidates_loaded.emit()
