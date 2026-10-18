extends Node2D
class_name Main

@export var pause_screen: PauseScreen
@export var level_complete_screen: LevelCompleteScreen
@export var win_screen: WinScreen
@export var level_scenes: Array[PackedScene]
@export var levels: Node2D

var is_web := OS.has_feature("web")
var level_index := 0


func _ready() -> void:
	RenderingServer.set_default_clear_color(Color.BLACK)


func _unhandled_input(event: InputEvent) -> void:
	if find_level() == null:
		return

	if event.is_action_pressed("pause"):
		pause()
		get_viewport().set_input_as_handled()

	if event.is_action_pressed("ui_cancel") and not is_web:
		pause()
		get_viewport().set_input_as_handled()


func _physics_process(_delta: float) -> void:
	if is_level_complete():
		quit_level()
		level_index += 1

		if level_index < level_scenes.size():
			level_complete_screen.visible = true
			level_complete_screen.continue_button.grab_focus()
		else:
			win_screen.visible = true
			win_screen.continue_button.grab_focus()


func is_level_complete() -> bool:
	if find_level() == null:
		return false

	for output_terminal: OutputTerminal in get_tree().get_nodes_in_group("output_terminals"):
		if not output_terminal.is_complete():
			return false

	return true


func start_game() -> void:
	level_index = 0
	start_level()


func start_level() -> void:
	quit_level()

	var level_scene := level_scenes[level_index]
	var level = level_scene.instantiate() as Level
	levels.add_child(level)


func quit_level() -> void:
	var level := find_level()

	if level != null:
		level.get_parent().remove_child(level)
		level.queue_free()


func pause() -> void:
	get_tree().paused = true
	pause_screen.visible = true
	pause_screen.resume_button.grab_focus()


func find_level() -> Level:
	return get_tree().get_first_node_in_group("levels") as Level


func exit() -> void:
	get_tree().quit()
