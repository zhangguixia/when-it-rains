extends RefCounted

func run(assert_true: Callable, assert_equal: Callable) -> void:
	var machine_script: Script = load("res://game/cat/CatStateMachine.gd")
	assert_true.call(machine_script != null, "cat state machine script exists")
	if machine_script == null:
		return
	var machine: RefCounted = machine_script.new()
	assert_equal.call(machine.state, "Hesitating", "initial cat state")

	machine.apply_care({"cushion_comfort": 0.8, "milk_ready": false, "pet_count": 0, "visit": 1})
	assert_equal.call(machine.state, "Approaching", "comfortable cushion invites approach")

	machine.apply_care({"cushion_comfort": 0.8, "milk_ready": true, "pet_count": 0, "visit": 1})
	assert_equal.call(machine.state, "Drinking", "milk leads to drinking")

	machine.apply_care({"cushion_comfort": 0.8, "milk_ready": true, "pet_count": 2, "visit": 1})
	assert_equal.call(machine.state, "Purring", "petting after milk leads to purring")

	machine.start_leaving()
	assert_equal.call(machine.state, "Leaving", "leaving state")

	machine.start_returning()
	assert_equal.call(machine.state, "Returning", "returning state")
