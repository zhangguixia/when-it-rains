extends ColorRect

signal milk_poured

var filled := false

func _ready() -> void:
	_set_visual_color(Color(0.35, 0.42, 0.48, 1))

func get_art_node_name() -> String:
	return "MilkBowlArt"

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		pour_milk()

func pour_milk() -> void:
	filled = true
	_set_visual_color(Color(0.92, 0.88, 0.72, 1))
	milk_poured.emit()

func reset_bowl() -> void:
	filled = false
	_set_visual_color(Color(0.35, 0.42, 0.48, 1))

func get_prompt_text() -> String:
	if filled:
		return "牛奶倒好了，小猫闻到了。"
	return "点击牛奶碗，倒一点温牛奶。"

func _set_visual_color(next_color: Color) -> void:
	var art := get_node_or_null(get_art_node_name())
	if art is ColorRect:
		art.color = next_color
	else:
		color = next_color
