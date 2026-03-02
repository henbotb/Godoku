extends Control



func _on_server_pressed() -> void:
	NetworkHandler.start_server()
	pass # Replace with function body.


func _on_client_pressed() -> void:
	NetworkHandler.start_client()
	pass # Replace with function body.
