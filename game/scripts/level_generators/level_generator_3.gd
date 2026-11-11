extends LevelGenerator
class_name LevelGenerator3

@export var level: Level
@export var main_area: Area2D

@export var input_terminal_view_scene: PackedScene
@export var output_terminal_view_scene: PackedScene
@export var incrementer_view_scene: PackedScene
@export var adder_view_scene: PackedScene

var rng := RandomNumberGenerator.new()


func _ready() -> void:
	if random_seed != 0:
		rng.seed = random_seed


func generate() -> void:
	var values := generate_values(3)

	var points := Generators.generate_points_in_area(rng, main_area, 7, 400.0)
	points.sort_custom(func(a, b): return a.x < b.x)
	var input_points := points.slice(0, 3)
	var operator_points := points.slice(3, 5)
	var output_points := points.slice(5, 7)
	Arrays.shuffle(input_points, rng)
	Arrays.shuffle(operator_points, rng)
	Arrays.shuffle(output_points, rng)

	for i in 3:
		var input_terminal_view := input_terminal_view_scene.instantiate() as InputTerminalView
		input_terminal_view.position = input_points[i]
		input_terminal_view.value = values[i]
		level.modules.add_child(input_terminal_view)

	for i in 2:
		var output_terminal_view := output_terminal_view_scene.instantiate() as OutputTerminalView
		output_terminal_view.position = output_points[i]
		output_terminal_view.value = Math.inc_8(values[0]) if i == 0 else Math.add_8(values[1], values[2])
		level.modules.add_child(output_terminal_view)

	var incrementer_view := incrementer_view_scene.instantiate() as IncrementerView
	incrementer_view.position = operator_points[0]
	level.modules.add_child(incrementer_view)

	var adder_view := adder_view_scene.instantiate() as AdderView
	adder_view.position = operator_points[1]
	level.modules.add_child(adder_view)


func generate_values(count: int) -> Array[int]:
	var values: Array[int]

	while values.size() < count:
		var value := rng.randi_range(32, 63)

		if value not in values and Math.dec_8(value) not in values and Math.inc_8(value) not in values:
			values.push_back(value)

	return values
