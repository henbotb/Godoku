extends Button
class_name Cell

var value: int
var is_locked: bool
var big_index: int
var small_index: int
var is_highlighted: bool
var candidates: Candidates

const HIGHLIGHTED = preload("uid://be5h05f4havy0")
const DEFAULT = preload("uid://dqqaua4my3ejj")

# TESTING {
var rng = RandomNumberGenerator.new()
# }

func _init(big_ndx: int, small_ndx, val := 0, highlighted := false, is_lock := false):
	big_index = big_ndx
	small_index = small_ndx
	value = val
	is_highlighted = highlighted
	is_locked = is_lock and val != 0
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	size_flags_vertical = Control.SIZE_EXPAND_FILL
	
	if is_locked:
		add_theme_color_override("font_color", Color.DARK_GRAY)
	
	add_to_group(str(val))
	add_to_group("cell")
	candidates = Candidates.new()

	add_child(candidates)

	

func initialize_candidates(cols: int, house_size: int):
	candidates.initialize_candidates(cols, house_size)
	candidates.visible = (value == 0)

func render():
	text = get_display_value(value)
	candidates.visible = (value == 0)

func highlight():
	if not is_highlighted:
		self.theme = HIGHLIGHTED
		is_highlighted = true
		add_to_group("highlighted")
		
func unhighlight():
	if is_highlighted:
		self.theme = DEFAULT
		is_highlighted = false
		remove_from_group("highlighted")
		
		
static func get_display_value(val: int) -> String:
	if val == 0:
		return ""
	if 0 < val and val < 10:
		return str(val)
	return char(val + 55)
	# 87 is lower case, 55 is upper case
