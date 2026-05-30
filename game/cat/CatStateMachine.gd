extends RefCounted

signal state_changed(new_state: String)

var state := "Hesitating"

func apply_care(snapshot: Dictionary) -> void:
	var comfort := float(snapshot.get("cushion_comfort", 0.0))
	var milk_ready := bool(snapshot.get("milk_ready", false))
	var pet_count := int(snapshot.get("pet_count", 0))

	if pet_count >= 2 and milk_ready:
		_set_state("Purring")
	elif milk_ready:
		_set_state("Drinking")
	elif comfort >= 0.7:
		_set_state("Approaching")
	elif comfort >= 0.5:
		_set_state("Resting")
	else:
		_set_state("Hesitating")

func start_leaving() -> void:
	_set_state("Leaving")

func start_returning() -> void:
	_set_state("Returning")

func _set_state(next_state: String) -> void:
	if state == next_state:
		return
	state = next_state
	state_changed.emit(state)
