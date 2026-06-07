extends RefCounted

func run(assert_true: Callable, assert_equal: Callable) -> void:
	var dragger_script: Script = load("res://game/keepsakes/LeafDragger.gd")
	assert_true.call(dragger_script != null, "leaf dragger script exists")
	if dragger_script == null:
		return

	var dragger: Control = dragger_script.new()
	assert_equal.call(dragger.get_slot_for_position(Vector2(260, 420)), 0, "window slot")
	assert_equal.call(dragger.get_slot_for_position(Vector2(620, 420)), 1, "cushion slot")
	assert_equal.call(dragger.get_slot_for_position(Vector2(980, 420)), 2, "box slot")
	assert_equal.call(dragger.get_snap_position_for_slot(0), Vector2(260, 420), "window snap")
	assert_equal.call(dragger.get_snap_position_for_slot(1), Vector2(620, 420), "cushion snap")
	assert_equal.call(dragger.get_snap_position_for_slot(2), Vector2(980, 420), "box snap")
	assert_equal.call(dragger.get_snap_position_for_slot(99), Vector2(620, 420), "unknown slot snaps to center")
	assert_true.call(dragger.has_method("get_art_node_name"), "leaf exposes art node name")
	if dragger.has_method("get_art_node_name"):
		assert_equal.call(dragger.get_art_node_name(), "LeafArt", "leaf art node name")
	dragger.free()
