extends RefCounted

func run(assert_true: Callable, assert_equal: Callable) -> void:
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
