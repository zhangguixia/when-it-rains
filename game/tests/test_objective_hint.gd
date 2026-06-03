extends RefCounted

func run(assert_true: Callable, assert_equal: Callable) -> void:
	var hint_script: Script = load("res://game/shelter/ObjectiveHint.gd")
	assert_true.call(hint_script != null, "objective hint script exists")
	if hint_script == null:
		return

	var hint: RefCounted = hint_script.new()
	assert_equal.call(hint.get_hint({"cushion_moved": false, "milk_ready": false, "pet_count": 0}), "先把坐垫拖到干燥一点的地方。", "first hint asks for cushion")
	assert_equal.call(hint.get_hint({"cushion_moved": true, "milk_ready": false, "pet_count": 0}), "再点击牛奶碗，倒一点温牛奶。", "second hint asks for milk")
	assert_equal.call(hint.get_hint({"cushion_moved": true, "milk_ready": true, "pet_count": 0}), "最后轻轻摸摸小猫，让它知道这里安全。", "third hint asks for petting")
	assert_equal.call(hint.get_hint({"cushion_moved": true, "milk_ready": true, "pet_count": 1}), "它看起来安心多了。", "complete hint")
