extends RefCounted

func run(assert_true: Callable, assert_equal: Callable) -> void:
	var ending_script: Script = load("res://game/ui/EndingScreen.gd")
	assert_true.call(ending_script != null, "ending screen script exists")
	if ending_script == null:
		return

	var ending: Control = ending_script.new()
	assert_true.call(ending.has_method("get_ending_lines"), "ending screen exposes text lines")
	if not ending.has_method("get_ending_lines"):
		ending.free()
		return

	var lines: Array = ending.get_ending_lines()
	assert_equal.call(lines.size(), 3, "ending has three lines")
	assert_equal.call(lines[0], "雨还会再来的。", "first ending line")
	assert_equal.call(lines[1], "有些小小的善意，会被记住很久。", "second ending line")
	assert_equal.call(lines[2], "正式版会有更多来访的小动物和纪念品。", "third ending line")
	ending.free()
