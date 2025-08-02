class_name Bubbles extends Area2D

@onready var pop_audio: AudioStream = preload("res://sfx/pop.wav")

@onready var move_controller: MoveController = $MoveController
@onready var _animation_player: AnimationPlayer = $AnimationPlayer
@onready var timer: Timer = $Timer

var is_started: bool = false
var is_active: bool = false

# Timer for how long bubble should be underwater and above water
var timer_duration: float = 0
var min_inactive_time: float = 2.0
var max_inactive_time: float = 3.0

var min_active_time: float = 2.0
var max_active_time: float = 5.0

var is_player_on_top: bool = false

func _ready() -> void:
	move_controller.moved.connect(_on_move)
	timer.one_shot = true
	timer.timeout.connect(_on_timeout)
	area_entered.connect(_handle_area_enter)
	area_exited.connect(_handle_area_exit)
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

func _process(_delta: float) -> void:
	if is_started:
		move_controller.update()

func _on_move(offset: Vector2) -> void:
	if not is_active:
		return
	var colliding_areas: Array[Area2D] = get_overlapping_areas()
	for area in colliding_areas:
		if area is Player and area.move_controller.is_finished_moving():
			area.move_controller.shift(offset.normalized())

func get_start_time() -> float:
	if is_active:
		return randf_range(min_active_time, max_active_time)
	return randf_range(min_inactive_time, max_inactive_time)

func _on_timeout() -> void:
	if is_active:
		if is_player_on_top:
			_animation_player.play("expire_with_sound")
		else:
			_animation_player.play("expire")
	else:
		_animation_player.play_backwards("expire")

func _on_expire_end() -> void:
	if not is_active:
		show()
		switch_active()
		return
	switch_active()
	timer.start(get_start_time())

func _on_expire_start() -> void:
	if _animation_player.get_playing_speed() > 0:
		return
	timer.start(get_start_time())
	_animation_player.play("idle")

func move(move_direction: Vector2) -> void:
	move_controller.shift(move_direction)

func play_pop(pitch: float) -> void:
	AudioManager.play_audio(pop_audio, pitch)

func _handle_area_enter(area: Area2D) -> void:
	if area is Player:
		is_player_on_top = true

func _handle_area_exit(area: Area2D) -> void:
	if area is Player:
		is_player_on_top = false
