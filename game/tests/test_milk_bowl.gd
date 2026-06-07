extends RefCounted

func run(assert_true: Callable, assert_equal: Callable) -> void:
	var bowl_script: Script = load("res://game/shelter/MilkBowl.gd")
	assert_true.call(bowl_script != null, "milk bowl script exists")
	if bowl_script == null:
		return

	var bowl: ColorRect = bowl_script.new()
	assert_true.call(not bowl.filled, "milk bowl starts empty")
	assert_equal.call(bowl.get_prompt_text(), "点击牛奶碗，倒一点温牛奶。", "empty bowl prompt")
	assert_true.call(bowl.has_method("get_art_node_name"), "milk bowl exposes art node name")
	if bowl.has_method("get_art_node_name"):
		assert_equal.call(bowl.get_art_node_name(), "MilkBowlArt", "milk bowl art node name")

	bowl.pour_milk()
	assert_true.call(bowl.filled, "milk bowl becomes filled")
	assert_equal.call(bowl.get_prompt_text(), "牛奶倒好了，小猫闻到了。", "filled bowl prompt")

	assert_true.call(bowl.has_method("reset_bowl"), "milk bowl exposes reset")
	if not bowl.has_method("reset_bowl"):
		bowl.free()
		return
	bowl.reset_bowl()
	assert_true.call(not bowl.filled, "milk bowl resets to empty")
	assert_equal.call(bowl.get_prompt_text(), "点击牛奶碗，倒一点温牛奶。", "reset bowl prompt")
	bowl.free()
