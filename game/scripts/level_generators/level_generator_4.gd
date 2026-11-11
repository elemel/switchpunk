extends LevelGenerator
class_name LevelGenerator4

@export var level: Level
@export var main_area: Area2D

@export var input_terminal_scene: PackedScene
@export var output_terminal_scene: PackedScene
@export var decrementer_view_scene: PackedScene

var rng := RandomNumberGenerator.new()


func _ready() -> void:
	if random_seed != 0:
		rng.seed = random_seed


func generate() -> void:
	var values := generate_values(2)

	var points := Generators.generate_points_in_area(rng, main_area, 5, 400.0)
	points.sort_custom(func(a, b): return a.x < b.x)
	var input_points := points.slice(0, 2)
	var decrementer_point := points[2]
	var output_points := points.slice(3, 5)
	Arrays.shuffle(input_points, rng)
	Arrays.shuffle(output_points, rng)

	for i in 2:
		var input_terminal := input_terminal_scene.instantiate() as InputTerminal
		input_terminal.position = input_points[i]
		input_terminal.value = values[i]
		level.modules.add_child(input_terminal)

	for i in 2:
		var output_terminal := output_terminal_scene.instantiate() as OutputTerminal
		output_terminal.position = output_points[i]
		output_terminal.value = Math.dec_8(values[0]) if i == 0 else values[1]
		level.modules.add_child(output_terminal)

	var decrementer_view := decrementer_view_scene.instantiate() as DecrementerView
	decrementer_view.position = decrementer_point
	level.modules.add_child(decrementer_view)


func generate_values(count: int) -> Array[int]:
	var values: Array[int]

	while values.size() < count:
		var value := rng.randi_range(-127, -64)

		if value not in values and Math.dec_8(value) not in values and Math.inc_8(value) not in values:
			values.push_back(value)

	return values
