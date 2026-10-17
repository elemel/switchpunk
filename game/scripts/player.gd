extends Node2D
class_name Player

@export var drag_handle: Node2D

var grabbed_node: Node2D
var grab_offset := Vector2.ZERO


func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("grab"):
		var space_state := get_world_2d().direct_space_state
		var query := PhysicsPointQueryParameters2D.new()
		query.position = get_global_mouse_position()
		query.collide_with_areas = true
		query.collide_with_bodies = false

		var results := space_state.intersect_point(query)

		for result in results:
			var area: Area2D = result.collider
			var area_parent := area.get_parent() as Node2D

			if area_parent is Module:
				grabbed_node = area_parent
				grab_offset = grabbed_node.global_position - get_global_mouse_position()

	if grabbed_node != null:
		grabbed_node.global_position = grab_offset + get_global_mouse_position()

		if not Input.is_action_pressed("grab"):
			grabbed_node = null
