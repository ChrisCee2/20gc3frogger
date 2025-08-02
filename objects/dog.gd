class_name Dog extends Area2D

@onready var move_controller: MoveController = $MoveController
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var spawn_left: bool = true

var animation_states: Dictionary[int, Array] = {
	0: ["left", "right"],
	1: ["left1", "right1"],
	2: ["left2", "right2"]
}
var animation_state_count: int = 3
var current_animation_state: int = 0

var is_started: bool = false

func get_class_name() -> String:
	return "Dog"

func _ready() -> void:
	set_deferred("monitorable", false)
	current_animation_state = 0
	var spawn_dir = 0 # Left
	if not spawn_left:
		spawn_dir = 1 # Right
	animation_player.play(animation_states[current_animation_state][spawn_dir])
	move_controller.moved.connect(update_animation_state)
	hide()

func _process(_delta: float) -> void:
	if is_started:
		move_controller.update()

func start() -> void:
	is_started = true
	set_deferred("monitorable", true)
	show()

func move(move_direction: Vector2) -> void:
	move_controller.shift(move_direction)

func update_animation_state(move_offset: Vector2) -> void:
	current_animation_state = (current_animation_state + 1) % animation_state_count
	if move_offset.x < 0:
		animation_player.play(animation_states[current_animation_state][0])
	else:
		animation_player.play(animation_states[current_animation_state][1])
