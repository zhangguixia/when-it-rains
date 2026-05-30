extends Control

@onready var rain_label: Label = %RainLabel
@onready var prompt_label: Label = %PromptLabel
@onready var cushion_button: Button = %CushionButton
@onready var milk_button: Button = %MilkButton
@onready var advance_button: Button = %AdvanceButton
@onready var weather: Node = %WeatherController
@onready var care: Node = %CareController
@onready var cat: Area2D = %CatActor

var visit := 1
var stage := "first_rain"

func _ready() -> void:
	cushion_button.pressed.connect(_move_cushion)
	milk_button.pressed.connect(_pour_milk)
	advance_button.pressed.connect(_advance_weather)
	cat.petted.connect(_pet_cat)
	care.care_changed.connect(_on_care_changed)
	weather.rain_started.connect(_on_rain_started)
	weather.rain_stopped.connect(_on_rain_stopped)
	weather.start_first_rain()
	SaveService.set_stage("first_rain")

func _move_cushion() -> void:
	care.move_cushion("dry_left")
	prompt_label.text = "坐垫挪到了更干燥的地方。"

func _pour_milk() -> void:
	care.pour_milk()
	prompt_label.text = "牛奶倒好了，小猫闻到了。"

func _pet_cat() -> void:
	care.pet_cat()
	prompt_label.text = "你轻轻摸了摸小猫。"

func _on_care_changed(snapshot: Dictionary) -> void:
	snapshot["visit"] = visit
	cat.apply_care(snapshot)

func _advance_weather() -> void:
	match stage:
		"first_rain":
			stage = "first_goodbye"
			weather.stop_rain()
			cat.start_leaving()
			SaveService.set_stage("first_goodbye")
		"first_goodbye":
			stage = "second_rain"
			visit = 2
			care.reset_for_next_visit()
			weather.start_second_rain()
			cat.start_returning()
			SaveService.set_stage("second_rain")
		"second_rain":
			stage = "leaf_placement"
			SaveService.set_stage("leaf_placement")
			get_tree().change_scene_to_file("res://game/keepsakes/KeepsakeCorner.tscn")

func _on_rain_started(rain_visit: int) -> void:
	rain_label.text = "第 %d 场雨正在落下" % rain_visit
	if rain_visit == 1:
		prompt_label.text = "屋檐外很冷。它还不确定能不能进来。"
	else:
		prompt_label.text = "它又来了。这一次，它没有犹豫那么久。"

func _on_rain_stopped(_rain_visit: int) -> void:
	rain_label.text = "雨停了。"
	prompt_label.text = "它离开前回头看了一眼，留下了一片落叶。"
	SaveService.set_leaf_collected(true)
	CodexService.unlock_animal("kitten")
	CodexService.unlock_keepsake("leaf")
