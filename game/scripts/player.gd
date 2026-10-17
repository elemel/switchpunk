extends Node2D
class_name Player

@export var wire_scene: PackedScene
@export var output_port_scene: PackedScene
@export var input_port_scene: PackedScene

var dragged_node: Node2D
var drag_offset := Vector2.ZERO


func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("grab"):
		grab()

	if dragged_node != null:
		dragged_node.global_position = drag_offset + get_global_mouse_position()

		if not Input.is_action_pressed("grab"):
			drop()


func grab() -> void:
	var mouse_position := get_global_mouse_position()
	var area := find_area(mouse_position)

	if area != null:
		var area_parent := area.get_parent() as Node2D

		if area_parent is Module:
			dragged_node = area_parent
		elif area_parent is OutputPort:
			grab_output_port(area_parent)
		elif area_parent is InputPort:
			grab_input_port(area_parent)

		if dragged_node != null:
			drag_offset = dragged_node.global_position - get_global_mouse_position()


func grab_output_port(port: OutputPort) -> void:
	if port.module == null:
		dragged_node = port
		return

	if port.wire != null:
		var port_position := port.global_position
		var wire := port.wire
		wire.start_port = output_port_scene.instantiate() as OutputPort
		wire.start_port.module = null
		wire.start_port.global_position = port_position
		wire.add_child(wire.start_port)
		dragged_node = wire.start_port
		return

	var level := find_level()

	if level == null:
		return

	var new_wire := wire_scene.instantiate() as Wire
	level.wires.add_child(new_wire)
	new_wire.start_port = port

	var end_port := input_port_scene.instantiate() as InputPort
	end_port.global_position = port.global_position
	new_wire.add_child(end_port)
	new_wire.end_port = end_port
	dragged_node = end_port


func grab_input_port(port: InputPort) -> void:
	if port.module == null:
		dragged_node = port
		return

	if port.wire != null:
		var port_position := port.global_position
		var wire := port.wire
		wire.end_port = input_port_scene.instantiate() as InputPort
		wire.end_port.global_position = port_position
		wire.add_child(wire.end_port)
		dragged_node = wire.end_port
		return

	var level := find_level()

	if level == null:
		return

	var new_wire := wire_scene.instantiate() as Wire
	level.wires.add_child(new_wire)
	new_wire.end_port = port

	var start_port := output_port_scene.instantiate() as OutputPort
	start_port.global_position = port.global_position
	new_wire.add_child(start_port)
	new_wire.start_port = start_port
	dragged_node = start_port


func drop() -> void:
	if dragged_node is OutputPort:
		drop_output_port()
	elif dragged_node is InputPort:
		drop_input_port()

	dragged_node = null


func drop_output_port() -> void:
	var wire := dragged_node.wire as Wire
	var mouse_position := get_global_mouse_position()
	var area := find_area(mouse_position + drag_offset, dragged_node)

	if area != null:
		var area_parent := area.get_parent() as Node2D

		if area_parent is OutputPort:
			if area_parent.wire == null:
				area_parent.wire = wire
				wire.start_port = area_parent

				wire.remove_child(dragged_node)
				dragged_node.queue_free()

	if wire.start_port.module == null:
		wire.end_port = null
		wire.get_parent().remove_child(wire)
		wire.queue_free()


func drop_input_port() -> void:
	var wire := dragged_node.wire as Wire
	var mouse_position := get_global_mouse_position()
	var area := find_area(mouse_position + drag_offset, dragged_node)

	if area != null:
		var area_parent := area.get_parent() as Node2D

		if area_parent is InputPort:
			if area_parent.wire == null:
				area_parent.wire = wire
				wire.end_port = area_parent

				wire.remove_child(dragged_node)
				dragged_node.queue_free()

	if wire.end_port.module == null:
		wire.start_port = null
		wire.get_parent().remove_child(wire)
		wire.queue_free()


func find_area(area_position: Vector2, exclude_parent: Node2D = null) -> Area2D:
	var space_state := get_world_2d().direct_space_state
	var query := PhysicsPointQueryParameters2D.new()
	query.position = area_position
	query.collide_with_areas = true
	query.collide_with_bodies = false
	var results := space_state.intersect_point(query)

	for result in results:
		if result.collider.get_parent() != exclude_parent:
			return result.collider as Area2D

	return null


func find_level() -> Level:
	return get_tree().get_first_node_in_group("levels")
