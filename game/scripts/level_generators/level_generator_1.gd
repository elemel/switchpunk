extends LevelGenerator
class_name LevelGenerator1

@export var level: Level
@export var main_area: Area2D

@export var input_terminal_view_scene: PackedScene
@export var output_terminal_view_scene: PackedScene
@export var wire_scene: PackedScene

var rng := RandomNumberGenerator.new()


func _ready() -> void:
	if random_seed != 0:
		rng.seed = random_seed


func generate() -> void:
	var values := generate_values(2)

	var points := Generators.generate_points_in_area(rng, main_area, 4, 400.0)
	points.sort_custom(func(a, b): return a.x < b.x)
	var input_points := points.slice(0, 2)
	var output_points := points.slice(2, 4)
	Arrays.shuffle(input_points, rng)
	Arrays.shuffle(output_points, rng)

	var input_terminal_views: Array[InputTerminalView]
	var output_terminal_views: Array[OutputTerminalView]

	for i in 2:
		var input_terminal_view := input_terminal_view_scene.instantiate() as InputTerminalView
		input_terminal_view.position = input_points[i]
		input_terminal_view.value = values[i]
		level.modules.add_child(input_terminal_view)
		input_terminal_views.append(input_terminal_view)

	for i in 2:
		var output_terminal_view := output_terminal_view_scene.instantiate() as OutputTerminalView
		output_terminal_view.position = output_points[i]
		output_terminal_view.value = values[i]
		level.modules.add_child(output_terminal_view)
		output_terminal_views.append(output_terminal_view)

	var wire := wire_scene.instantiate() as Wire
	level.wires.add_child(wire)
	wire.start_port = input_terminal_views[0].port
	wire.end_port = output_terminal_views[0].port


func generate_values(count: int) -> Array[int]:
	var values: Array[int]

	while values.size() < count:
		var value := rng.randi_range(1, 15)

		if value != 0 and value not in values:
			values.push_back(value)

	return values
