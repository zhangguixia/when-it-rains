extends RefCounted

func run(assert_true: Callable, assert_equal: Callable) -> void:
	SaveService.reset_progress()
	CodexService.reset_codex()
	assert_true.call(not CodexService.is_animal_unlocked("kitten"), "kitten starts locked")
	assert_true.call(not CodexService.is_keepsake_unlocked("leaf"), "leaf starts locked")

	CodexService.unlock_animal("kitten")
	CodexService.unlock_keepsake("leaf")
	assert_true.call(CodexService.is_animal_unlocked("kitten"), "kitten unlocks")
	assert_true.call(CodexService.is_keepsake_unlocked("leaf"), "leaf unlocks")

	var animals := CodexService.get_animal_entries()
	assert_equal.call(animals.size(), 4, "demo shows four animal entries")
	assert_equal.call(animals[0]["id"], "kitten", "first animal is kitten")
	assert_true.call(animals[1]["locked"], "dog is locked preview")

	assert_true.call(SaveService.has_method("get_unlocked_animals"), "save service exposes unlocked animal list")
	assert_true.call(SaveService.has_method("get_unlocked_keepsakes"), "save service exposes unlocked keepsake list")
	assert_true.call(CodexService.has_method("load_from_save"), "codex service can reload from save")
	if not SaveService.has_method("get_unlocked_animals") or not SaveService.has_method("get_unlocked_keepsakes") or not CodexService.has_method("load_from_save"):
		return

	assert_true.call(SaveService.get_unlocked_animals().has("kitten"), "kitten unlock persists to save data")
	assert_true.call(SaveService.get_unlocked_keepsakes().has("leaf"), "leaf unlock persists to save data")

	CodexService.unlocked_animals.clear()
	CodexService.unlocked_keepsakes.clear()
	CodexService.load_from_save()
	assert_true.call(CodexService.is_animal_unlocked("kitten"), "kitten reloads from save data")
	assert_true.call(CodexService.is_keepsake_unlocked("leaf"), "leaf reloads from save data")
