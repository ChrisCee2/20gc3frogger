class_name Shampoo extends Area2D

@onready var move_controller: MoveController = $MoveController
@onready var _animation_player: AnimationPlayer = $AnimationPlayer

@export var should_move_left: bool = true

var is_started: bool = false

func _ready() -> void:
	move_controller.moved.connect(_on_move)
	set_deferred("monitorable", false)
	hide()

func start() -> void:
	is_started = true
	_animation_player.play("idle")
	set_deferred("monitorable", true)
	show()

func _process(delta: float) -> void:
	if is_started:
		move_controller.update()

func move(move_direction: Vector2) -> void:
	move_controller.shift(move_direction)

func _on_move(offset: Vector2) -> void:
	var colliding_areas: Array[Area2D] = get_overlapping_areas()
	for area in colliding_areas:
		if area is Player and area.move_controller.is_finished_moving():
			area.move_controller.shift(offset.normalized())
