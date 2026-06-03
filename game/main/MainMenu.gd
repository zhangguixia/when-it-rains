extends Control

signal start_requested
signal continue_requested
signal settings_requested
signal reset_requested
signal quit_requested

@onready var start_button: Button = %StartButton
@onready var continue_button: Button = %ContinueButton
@onready var settings_button: Button = %SettingsButton
@onready var reset_button: Button = %ResetButton
@onready var quit_button: Button = %QuitButton

func _ready() -> void:
	start_button.pressed.connect(func() -> void: start_requested.emit())
	continue_button.pressed.connect(func() -> void: continue_requested.emit())
	settings_button.pressed.connect(func() -> void: settings_requested.emit())
	reset_button.pressed.connect(func() -> void: reset_requested.emit())
	quit_button.pressed.connect(func() -> void: quit_requested.emit())
	continue_button.disabled = not SaveService.has_started_demo()
