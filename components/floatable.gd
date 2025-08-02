class_name Floatable extends Node

@export var area: Area2D
@export var move_controller: MoveController

func _ready() -> void:
	move_controller.moved.connect(_on_move)

func _on_move(offset: Vector2) -> void:
	var colliding_areas: Array[Area2D] = area.get_overlapping_areas()
	for colliding_area in colliding_areas:
		if colliding_area is Player and colliding_area.is_moving_to_same_area(area):
			colliding_area.move_controller.shift(offset.normalized())
