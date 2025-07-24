class_name Bubbles extends Area2D

@onready var move_controller: MoveController = $MoveController
@onready var _animation_player: AnimationPlayer = $AnimationPlayer
@onready var timer: Timer = $Timer

@export var should_move_left: bool = true
@export_range(0, 10) var move_interval: float = 1

var move_direction: Vector2 = Vector2.ZERO
var is_started: bool = false
var is_active: bool = false

# Timer for how long bubble should be underwater and above water
var timer_duration: float = 0
var min_inactive_time: float = 2.0
var max_inactive_time: float = 4.0

var min_active_time: float = 3.0
var max_active_time: float = 8.0

func _ready() -> void:
	move_controller.move_interval = move_interval
	move_direction = Vector2.LEFT if should_move_left else Vector2.RIGHT
	move_controller.moved.connect(_on_move)
	timer.one_shot = true
	timer.timeout.connect(_on_timeout)
	set_deferred("monitorable", is_active)
	set_deferred("monitoring", is_active)
	hide()

func start() -> void:
	is_started = true
	is_active = true
	_animation_player.play("idle")
	set_deferred("monitorable", is_active)
	set_deferred("monitoring", is_active)
	show()
	timer.start(get_start_time())

func switch_active() -> void:
	is_active = !is_active
	set_deferred("monitorable", is_active)
	set_deferred("monitoring", is_active)
	if is_active:
		show()
	else:
		hide()

func _process(delta: float) -> void:
	if is_started:
		update()
		move_controller.update()

func update() -> void:
	move_controller.move(move_direction)

func _on_move(offset: Vector2) -> void:
	if not is_active:
		return
	var colliding_areas: Array[Area2D] = get_overlapping_areas()
	for area in colliding_areas:
		if area is Player and area.move_controller.is_finished_moving():
			area.move_controller.shift(move_direction)

func get_start_time() -> float:
	if is_active:
		return randf_range(min_active_time, max_active_time)
	return randf_range(min_inactive_time, max_inactive_time)

func _on_timeout() -> void:
	# TODO: Later replace this with starting an animation, and on that animation end,
	# Perform the switch and restart the timer (bubble pop or reappear animation)
	switch_active()
	timer.start(get_start_time())
