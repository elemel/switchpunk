@tool
extends Node2D
class_name Display

@export var value := 0:
	set(new_value):
		if new_value != value:
			value = new_value

			if is_node_ready():
				update_label()

@export var label: Label

@onready var main := find_main()

func _ready() -> void:
	update_label()

	if main != null:
		main.format_changed.connect(_on_main_format_changed)


func update_label() -> void:
	if main != null and label != null:
		if main.use_hex_format:
			var unsigned_value := value & 0xFFFF
			label.text = "%XH" % unsigned_value
		else:
			label.text = str(value)


func find_main() -> Main:
	var tree := get_tree()

	if tree == null:
		return null

	return tree.get_first_node_in_group("mains")


func _on_main_format_changed() -> void:
	update_label()
