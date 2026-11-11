extends Node2D
class_name GameController

@export var main: Main

var is_web := OS.has_feature("web")


func _unhandled_input(event: InputEvent) -> void:
	var level := main.find_level()

	if level == null or level.complete:
		return

	if event.is_action_pressed("pause"):
		main.pause()
		get_viewport().set_input_as_handled()

	if event.is_action_pressed("ui_cancel") and not is_web:
		main.pause()
		get_viewport().set_input_as_handled()
