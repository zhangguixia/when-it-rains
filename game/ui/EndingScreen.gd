extends Control

@onready var line_1: Label = %Line1
@onready var line_2: Label = %Line2
@onready var line_3: Label = %Line3

func _ready() -> void:
	var lines := get_ending_lines()
	line_1.text = String(lines[0])
	line_2.text = String(lines[1])
	line_3.text = String(lines[2])

func get_ending_lines() -> Array:
	return [
		"雨还会再来的。",
		"有些小小的善意，会被记住很久。",
		"正式版会有更多来访的小动物和纪念品。"
	]
