extends RefCounted

func run(assert_true: Callable, assert_equal: Callable) -> void:
	var main_script: Script = load("res://game/main/Main.gd")
	assert_true.call(main_script != null, "main script exists")
	if main_script == null:
		return

	var main: Control = main_script.new()
	assert_true.call(main.has_method("get_scene_for_stage"), "main exposes scene routing helper")
	if not main.has_method("get_scene_for_stage"):
		main.free()
		return
	assert_equal.call(main.get_scene_for_stage("not_started"), "res://game/shelter/ShelterScene.tscn", "not started routes to shelter for explicit start")
	assert_equal.call(main.get_scene_for_stage("first_rain"), "res://game/shelter/ShelterScene.tscn", "first rain routes to shelter")
	assert_equal.call(main.get_scene_for_stage("first_goodbye"), "res://game/shelter/ShelterScene.tscn", "first goodbye routes to shelter")
	assert_equal.call(main.get_scene_for_stage("second_rain"), "res://game/shelter/ShelterScene.tscn", "second rain routes to shelter")
	assert_equal.call(main.get_scene_for_stage("leaf_placement"), "res://game/keepsakes/KeepsakeCorner.tscn", "leaf placement resumes at keepsake corner")
	assert_equal.call(main.get_scene_for_stage("codex_reveal"), "res://game/ui/CodexPanel.tscn", "codex reveal resumes at codex")
	assert_equal.call(main.get_scene_for_stage("demo_complete"), "res://game/ui/CodexPanel.tscn", "complete demo resumes at codex")
	main.free()
