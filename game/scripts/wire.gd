@tool
extends Node2D
class_name Wire

@export var start_port: OutputPort:
	set(new_start_port):
		if new_start_port != start_port:
			if start_port != null:
				start_port.wire = null

			start_port = new_start_port

			if start_port != null:
				start_port.wire = self

@export var end_port: InputPort:
	set(new_end_port):
		if new_end_port != end_port:
			if end_port != null:
				end_port.wire = null
				end_port.value = 0

			end_port = new_end_port

			if end_port != null:
				end_port.wire = self
				end_port.value = get_value()

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
	if end_port != null:
		end_port.value = get_value()


func get_value() -> int:
	if start_port == null:
		return 0

	return start_port.value


func update_line() -> void:
	if line == null:
		return

	if start_port == null || end_port == null || line == null:
		line.clear_points()
		return

	var distance := start_port.global_position.distance_to(end_port.global_position)
	var curve_offset := distance * curviness

	curve.clear_points()

	curve.add_point(
		start_port.global_position,
		Vector2.ZERO,
		Vector2.RIGHT.rotated(start_port.global_rotation) * curve_offset,
	)

	curve.add_point(
		end_port.global_position,
		Vector2.RIGHT.rotated(end_port.global_rotation) * curve_offset,
		Vector2.ZERO,
	)

	line.points = curve.get_baked_points()
