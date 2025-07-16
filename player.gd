class_name Player extends AnimatableBody2D

@export var move_amount: float = 32
@onready var input_controller: InputController = $InputController
@onready var timer: Timer = $Timer #TODO: Eventually switch out with animation player, allow when anim ends
@onready var hop_time: float = 0.1

var desired_position = global_position

func _process(delta: float) -> void:
	input_controller.update()

func _physics_process(delta: float) -> void:
	var move_direction: Vector2 = input_controller.get_move_direction()
	global_position = global_position.lerp(desired_position, (hop_time - timer.time_left) / hop_time)
	if timer.time_left != 0 or move_direction == Vector2.ZERO:
		return
	desired_position += move_direction * move_amount
	timer.start(hop_time)

func update_position(offset: Vector2) -> void:
	global_position += offset
	desired_position += offset
