extends Node

var failures: Array[String] = []

func _ready() -> void:
	_run_script("res://game/tests/test_save_service.gd")
	_run_script("res://game/tests/test_codex_service.gd")
	_run_script("res://game/tests/test_cat_state_machine.gd")
	_run_script("res://game/tests/test_care_controller.gd")
	if failures.is_empty():
		print("TESTS PASSED")
		get_tree().quit(0)
	else:
		for failure in failures:
			push_error(failure)
		get_tree().quit(1)

func _run_script(path: String) -> void:
	var script := load(path)
	if script == null:
		failures.append("Could not load test script: %s" % path)
		return
	var suite = script.new()
	suite.run(_assert_true, _assert_equal)

func _assert_true(value: bool, label: String) -> void:
	if not value:
		failures.append("Expected true: %s" % label)

func _assert_equal(actual, expected, label: String) -> void:
	if actual != expected:
		failures.append("%s expected <%s> got <%s>" % [label, expected, actual])
