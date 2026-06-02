extends ColorRect

signal leaf_placed(slot_index: int)

const SNAP_POSITIONS := {
	0: Vector2(260, 420),
	1: Vector2(620, 420),
	2: Vector2(980, 420)
}

var dragging := false
var drag_offset := Vector2.ZERO

func _ready() -> void:
	position = Vector2(620, 650)

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		dragging = event.pressed
		if dragging:
			drag_offset = get_global_mouse_position() - global_position
		else:
			var slot_index := get_slot_for_position(global_position)
			position = get_snap_position_for_slot(slot_index)
			leaf_placed.emit(slot_index)
	elif event is InputEventMouseMotion and dragging:
		global_position = get_global_mouse_position() - drag_offset

func get_slot_for_position(drop_position: Vector2) -> int:
	if drop_position.x < 440:
		return 0
	if drop_position.x < 800:
		return 1
	return 2

func get_snap_position_for_slot(slot_index: int) -> Vector2:
	return SNAP_POSITIONS.get(slot_index, SNAP_POSITIONS[1])
