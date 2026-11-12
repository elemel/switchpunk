extends Entity
class_name Board

@export var chips: Dictionary[int, Rect2i]
@export var wires: Dictionary[int, Array]


func add_chip(chip_id: int, rect: Rect2i) -> void:
	chips[chip_id] = rect


func move_chip(chip_id: int, new_rect: Rect2i) -> void:
	chips[chip_id] = new_rect


func remove_chip(chip_id: int) -> void:
	chips.erase(chip_id)


func add_wire(wire_id: int, path: Array[Vector2i]) -> void:
	wires[wire_id] = path


func move_wire(wire_id: int, new_path: Array[Vector2i]) -> void:
	wires[wire_id] = new_path


func remove_wire(wire_id: int) -> void:
	wires.erase(wire_id)
