@tool
extends Chip
class_name Decrementer

@export var input_port: InputPort
@export var output_port: OutputPort

@export var display: Display


func _ready() -> void:
	update()


func _physics_process(_delta: float) -> void:
	update()


func update() -> void:
	var result := get_result()

	if output_port != null:
		output_port.value = result

	if display != null:
		display.value = result


func get_input_value() -> int:
	if input_port == null:
		return 0

	return input_port.value


func get_result() -> int:
	return Math.dec_8(get_input_value())
