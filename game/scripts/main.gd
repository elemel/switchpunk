extends Node2D
class_name Main

signal format_changed

@export var pause_screen: PauseScreen
@export var level_complete_screen: LevelCompleteScreen
@export var win_screen: WinScreen
@export var level_scenes: Array[PackedScene]
@export var levels: Node2D
@export var start_level_index := 0
@export var use_hex_format := false
@export var format_button: Button
@export var random_seed := 0
@export var game_controller: GameController
@export var game_view: GameView

var is_web := OS.has_feature("web")
var level_index := start_level_index
var level_seeds: Array[int]


func _ready() -> void:
	RenderingServer.set_default_clear_color(Color.BLACK)
	update_format_button()


func _physics_process(_delta: float) -> void:
	var level := find_level()

	if level != null && is_level_complete() && not level.complete:
		level.complete = true
		level_index += 1

		if level_index < level_scenes.size():
			level_complete_screen.open()
		else:
			win_screen.open()


func is_level_complete() -> bool:
	if find_level() == null:
		return false

	for output_terminal_view: OutputTerminalView in get_tree().get_nodes_in_group("output_terminal_views"):
		if not output_terminal_view.is_complete():
			return false

	return true


func start_game() -> void:
	level_seeds.clear()
	var rng := RandomNumberGenerator.new()

	if random_seed != 0:
		rng.seed = random_seed

	for i in level_scenes.size():
		var level_seed := rng.randi()
		level_seeds.push_back(level_seed)

	level_index = start_level_index
	start_level()


func start_level() -> void:
	quit_level()
	var level_scene := level_scenes[level_index]
	var level = level_scene.instantiate() as Level

	if level.level_generator != null:
		level.level_generator.random_seed = level_seeds[level_index]

	levels.add_child(level)


func quit_level() -> void:
	var level := find_level()

	if level != null:
		level.get_parent().remove_child(level)
		level.queue_free()


func pause() -> void:
	pause_screen.open()


func find_level() -> Level:
	return get_tree().get_first_node_in_group("levels") as Level


func exit() -> void:
	get_tree().quit()


func _on_pause_button_pressed() -> void:
	pause()


func _on_format_button_pressed() -> void:
	use_hex_format = not use_hex_format
	update_format_button()
	format_changed.emit()


func update_format_button() -> void:
	format_button.text = "HEX" if use_hex_format else "DEC"
