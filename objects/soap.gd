class_name Soap extends Area2D

@onready var move_controller: MoveController = $MoveController
@onready var _animation_player: AnimationPlayer = $AnimationPlayer

@export var should_move_left: bool = true
@export_range(0, 10) var move_interval: float = 1

var move_direction: Vector2 = Vector2.ZERO
var is_started: bool = false

func _ready() -> void:
	move_controller.move_interval = move_interval
	move_direction = Vector2.LEFT if should_move_left else Vector2.RIGHT
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
		update()
		move_controller.update()

func update() -> void:
	move_controller.move(move_direction)

func _on_move() -> void:
	var colliding_areas: Array[Area2D] = get_overlapping_areas()
	for area in colliding_areas:
		if area is Player and area.move_controller.is_finished_moving():
			area.move_controller.shift(move_direction)
