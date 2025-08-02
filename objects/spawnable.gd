class_name Spawnable extends Node

@export var spawn_offset: Vector2 = Vector2.LEFT # Spawning from the right

func get_spawn_offset() -> Vector2:
	return spawn_offset
