class_name Person extends Area2D

@onready var move_controller: MoveController = $MoveController

var is_started: bool = false

func _ready() -> void:
	set_deferred("monitorable", false)
	hide()

func _process(delta: float) -> void:
	if is_started:
		move_controller.update()

func start() -> void:
	is_started = true
	set_deferred("monitorable", true)
	show()

func move(move_direction: Vector2) -> void:
	move_controller.shift(move_direction)
