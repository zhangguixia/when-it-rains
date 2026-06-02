extends RefCounted

func is_care_complete(snapshot: Dictionary) -> bool:
	return bool(snapshot.get("cushion_moved", false)) \
		and bool(snapshot.get("milk_ready", false)) \
		and int(snapshot.get("pet_count", 0)) >= 1

func get_next_stage_after_care(current_stage: String) -> String:
	match current_stage:
		"first_rain":
			return "first_goodbye"
		"second_rain":
			return "leaf_placement"
		_:
			return ""

func get_stage_after_delay(current_stage: String) -> String:
	if current_stage == "first_goodbye":
		return "second_rain"
	return ""
