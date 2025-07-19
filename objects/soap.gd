class_name Soap extends Area2D

@onready var move_controller: MoveController = $MoveController
@onready var _animation_player: AnimationPlayer = $AnimationPlayer
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

@export var should_move_left: bool = true
@export_range(0, 10) var move_interval: float = 1

var move_direction: Vector2 = Vector2.ZERO
var is_started: bool = false

func _ready() -> void:
	move_controller.move_interval = move_interval
	move_direction = Vector2.LEFT if should_move_left else Vector2.RIGHT
	move_controller.moved.connect(_on_move)
	collision_shape.disabled = true
	hide()

func start() -> void:
	is_started = true
	_animation_player.play("idle")
	collision_shape.disabled = false
	show()

func _process(delta: float) -> void:
	if is_started:
		update()
		move_controller.update()

func update() -> void:
	move_controller.move(move_direction)

func _on_move() -> void:
	var colliding_areas: Array[Area2D] = get_overlapping_areas()
	for area in colliding_areas:
		if area is Player:
			area.move_controller.shift(move_direction)
