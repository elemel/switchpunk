@tool
extends Module
class_name Adder

@export var port_a: InputPort
@export var port_b: InputPort
@export var sum_port: OutputPort

@export var display: Display


func _ready() -> void:
	update()


func _physics_process(_delta: float) -> void:
	update()


func update() -> void:
	var sum := get_sum()

	if sum_port != null:
		sum_port.value = sum

	if display != null:
		display.value = sum


func get_a() -> int:
	if port_a == null:
		return 0

	return port_a.value


func get_b() -> int:
	if port_b == null:
		return 0

	return port_b.value


func get_sum() -> int:
	return get_a() + get_b()
