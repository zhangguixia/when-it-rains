extends Control

const CODEX_SCENE := preload("res://game/ui/CodexPanel.tscn")

@onready var slot_0: Button = %Slot0
@onready var slot_1: Button = %Slot1
@onready var slot_2: Button = %Slot2

func _ready() -> void:
	slot_0.pressed.connect(func() -> void: _choose_slot(0))
	slot_1.pressed.connect(func() -> void: _choose_slot(1))
	slot_2.pressed.connect(func() -> void: _choose_slot(2))

func _choose_slot(index: int) -> void:
	SaveService.set_leaf_slot(index)
	SaveService.set_stage("codex_reveal")
	CodexService.unlock_animal("kitten")
	CodexService.unlock_keepsake("leaf")
	_show_codex()

func _show_codex() -> void:
	for child in get_children():
		child.queue_free()
	var codex := CODEX_SCENE.instantiate()
	add_child(codex)
