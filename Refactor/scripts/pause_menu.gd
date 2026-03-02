extends Control

# TODO: saving system for game current state, probably managed NOT here
@onready var confirm_quit_panel: Panel = $ConfirmQuitPanel
@onready var settings: Control = $Settings
@onready var multiplayer_panel: Panel = $MultiplayerPanel
@onready var code_line_edit: LineEdit = $MultiplayerPanel/MarginContainer/VBoxContainer2/VBoxContainer3/HBoxContainer/CodeLineEdit

func _ready() -> void:
	settings.handle_self_input = false

func copy_code():
	# TODO: generate code when copy code is clicked or something? 
	# maybe when the container is opened for the first imte
	# not sure when the best place to actually do this is
	# maybe it makes sense to have another button for generating the code in the first place
	DisplayServer.clipboard_set(code_line_edit.text)

func toggle_code_displayed():
	code_line_edit.secret = not code_line_edit.secret

func display_pause_menu(on: bool):
	visible = on

func display_confirm_quit(on: bool):
	confirm_quit_panel.visible = on
	
func display_multiplayer(on: bool):
	multiplayer_panel.visible = on

func confirm_quit():
	# TODO: some save function of some kind
	SceneLoader.load_scene("res://Refactor/scenes/start_menu.tscn", SceneLoader.SceneType.Menu)

func _input(event: InputEvent):
	if event.is_action_pressed(&"settings"):
		
		if not visible:
			display_pause_menu(true)
			return
		
		if confirm_quit_panel.visible or multiplayer_panel.visible or settings.visible:
			display_confirm_quit(false)
			display_multiplayer(false)
			settings.display_settings(false)
			return

		if visible:
			display_pause_menu(false)
			return
