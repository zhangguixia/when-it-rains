extends Control

const SCENE_TITLE := "雨天收容所"

@onready var rain_label: Label = %RainLabel
@onready var prompt_label: Label = %PromptLabel
@onready var objective_label: Label = %ObjectiveLabel
@onready var cushion: ColorRect = %Cushion
@onready var milk_bowl: ColorRect = %MilkBowl
@onready var advance_button: Button = %AdvanceButton
@onready var transition_timer: Timer = %TransitionTimer
@onready var weather: Node = %WeatherController
@onready var care: Node = %CareController
@onready var cat: Area2D = %CatActor

var visit := 1
var stage := "first_rain"
var transition_pending := false
var progression := preload("res://game/shelter/DemoProgression.gd").new()
var objective_hint := preload("res://game/shelter/ObjectiveHint.gd").new()

func _ready() -> void:
	cushion.cushion_dropped.connect(_move_cushion)
	milk_bowl.milk_poured.connect(_pour_milk)
	advance_button.pressed.connect(_advance_weather)
	transition_timer.timeout.connect(_advance_weather)
	cat.petted.connect(_pet_cat)
	care.care_changed.connect(_on_care_changed)
	weather.rain_started.connect(_on_rain_started)
	weather.rain_stopped.connect(_on_rain_stopped)
	_restore_from_saved_stage()

func get_scene_title() -> String:
	return SCENE_TITLE

func _move_cushion(area_id: String) -> void:
	care.move_cushion(area_id)
	match area_id:
		"dry_left":
			prompt_label.text = "坐垫挪到了更干燥的地方。"
		"wet_right":
			prompt_label.text = "这里有一点飘雨，小猫缩了缩。"
		_:
			prompt_label.text = "坐垫放在屋檐中间。"

func _pour_milk() -> void:
	care.pour_milk()
	prompt_label.text = milk_bowl.get_prompt_text()

func _pet_cat() -> void:
	care.pet_cat()
	prompt_label.text = "你轻轻摸了摸小猫。"

func _on_care_changed(snapshot: Dictionary) -> void:
	snapshot["visit"] = visit
	objective_label.text = objective_hint.get_hint(snapshot)
	cat.apply_care(snapshot)
	_maybe_advance_after_care(snapshot)

func _advance_weather() -> void:
	match stage:
		"first_rain":
			stage = "first_goodbye"
			transition_pending = false
			weather.stop_rain()
			cat.start_leaving()
			SaveService.set_stage("first_goodbye")
			_queue_advance_after_delay(2.0)
		"first_goodbye":
			stage = "second_rain"
			transition_pending = false
			visit = 2
			care.reset_for_next_visit()
			milk_bowl.reset_bowl()
			weather.start_second_rain()
			cat.start_returning()
			SaveService.set_stage("second_rain")
		"second_rain":
			stage = "leaf_placement"
			transition_pending = false
			SaveService.set_stage("leaf_placement")
			get_tree().change_scene_to_file("res://game/keepsakes/KeepsakeCorner.tscn")

func _on_rain_started(rain_visit: int) -> void:
	rain_label.text = "第 %d 场雨正在落下" % rain_visit
	objective_label.text = objective_hint.get_hint(care.get_care_snapshot(rain_visit))
	if rain_visit == 1:
		prompt_label.text = "屋檐外很冷。它还不确定能不能进来。"
	else:
		prompt_label.text = "它又来了。这一次，它没有犹豫那么久。"

func _on_rain_stopped(_rain_visit: int) -> void:
	rain_label.text = "雨停了。"
	prompt_label.text = "它离开前回头看了一眼，留下了一片落叶。"
	objective_label.text = "等下一场雨。"
	SaveService.set_leaf_collected(true)
	CodexService.unlock_animal("kitten")
	CodexService.unlock_keepsake("leaf")

func _restore_from_saved_stage() -> void:
	var restore_state := get_restore_state_for_stage(SaveService.get_stage())
	stage = String(restore_state["stage"])
	visit = int(restore_state["visit"])
	match String(restore_state["weather"]):
		"stopped":
			weather.visit = visit
			weather.raining = false
			_on_rain_stopped(visit)
		_:
			if visit == 2:
				weather.start_second_rain()
			else:
				weather.start_first_rain()
	match String(restore_state["cat"]):
		"Leaving":
			cat.start_leaving()
		"Returning":
			cat.start_returning()
		_:
			pass
	SaveService.set_stage(stage)

func _maybe_advance_after_care(snapshot: Dictionary) -> void:
	if transition_pending:
		return
	if not progression.is_care_complete(snapshot):
		return
	if progression.get_next_stage_after_care(stage) == "":
		return
	match stage:
		"first_rain":
			prompt_label.text = "它终于安心坐下了。雨声慢慢变小。"
			_queue_advance_after_delay(1.2)
		"second_rain":
			prompt_label.text = "它记得这里。落叶还在等你收好。"
			_queue_advance_after_delay(1.2)

func _queue_advance_after_delay(seconds: float) -> void:
	transition_pending = true
	transition_timer.start(seconds)

func get_restore_state_for_stage(saved_stage: String) -> Dictionary:
	match saved_stage:
		"first_goodbye":
			return {"stage": "first_goodbye", "visit": 1, "weather": "stopped", "cat": "Leaving"}
		"second_rain":
			return {"stage": "second_rain", "visit": 2, "weather": "raining", "cat": "Returning"}
		_:
			return {"stage": "first_rain", "visit": 1, "weather": "raining", "cat": "Hesitating"}
