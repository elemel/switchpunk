extends CanvasLayer
class_name LevelCompleteScreen

@export var main: Main
@export var continue_button: Button


func _ready() -> void:
	visible = false


func _on_continue_button_pressed() -> void:
	visible = false
	main.start_level()
	get_viewport().set_input_as_handled()
