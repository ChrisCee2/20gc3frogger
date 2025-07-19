class_name Player extends Area2D

signal fail
signal reached_bed

@onready var input_controller: InputController = $InputController
@onready var move_controller: MoveController = $MoveController
@onready var move_interval: float = 0.0

var desired_position = global_position
var move_buffer: Vector2 = Vector2.ZERO
var is_active: bool = false
var areas: Array[Area2D] = []

func _ready() -> void:
	move_controller.move_interval = move_interval
	move_controller.finished_moving.connect(_on_finished_moving)
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
	if area is Soap or area is Water:
		areas.append(area)
	elif area is Person:
		fail_player()
	elif area is Bed:
		_on_player_reached_bed(area)

func _handle_area_exit(area: Area2D) -> void:
	if area is Soap or area is Water:
		areas.erase(area)
		if move_controller.is_finished_moving() and did_fail_by_water():
			fail_player()
	if area is PlayArea:
		fail_player()

func teleport(new_position: Vector2) -> void:
	move_controller.teleport(new_position)

func activate() -> void:
	is_active = true
	monitoring = true
	set_deferred("monitorable", true)

func deactivate() -> void:
	is_active = false
	monitoring = false
	set_deferred("monitorable", false)

func _on_player_reached_bed(bed: Bed) -> void:
	if is_active:
		deactivate()
		# Play sleep animation?
		reached_bed.emit(bed)

func fail_player() -> void:
	if is_active:
		deactivate()
		# Play fail animation
		fail.emit()

func did_fail_by_water() -> bool:
	var is_in_water: bool = false
	for area in areas:
		if area is Water:
			is_in_water = true
		elif area is Soap:
			return false
	return is_in_water

func _on_finished_moving() -> void:
	if did_fail_by_water():
		# Play fail animation
		fail_player()
