class_name MoveController extends Node

signal moved
signal finished_moving

@onready var animation_timer: Timer = $AnimationTimer
@onready var can_move_timer: Timer = $MoveTimer

@export var object: CollisionObject2D
@export_range(0, 10) var move_interval: float = 0.0 # In seconds

var animation_interval: float = 0.05
var move_amount: float = 32
var previous_position: Vector2 = Vector2.ZERO
var desired_position: Vector2 = Vector2.ZERO

func _ready() -> void:
	can_move_timer.one_shot = true
	if move_interval > 0:
		can_move_timer.wait_time = move_interval
	animation_timer.one_shot = true
	animation_timer.wait_time = animation_interval
	animation_timer.timeout.connect(_on_move_animation_timeout)
	previous_position = object.global_position
	desired_position = object.global_position

func can_move() -> bool:
	return can_move_timer.time_left == 0

func move(direction: Vector2) -> void:
	if direction == Vector2.ZERO or not can_move():
		return
	update_position(direction * move_amount)
	if move_interval > 0:
		can_move_timer.start(move_interval)

func shift(direction: Vector2):
	update_position(direction * move_amount)

func update_position(offset: Vector2) -> void:
	if !is_finished_moving():
		animation_timer.stop()
		finished_moving.emit()
	previous_position = desired_position
	desired_position += offset
	animation_timer.start(animation_interval)
	moved.emit(offset)

func teleport(new_position: Vector2) -> void:
	previous_position = new_position
	desired_position = new_position
	object.global_position = desired_position
	animation_timer.stop()

func update() -> void:
	object.global_position = previous_position.lerp(
		desired_position,
		(animation_interval - animation_timer.time_left) / animation_interval
	)

func is_finished_moving() -> bool:
	return animation_timer.time_left == 0

func _on_move_animation_timeout() -> void:
	finished_moving.emit()
