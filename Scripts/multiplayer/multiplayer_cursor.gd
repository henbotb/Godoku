extends Control

var rng = RandomNumberGenerator.new()

func _ready() -> void:
	self_modulate = Color(rng.randf(), rng.randf(), rng.randf())

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())


func _process(_delta: float) -> void:
	if not is_multiplayer_authority():
		return
	
	position = get_global_mouse_position()
