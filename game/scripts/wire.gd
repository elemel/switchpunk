@tool
extends Node2D
class_name Wire

@export var output_port: OutputPort:
	set(new_output_port):
		if new_output_port != output_port:
			if output_port != null:
				output_port.wire = null

			output_port = new_output_port

			if output_port != null:
				output_port.wire = self

@export var input_port: InputPort:
	set(new_input_port):
		if new_input_port != input_port:
			if input_port != null:
				input_port.wire = null

			input_port = new_input_port

			if input_port != null:
				input_port.wire = self

@export var line: Line2D
@export_range(0.0, 1.0, 0.01) var curviness := 0.5

var curve := Curve2D.new()


func _ready() -> void:
	update()


func _physics_process(_delta: float) -> void:
	update()


func update() -> void:
	update_value()
	update_line()


func update_value() -> void:
	if input_port != null:
		input_port.value = get_value()


func get_value() -> int:
	if output_port == null:
		return 0

	return output_port.value


func update_line() -> void:
	if line == null:
		return

	if output_port == null || input_port == null || line == null:
		line.clear_points()
		return

	var distance := output_port.global_position.distance_to(input_port.global_position)
	var curve_offset := distance * curviness

	curve.clear_points()

	curve.add_point(
		output_port.global_position,
		Vector2.ZERO,
		Vector2.RIGHT.rotated(output_port.global_rotation) * curve_offset,
	)

	curve.add_point(
		input_port.global_position,
		Vector2.RIGHT.rotated(input_port.global_rotation) * curve_offset,
		Vector2.ZERO,
	)

	line.points = curve.get_baked_points()
