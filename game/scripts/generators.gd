class_name Generators


static func generate_points_in_area(rng: RandomNumberGenerator, area: Area2D, count: int, min_distance: float) -> Array[Vector2]:
	var shape_owner = area.shape_find_owner(0)
	var collision_shape = area.shape_owner_get_owner(shape_owner) as CollisionShape2D
	var rect_shape = collision_shape.shape as RectangleShape2D
	var extents = rect_shape.extents

	var points: Array[Vector2] = []

	while points.size() < count:
		var local_point = Vector2(
			rng.randf_range(-extents.x, extents.x),
			rng.randf_range(-extents.y, extents.y)
		)

		var global_point = collision_shape.global_transform * local_point
		
		var too_close = false

		for existing_point in points:
			if global_point.distance_to(existing_point) < min_distance:
				too_close = true
				break
				
		if not too_close:
			points.append(global_point)
			
	return points


static func shuffle_array(rng: RandomNumberGenerator, array: Array) -> void:
	for i in range(array.size() - 1, 0, -1):
		var j = rng.randi_range(0, i)
		Arrays.swap(array, i, j)
