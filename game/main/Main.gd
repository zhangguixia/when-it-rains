extends Control

const MAIN_MENU_SCENE := preload("res://game/main/MainMenu.tscn")
const SHELTER_SCENE := "res://game/shelter/ShelterScene.tscn"

@onready var content: Control = %Content

func _ready() -> void:
	_show_main_menu()

func _show_main_menu() -> void:
	_clear_content()
	var menu := MAIN_MENU_SCENE.instantiate()
	menu.start_requested.connect(_start_demo)
	menu.continue_requested.connect(_continue_demo)
	menu.reset_requested.connect(_reset_progress)
	menu.quit_requested.connect(_quit_game)
	content.add_child(menu)

func _start_demo() -> void:
	SaveService.start_new_demo()
	get_tree().change_scene_to_file(SHELTER_SCENE)

func _continue_demo() -> void:
	get_tree().change_scene_to_file(SHELTER_SCENE)

func _reset_progress() -> void:
	SaveService.reset_progress()
	_show_main_menu()

func _quit_game() -> void:
	get_tree().quit()

func _clear_content() -> void:
	for child in content.get_children():
		child.queue_free()
