extends MultiplayerSpawner

@export var network_player: PackedScene

func _ready() -> void:
	multiplayer.peer_connected.connect(spawn_cursor)
	
func spawn_cursor(id: int) -> void:
	if not multiplayer.is_server():
		return
		
	var cursor: Node = network_player.instantiate()
	cursor.name = str(id)
	
	get_node(spawn_path).call_deferred("add_child", cursor)
