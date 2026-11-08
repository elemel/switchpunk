@tool
extends Node2D
class_name Display

@export var value := 0
@export var label: Label
@export var tween_duration := 0.2

@onready var main := find_main()

var text_tween: Tween
var text_value := 0


func _ready() -> void:
	update_label()

	if main != null:
		main.format_changed.connect(_on_main_format_changed)


func _physics_process(_delta: float) -> void:
	if text_tween != null:
		update_label()

	if text_tween != null:
		if not text_tween.is_valid():
			text_tween.kill()
			text_tween = null

	if text_tween == null:
		if text_value != value:
			text_tween = create_tween()
			text_tween.tween_property(self, "text_value", value, tween_duration).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)


func update_label() -> void:
	if main != null and label != null:
		if main.use_hex_format:
			var unsigned_value := text_value & 0xFF
			label.text = "%X" % unsigned_value
		else:
			label.text = str(text_value)


func find_main() -> Main:
	var tree := get_tree()

	if tree == null:
		return null

	return tree.get_first_node_in_group("mains")


func _on_main_format_changed() -> void:
	update_label()
