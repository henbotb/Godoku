extends GridContainer
class_name Candidates

var candidate_values: Array[bool] = []

static var cols: int
static var block_size: int

func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT, true)
	add_theme_constant_override("h_separation", 0)
	add_theme_constant_override("v_separation", 0)
	
	add_to_group("candidates")

	# maybe migrate candidates to cells ?
func initialize_candidates(_candidate_values: Array[bool] = []):
	
	var filled_already: bool = false
	if _candidate_values != []:
		candidate_values = _candidate_values
		filled_already = true
	
	columns = cols
	
	for candidate_index in range(block_size):
		if not filled_already:
			candidate_values.append(false)

		var candidate_label = Label.new()

		candidate_label.text = Cell.get_display_value(candidate_index + 1) if candidate_values[candidate_index] else ""
		
		candidate_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL | Control.SIZE_SHRINK_CENTER
		candidate_label.size_flags_vertical = Control.SIZE_EXPAND_FILL | Control.SIZE_SHRINK_CENTER
		candidate_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		candidate_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		
		candidate_label.add_theme_font_size_override("font_size", 12)
		candidate_label.add_to_group("candidate_%d" % (candidate_index + 1))
		
		add_child(candidate_label)

func toggle_candidate(value: int):
	if value < 1 or value > block_size:
		return
		
	if candidate_values[value - 1]:
		get_child(value - 1).text = ""
	else:
		get_child(value - 1).text = Cell.get_display_value(value)
		
	candidate_values[value - 1] = not candidate_values[value - 1]
