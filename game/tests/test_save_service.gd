extends RefCounted

func run(assert_true: Callable, assert_equal: Callable) -> void:
	SaveService.reset_progress()
	assert_equal.call(SaveService.get_stage(), "not_started", "fresh stage")
	assert_true.call(not SaveService.has_started_demo(), "fresh save has not started")

	SaveService.start_new_demo()
	assert_equal.call(SaveService.get_stage(), "first_rain", "new demo starts at first rain")
	assert_true.call(SaveService.has_started_demo(), "started demo flag")

	SaveService.set_stage("leaf_placement")
	SaveService.set_leaf_slot(2)
	assert_equal.call(SaveService.get_stage(), "leaf_placement", "stage saves in memory")
	assert_equal.call(SaveService.get_leaf_slot(), 2, "leaf slot saves in memory")

	SaveService.reset_progress()
	assert_equal.call(SaveService.get_stage(), "not_started", "reset stage")
	assert_equal.call(SaveService.get_leaf_slot(), -1, "reset leaf slot")
