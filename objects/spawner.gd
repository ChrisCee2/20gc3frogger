class_name Spawner extends Node2D

@onready var timer: Timer = $Timer
@onready var move_timer: Timer = $MoveTimer
@onready var spawned_objects: Node = $SpawnedObjects

@export var spawn_on_start: bool = true
@export var autostart: bool = false
@export var object: Node2D
@export var min_spawn_time: float = 3
@export var max_spawn_time: float = 6
@export var move_interval: float = 0.6
@export var move_direction: Vector2 = Vector2.LEFT

@export_group("Prespawn")
@export var prespawn_amount: int = 0
@export var prespawn_offset_interval: float = 32
@export var prespawn_start_offset: float = 4 # Multiplied by the interval
@export var min_prespawn_offset: float = 3 # From each prespawned object multiplied by the interval
@export var max_prespawn_offset: float = 6 # From each prespawned object multiplied by the interval

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
	prespawn()
	if spawn_on_start:
		spawn()
	timer.start(get_wait_time())
	move_timer.start(move_interval)

func prespawn() -> void:
	var current_offset: Vector2 = move_direction * prespawn_start_offset * prespawn_offset_interval
	for i in range(prespawn_amount):
		spawn_at(global_position + current_offset)
		current_offset += move_direction * \
		randi_range(min_prespawn_offset, max_prespawn_offset) * prespawn_offset_interval

func end() -> void:
	is_started = false
	timer.stop()

func spawn() -> void:
	if is_started and object != null:
		create_object(global_position)

func spawn_at(spawn_position: Vector2) -> void:
	if is_started and object != null:
		create_object(spawn_position)

func create_object(spawn_position: Vector2) -> void:
	var new_object: Node2D = object.duplicate()
	if move_direction == Vector2.RIGHT and new_object is Dog:
		new_object.spawn_left = false
	new_object.global_position = spawn_position
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
