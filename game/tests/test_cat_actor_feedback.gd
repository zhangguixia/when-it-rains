extends RefCounted

func run(assert_true: Callable, assert_equal: Callable) -> void:
	var actor_script: Script = load("res://game/cat/CatActor.gd")
	assert_true.call(actor_script != null, "cat actor script exists")
	if actor_script == null:
		return

	var actor: Area2D = actor_script.new()
	assert_true.call(actor.has_method("get_visual_profile_for_state"), "cat actor exposes visual profiles")
	if not actor.has_method("get_visual_profile_for_state"):
		actor.free()
		return

	var hesitant: Dictionary = actor.get_visual_profile_for_state("Hesitating")
	assert_equal.call(hesitant["label"], "小猫还在犹豫", "hesitating label")
	assert_equal.call(hesitant["offset"], Vector2(-180, 0), "hesitating offset")

	var drinking: Dictionary = actor.get_visual_profile_for_state("Drinking")
	assert_equal.call(drinking["label"], "小猫在喝牛奶", "drinking label")
	assert_equal.call(drinking["offset"], Vector2(-40, 20), "drinking moves toward bowl")

	var purring: Dictionary = actor.get_visual_profile_for_state("Purring")
	assert_equal.call(purring["label"], "小猫安心地呼噜", "purring label")
	assert_equal.call(purring["scale"], Vector2(1.08, 0.92), "purring relaxed scale")

	var leaving: Dictionary = actor.get_visual_profile_for_state("Leaving")
	assert_equal.call(leaving["label"], "雨停了，它回头看了一眼", "leaving label")
	assert_equal.call(leaving["offset"], Vector2(180, -20), "leaving offset")

	var returning: Dictionary = actor.get_visual_profile_for_state("Returning")
	assert_equal.call(returning["label"], "它又回来了", "returning label")
	assert_equal.call(returning["offset"], Vector2(-80, 0), "returning offset")
	actor.free()
