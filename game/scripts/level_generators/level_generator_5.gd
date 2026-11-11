extends LevelGenerator
class_name LevelGenerator5

@export var level: Level
@export var main_area: Area2D

@export var input_terminal_view_scene: PackedScene
@export var output_terminal_view_scene: PackedScene
@export var decrementer_view_scene: PackedScene
@export var negator_view_scene: PackedScene

var rng := RandomNumberGenerator.new()


func _ready() -> void:
	if random_seed != 0:
		rng.seed = random_seed


func generate() -> void:
	var values := generate_values(2)

	var points := Generators.generate_points_in_area(rng, main_area, 6, 400.0)
	points.sort_custom(func(a, b): return a.x < b.x)
	var input_points := points.slice(0, 2)
	var operator_points := points.slice(2, 4)
	var output_points := points.slice(4, 6)
	Arrays.shuffle(input_points, rng)
	Arrays.shuffle(operator_points, rng)
	Arrays.shuffle(output_points, rng)

	for i in 2:
		var input_terminal_view := input_terminal_view_scene.instantiate() as InputTerminalView
		input_terminal_view.position = input_points[i]
		input_terminal_view.value = values[i]
		level.modules.add_child(input_terminal_view)

	var output_terminal_view_a := output_terminal_view_scene.instantiate() as OutputTerminalView
	output_terminal_view_a.position = output_points[0]
	output_terminal_view_a.value = values[0]
	level.modules.add_child(output_terminal_view_a)

	var output_terminal_view_b := output_terminal_view_scene.instantiate() as OutputTerminalView
	output_terminal_view_b.position = output_points[1]
	output_terminal_view_b.value = Math.dec_8(Math.neg_8(values[1]))
	level.modules.add_child(output_terminal_view_b)

	var decrementer_view := decrementer_view_scene.instantiate() as DecrementerView
	decrementer_view.position = operator_points[0]
	level.modules.add_child(decrementer_view)

	var negator_view := negator_view_scene.instantiate() as NegatorView
	negator_view.position = operator_points[1]
	level.modules.add_child(negator_view)


func generate_values(count: int) -> Array[int]:
	var values: Array[int]

	while values.size() < count:
		var value := rng.randi_range(-127, 127)

		if value in [-1, 0, 1]:
			continue

		if value in values or Math.dec_8(value) in values or Math.inc_8(value) in values:
			continue

		if -value in values or Math.dec_8(-value) in values or Math.inc_8(-value) in values:
			continue

		values.push_back(value)

	return values
