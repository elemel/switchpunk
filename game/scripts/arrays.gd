class_name Arrays


static func swap(array: Array, i: int, j: int) -> void:
	var temp = array[i]
	array[i] = array[j]
	array[j] = temp
