extends LevelGenerator
class_name LevelGenerator2

@export var level: Level
@export var main_area: Area2D

@export var input_terminal_view_scene: PackedScene
@export var output_terminal_view_scene: PackedScene
@export var incrementer_view_scene: PackedScene
@export var wire_view_scene: PackedScene

var rng := RandomNumberGenerator.new()


func _ready() -> void:
	if random_seed != 0:
		rng.seed = random_seed


func generate() -> void:
	var value := generate_values(1)[0]

	var points := Generators.generate_points_in_area(rng, main_area, 7, 400.0)
	points.sort_custom(func(a, b): return a.x < b.x)
	var input_point := points[0]
	var incrementer_point := points[1]
	var output_point := points[2]

	var input_terminal_view := input_terminal_view_scene.instantiate() as InputTerminalView
	input_terminal_view.position = input_point
	input_terminal_view.value = value
	level.modules.add_child(input_terminal_view)

	var output_terminal_view := output_terminal_view_scene.instantiate() as OutputTerminalView
	output_terminal_view.position = output_point
	output_terminal_view.value = Math.inc_8(value)
	level.modules.add_child(output_terminal_view)

	var incrementer_view := incrementer_view_scene.instantiate() as IncrementerView
	incrementer_view.position = incrementer_point
	level.modules.add_child(incrementer_view)

	var wire_view := wire_view_scene.instantiate() as WireView
	level.wires.add_child(wire_view)
	wire_view.start_port = input_terminal_view.port
	wire_view.end_port = output_terminal_view.port


func generate_values(count: int) -> Array[int]:
	var values: Array[int]

	while values.size() < count:
		var value := rng.randi_range(16, 31)

		if value not in values and Math.dec_8(value) not in values and Math.inc_8(value) not in values:
			values.push_back(value)

	return values
