extends RefCounted

func run(assert_true: Callable, assert_equal: Callable) -> void:
	var shelter_script: Script = load("res://game/shelter/ShelterScene.gd")
	assert_true.call(shelter_script != null, "shelter script exists")
	if shelter_script == null:
		return

	var shelter: Control = shelter_script.new()
	assert_true.call(shelter.has_method("get_restore_state_for_stage"), "shelter exposes restore state helper")
	if not shelter.has_method("get_restore_state_for_stage"):
		shelter.free()
		return

	assert_equal.call(shelter.get_restore_state_for_stage("first_rain"), {"stage": "first_rain", "visit": 1, "weather": "raining", "cat": "Hesitating"}, "first rain restore")
	assert_equal.call(shelter.get_restore_state_for_stage("first_goodbye"), {"stage": "first_goodbye", "visit": 1, "weather": "stopped", "cat": "Leaving"}, "first goodbye restore")
	assert_equal.call(shelter.get_restore_state_for_stage("second_rain"), {"stage": "second_rain", "visit": 2, "weather": "raining", "cat": "Returning"}, "second rain restore")
	assert_equal.call(shelter.get_restore_state_for_stage("unknown"), {"stage": "first_rain", "visit": 1, "weather": "raining", "cat": "Hesitating"}, "unknown stage falls back to first rain")
	shelter.free()
