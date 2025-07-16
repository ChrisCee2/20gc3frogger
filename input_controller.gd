class_name InputController extends Node

var is_holding_left: bool = false
var is_holding_right: bool = false
var is_holding_up: bool = false
var is_holding_down: bool = false

func update() -> void:
	is_holding_left = Input.is_action_pressed("left")
	is_holding_right = Input.is_action_pressed("right")
	is_holding_up = Input.is_action_pressed("up")
	is_holding_down = Input.is_action_pressed("down")

func get_move_direction() -> Vector2:
	var x: int = 0
	var y: int = 0
	if is_holding_left:
		x -= 1
	if is_holding_right:
		x += 1
	if is_holding_up:
		y -= 1
	if is_holding_down:
		y += 1
	return Vector2(x, y)
