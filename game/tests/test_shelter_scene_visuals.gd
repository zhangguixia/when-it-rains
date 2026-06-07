extends RefCounted

func run(assert_true: Callable, assert_equal: Callable) -> void:
	var shelter_script: Script = load("res://game/shelter/ShelterScene.gd")
	assert_true.call(shelter_script != null, "shelter scene script exists")
	if shelter_script == null:
		return

	var shelter: Control = shelter_script.new()
	assert_true.call(shelter.has_method("get_scene_title"), "shelter scene exposes scene title")
	if shelter.has_method("get_scene_title"):
		assert_equal.call(shelter.get_scene_title(), "雨天收容所", "shelter scene title")
	shelter.free()
