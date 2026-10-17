extends Node2D
class_name Main

@export var pause_screen: PauseScreen

var is_web := OS.has_feature("web")


func _ready() -> void:
	RenderingServer.set_default_clear_color(Color.BLACK)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		pause()
		get_viewport().set_input_as_handled()

	if event.is_action_pressed("ui_cancel") and not is_web:
		pause()
		get_viewport().set_input_as_handled()


func pause() -> void:
	get_tree().paused = true
	pause_screen.visible = true
	pause_screen.resume_button.grab_focus()
