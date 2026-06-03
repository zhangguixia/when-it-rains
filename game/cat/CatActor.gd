extends Area2D

signal petted

@onready var label: Label = %Label
@onready var body: ColorRect = %Body

var state_machine := preload("res://game/cat/CatStateMachine.gd").new()
var home_position := Vector2.ZERO

func _ready() -> void:
	home_position = position
	input_event.connect(_on_input_event)
	state_machine.state_changed.connect(_on_state_changed)
	_on_state_changed(state_machine.state)

func apply_care(snapshot: Dictionary) -> void:
	state_machine.apply_care(snapshot)

func start_leaving() -> void:
	state_machine.start_leaving()

func start_returning() -> void:
	state_machine.start_returning()

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		petted.emit()

func _on_state_changed(new_state: String) -> void:
	var profile := get_visual_profile_for_state(new_state)
	label.text = String(profile["label"])
	body.color = profile["color"]
	position = home_position + profile["offset"]
	scale = profile["scale"]

func get_visual_profile_for_state(new_state: String) -> Dictionary:
	match new_state:
		"Hesitating":
			return _profile("小猫还在犹豫", Color(0.38, 0.42, 0.48, 1), Vector2(-180, 0), Vector2.ONE)
		"Approaching":
			return _profile("小猫靠近了", Color(0.50, 0.50, 0.52, 1), Vector2(-90, 8), Vector2.ONE)
		"Resting":
			return _profile("小猫坐下了", Color(0.56, 0.52, 0.48, 1), Vector2(0, 20), Vector2(1.0, 0.94))
		"Drinking":
			return _profile("小猫在喝牛奶", Color(0.62, 0.58, 0.50, 1), Vector2(-40, 20), Vector2(1.0, 0.94))
		"Purring":
			return _profile("小猫安心地呼噜", Color(0.78, 0.64, 0.48, 1), Vector2(0, 24), Vector2(1.08, 0.92))
		"Leaving":
			return _profile("雨停了，它回头看了一眼", Color(0.70, 0.70, 0.68, 1), Vector2(180, -20), Vector2(0.94, 0.94))
		"Returning":
			return _profile("它又回来了", Color(0.90, 0.72, 0.50, 1), Vector2(-80, 0), Vector2(1.04, 1.0))
		_:
			return _profile("小猫", Color(0.45, 0.45, 0.48, 1), Vector2.ZERO, Vector2.ONE)

func _profile(profile_label: String, profile_color: Color, profile_offset: Vector2, profile_scale: Vector2) -> Dictionary:
	return {
		"label": profile_label,
		"color": profile_color,
		"offset": profile_offset,
		"scale": profile_scale
	}
