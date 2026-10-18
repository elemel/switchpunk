@tool
extends Chip
class_name Modulo

@export var port_a: InputPort
@export var port_b: InputPort
@export var result_port: OutputPort

@export var display: Display


func _ready() -> void:
	update()


func _physics_process(_delta: float) -> void:
	update()


func update() -> void:
	var result := get_result()

	if result_port != null:
		result_port.value = result

	if display != null:
		display.value = result


func get_a() -> int:
	if port_a == null:
		return 0

	return port_a.value


func get_b() -> int:
	if port_b == null:
		return 0

	return port_b.value


func get_result() -> int:
	var a := get_a()
	var b := get_b()

	if b == 0:
		return 0

	return posmod(a, b)
