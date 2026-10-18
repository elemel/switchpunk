extends CanvasLayer
class_name WinScreen

@export var title_screen: TitleScreen
@export var continue_button: Button


func _ready() -> void:
	visible = false


func _on_continue_button_pressed() -> void:
	visible = false
	title_screen.visible = true
	title_screen.start_button.grab_focus()
	get_viewport().set_input_as_handled()
