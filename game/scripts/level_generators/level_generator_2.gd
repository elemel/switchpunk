extends LevelGenerator
class_name LevelGenerator2

@export var level: Level
@export var main_area: Area2D

@export var input_terminal_scene: PackedScene
@export var output_terminal_scene: PackedScene
@export var incrementer_scene: PackedScene
@export var wire_scene: PackedScene

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

	var input_terminal := input_terminal_scene.instantiate() as InputTerminal
	input_terminal.position = input_point
	input_terminal.value = value
	level.modules.add_child(input_terminal)

	var output_terminal := output_terminal_scene.instantiate() as OutputTerminal
	output_terminal.position = output_point
	output_terminal.value = Math.inc_8(value)
	level.modules.add_child(output_terminal)

	var incrementer := incrementer_scene.instantiate() as Incrementer
	incrementer.position = incrementer_point
	level.modules.add_child(incrementer)

	var wire := wire_scene.instantiate() as Wire
	level.wires.add_child(wire)
	wire.start_port = input_terminal.port
	wire.end_port = output_terminal.port


func generate_values(count: int) -> Array[int]:
	var values: Array[int]

	while values.size() < count:
		var value := rng.randi_range(-128, 127)

		if value != 0 and value not in values and Math.dec_8(value) not in values and Math.inc_8(value) not in values:
			values.push_back(value)

	return values
