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

func _process(delta: float) -> void:
	if not is_active:
		return
	move_controller.update()
	print(global_position)
	check_collisions()

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

func check_collisions() -> void:
	var colliding_areas: Array[Area2D] = get_overlapping_areas()
	var is_in_play_area = false
	for area in colliding_areas:
		if area is PlayArea:
			is_in_play_area = true
		if area is Person:
			fail_player()
	if not is_in_play_area:
		print("NOTINPLAY")
		fail_player()

func teleport(new_position: Vector2) -> void:
	print("teleport")
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
