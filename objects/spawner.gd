class_name Spawner extends Node2D

@onready var timer: Timer = $Timer

@export var autostart: bool = false
@export var object_parent: Node
@export var object: Node2D
@export var min_spawn_time: float = 1.5
@export var max_spawn_time: float = 3

var is_started = false

func _ready() -> void:
	timer.one_shot = true
	timer.timeout.connect(_on_timeout)
	if autostart:
		start()

func start() -> void:
	is_started = true
	timer.start(get_wait_time())

func end() -> void:
	is_started = false
	timer.stop()

func spawn() -> void:
	if is_started and object != null:
		var new_object: Node2D = object.duplicate()
		new_object.global_position = global_position
		var parent: Node = object_parent
		if parent == null:
			parent = get_tree().get_root()
		parent.add_child(new_object)
		if new_object.has_method("start"):
			new_object.start()

func get_wait_time() -> float:
	return randf_range(min_spawn_time, max_spawn_time)

func _on_timeout() -> void:
	if is_started:
		spawn()
		timer.start(get_wait_time())
