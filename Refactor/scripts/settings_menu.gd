extends Control

@onready var master_slider: HSlider = $SettingTabContainer/DisplayAndAudioTabBar/MarginContainer/VBoxContainer/MasterVolumeHBox/MasterSlider
@onready var music_slider: HSlider = $SettingTabContainer/DisplayAndAudioTabBar/MarginContainer/VBoxContainer/MusicVolumeHBox/MusicSlider
@onready var effect_slider: HSlider = $SettingTabContainer/DisplayAndAudioTabBar/MarginContainer/VBoxContainer/EffectVolumeHBox/EffectSlider

@onready var master_percentage: Label = $SettingTabContainer/DisplayAndAudioTabBar/MarginContainer/VBoxContainer/MasterVolumeHBox/MasterPercentage
@onready var music_percentage: Label = $SettingTabContainer/DisplayAndAudioTabBar/MarginContainer/VBoxContainer/MusicVolumeHBox/MusicPercentage
@onready var effects_percentage: Label = $SettingTabContainer/DisplayAndAudioTabBar/MarginContainer/VBoxContainer/EffectVolumeHBox/EffectsPercentage

@onready var color_picker_button: ColorPickerButton = $SettingTabContainer/BoardTabBar/MarginContainer/VBoxContainer/HBoxContainer/ColorPickerButton

# I can't tell if basically this whole script should 
# be the autoload singleton that settings.gd is by itself
# the only thing this script would have to do is: 
# read in values
# .tscn -> signal when changed
# ^^^^
# maybe add a save button for this expressed purpose?
# but also people like real time responses to their setting updates (sound setting ie)

# TODO: font size / thresholds, gui scale maybe?


# no idea if this is a good way of doing things
var handle_self_input := true:
	get:
		return handle_self_input
	set(value):
		set_process_input(value)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var color_picker = color_picker_button.get_picker()
	color_picker.sampler_visible = false
	color_picker.color_modes_visible = false
	color_picker.sliders_visible = false
	color_picker.hex_visible = false
	color_picker.presets_visible = false
	
func display_settings(on: bool) -> void:
	visible = on

func update_slider_percentage(value: float, slider_name: StringName) -> void:
	match slider_name:
		"music":
			music_percentage.text = str(roundi(value * 66.67))
		"effect":
			effects_percentage.text = str(roundi(value * 66.67))
		"master", _:
			master_percentage.text = str(roundi(value * 66.67))

func toggle_fullscreen(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _update_color(color: Color):
	Settings.highlight_color = color
	Settings.HIGHLIGHTED.get_stylebox("normal", "Button").bg_color = color

# TODO: make more comprehensive "window order" settings,
# maybe have a singleton that tracks the "outermost" control node, and on
# &"escape", it reads from the singleton to close the outermost layer
# and changes singletons reference to the outermost layer
# maybe test this in a new project

func _input(event):
	if event.is_action_pressed(&"settings") and visible:
		display_settings(false)
