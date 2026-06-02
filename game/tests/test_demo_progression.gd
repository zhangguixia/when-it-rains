extends RefCounted

func run(assert_true: Callable, assert_equal: Callable) -> void:
	var progression_script: Script = load("res://game/shelter/DemoProgression.gd")
	assert_true.call(progression_script != null, "demo progression script exists")
	if progression_script == null:
		return

	var progression: RefCounted = progression_script.new()
	assert_true.call(not progression.is_care_complete({"cushion_moved": false, "milk_ready": true, "pet_count": 1}), "care requires cushion movement")
	assert_true.call(not progression.is_care_complete({"cushion_moved": true, "milk_ready": false, "pet_count": 1}), "care requires milk")
	assert_true.call(not progression.is_care_complete({"cushion_moved": true, "milk_ready": true, "pet_count": 0}), "care requires petting")
	assert_true.call(progression.is_care_complete({"cushion_moved": true, "milk_ready": true, "pet_count": 1}), "care completes after cushion milk and petting")

	assert_equal.call(progression.get_next_stage_after_care("first_rain"), "first_goodbye", "first visit care leads to goodbye")
	assert_equal.call(progression.get_next_stage_after_care("second_rain"), "leaf_placement", "second visit care leads to leaf placement")
	assert_equal.call(progression.get_next_stage_after_care("first_goodbye"), "", "goodbye does not advance from care")
	assert_equal.call(progression.get_stage_after_delay("first_goodbye"), "second_rain", "goodbye delay leads to second rain")
	assert_equal.call(progression.get_stage_after_delay("second_rain"), "", "second rain has no delay transition")
