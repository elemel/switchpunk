@tool
extends Chip
class_name Negator

@export var port_a: InputPort
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


func get_result() -> int:
	return Math.neg_8(get_a())
