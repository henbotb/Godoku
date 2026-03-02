extends Control

@onready var code_line_edit: LineEdit = $MultiplayerPanel/MarginContainer/VBoxContainer2/VBoxContainer/HBoxContainer/CodeLineEdit
@onready var multiplayer_panel: Panel = $MultiplayerPanel


func _on_quit_button_pressed() -> void:
	Settings.save()
	get_tree().quit()

func toggle_code_visibility():
	code_line_edit.secret = not code_line_edit.secret 

func paste_code():
	code_line_edit.text = DisplayServer.clipboard_get()

func toggle_multiplayer_visibility(on: bool):
	multiplayer_panel.visible = on


func _on_resume_game_button_pressed() -> void:
	pass # Replace with function body.

func _on_new_game_button_pressed() -> void:
	# TODO: add more elaborate start menu
	

	SceneLoader.load_scene(
		"uid://ceg2ys6ghalka", # puzzle_view.tscn
		SceneLoader.SceneType.Puzzle, 
		{
			"board": BoardResource.new(9, 9, 3, 3), 
			"candidates": CandidateResource.new(9, 9, 3, 3),
		}
	)
			
			
			
	# 050703060007000800000816000000030000005000100730040086906000204840572093000409000
	
	
func _input(event: InputEvent):
	if event.is_action_pressed(&"settings"):
		toggle_multiplayer_visibility(false)
		
