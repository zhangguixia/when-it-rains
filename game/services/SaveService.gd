extends Node

const SAVE_PATH := "user://when_it_rains_demo_save.json"

var data := _default_data()

func _ready() -> void:
	load_progress()

func _default_data() -> Dictionary:
	return {
		"stage": "not_started",
		"kitten_visits": 0,
		"leaf_collected": false,
		"leaf_slot": -1,
		"settings": {
			"master_volume": 1.0,
			"ambience_volume": 1.0,
			"music_volume": 0.8,
			"fullscreen": false
		}
	}

func has_started_demo() -> bool:
	return data["stage"] != "not_started"

func start_new_demo() -> void:
	data = _default_data()
	data["stage"] = "first_rain"
	save_progress()

func reset_progress() -> void:
	data = _default_data()
	save_progress()

func get_stage() -> String:
	return String(data["stage"])

func set_stage(stage: String) -> void:
	data["stage"] = stage
	save_progress()

func get_leaf_slot() -> int:
	return int(data["leaf_slot"])

func set_leaf_slot(slot_index: int) -> void:
	data["leaf_slot"] = slot_index
	save_progress()

func set_leaf_collected(value: bool) -> void:
	data["leaf_collected"] = value
	save_progress()

func is_leaf_collected() -> bool:
	return bool(data["leaf_collected"])

func set_kitten_visits(count: int) -> void:
	data["kitten_visits"] = count
	save_progress()

func get_kitten_visits() -> int:
	return int(data["kitten_visits"])

func get_settings() -> Dictionary:
	return data["settings"].duplicate(true)

func set_setting(key: String, value) -> void:
	data["settings"][key] = value
	save_progress()

func save_progress() -> void:
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		push_error("Could not write save file: %s" % SAVE_PATH)
		return
	file.store_string(JSON.stringify(data))

func load_progress() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		data = _default_data()
		return
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		data = _default_data()
		return
	var parsed = JSON.parse_string(file.get_as_text())
	if typeof(parsed) != TYPE_DICTIONARY:
		data = _default_data()
		return
	data = _default_data()
	for key in parsed.keys():
		data[key] = parsed[key]
