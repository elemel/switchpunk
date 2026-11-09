extends LevelGenerator
class_name LevelGenerator3

@export var level: Level
@export var main_area: Area2D

@export var input_terminal_scene: PackedScene
@export var output_terminal_scene: PackedScene
@export var incrementer_scene: PackedScene
@export var adder_scene: PackedScene

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
		var input_terminal := input_terminal_scene.instantiate() as InputTerminal
		input_terminal.position = input_points[i]
		input_terminal.value = values[i]
		level.modules.add_child(input_terminal)

	for i in 2:
		var output_terminal := output_terminal_scene.instantiate() as OutputTerminal
		output_terminal.position = output_points[i]
		output_terminal.value = Math.inc_8(values[0]) if i == 0 else Math.add_8(values[1], values[2])
		level.modules.add_child(output_terminal)

	var incrementer := incrementer_scene.instantiate() as Incrementer
	incrementer.position = operator_points[0]
	level.modules.add_child(incrementer)

	var adder := adder_scene.instantiate() as Adder
	adder.position = operator_points[1]
	level.modules.add_child(adder)


func generate_values(count: int) -> Array[int]:
	var values: Array[int]

	while values.size() < count:
		var value := rng.randi_range(32, 63)

		if value not in values and Math.dec_8(value) not in values and Math.inc_8(value) not in values:
			values.push_back(value)

	return values
