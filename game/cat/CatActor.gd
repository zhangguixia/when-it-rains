extends Area2D

signal petted

@onready var label: Label = %Label
@onready var body: ColorRect = %Body

var state_machine := preload("res://game/cat/CatStateMachine.gd").new()

func _ready() -> void:
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
	label.text = _label_for_state(new_state)
	body.color = _color_for_state(new_state)

func _label_for_state(new_state: String) -> String:
	match new_state:
		"Hesitating": return "小猫还在犹豫"
		"Approaching": return "小猫靠近了"
		"Resting": return "小猫坐下了"
		"Drinking": return "小猫在喝牛奶"
		"Purring": return "小猫安心地呼噜"
		"Leaving": return "雨停了，它回头看了一眼"
		"Returning": return "它又回来了"
		_: return "小猫"

func _color_for_state(new_state: String) -> Color:
	match new_state:
		"Hesitating": return Color(0.38, 0.42, 0.48, 1)
		"Approaching": return Color(0.50, 0.50, 0.52, 1)
		"Drinking": return Color(0.62, 0.58, 0.50, 1)
		"Purring": return Color(0.78, 0.64, 0.48, 1)
		"Leaving": return Color(0.70, 0.70, 0.68, 1)
		"Returning": return Color(0.90, 0.72, 0.50, 1)
		_: return Color(0.45, 0.45, 0.48, 1)
