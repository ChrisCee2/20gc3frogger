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

# Returns move direction from key just pressed
func get_immediate_move_direction() -> Vector2:
	var direction 
	if Input.is_action_just_pressed("left"):
		return Vector2.LEFT
	elif Input.is_action_just_pressed("right"):
		return Vector2.RIGHT
	elif Input.is_action_just_pressed("up"):
		return Vector2.UP
	elif Input.is_action_just_pressed("down"):
		return Vector2.DOWN
	return Vector2.ZERO
		
