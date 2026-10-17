@tool
extends Module
class_name OutputTerminal

@export var input_port: InputPort
@export var lamp: Lamp
@export var display: Display

@export var value := 0:
	set(new_value):
		if new_value != value:
			value = new_value
			update()


func _ready() -> void:
	update()


func _physics_process(_delta: float) -> void:
	update()


func update() -> void:
	update_display()
	update_lamp()


func update_display() -> void:
	if display != null:
		display.value = value


func update_lamp() -> void:
	if lamp != null:
		var input_value := get_input_value()

		if input_value == value:
			lamp.panel.modulate = Color.GREEN
		else:
			lamp.panel.modulate = Color.RED
	

func get_input_value() -> int:
	if input_port == null:
		return 0

	return input_port.value
