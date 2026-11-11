extends Resource
class_name Game

@export var next_id := 1

var entities: Dictionary[int, Entity]


func generate_id() -> int:
	var id := next_id
	next_id += 1
	return id
