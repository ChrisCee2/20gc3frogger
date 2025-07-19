class_name Player extends Area2D

signal fail

@onready var input_controller: InputController = $InputController
@onready var move_controller: MoveController = $MoveController
@onready var move_interval: float = 0.0

var desired_position = global_position
var move_buffer: Vector2 = Vector2.ZERO
var is_active: bool = false

func _ready() -> void:
	move_controller.move_interval = move_interval
	area_entered.connect(_handle_area_enter)
	area_exited.connect(_handle_area_exit)

func _process(delta: float) -> void:
	if not is_active:
		return
	move_controller.update()

func _physics_process(delta: float) -> void:
	if not is_active:
		return
	move()

func move() -> void:
	if move_controller.can_move() and move_buffer != Vector2.ZERO:
		move_controller.move(move_buffer)
		move_buffer = Vector2.ZERO

func _unhandled_key_input(event: InputEvent) -> void:
	var move_direction: Vector2 = input_controller.get_immediate_move_direction()
	if move_direction != Vector2.ZERO:
		move_buffer = move_direction
		move()

func _handle_area_enter(area: Area2D) -> void:
	if area is Person:
			fail_player()

func _handle_area_exit(area: Area2D) -> void:
	if area is PlayArea:
		fail_player()

func teleport(new_position: Vector2) -> void:
	move_controller.teleport(new_position)

func activate() -> void:
	is_active = true

func deactivate() -> void:
	is_active = false

func fail_player() -> void:
	if is_active:
		deactivate()
		# Play fail animation
		fail.emit()
