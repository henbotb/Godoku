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
	
	# something is going to handle "locked" vs "unlocked" values. 
	# Maybe store one as the shift counterpart: 3 -> #, 5 -> %
	
	DisplayServer.clipboard_set(code_line_edit.text)

func toggle_code_displayed():
	code_line_edit.secret = not code_line_edit.secret


func _set_window_visibility(_window: String, _visible: bool):
	match(_window):
		"resume":
			visible = _visible
		"settings":
			settings.display_settings(_visible)
		"host":
			multiplayer_panel.visible = _visible
		"quit":
			confirm_quit_panel.visible = _visible


func confirm_quit():
	# TODO: some save function of some kind
	SceneLoader.load_scene(
		"uid://d30yqy8wiye5i", 
		SceneLoader.SceneType.Menu,
		)
		
	settings.handle_self_input = true

func _input(event: InputEvent):
	if event.is_action_pressed(&"settings"):
		
		if not visible:
			visible = true
			return
		
		if confirm_quit_panel.visible or multiplayer_panel.visible or settings.visible:
			_set_window_visibility("quit", false)
			settings.display_settings(false)
			_set_window_visibility("host", false)
			return

		if visible:
			visible = false
			return
