class_name Player extends AnimatableBody2D

@export var move_amount: float = 32
@onready var input_controller: InputController = $InputController
@onready var move_controller: MoveController = $MoveController
@onready var timer: Timer = $Timer #TODO: Eventually switch out with animation player, allow when anim ends
@onready var move_interval: float = 0.0

var desired_position = global_position
var move_buffer: Vector2 = Vector2.ZERO

func _ready() -> void:
	move_controller.move_interval = move_interval

func _process(delta: float) -> void:
	move_controller.update()

func _physics_process(delta: float) -> void:
	move()

func move() -> void:
	if move_controller.can_move() and move_buffer != Vector2.ZERO:
		print(move_buffer)
		move_controller.move(move_buffer)
		move_buffer = Vector2.ZERO

func _unhandled_key_input(event: InputEvent) -> void:
	var move_direction: Vector2 = input_controller.get_immediate_move_direction()
	if move_direction != Vector2.ZERO:
		move_buffer = move_direction
		move()
