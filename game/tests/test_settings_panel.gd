extends RefCounted

func run(assert_true: Callable, assert_equal: Callable) -> void:
	var settings_script: Script = load("res://game/ui/SettingsPanel.gd")
	assert_true.call(settings_script != null, "settings panel script exists")
	if settings_script == null:
		return

	var panel: Control = settings_script.new()
	assert_true.call(panel.has_method("get_page_title"), "settings panel exposes page title")
	if panel.has_method("get_page_title"):
		assert_equal.call(panel.get_page_title(), "设置", "settings page title")
	assert_true.call(panel.has_signal("back_requested"), "settings panel emits back signal")
	panel.free()
