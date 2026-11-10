extends CanvasLayer
class_name NewGameScreen

@export var main: Main
@export var title_screen: TitleScreen

@export var tutorial_button: Button
@export var adventure_button: Button
@export var cancel_button: Button

var is_web := OS.has_feature("web")


func _ready() -> void:
	visible = false


func open() -> void:
	visible = true
	tutorial_button.grab_focus()


func close() -> void:
	visible = false


func _unhandled_input(event: InputEvent) -> void:
	if visible and event.is_action_pressed("ui_cancel") and not is_web:
		cancel()
		get_viewport().set_input_as_handled()


func cancel() -> void:
	close()
	title_screen.open()


func _on_tutorial_button_pressed() -> void:
	close()
	main.start_game()
	get_viewport().set_input_as_handled()


func _on_adventure_button_pressed() -> void:
	get_viewport().set_input_as_handled()


func _on_cancel_button_pressed() -> void:
	cancel()
	get_viewport().set_input_as_handled()
