extends CanvasLayer
class_name TitleScreen

@export var main: Main
@export var start_button: Button
@export var exit_button: Button

var is_web := OS.has_feature("web")


func _ready() -> void:
	if is_web:
		exit_button.visible = false

	visible = true
	start_button.grab_focus()


func _unhandled_input(event: InputEvent) -> void:
	if visible and event.is_action_pressed("ui_cancel") and not is_web:
		main.exit()
		get_viewport().set_input_as_handled()


func _on_new_game_button_pressed() -> void:
	visible = false
	main.start_game()
	get_viewport().set_input_as_handled()


func _on_exit_button_pressed() -> void:
	main.exit()
	get_viewport().set_input_as_handled()
