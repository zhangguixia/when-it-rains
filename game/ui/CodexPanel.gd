extends Control

const PAGE_TITLE := "雨天图鉴"
const LOCKED_TEXT := "还没有遇见。"

@onready var animal_list: VBoxContainer = %AnimalList
@onready var keepsake_list: VBoxContainer = %KeepsakeList
@onready var finish_button: Button = %FinishButton

func _ready() -> void:
	_render_animals()
	_render_keepsakes()
	SaveService.set_stage("codex_reveal")
	finish_button.pressed.connect(_finish_demo)

func get_page_title() -> String:
	return PAGE_TITLE

func get_locked_text() -> String:
	return LOCKED_TEXT

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
	label.add_theme_font_size_override("font_size", 28)
	label.add_theme_color_override("font_color", Color(0.96, 0.86, 0.65))
	return label

func _make_entry(title: String, body: String, locked: bool) -> PanelContainer:
	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(0, 104)
	panel.add_theme_stylebox_override("panel", _make_entry_style(locked))
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 8)
	var title_label := Label.new()
	var body_label := Label.new()
	title_label.text = "???" if locked else title
	title_label.add_theme_font_size_override("font_size", 24)
	title_label.add_theme_color_override("font_color", Color(0.98, 0.92, 0.78) if not locked else Color(0.62, 0.61, 0.58))
	body_label.text = body if not locked else LOCKED_TEXT
	body_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	body_label.add_theme_font_size_override("font_size", 18)
	body_label.add_theme_color_override("font_color", Color(0.78, 0.73, 0.63) if not locked else Color(0.48, 0.48, 0.46))
	box.add_child(title_label)
	box.add_child(body_label)
	panel.add_child(box)
	return panel

func _make_entry_style(locked: bool) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.18, 0.15, 0.12, 0.88) if not locked else Color(0.10, 0.11, 0.12, 0.76)
	style.border_color = Color(0.82, 0.63, 0.38, 0.7) if not locked else Color(0.35, 0.36, 0.36, 0.65)
	style.set_border_width_all(1)
	style.set_corner_radius_all(8)
	style.content_margin_left = 22
	style.content_margin_top = 16
	style.content_margin_right = 22
	style.content_margin_bottom = 16
	return style

func _finish_demo() -> void:
	SaveService.set_stage("demo_complete")
	get_tree().change_scene_to_file("res://game/ui/EndingScreen.tscn")
