class_name PlayArea extends Area2D

@export var size: Vector2 = Vector2.ZERO

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var sprite: Sprite2D = $Sprite2D

func get_class_name() -> String:
	return "PlayArea"

func _ready() -> void:
	set_size(size)

func set_size(new_size: Vector2) -> void:
	collision_shape.shape.size = new_size
	sprite.scale = new_size
