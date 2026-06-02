extends ColorRect

signal milk_poured

var filled := false

func _ready() -> void:
	color = Color(0.35, 0.42, 0.48, 1)

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		pour_milk()

func pour_milk() -> void:
	filled = true
	color = Color(0.92, 0.88, 0.72, 1)
	milk_poured.emit()

func reset_bowl() -> void:
	filled = false
	color = Color(0.35, 0.42, 0.48, 1)

func get_prompt_text() -> String:
	if filled:
		return "牛奶倒好了，小猫闻到了。"
	return "点击牛奶碗，倒一点温牛奶。"
