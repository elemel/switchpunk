@tool
extends Node2D
class_name Display

@export var value := 0:
	set(new_value):
		if new_value != value:
			value = new_value
			update_label()

@export var label: Label


func update_label() -> void:
	if label != null:
		label.text = "%X" % value
