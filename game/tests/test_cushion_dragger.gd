extends RefCounted

func run(assert_true: Callable, assert_equal: Callable) -> void:
	var dragger_script: Script = load("res://game/shelter/CushionDragger.gd")
	assert_true.call(dragger_script != null, "cushion dragger script exists")
	if dragger_script == null:
		return

	var dragger: Control = dragger_script.new()
	assert_equal.call(dragger.get_area_for_position(Vector2(420, 760)), "dry_left", "left drop area")
	assert_equal.call(dragger.get_area_for_position(Vector2(700, 760)), "center", "center drop area")
	assert_equal.call(dragger.get_area_for_position(Vector2(1040, 760)), "wet_right", "right drop area")
	assert_equal.call(dragger.get_snap_position_for_area("dry_left"), Vector2(420, 800), "left snap position")
	assert_equal.call(dragger.get_snap_position_for_area("center"), Vector2(700, 800), "center snap position")
	assert_equal.call(dragger.get_snap_position_for_area("wet_right"), Vector2(1040, 800), "right snap position")
	dragger.free()
