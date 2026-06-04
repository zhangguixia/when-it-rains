extends Control

signal back_requested

const PAGE_TITLE := "设置"

@onready var master_slider: HSlider = %MasterSlider
@onready var rain_slider: HSlider = %RainSlider
@onready var music_slider: HSlider = %MusicSlider
@onready var fullscreen_check: CheckBox = %FullscreenCheck
@onready var back_button: Button = %BackButton

func _ready() -> void:
	var settings := SaveService.get_settings()
	master_slider.value = float(settings["master_volume"])
	rain_slider.value = float(settings["ambience_volume"])
	music_slider.value = float(settings["music_volume"])
	fullscreen_check.button_pressed = bool(settings["fullscreen"])

	master_slider.value_changed.connect(func(value: float) -> void: SaveService.set_setting("master_volume", value))
	rain_slider.value_changed.connect(func(value: float) -> void: SaveService.set_setting("ambience_volume", value))
	music_slider.value_changed.connect(func(value: float) -> void: SaveService.set_setting("music_volume", value))
	fullscreen_check.toggled.connect(_set_fullscreen)
	back_button.pressed.connect(func() -> void: back_requested.emit())

func get_page_title() -> String:
	return PAGE_TITLE

func _set_fullscreen(enabled: bool) -> void:
	SaveService.set_setting("fullscreen", enabled)
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if enabled else DisplayServer.WINDOW_MODE_WINDOWED)
