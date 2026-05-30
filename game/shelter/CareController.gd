extends Node

signal care_changed(snapshot: Dictionary)

const AREA_DRYNESS := {
	"dry_left": 0.95,
	"center": 0.65,
	"wet_right": 0.35
}

var cushion_area := "center"
var milk_ready := false
var pet_count := 0

func move_cushion(area_id: String) -> void:
	if not AREA_DRYNESS.has(area_id):
		push_warning("Unknown cushion area: %s" % area_id)
		return
	cushion_area = area_id
	care_changed.emit(get_care_snapshot(1))

func pour_milk() -> void:
	milk_ready = true
	care_changed.emit(get_care_snapshot(1))

func pet_cat() -> void:
	pet_count += 1
	care_changed.emit(get_care_snapshot(1))

func get_cushion_comfort() -> float:
	return float(AREA_DRYNESS[cushion_area])

func get_care_snapshot(visit: int) -> Dictionary:
	return {
		"cushion_area": cushion_area,
		"cushion_comfort": get_cushion_comfort(),
		"milk_ready": milk_ready,
		"pet_count": pet_count,
		"visit": visit
	}

func reset_for_next_visit() -> void:
	milk_ready = false
	pet_count = 0
