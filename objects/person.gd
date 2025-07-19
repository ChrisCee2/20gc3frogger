class_name Person extends Area2D

@onready var move_controller: MoveController = $MoveController

@export var should_move_left: bool = true
@export_range(0, 10) var move_interval: float = 0.3

var move_direction: Vector2 = Vector2.ZERO

func _ready() -> void:
	move_controller.move_interval = move_interval
	move_direction = Vector2.LEFT if should_move_left else Vector2.RIGHT
	set_deferred("monitorable", false)
	hide()

var is_started: bool = false

func start() -> void:
	is_started = true
	set_deferred("monitorable", true)
	show()

func _process(delta: float) -> void:
	if is_started:
		update()

func update() -> void:
	move_controller.move(move_direction)
	move_controller.update()
