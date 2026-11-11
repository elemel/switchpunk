extends LevelGenerator
class_name LevelGenerator6

@export var level: Level
@export var main_area: Area2D

@export var input_terminal_view_scene: PackedScene
@export var output_terminal_scene: PackedScene
@export var decrementer_view_scene: PackedScene
@export var negator_scene: PackedScene
@export var subtractor_scene: PackedScene

var rng := RandomNumberGenerator.new()


func _ready() -> void:
	if random_seed != 0:
		rng.seed = random_seed


func generate() -> void:
	var values := generate_values(3)

	var points := Generators.generate_points_in_area(rng, main_area, 8, 400.0)
	points.sort_custom(func(a, b): return a.x < b.x)
	var input_points := points.slice(0, 3)
	var operator_points := points.slice(3, 6)
	var output_points := points.slice(6, 8)
	Arrays.shuffle(input_points, rng)
	Arrays.shuffle(operator_points, rng)
	Arrays.shuffle(output_points, rng)

	for i in 3:
		var input_terminal_view := input_terminal_view_scene.instantiate() as InputTerminalView
		input_terminal_view.position = input_points[i]
		input_terminal_view.value = values[i]
		level.modules.add_child(input_terminal_view)

	for i in 2:
		var output_terminal := output_terminal_scene.instantiate() as OutputTerminal
		output_terminal.position = output_points[i]
		output_terminal.value = Math.neg_8(values[0]) if i == 0 else Math.sub_8(values[1], Math.dec_8(values[2]))
		level.modules.add_child(output_terminal)

	var decrementer_view := decrementer_view_scene.instantiate() as DecrementerView
	decrementer_view.position = operator_points[0]
	level.modules.add_child(decrementer_view)

	var negator := negator_scene.instantiate() as Negator
	negator.position = operator_points[1]
	level.modules.add_child(negator)

	var subtractor := subtractor_scene.instantiate() as Subtractor
	subtractor.position = operator_points[2]
	level.modules.add_child(subtractor)


func generate_values(count: int) -> Array[int]:
	var values: Array[int]

	while values.size() < count:
		var value := rng.randi_range(-128, 127)

		if value in [-128, -1, 0, 1]:
			continue

		if value in values or Math.dec_8(value) in values or Math.inc_8(value) in values:
			continue

		if -value in values or Math.dec_8(-value) in values or Math.inc_8(-value) in values:
			continue

		values.push_back(value)

	return values
