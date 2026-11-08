extends CanvasLayer
class_name WinScreen

@export var title_screen: TitleScreen
@export var continue_button: Button
@export var root_control: Control


func _ready() -> void:
	visible = false


func open() -> void:
	visible = true
	root_control.modulate.a = 0.0
	var tween := create_tween()
	tween.tween_property(root_control, "modulate:a", 1.0, 1.0)
	continue_button.grab_focus()


func close() -> void:
	visible = false


func _on_continue_button_pressed() -> void:
	visible = false
	title_screen.visible = true
	title_screen.start_button.grab_focus()
	get_viewport().set_input_as_handled()
