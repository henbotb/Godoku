extends Control

# DISPLAY AND AUDIO IMPORTS
@onready var fullscreen_check_button: CheckButton = $SettingTabContainer/DisplayAndAudioTabBar/MarginContainer/VBoxContainer/FullscreenCheckButton
@onready var master_slider: HSlider = $SettingTabContainer/DisplayAndAudioTabBar/MarginContainer/VBoxContainer/MasterVolumeHBox/MasterSlider
@onready var music_slider: HSlider = $SettingTabContainer/DisplayAndAudioTabBar/MarginContainer/VBoxContainer/MusicVolumeHBox/MusicSlider
@onready var effect_slider: HSlider = $SettingTabContainer/DisplayAndAudioTabBar/MarginContainer/VBoxContainer/EffectVolumeHBox/EffectSlider
@onready var master_percentage: Label = $SettingTabContainer/DisplayAndAudioTabBar/MarginContainer/VBoxContainer/MasterVolumeHBox/MasterPercentage
@onready var music_percentage: Label = $SettingTabContainer/DisplayAndAudioTabBar/MarginContainer/VBoxContainer/MusicVolumeHBox/MusicPercentage
@onready var effects_percentage: Label = $SettingTabContainer/DisplayAndAudioTabBar/MarginContainer/VBoxContainer/EffectVolumeHBox/EffectsPercentage

# BOARD IMPORTS
@onready var highlight_block_check_box: CheckBox = $SettingTabContainer/BoardTabBar/MarginContainer/VBoxContainer/HighlightBlockCheckBox
@onready var highlight_orthogonal_check_box: CheckBox = $SettingTabContainer/BoardTabBar/MarginContainer/VBoxContainer/HighlightOrthogonalCheckBox
@onready var highlight_same_value_check_box: CheckBox = $SettingTabContainer/BoardTabBar/MarginContainer/VBoxContainer/HighlightSameValueCheckBox
@onready var highlight_empty_cells_check_box: CheckBox = $SettingTabContainer/BoardTabBar/MarginContainer/VBoxContainer/HighlightEmptyCellsCheckBox
@onready var highlight_candidates: CheckBox = $SettingTabContainer/BoardTabBar/MarginContainer/VBoxContainer/HighlightCandidates
@onready var highlight_all_check_box: CheckBox = $SettingTabContainer/BoardTabBar/MarginContainer/VBoxContainer/HighlightAllCheckBox
@onready var color_picker_button: ColorPickerButton = $SettingTabContainer/BoardTabBar/MarginContainer/VBoxContainer/HBoxContainer/ColorPickerButton


# TODO: font size / thresholds, gui scale maybe?

# TODO: make more comprehensive "window order" settings,
# maybe have a singleton that tracks the "outermost" control node, and on
# &"escape", it reads from the singleton to close the outermost layer
# and changes singletons reference to the outermost layer
# maybe test this in a new project


# no idea if this is a good way of doing things
var handle_self_input: bool =  true:
	get:
		return handle_self_input
	set(value):
		set_process_input(value)

signal highlighting_updated


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var color_picker = color_picker_button.get_picker()
	color_picker.sampler_visible = false
	color_picker.color_modes_visible = false
	color_picker.sliders_visible = false
	color_picker.hex_visible = false
	color_picker.presets_visible = false
	
	load_settings()


func load_settings() -> void:
	
	# DISPLAY AND AUDIO
	fullscreen_check_button.button_pressed = Settings.fullscreen
	master_slider.value = Settings.master_percentage
	music_slider.value = Settings.music_percentage
	effect_slider.value = Settings.effect_percentage
	# maybe not needed?
	#master_percentage.text = str(roundi(Settings.master_percentage * 66.67))
	#music_percentage.text = str(roundi(Settings.music_percentage * 66.67))
	#effects_percentage.text = str(roundi(Settings.effect_percentage * 66.67))
	
	# BOARD
	highlight_block_check_box.button_pressed = Settings.highlight_block
	highlight_orthogonal_check_box.button_pressed = Settings.highlight_orthogonal
	highlight_same_value_check_box.button_pressed = Settings.highlight_same_value
	highlight_empty_cells_check_box.button_pressed = Settings.highlight_empty_cells
	highlight_candidates.button_pressed = Settings.highlight_candidates
	highlight_all_check_box.button_pressed = Settings.highlight_all
	color_picker_button.color = Settings.highlight_color


func display_settings(on: bool) -> void:
	if not on: # trying to set to false
		Settings.save()
	visible = on


func _update_slider_percentage(value: float, slider: Range) -> void:
	var slider_label: Label = null
	match(slider.name):
		"MasterSlider":
			slider_label = master_percentage
		"MusicSlider":
			slider_label = music_percentage
		"EffectSlider":
			slider_label = effects_percentage
			
	slider_label.text = str(roundi(value * 66.67))

func _save_slide_percentage(value_changed: bool, slider: Slider) -> void:
	if not value_changed:
		return
		
	match(slider.name):
		"MasterSlider":
			Settings.master_percentage = slider.value
		"MusicSlider":
			Settings.music_percentage = slider.value
		"EffectSlider":
			Settings.effect_percentage = slider.value


func _check_box_updated(box: BaseButton) -> void:
	match(box.name):
		"HighlightBlockCheckBox":
			Settings.highlight_block = box.button_pressed	
		"HighlightOrthogonalCheckBox":
			Settings.highlight_orthogonal = box.button_pressed
		"HighlightSameValueCheckBox":
			Settings.highlight_same_value = box.button_pressed
		"HighlightEmptyCellsCheckBox":
			Settings.highlight_empty_cells = box.button_pressed
		"HighlightAllCheckBox":
			Settings.highlight_all = box.button_pressed
		"HighlightCandidates":
			Settings.highlight_candidates = box.button_pressed
	
	highlighting_updated.emit()


func toggle_fullscreen(toggled_on: bool) -> void:		
	Settings.fullscreen = toggled_on


func _update_color(color: Color):
	Settings.highlight_color = color
	Settings.HIGHLIGHTED.get_stylebox("normal", "Button").bg_color = color


func _save_on_tab_change(_tab: int) -> void:
	Settings.save()


func _input(event):
	if event.is_action_pressed(&"settings") and visible:
		display_settings(false)
