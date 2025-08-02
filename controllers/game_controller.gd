class_name GameController extends Node

@onready var win_audio: AudioStream = preload("res://sfx/win.wav")

@onready var reset_timer: Timer = $ResetTimer

@export_group("Game Objects")
@export var beds: Node
@export var play_area: Area2D
@export var player: Player

@export_group("UI")
@export var game_end_menu: GameEndMenu
@export var lives_ui: Lives
@export var end_frame: EndFrame

@export_group("Game Settings")
@export_range(1, 10) var lives: int = 3
@export var play_area_size: Vector2 = Vector2(640, 640)
@export var play_area_position: Vector2 = Vector2.ZERO
@export var start_position: Vector2 = Vector2.ZERO # Should get start position from play area

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
	play_area.global_position = play_area_position
	player.activate()
	is_started = true
	is_finished = false
	lives_ui.set_lives(lives)

func finish() -> void:
	is_finished = true
	game_end_menu.enable()

func _on_player_fail(fail_object: Object) -> void:
	lives -= 1
	lives_ui.remove_life()
	player.deactivate()
	player.hide()
	if lives <= 0:
		if fail_object is Dog:
			end_frame.show_lose_dog()
		elif fail_object is PlayArea:
			end_frame.show_lose_oob()
		elif fail_object is Water:
			end_frame.show_lose_water()
		finish()
	else:
		player.teleport(start_position)
		player.reset_state()
		reset_timer.start(reset_delay)

func _on_player_reached_bed(bed: Bed) -> void:
	AudioManager.play_audio(win_audio)
	bed_count += 1
	bed.deactivate()
	player.deactivate()
	player.hide()
	if bed_count == beds.get_child_count():
		end_frame.show_win()
		finish()
	else:
		player.teleport(start_position)
		player.reset_state()
		reset_timer.start(reset_delay)

func _on_reset_timer_finished() -> void:
	player.show()
	player.activate()

func _unhandled_key_input(event: InputEvent) -> void:
	if is_finished and Input.is_action_pressed("menu"):
		game_end_menu.go_to_main_menu()
