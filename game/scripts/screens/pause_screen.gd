extends CanvasLayer
class_name PauseScreen

@export var main: Main
@export var title_screen: TitleScreen

@export var resume_button: Button
@export var quit_button: Button

var is_web := OS.has_feature("web")


func _ready() -> void:
	visible = false


func open() -> void:
	visible = true
	get_tree().paused = true
	resume_button.grab_focus()


func close() -> void:
	visible = false
	get_tree().paused = false


func _on_resume_button_pressed() -> void:
	close()
	get_viewport().set_input_as_handled()


func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return


	if event.is_action_pressed("pause"):
		close()
		get_viewport().set_input_as_handled()
		return

	if event.is_action_pressed("ui_cancel") and not is_web:
		close()
		get_viewport().set_input_as_handled()
		return


func _on_quit_game_button_pressed() -> void:
	main.quit_level()
	close()
	title_screen.open()
	get_viewport().set_input_as_handled()


func _on_restart_level_button_pressed() -> void:
	main.start_level()
	close()
	get_viewport().set_input_as_handled()
