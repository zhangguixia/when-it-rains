extends Control

const CODEX_SCENE := preload("res://game/ui/CodexPanel.tscn")

@onready var instruction: Label = %Instruction
@onready var leaf: ColorRect = %Leaf

func _ready() -> void:
	leaf.leaf_placed.connect(_choose_slot)

func _choose_slot(index: int) -> void:
	SaveService.set_leaf_slot(index)
	SaveService.set_stage("codex_reveal")
	CodexService.unlock_animal("kitten")
	CodexService.unlock_keepsake("leaf")
	instruction.text = "落叶放好了。这个角落开始有了回忆。"
	await get_tree().create_timer(0.8).timeout
	_show_codex()

func _show_codex() -> void:
	for child in get_children():
		child.queue_free()
	var codex := CODEX_SCENE.instantiate()
	add_child(codex)
