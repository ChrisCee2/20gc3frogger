class_name GameController extends Node

@onready var reset_timer: Timer = $ResetTimer

@export var beds: Node
@export var play_area: Area2D
@export var play_area_size: Vector2 = Vector2(640, 640)
@export var start_position: Vector2 = Vector2.ZERO # Should get start position from play area
@export var player: Player
@export_range(1, 10) var lives: int = 3

var is_started: bool = false
var is_finished: bool = false
var reset_delay: float = 0.25 # Delay for reset
var bed_count: int = 0

func _ready() -> void:
	player.fail.connect(_on_player_fail)
	player.reached_bed.connect(_on_player_reached_bed)
	reset_timer.one_shot = true
	reset_timer.timeout.connect(_on_reset_timer_finished)
	start()

func start() -> void:
	bed_count = 0
	play_area.set_size(Vector2(play_area_size))
	player.activate()
	is_started = true
	is_finished = false

func finish() -> void:
	is_finished = true

func _on_player_fail() -> void:
	lives -= 1
	player.hide()
	if lives <= 0:
		finish()
	else:
		player.teleport(start_position)
		reset_timer.start(reset_delay)

func _on_player_reached_bed(bed: Bed) -> void:
	bed_count += 1
	bed.deactivate()
	player.hide()
	if bed_count == beds.get_child_count():
		finish()
	else:
		player.teleport(start_position)
		reset_timer.start(reset_delay)

func _on_reset_timer_finished() -> void:
	player.show()
	player.activate()
