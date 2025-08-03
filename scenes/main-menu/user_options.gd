# user_options.gd
extends Control

# (FIX) Declare the signal so other nodes know it exists.
signal back_pressed


@onready var display_mode_button = $CenterContainer/VBoxContainer/PanelContainer/VBoxContainer/DisplayModeButton
@onready var display_mode_label = $CenterContainer/VBoxContainer/PanelContainer/VBoxContainer/DisplayModeLabel

const DISPLAY_MODES = [DisplayServer.WINDOW_MODE_WINDOWED,
					  DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN]
const DISPLAY_MODE_NAMES = ["Windowed", "Fullscreen"]

func _ready():
	# SET ALL AUDIOSERVER DB TO 40
	var bus_idx = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(bus_idx, linear_to_db(0.4))
	bus_idx = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_db(bus_idx, linear_to_db(0.4))
	bus_idx = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_volume_db(bus_idx, linear_to_db(0.4))

	if OS.has_feature("web"):
		display_mode_button.hide()
		display_mode_label.hide()
	else:
		for mode_name in DISPLAY_MODE_NAMES:
			display_mode_button.add_item(mode_name)
		var current_mode = DisplayServer.window_get_mode()
		var current_mode_idx = DISPLAY_MODES.find(current_mode)
		if current_mode_idx != -1:
			display_mode_button.select(current_mode_idx)

func _on_volume_slider_value_changed(value):
	var bus_idx = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(bus_idx, linear_to_db(value / 100.0))

func _on_sound_slider_value_changed(value):
	var bus_idx = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_volume_db(bus_idx, linear_to_db(value / 100.0))

func _on_music_slider_value_changed(value):
	var bus_idx = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_db(bus_idx, linear_to_db(value / 100.0))

func _on_display_mode_button_item_selected(index):
	#click sound
	SoundManager.playSound(SoundManager.SOUND.CLICK)
	DisplayServer.window_set_mode(DISPLAY_MODES[index])

func _on_back_button_pressed():
	# Instead of self.hide(), we now emit our custom signal.
	emit_signal("back_pressed")
