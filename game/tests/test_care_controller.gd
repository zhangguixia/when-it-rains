extends RefCounted

func run(assert_true: Callable, assert_equal: Callable) -> void:
	var care_script: Script = load("res://game/shelter/CareController.gd")
	assert_true.call(care_script != null, "care controller script exists")
	if care_script == null:
		return
	var care: Node = care_script.new()
	assert_equal.call(care.cushion_area, "center", "default cushion area")
	assert_equal.call(care.get_cushion_comfort(), 0.65, "default comfort")

	care.move_cushion("dry_left")
	assert_equal.call(care.cushion_area, "dry_left", "cushion moves")
	assert_equal.call(care.get_cushion_comfort(), 0.95, "dry area comfort")

	care.pour_milk()
	assert_true.call(care.milk_ready, "milk ready")

	care.pet_cat()
	care.pet_cat()
	assert_equal.call(care.pet_count, 2, "pet count")

	var snapshot: Dictionary = care.get_care_snapshot(2)
	assert_equal.call(snapshot["visit"], 2, "snapshot visit")
	assert_true.call(snapshot["milk_ready"], "snapshot milk")
	care.free()
