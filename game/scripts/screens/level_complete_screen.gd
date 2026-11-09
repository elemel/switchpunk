extends CanvasLayer
class_name LevelCompleteScreen

@export var main: Main
@export var continue_button: Button
@export var root_control: Control


func _ready() -> void:
	visible = false


func open() -> void:
	visible = true
	root_control.modulate.a = 0.0
	var tween := create_tween()
	tween.tween_interval(1.0)
	tween.tween_property(root_control, "modulate:a", 1.0, 1.0)
	continue_button.grab_focus()


func close() -> void:
	visible = false


func _on_continue_button_pressed() -> void:
	close()
	main.start_level()
	get_viewport().set_input_as_handled()
