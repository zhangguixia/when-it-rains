extends Node

var unlocked_animals: Dictionary = {}
var unlocked_keepsakes: Dictionary = {}

const ANIMAL_ENTRIES := [
	{"id": "kitten", "name": "小猫", "hint": "它记得这个屋檐。"},
	{"id": "dog", "name": "小狗", "hint": "远处传来一声叫声。"},
	{"id": "bird", "name": "小鸟", "hint": "有羽毛落在窗边。"},
	{"id": "hedgehog", "name": "小刺猬", "hint": "它还在找避雨的路。"}
]

const KEEPSAKE_ENTRIES := [
	{"id": "leaf", "name": "落叶", "text": "它留下的落叶，边缘还带着雨水。"},
	{"id": "glass_marble", "name": "玻璃珠", "text": "还未获得。"},
	{"id": "feather", "name": "羽毛", "text": "还未获得。"},
	{"id": "acorn", "name": "橡果", "text": "还未获得。"}
]

func _ready() -> void:
	load_from_save()

func reset_codex() -> void:
	unlocked_animals.clear()
	unlocked_keepsakes.clear()

func unlock_animal(id: String) -> void:
	unlocked_animals[id] = true
	SaveService.unlock_codex_animal(id)

func unlock_keepsake(id: String) -> void:
	unlocked_keepsakes[id] = true
	SaveService.unlock_codex_keepsake(id)

func load_from_save() -> void:
	unlocked_animals.clear()
	unlocked_keepsakes.clear()
	for id in SaveService.get_unlocked_animals():
		unlocked_animals[String(id)] = true
	for id in SaveService.get_unlocked_keepsakes():
		unlocked_keepsakes[String(id)] = true

func is_animal_unlocked(id: String) -> bool:
	return unlocked_animals.get(id, false)

func is_keepsake_unlocked(id: String) -> bool:
	return unlocked_keepsakes.get(id, false)

func get_animal_entries() -> Array:
	var result: Array = []
	for entry in ANIMAL_ENTRIES:
		var item: Dictionary = entry.duplicate(true)
		item["locked"] = not is_animal_unlocked(String(item["id"]))
		result.append(item)
	return result

func get_keepsake_entries() -> Array:
	var result: Array = []
	for entry in KEEPSAKE_ENTRIES:
		var item: Dictionary = entry.duplicate(true)
		item["locked"] = not is_keepsake_unlocked(String(item["id"]))
		result.append(item)
	return result
