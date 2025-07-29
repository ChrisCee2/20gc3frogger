class_name Spawner extends Node2D

@onready var timer: Timer = $Timer
@onready var move_timer: Timer = $MoveTimer
@onready var spawned_objects: Node = $SpawnedObjects

@export var autostart: bool = false
@export var object: Node2D
@export var min_spawn_time: float = 1.5
@export var max_spawn_time: float = 3
@export var move_interval: float = 0.6
@export var move_direction: Vector2 = Vector2.LEFT

var is_started = false

func _ready() -> void:
	timer.one_shot = true
	timer.timeout.connect(_on_timeout)
	move_timer.one_shot = true
	move_timer.timeout.connect(_on_move_timer_timeout)
	if autostart:
		start()

func start() -> void:
	is_started = true
	timer.start(get_wait_time())
	move_timer.start(move_interval)

func end() -> void:
	is_started = false
	timer.stop()

func spawn() -> void:
	if is_started and object != null:
		var new_object: Node2D = object.duplicate()
		new_object.global_position = global_position
		spawned_objects.add_child(new_object)
		if new_object.has_method("start"):
			new_object.start()

func get_wait_time() -> float:
	return randf_range(min_spawn_time, max_spawn_time)

func _on_timeout() -> void:
	if is_started:
		spawn()
		timer.start(get_wait_time())

func _on_move_timer_timeout() -> void:
	if is_started:
		for object in spawned_objects.get_children():
			if object.has_method("move"):
				object.move(move_direction.normalized())
		move_timer.start(move_interval)
