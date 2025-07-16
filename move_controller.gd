class_name MoveController extends Node

@onready var animation_timer: Timer = $AnimationTimer
@onready var move_timer: Timer = $MoveTimer

@export var object: PhysicsBody2D
@export_range(0, 10) var move_interval: float = 0.0 # In seconds

var animation_interval: float = 0.025
var move_amount: float = 32
var desired_position: Vector2 = Vector2.ZERO

func _ready() -> void:
	move_timer.one_shot = true
	move_timer.wait_time = move_interval
	animation_timer.one_shot = true
	animation_timer.wait_time = animation_interval
	desired_position = object.global_position

func can_move() -> bool:
	return move_timer.time_left == 0

func move(direction: Vector2) -> void:
	if direction == Vector2.ZERO or not can_move():
		return
	object.global_position = desired_position
	update_position(direction * move_amount)
	move_timer.start(move_interval)

func update_position(offset: Vector2) -> void:
	desired_position += offset
	animation_timer.start(animation_interval)

func update() -> void:
	object.global_position = object.global_position.lerp(
		desired_position,
		(animation_interval - animation_timer.time_left) / animation_interval
	)
