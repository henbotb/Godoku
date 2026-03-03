extends Button
class_name Cell

var value: int:
	set(_value):
		remove_from_group("value_%d" % abs(value))
		add_to_group("value_%d" % abs(_value))
		if _value == 0:
			text = ""
		else:
			text = get_display_value(abs(_value))
			if _value < 0:
				add_theme_color_override("font_color", Color.DARK_GRAY)
		value = _value

var pos: Vector2i
var candidates: Candidates


func _init(_pos: Vector2i, _value := 0):
	pos = _pos
	value = _value
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	size_flags_vertical = Control.SIZE_EXPAND_FILL
		
	add_to_group("value_%d" % abs(_value))
	add_to_group("cell")
	candidates = Candidates.new()

	add_child(candidates)


func initialize_candidates(cols: int, house_size: int):
	candidates.initialize_candidates()
	candidates.visible = (value == 0)


func render():
	text = get_display_value(value)
	candidates.visible = (value == 0)


func highlight():
		theme = Settings.HIGHLIGHTED
		add_to_group("highlighted")


func unhighlight():
	theme = null
	remove_from_group("highlighted")


static func get_display_value(val: int) -> String:
	if val == 0:
		return ""
	if 0 < val and val < 10:
		return str(val)
	return char(val + 55)
	# 87 is lower case, 55 is upper case
