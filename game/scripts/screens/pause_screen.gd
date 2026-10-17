extends CanvasLayer
class_name PauseScreen

@export var title_screen: TitleScreen

@export var resume_button: Button
@export var quit_button: Button

var is_web := OS.has_feature("web")


func _on_resume_button_pressed() -> void:
	resume()
	get_viewport().set_input_as_handled()


func _unhandled_input(event: InputEvent) -> void:
	if visible and event.is_action_pressed("pause"):
		resume()
		get_viewport().set_input_as_handled()

	if visible and event.is_action_pressed("ui_cancel") and not is_web:
		resume()
		get_viewport().set_input_as_handled()


func resume() -> void:
	get_tree().paused = false
	visible = false


func _on_quit_button_pressed() -> void:
	title_screen.visible = true
	title_screen.start_button.grab_focus()
	get_viewport().set_input_as_handled()
