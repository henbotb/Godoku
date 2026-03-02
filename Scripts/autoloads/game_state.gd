# TODO: move to resource

extends Node

enum MarkingMode {
	ADD,
	CELL_CANDIDATE,
	BLOCK_CANDIDATE,
	COLOR,
}

var marking_mode = MarkingMode.ADD
var in_game = false
