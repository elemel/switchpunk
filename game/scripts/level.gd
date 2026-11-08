extends Node2D
class_name Level

@export var wires: Node2D
@export var modules: Node2D

@export var level_generator: LevelGenerator

var complete := false


func _ready() -> void:
	if level_generator != null:
		level_generator.generate()
