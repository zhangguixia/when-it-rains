extends Control

const MAIN_MENU_SCENE := preload("res://game/main/MainMenu.tscn")
const SETTINGS_SCENE := preload("res://game/ui/SettingsPanel.tscn")
const SHELTER_SCENE := "res://game/shelter/ShelterScene.tscn"
const KEEPSAKE_SCENE := "res://game/keepsakes/KeepsakeCorner.tscn"
const CODEX_SCENE := "res://game/ui/CodexPanel.tscn"
const ENDING_SCENE := "res://game/ui/EndingScreen.tscn"

@onready var content: Control = %Content

func _ready() -> void:
	_show_main_menu()

func _show_main_menu() -> void:
	_clear_content()
	var menu := MAIN_MENU_SCENE.instantiate()
	menu.start_requested.connect(_start_demo)
	menu.continue_requested.connect(_continue_demo)
	menu.settings_requested.connect(_show_settings)
	menu.reset_requested.connect(_reset_progress)
	menu.quit_requested.connect(_quit_game)
	content.add_child(menu)

func _show_settings() -> void:
	_clear_content()
	var settings := SETTINGS_SCENE.instantiate()
	settings.back_requested.connect(_show_main_menu)
	content.add_child(settings)

func _start_demo() -> void:
	SaveService.start_new_demo()
	get_tree().change_scene_to_file(SHELTER_SCENE)

func _continue_demo() -> void:
	get_tree().change_scene_to_file(get_scene_for_stage(SaveService.get_stage()))

func _reset_progress() -> void:
	SaveService.reset_progress()
	CodexService.reset_codex()
	_show_main_menu()

func _quit_game() -> void:
	get_tree().quit()

func _clear_content() -> void:
	for child in content.get_children():
		child.queue_free()

func get_scene_for_stage(stage: String) -> String:
	match stage:
		"leaf_placement":
			return KEEPSAKE_SCENE
		"codex_reveal":
			return CODEX_SCENE
		"demo_complete":
			return ENDING_SCENE
		_:
			return SHELTER_SCENE
