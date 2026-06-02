extends ColorRect

signal cushion_dropped(area_id: String)

const SNAP_POSITIONS := {
	"dry_left": Vector2(420, 800),
	"center": Vector2(700, 800),
	"wet_right": Vector2(1040, 800)
}

var dragging := false
var drag_offset := Vector2.ZERO

func _ready() -> void:
	position = get_snap_position_for_area("center")

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		dragging = event.pressed
		if dragging:
			drag_offset = get_global_mouse_position() - global_position
		else:
			var area_id := get_area_for_position(global_position)
			position = get_snap_position_for_area(area_id)
			cushion_dropped.emit(area_id)
	elif event is InputEventMouseMotion and dragging:
		global_position = get_global_mouse_position() - drag_offset

func get_area_for_position(drop_position: Vector2) -> String:
	if drop_position.x < 560:
		return "dry_left"
	if drop_position.x < 900:
		return "center"
	return "wet_right"

func get_snap_position_for_area(area_id: String) -> Vector2:
	return SNAP_POSITIONS.get(area_id, SNAP_POSITIONS["center"])
