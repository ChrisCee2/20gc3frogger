class_name Bed extends Area2D

@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func deactivate() -> void:
	hide()
	collision_shape.disabled = true
