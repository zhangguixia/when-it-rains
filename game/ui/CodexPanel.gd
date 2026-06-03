extends Control

@onready var animal_list: VBoxContainer = %AnimalList
@onready var keepsake_list: VBoxContainer = %KeepsakeList
@onready var finish_button: Button = %FinishButton

func _ready() -> void:
	_render_animals()
	_render_keepsakes()
	SaveService.set_stage("codex_reveal")
	finish_button.pressed.connect(_finish_demo)

func _render_animals() -> void:
	animal_list.add_child(_make_header("动物"))
	for entry in CodexService.get_animal_entries():
		animal_list.add_child(_make_entry(String(entry["name"]), String(entry["hint"]), bool(entry["locked"])))

func _render_keepsakes() -> void:
	keepsake_list.add_child(_make_header("纪念品"))
	for entry in CodexService.get_keepsake_entries():
		keepsake_list.add_child(_make_entry(String(entry["name"]), String(entry["text"]), bool(entry["locked"])))

func _make_header(text: String) -> Label:
	var label := Label.new()
	label.text = text
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	return label

func _make_entry(title: String, body: String, locked: bool) -> PanelContainer:
	var panel := PanelContainer.new()
	var box := VBoxContainer.new()
	var title_label := Label.new()
	var body_label := Label.new()
	title_label.text = "???" if locked else title
	body_label.text = body if not locked else "还没有遇见。"
	box.add_child(title_label)
	box.add_child(body_label)
	panel.add_child(box)
	return panel

func _finish_demo() -> void:
	SaveService.set_stage("demo_complete")
	get_tree().change_scene_to_file("res://game/ui/EndingScreen.tscn")
