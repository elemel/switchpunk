class_name Arrays


static func shuffle(array: Array, rng: RandomNumberGenerator) -> void:
	for i in range(array.size() - 1, 0, -1):
		var j = rng.randi_range(0, i)
		swap(array, i, j)


static func swap(array: Array, i: int, j: int) -> void:
	var temp = array[i]
	array[i] = array[j]
	array[j] = temp
