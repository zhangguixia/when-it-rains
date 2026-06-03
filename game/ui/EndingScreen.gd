extends Control

signal main_menu_requested
signal restart_requested

@onready var line_1: Label = %Line1
@onready var line_2: Label = %Line2
@onready var line_3: Label = %Line3
@onready var main_menu_button: Button = %MainMenuButton
@onready var restart_button: Button = %RestartButton

func _ready() -> void:
	var lines := get_ending_lines()
	line_1.text = String(lines[0])
	line_2.text = String(lines[1])
	line_3.text = String(lines[2])
	main_menu_button.pressed.connect(_go_to_main_menu)
	restart_button.pressed.connect(_restart_demo)

func get_ending_lines() -> Array:
	return [
		"雨还会再来的。",
		"有些小小的善意，会被记住很久。",
		"正式版会有更多来访的小动物和纪念品。"
	]

func _go_to_main_menu() -> void:
	main_menu_requested.emit()
	get_tree().change_scene_to_file("res://game/main/Main.tscn")

func _restart_demo() -> void:
	restart_requested.emit()
	SaveService.start_new_demo()
	CodexService.reset_codex()
	get_tree().change_scene_to_file("res://game/shelter/ShelterScene.tscn")
