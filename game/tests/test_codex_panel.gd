extends RefCounted

func run(assert_true: Callable, assert_equal: Callable) -> void:
	var codex_script: Script = load("res://game/ui/CodexPanel.gd")
	assert_true.call(codex_script != null, "codex panel script exists")
	if codex_script == null:
		return

	var panel: Control = codex_script.new()
	assert_true.call(panel.has_method("get_page_title"), "codex panel exposes page title")
	assert_true.call(panel.has_method("get_locked_text"), "codex panel exposes locked copy")
	if panel.has_method("get_page_title"):
		assert_equal.call(panel.get_page_title(), "雨天图鉴", "codex page title")
	if panel.has_method("get_locked_text"):
		assert_equal.call(panel.get_locked_text(), "还没有遇见。", "codex locked copy")
	panel.free()
