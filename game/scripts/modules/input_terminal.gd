@tool
extends Chip
class_name InputTerminal

@export var display: Display
@export var port: OutputPort

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
	if display != null:
		display.value = value

	if port != null:
		port.value = value
