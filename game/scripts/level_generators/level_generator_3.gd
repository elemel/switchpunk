extends LevelGenerator
class_name LevelGenerator3

@export var level: Level
@export var main_area: Area2D

@export var input_terminal_scene: PackedScene
@export var output_terminal_scene: PackedScene
@export var incrementer_scene: PackedScene
@export var adder_scene: PackedScene
@export var wire_scene: PackedScene

var rng := RandomNumberGenerator.new()


func _ready() -> void:
	if random_seed != 0:
		rng.seed = random_seed


func generate() -> void:
	var values := generate_values(3)

	var points := Generators.generate_points_in_area(rng, main_area, 7, 400.0)
	points.sort_custom(func(a, b): return a.x < b.x)
	var input_points := points.slice(0, 3)
	var incrementer_point := points[3]
	var adder_point := points[4]
	var output_points := points.slice(5, 7)
	Arrays.shuffle(input_points, rng)
	Arrays.shuffle(output_points, rng)

	var input_terminals: Array[InputTerminal]
	var output_terminals: Array[OutputTerminal]

	for i in 3:
		var input_terminal := input_terminal_scene.instantiate() as InputTerminal
		input_terminal.position = input_points[i]
		input_terminal.value = values[i]
		level.modules.add_child(input_terminal)
		input_terminals.append(input_terminal)

	for i in 2:
		var output_terminal := output_terminal_scene.instantiate() as OutputTerminal
		output_terminal.position = output_points[i]
		output_terminal.value = Math.inc_8(values[0]) if i == 0 else Math.add_8(values[1], values[2])
		level.modules.add_child(output_terminal)
		output_terminals.append(output_terminal)

	var incrementer := incrementer_scene.instantiate() as Incrementer
	incrementer.position = incrementer_point
	level.modules.add_child(incrementer)

	var adder := adder_scene.instantiate() as Adder
	adder.position = adder_point
	level.modules.add_child(adder)

	var wire := wire_scene.instantiate() as Wire
	level.wires.add_child(wire)
	wire.start_port = input_terminals[rng.randi_range(1, 2)].port
	wire.end_port = incrementer.input_port


func generate_values(count: int) -> Array[int]:
	var values: Array[int]

	while values.size() < count:
		var value := rng.randi_range(-128, 127)

		if value != 0 and value not in values and Math.dec_8(value) not in values and Math.inc_8(value) not in values:
			values.push_back(value)

	return values
