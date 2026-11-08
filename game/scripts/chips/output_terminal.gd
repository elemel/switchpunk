@tool
extends Chip
class_name OutputTerminal

@export var port: InputPort
@export var lamp: Lamp
@export var display: Display
@export var lamp_change_duration := 0.1

@export var value := 0


var lamp_tween: Tween
var lamp_complete := false


func _ready() -> void:
	if lamp != null:
		lamp.panel.modulate = Color.RED


func _physics_process(_delta: float) -> void:
	update()


func update() -> void:
	update_display()
	update_lamp()


func update_display() -> void:
	if display != null:
		display.value = value


func update_lamp() -> void:
	if lamp_tween != null:
		if not lamp_tween.is_valid():
			lamp_tween.kill()
			lamp_tween = null

	if lamp_tween == null and lamp != null:
		var complete := is_complete()

		if complete != lamp_complete:
			lamp_complete = complete
			lamp_tween = create_tween()

			if lamp_complete:
				lamp_tween.tween_property(lamp.panel, "modulate", Color.GREEN, lamp_change_duration)
			else:
				lamp_tween.tween_property(lamp.panel, "modulate", Color.RED, lamp_change_duration)


func is_complete() -> bool:
	var input_value := get_input_value()
	return input_value == value


func get_input_value() -> int:
	if port == null:
		return 0

	return port.value
